#!/bin/bash

# Migration script for OpenPharma MCP servers
# This script creates new repositories in openpharma-org and transfers code

set -e  # Exit on error

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 OpenPharma Server Migration Script${NC}\n"

# Server mappings: local_path|repo_name|description
declare -a SERVERS=(
    "/Users/joan.saez-pons/code/fda-mcp-server|fda-mcp|MCP server for FDA drug labels, adverse events, recalls, and safety data"
    "/Users/joan.saez-pons/code/ct.gov-mcp-server|ct-gov-mcp|MCP server for ClinicalTrials.gov trial search and study information"
    "/Users/joan.saez-pons/code/pubmed-mcp-server-npm|pubmed-mcp|MCP server for PubMed biomedical literature search and article retrieval"
    "/Users/joan.saez-pons/code/codes-mcp-server|nlm-codes-mcp|MCP server for medical coding systems (ICD-10/11, HCPCS, NPI, HPO)"
    "/Users/joan.saez-pons/code/who-mcp-server|who-mcp|MCP server for WHO Global Health Observatory statistics and indicators"
    "/Users/joan.saez-pons/code/sec-mcp-server|sec-mcp|MCP server for SEC EDGAR filings and company financial data"
    "/Users/joan.saez-pons/code/icd-mcp-server|healthcare-mcp|MCP server for CMS Medicare provider and claims data"
    "/Users/joan.saez-pons/code/yahoo-finance-mcp-server|financials-mcp|MCP server for stock data and FRED economic indicators"
    "/Users/joan.saez-pons/code/datacommons-mcp|datacommons-mcp|MCP server for Google Data Commons population and health statistics"
    "/Users/joan.saez-pons/code/opentargets-mcp-server|opentargets-mcp|MCP server for Open Targets genetic evidence and target validation"
    "/Users/joan.saez-pons/code/pubchem-mcp-server|pubchem-mcp|MCP server for PubChem chemical structures and compound properties"
    "/Users/joan.saez-pons/code/patent_mcp_server|patents-mcp|MCP server for USPTO and Google Patents search"
    "/Users/joan.saez-pons/code/cdc-mcp-server|cdc-mcp|MCP server for CDC disease surveillance and public health data"
)

# Function to migrate a single server
migrate_server() {
    local SOURCE_PATH=$1
    local REPO_NAME=$2
    local DESCRIPTION=$3

    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}📦 Migrating: ${REPO_NAME}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # Check if source path exists
    if [ ! -d "$SOURCE_PATH" ]; then
        echo -e "${RED}❌ Source path not found: $SOURCE_PATH${NC}"
        return 1
    fi

    cd "$SOURCE_PATH"

    # Check if it's a git repository
    if [ ! -d ".git" ]; then
        echo -e "${RED}❌ Not a git repository: $SOURCE_PATH${NC}"
        return 1
    fi

    # Update package.json if it exists (for npm packages)
    if [ -f "package.json" ]; then
        echo "📝 Updating package.json scope to @openpharma-org..."

        # Backup original
        cp package.json package.json.backup

        # Update name, repository, homepage, bugs URL
        cat package.json | \
            sed 's/"name": "@uh-joan\/\([^"]*\)"/"name": "@openpharma-org\/\1"/' | \
            sed 's/github.com\/uh-joan/github.com\/openpharma-org/' | \
            sed 's/Joan Saez-Pons <uh-joan@github.com>/OpenPharma Contributors/' \
            > package.json.tmp && mv package.json.tmp package.json

        echo -e "${GREEN}✓ Package.json updated${NC}"
    fi

    # Update pyproject.toml if it exists (for Python packages)
    if [ -f "pyproject.toml" ]; then
        echo "📝 Updating pyproject.toml..."

        cp pyproject.toml pyproject.toml.backup

        sed -i '' 's/github.com\/uh-joan/github.com\/openpharma-org/' pyproject.toml

        echo -e "${GREEN}✓ pyproject.toml updated${NC}"
    fi

    # Check for existing remote
    EXISTING_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")

    # Create new GitHub repository in openpharma-org
    echo "🔧 Creating repository: openpharma-org/${REPO_NAME}..."

    if gh repo view "openpharma-org/${REPO_NAME}" >/dev/null 2>&1; then
        echo -e "${BLUE}ℹ️  Repository already exists: openpharma-org/${REPO_NAME}${NC}"
        read -p "Do you want to force push? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Skipping ${REPO_NAME}"
            return 0
        fi
    else
        gh repo create "openpharma-org/${REPO_NAME}" \
            --public \
            --description "$DESCRIPTION" \
            --source=. \
            || {
                echo -e "${RED}❌ Failed to create repository${NC}"
                return 1
            }
    fi

    # Add/update remote
    if git remote get-url openpharma >/dev/null 2>&1; then
        git remote set-url openpharma "git@github.com:openpharma-org/${REPO_NAME}.git"
    else
        git remote add openpharma "git@github.com:openpharma-org/${REPO_NAME}.git"
    fi

    # Commit package.json changes if any
    if [ -f "package.json.backup" ] || [ -f "pyproject.toml.backup" ]; then
        git add package.json pyproject.toml 2>/dev/null || true
        git commit -m "Update package scope to @openpharma-org

- Change npm scope from @uh-joan to @openpharma-org
- Update repository URLs to openpharma-org
- Update author to OpenPharma Contributors" || echo "No changes to commit"
    fi

    # Push to new remote
    echo "📤 Pushing to openpharma-org/${REPO_NAME}..."
    git push openpharma main --force || git push openpharma master --force || {
        echo -e "${RED}❌ Failed to push to openpharma-org${NC}"
        return 1
    }

    echo -e "${GREEN}✅ Successfully migrated: ${REPO_NAME}${NC}"
    echo -e "${GREEN}🔗 https://github.com/openpharma-org/${REPO_NAME}${NC}"

    # Cleanup backups
    rm -f package.json.backup pyproject.toml.backup

    return 0
}

# Main migration loop
SUCCESSFUL=0
FAILED=0
SKIPPED=0

for server_info in "${SERVERS[@]}"; do
    IFS='|' read -r SOURCE_PATH REPO_NAME DESCRIPTION <<< "$server_info"

    if migrate_server "$SOURCE_PATH" "$REPO_NAME" "$DESCRIPTION"; then
        ((SUCCESSFUL++))
    else
        ((FAILED++))
    fi
done

# Summary
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 Migration Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Successful: ${SUCCESSFUL}${NC}"
echo -e "${RED}❌ Failed: ${FAILED}${NC}"
echo -e "\n${GREEN}🎉 Migration complete!${NC}"
echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Visit https://github.com/openpharma-org to see all repositories"
echo "2. Configure branch protection rules for main branches"
echo "3. Set up GitHub Actions for CI/CD"
echo "4. Add topics/tags to each repository for discoverability"
echo "5. Publish packages to npm registry with @openpharma-org scope"

cd -
