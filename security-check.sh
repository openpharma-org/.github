#!/bin/bash

# Security check script for OpenPharma MCP servers
# Scans for secrets, credentials, and sensitive data before migration

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔐 OpenPharma Security Check${NC}\n"

# Directories to check
declare -a DIRS=(
    "/Users/joan.saez-pons/code/fda-mcp-server"
    "/Users/joan.saez-pons/code/ct.gov-mcp-server"
    "/Users/joan.saez-pons/code/pubmed-mcp-server-npm"
    "/Users/joan.saez-pons/code/codes-mcp-server"
    "/Users/joan.saez-pons/code/who-mcp-server"
    "/Users/joan.saez-pons/code/sec-mcp-server"
    "/Users/joan.saez-pons/code/icd-mcp-server"
    "/Users/joan.saez-pons/code/yahoo-finance-mcp-server"
    "/Users/joan.saez-pons/code/datacommons-mcp"
    "/Users/joan.saez-pons/code/opentargets-mcp-server"
    "/Users/joan.saez-pons/code/pubchem-mcp-server"
    "/Users/joan.saez-pons/code/patent_mcp_server"
    "/Users/joan.saez-pons/code/cdc-mcp-server"
)

# Patterns to search for
declare -a PATTERNS=(
    "API_KEY"
    "SECRET"
    "TOKEN"
    "PASSWORD"
    "CREDENTIAL"
    "PRIVATE_KEY"
    "AWS_"
    "GOOGLE_"
    "github_pat_"
    "ghp_"
)

ISSUES_FOUND=0
TOTAL_CHECKED=0

check_directory() {
    local DIR=$1
    local REPO_NAME=$(basename "$DIR")

    if [ ! -d "$DIR" ]; then
        echo -e "${YELLOW}⚠️  Directory not found: $DIR${NC}"
        return
    fi

    ((TOTAL_CHECKED++))

    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}🔍 Checking: ${REPO_NAME}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    cd "$DIR"

    LOCAL_ISSUES=0

    # Check .env files
    if [ -f ".env" ]; then
        echo -e "${YELLOW}⚠️  Found .env file (should be in .gitignore)${NC}"
        ((LOCAL_ISSUES++))

        # Check if .env is in .gitignore
        if [ -f ".gitignore" ] && grep -q "^\.env$" .gitignore; then
            echo -e "${GREEN}   ✓ .env is in .gitignore${NC}"
        else
            echo -e "${RED}   ✗ .env is NOT in .gitignore!${NC}"
        fi
    fi

    # Check for .env.example (should exist)
    if [ ! -f ".env.example" ] && [ -f ".env" ]; then
        echo -e "${YELLOW}⚠️  No .env.example file found (recommended)${NC}"
    fi

    # Check for credentials in tracked files
    for pattern in "${PATTERNS[@]}"; do
        # Search in git-tracked files only
        MATCHES=$(git grep -i "$pattern" 2>/dev/null | grep -v ".gitignore" | grep -v ".env.example" | grep -v "README" | grep -v "EXAMPLE" || true)

        if [ -n "$MATCHES" ]; then
            echo -e "${RED}🚨 Found '$pattern' in tracked files:${NC}"
            echo "$MATCHES" | while read -r line; do
                echo -e "${RED}   $line${NC}"
            done
            ((LOCAL_ISSUES++))
        fi
    done

    # Check for hardcoded IPs, emails, etc.
    SENSITIVE_PATTERNS=(
        "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:[0-9]+"  # IP:Port
        "postgresql://[^@]+@"  # DB connection strings
        "mongodb://[^@]+@"
        "mysql://[^@]+@"
    )

    for pattern in "${SENSITIVE_PATTERNS[@]}"; do
        MATCHES=$(git grep -E "$pattern" 2>/dev/null | grep -v "example" | grep -v "localhost" || true)
        if [ -n "$MATCHES" ]; then
            echo -e "${RED}🚨 Found potential sensitive data:${NC}"
            echo "$MATCHES" | while read -r line; do
                echo -e "${RED}   $line${NC}"
            done
            ((LOCAL_ISSUES++))
        fi
    done

    # Check for credential files
    CRED_FILES=(".credentials" "credentials.json" "service-account.json" "*.pem" "*.key" "id_rsa")
    for file_pattern in "${CRED_FILES[@]}"; do
        FILES=$(find . -name "$file_pattern" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null || true)
        if [ -n "$FILES" ]; then
            echo -e "${RED}🚨 Found credential files:${NC}"
            echo "$FILES" | while read -r file; do
                echo -e "${RED}   $file${NC}"

                # Check if in .gitignore
                if [ -f ".gitignore" ] && grep -q "$(basename "$file")" .gitignore; then
                    echo -e "${GREEN}      ✓ In .gitignore${NC}"
                else
                    echo -e "${RED}      ✗ NOT in .gitignore!${NC}"
                fi
            done
            ((LOCAL_ISSUES++))
        fi
    done

    if [ $LOCAL_ISSUES -eq 0 ]; then
        echo -e "${GREEN}✅ No security issues found${NC}"
    else
        echo -e "${RED}❌ Found $LOCAL_ISSUES potential security issue(s)${NC}"
        ((ISSUES_FOUND+=LOCAL_ISSUES))
    fi
}

# Check all directories
for dir in "${DIRS[@]}"; do
    check_directory "$dir"
done

# Summary
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 Security Check Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Repositories checked: ${TOTAL_CHECKED}"

if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ No security issues found!${NC}"
    echo -e "${GREEN}Safe to proceed with migration.${NC}"
    exit 0
else
    echo -e "${RED}❌ Found ${ISSUES_FOUND} potential security issue(s)${NC}"
    echo -e "${YELLOW}⚠️  Please review and fix issues before migration.${NC}"
    echo -e "\n${BLUE}Recommended actions:${NC}"
    echo "1. Remove secrets from tracked files"
    echo "2. Add sensitive files to .gitignore"
    echo "3. Create .env.example templates (without real values)"
    echo "4. Use environment variables for all secrets"
    echo "5. Consider using git-filter-repo to remove secrets from history"
    exit 1
fi
