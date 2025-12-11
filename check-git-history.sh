#!/bin/bash

# Check git history for secrets across all commits
# This is CRITICAL before making repositories public

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔍 Git History Security Scan${NC}\n"
echo -e "${YELLOW}⚠️  This scans ALL commits for leaked secrets${NC}\n"

# Servers to check
declare -a SERVERS=(
    "fda-mcp-server"
    "ct.gov-mcp-server"
    "pubmed-mcp-server-npm"
    "codes-mcp-server"
    "who-mcp-server"
    "sec-mcp-server"
    "icd-mcp-server"
    "yahoo-finance-mcp-server"
    "datacommons-mcp"
    "opentargets-mcp-server"
    "pubchem-mcp-server"
    "patent_mcp_server"
    "cdc-mcp-server"
)

# Patterns that indicate secrets (regex)
declare -a SECRET_PATTERNS=(
    "[A-Za-z0-9]{32,}"  # Long alphanumeric strings (API keys)
    "[0-9a-fA-F]{40}"    # SHA-1 hashes (tokens)
    "ghp_[A-Za-z0-9]{36}" # GitHub personal access tokens
    "github_pat_[A-Za-z0-9_]{82}" # GitHub fine-grained tokens
    "AKIA[0-9A-Z]{16}"   # AWS access keys
    "AIza[0-9A-Za-z\\-_]{35}"  # Google API keys
    "sk-[A-Za-z0-9]{48}"  # OpenAI API keys
    "xox[baprs]-[0-9a-zA-Z-]{10,48}"  # Slack tokens
    "-----BEGIN [A-Z]+ PRIVATE KEY-----"  # Private keys
)

# Files/paths that commonly contain secrets
declare -a SENSITIVE_FILES=(
    "*.env"
    ".env.*"
    "credentials.json"
    "*-credentials.json"
    "*.pem"
    "*.key"
    ".mcp.json"
    "config/secrets.*"
)

TOTAL_ISSUES=0
REPOS_WITH_ISSUES=()

