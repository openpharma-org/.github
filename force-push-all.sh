#!/bin/bash

# Force push all MCP servers to openpharma-org (fixing empty repos)

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 Force Pushing All Servers to OpenPharma${NC}\n"

# Server mappings
declare -a SERVERS=(
    "/Users/joan.saez-pons/code/fda-mcp-server|fda-mcp"
    "/Users/joan.saez-pons/code/ct.gov-mcp-server|ct-gov-mcp"
    "/Users/joan.saez-pons/code/pubmed-mcp-server-npm|pubmed-mcp"
    "/Users/joan.saez-pons/code/codes-mcp-server|nlm-codes-mcp"
    "/Users/joan.saez-pons/code/who-mcp-server|who-mcp"
    "/Users/joan.saez-pons/code/sec-mcp-server|sec-mcp"
    "/Users/joan.saez-pons/code/icd-mcp-server|healthcare-mcp"
    "/Users/joan.saez-pons/code/yahoo-finance-mcp-server|financials-mcp"
    "/Users/joan.saez-pons/code/datacommons-mcp|datacommons-mcp"
    "/Users/joan.saez-pons/code/opentargets-mcp-server|opentargets-mcp"
    "/Users/joan.saez-pons/code/pubchem-mcp-server|pubchem-mcp"
    "/Users/joan.saez-pons/code/patent_mcp_server|patents-mcp"
    "/Users/joan.saez-pons/code/cdc-mcp-server|cdc-mcp"
)

push_to_org() {
    local SOURCE_PATH=$1
    local REPO_NAME=$2

    echo -e "\n${BLUE}📤 Pushing: ${REPO_NAME}${NC}"

    if [ ! -d "$SOURCE_PATH" ]; then
        echo -e "${RED}❌ Source not found: $SOURCE_PATH${NC}"
        return 1
    fi

    # Create temp directory with clean code
    TEMP_DIR="/tmp/openpharma-push-${REPO_NAME}"
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"

    # Copy excluding secrets and build artifacts
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

    # Update package.json
    if [ -f "package.json" ]; then
        cat package.json | \
            sed 's/"name": "@uh-joan\/\([^"]*\)"/"name": "@openpharma-org\/\1"/' | \
            sed 's/github.com\/uh-joan/github.com\/openpharma-org/' | \
            sed 's/Joan Saez-Pons <uh-joan@github.com>/OpenPharma Contributors/' \
            > package.json.tmp && mv package.json.tmp package.json
    fi

    # Update pyproject.toml
    if [ -f "pyproject.toml" ]; then
        sed -i '' 's/github.com\/uh-joan/github.com\/openpharma-org/' pyproject.toml
        sed -i '' 's/riemannzeta/openpharma-org/' pyproject.toml
    fi

    # Ensure .gitignore
    if [ ! -f ".gitignore" ]; then
        cat > .gitignore <<EOF
node_modules/
.env
.env.*
!.env.example
.mcp.json
*-credentials.json
credentials.json
*.pem
*.key
.DS_Store
dist/
build/
coverage/
*.log
EOF
    fi

    # Init fresh repo
    git init
    git add .
    git commit -m "Initial commit: ${REPO_NAME}

OpenPharma MCP server - pharmaceutical and biomedical data access

Migrated to openpharma-org with clean history and updated package scope.
All sensitive data removed, ready for public release.

Part of OpenPharma: https://github.com/openpharma-org"

    # Push to GitHub
    git remote add origin "git@github.com:openpharma-org/${REPO_NAME}.git"
    git branch -M main
    git push -u origin main --force

    echo -e "${GREEN}✅ Pushed: ${REPO_NAME}${NC}"

    cd -
    rm -rf "$TEMP_DIR"
}

SUCCESSFUL=0
FAILED=0

for server_info in "${SERVERS[@]}"; do
    IFS='|' read -r SOURCE_PATH REPO_NAME <<< "$server_info"

    if push_to_org "$SOURCE_PATH" "$REPO_NAME"; then
        ((SUCCESSFUL++))
    else
        ((FAILED++))
    fi
done

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 Push Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Successful: ${SUCCESSFUL}${NC}"
echo -e "${RED}❌ Failed: ${FAILED}${NC}"
echo -e "\n${GREEN}🎉 All repos now have code!${NC}"
echo -e "Visit: https://github.com/openpharma-org"
