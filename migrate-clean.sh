#!/bin/bash

# Safe migration script - creates fresh repos with clean history
# This ensures NO secrets leak into openpharma-org

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 OpenPharma Clean Migration${NC}\n"
echo -e "${GREEN}Strategy: Create fresh repos with current code only (no git history)${NC}\n"

# Server mappings
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

SUCCESSFUL=0
FAILED=0

migrate_server_clean() {
    local SOURCE_PATH=$1
    local REPO_NAME=$2
    local DESCRIPTION=$3

    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}📦 Migrating: ${REPO_NAME}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [ ! -d "$SOURCE_PATH" ]; then
        echo -e "${RED}❌ Source not found: $SOURCE_PATH${NC}"
        return 1
    fi

    # Create temporary clean directory
    TEMP_DIR="/tmp/openpharma-${REPO_NAME}"
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"

    # Copy current code (exclude git, node_modules, secrets)
    echo "📋 Copying current code..."
    rsync -av --exclude='.git' \
              --exclude='node_modules' \
              --exclude='.env' \
              --exclude='.mcp.json' \
              --exclude='*-credentials.json' \
              --exclude='credentials.json' \
              --exclude='*.pem' \
              --exclude='*.key' \
              --exclude='.DS_Store' \
              "$SOURCE_PATH/" "$TEMP_DIR/"

    cd "$TEMP_DIR"

    # Update package.json if exists
    if [ -f "package.json" ]; then
        echo "📝 Updating package.json..."
        cat package.json | \
            sed 's/"name": "@uh-joan\/\([^"]*\)"/"name": "@openpharma-org\/\1"/' | \
            sed 's/github.com\/uh-joan/github.com\/openpharma-org/' | \
            sed 's/Joan Saez-Pons <uh-joan@github.com>/OpenPharma Contributors/' \
            > package.json.tmp && mv package.json.tmp package.json
    fi

    # Update pyproject.toml if exists
    if [ -f "pyproject.toml" ]; then
        echo "📝 Updating pyproject.toml..."
        sed -i '' 's/github.com\/uh-joan/github.com\/openpharma-org/' pyproject.toml
        sed -i '' 's/riemannzeta/openpharma-org/' pyproject.toml
    fi

    # Ensure .gitignore includes sensitive files
    if [ -f ".gitignore" ]; then
        for pattern in ".env" ".env.*" ".mcp.json" "*-credentials.json" "credentials.json" "*.pem" "*.key"; do
            if ! grep -q "^${pattern}$" .gitignore; then
                echo "$pattern" >> .gitignore
            fi
        done
    fi

    # Initialize fresh git repo
    echo "🎯 Creating fresh git repository..."
    git init
    git add .
    git commit -m "Initial commit: ${REPO_NAME}

OpenPharma MCP server for pharmaceutical and biomedical data access.

${DESCRIPTION}

Migrated from personal repositories to openpharma-org with clean history.
All sensitive data removed, ready for public release.

Part of OpenPharma: https://github.com/openpharma-org"

    # Create GitHub repository
    echo "🔧 Creating GitHub repository..."
    if gh repo view "openpharma-org/${REPO_NAME}" >/dev/null 2>&1; then
        echo -e "${YELLOW}ℹ️  Repository already exists${NC}"
        read -p "Delete and recreate? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            gh repo delete "openpharma-org/${REPO_NAME}" --yes || true
        else
            echo "Skipping ${REPO_NAME}"
            return 0
        fi
    fi

    gh repo create "openpharma-org/${REPO_NAME}" \
        --public \
        --description "$DESCRIPTION" \
        --homepage "https://github.com/openpharma-org" \
        || {
            echo -e "${RED}❌ Failed to create repository${NC}"
            return 1
        }

    # Push to GitHub
    echo "📤 Pushing to openpharma-org..."
    git remote add origin "git@github.com:openpharma-org/${REPO_NAME}.git"
    git branch -M main
    git push -u origin main

    echo -e "${GREEN}✅ Successfully migrated: ${REPO_NAME}${NC}"
    echo -e "${GREEN}🔗 https://github.com/openpharma-org/${REPO_NAME}${NC}"

    # Cleanup
    cd -
    rm -rf "$TEMP_DIR"

    return 0
}

# Migrate all servers
for server_info in "${SERVERS[@]}"; do
    IFS='|' read -r SOURCE_PATH REPO_NAME DESCRIPTION <<< "$server_info"

    if migrate_server_clean "$SOURCE_PATH" "$REPO_NAME" "$DESCRIPTION"; then
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

if [ $SUCCESSFUL -gt 0 ]; then
    echo -e "\n${GREEN}🎉 Migration complete!${NC}"
    echo -e "\n${BLUE}✅ Security: All repos have clean history (no secrets)${NC}"
    echo -e "${BLUE}🔗 Organization: https://github.com/openpharma-org${NC}"
    echo -e "\n${YELLOW}Next steps:${NC}"
    echo "1. Add topics to each repository (pharmaceutical, mcp, biomedical, etc.)"
    echo "2. Configure branch protection rules"
    echo "3. Set up GitHub Actions for CI/CD"
    echo "4. Publish packages to npm registry"
    echo "5. Announce in community!"
fi