check_repo_history() {
    local REPO_NAME=$1
    local REPO_PATH="/Users/joan.saez-pons/code/$REPO_NAME"

    if [ ! -d "$REPO_PATH" ]; then
        echo -e "${YELLOW}⚠️  Not found: $REPO_PATH${NC}"
        return
    fi

    if [ ! -d "$REPO_PATH/.git" ]; then
        echo -e "${YELLOW}⚠️  Not a git repo: $REPO_PATH${NC}"
        return
    fi

    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}🔍 Scanning: ${REPO_NAME}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    cd "$REPO_PATH"

    LOCAL_ISSUES=0

    # Check 1: Scan for sensitive files in git history
    echo -e "${YELLOW}📁 Checking for sensitive files in history...${NC}"
    for pattern in "${SENSITIVE_FILES[@]}"; do
        FOUND=$(git log --all --full-history --pretty=format:"%H" -- "$pattern" 2>/dev/null | head -5)
        if [ -n "$FOUND" ]; then
            echo -e "${RED}   ⚠️  Found '$pattern' in git history:${NC}"
            while IFS= read -r commit; do
                COMMIT_INFO=$(git show --no-patch --format="%h - %s (%an, %ar)" "$commit" 2>/dev/null)
                echo -e "${RED}      $COMMIT_INFO${NC}"
            done <<< "$FOUND"
            ((LOCAL_ISSUES++))
        fi
    done

    # Check 2: Scan commit messages for secrets
    echo -e "${YELLOW}💬 Checking commit messages...${NC}"
    for pattern in "${SECRET_PATTERNS[@]}"; do
        FOUND=$(git log --all --grep="$pattern" --format="%H %s" 2>/dev/null | head -3)
        if [ -n "$FOUND" ]; then
            echo -e "${RED}   ⚠️  Potential secret in commit message:${NC}"
            echo -e "${RED}      $FOUND${NC}"
            ((LOCAL_ISSUES++))
        fi
    done

    # Check 3: Scan file contents across all commits for API keys
    echo -e "${YELLOW}🔑 Checking for hardcoded API keys in history...${NC}"

    # Check for common API key patterns
    SUSPICIOUS_COMMITS=$(git log --all -S"API_KEY" -S"SECRET" -S"TOKEN" -S"PASSWORD" --format="%H" | head -10)
    if [ -n "$SUSPICIOUS_COMMITS" ]; then
        echo -e "${YELLOW}   Found commits with potential secrets:${NC}"
        while IFS= read -r commit; do
            # Check if this commit actually added secrets (not just references)
            DIFF=$(git show "$commit" | grep -E "^\+.*['\"]?(API_KEY|SECRET|TOKEN|PASSWORD)['\"]?\s*[:=]" | grep -v "process.env" | grep -v "your_" | head -3)
            if [ -n "$DIFF" ]; then
                COMMIT_INFO=$(git show --no-patch --format="%h - %s" "$commit")
                echo -e "${RED}      $COMMIT_INFO${NC}"
                echo "$DIFF" | while IFS= read -r line; do
                    echo -e "${RED}         $line${NC}"
                done
                ((LOCAL_ISSUES++))
            fi
        done <<< "$SUSPICIOUS_COMMITS"
    fi

    # Check 4: Look for actual secret values (high-entropy strings)
    echo -e "${YELLOW}🎲 Checking for high-entropy strings (potential secrets)...${NC}"

    # Look for commits that added long alphanumeric strings
    SUSPICIOUS=$(git log --all -S"$(printf '[A-Za-z0-9]{40}')" --format="%H" --diff-filter=A | head -5)
    if [ -n "$SUSPICIOUS" ]; then
        while IFS= read -r commit; do
            # Check if added actual keys (not dependencies, not comments)
            ADDITIONS=$(git show "$commit" | grep -E "^\+.*['\"]?[A-Za-z0-9]{32,}['\"]?" | grep -v "node_modules" | grep -v "package-lock" | grep -v "// " | head -2)
            if [ -n "$ADDITIONS" ]; then
                COMMIT_INFO=$(git show --no-patch --format="%h - %s" "$commit")
                echo -e "${RED}      $COMMIT_INFO${NC}"
                ((LOCAL_ISSUES++))
            fi
        done <<< "$SUSPICIOUS"
    fi

    # Summary for this repo
    if [ $LOCAL_ISSUES -eq 0 ]; then
        echo -e "${GREEN}✅ No secrets found in git history${NC}"
    else
        echo -e "${RED}❌ Found $LOCAL_ISSUES potential issue(s) in git history${NC}"
        REPOS_WITH_ISSUES+=("$REPO_NAME: $LOCAL_ISSUES issues")
        ((TOTAL_ISSUES+=LOCAL_ISSUES))
    fi
}

# Scan all repos
for server in "${SERVERS[@]}"; do
    check_repo_history "$server"
done

# Final summary
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 Git History Security Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ $TOTAL_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ All repositories clean!${NC}"
    echo -e "${GREEN}   Safe to make repositories public.${NC}"
    exit 0
else
    echo -e "${RED}❌ Found secrets in git history!${NC}"
    echo -e "${RED}   Total issues: $TOTAL_ISSUES${NC}"
    echo -e "\n${YELLOW}Repositories with issues:${NC}"
    for repo_info in "${REPOS_WITH_ISSUES[@]}"; do
        echo -e "${YELLOW}   - $repo_info${NC}"
    done

    echo -e "\n${RED}🚨 CRITICAL: Do NOT make these repos public yet!${NC}"
    echo -e "\n${BLUE}Remediation options:${NC}"
    echo "1. Use BFG Repo-Cleaner to remove secrets from history:"
    echo "   brew install bfg"
    echo "   bfg --replace-text passwords.txt repo.git"
    echo ""
    echo "2. Use git-filter-repo (recommended):"
    echo "   pip install git-filter-repo"
    echo "   git filter-repo --invert-paths --path .env"
    echo ""
    echo "3. Squash history and start fresh (nuclear option):"
    echo "   Create new repo with current clean state only"
    echo ""
    echo "4. Revoke compromised API keys and regenerate"

    exit 1
fi
