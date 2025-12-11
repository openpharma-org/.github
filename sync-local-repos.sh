#!/bin/bash

# Sync local repositories with openpharma-org
# Updates git remotes and pushes local changes

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔄 Syncing Local Repos with OpenPharma Org${NC}\n"

# Server mappings: local_path|org_repo_name
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

sync_repo() {
    local LOCAL_PATH=$1
    local REPO_NAME=$2

    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}🔄 Syncing: ${REPO_NAME}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [ ! -d "$LOCAL_PATH" ]; then
        echo -e "${YELLOW}⚠️  Directory not found: $LOCAL_PATH${NC}"
        return 1
    fi

    if [ ! -d "$LOCAL_PATH/.git" ]; then
        echo -e "${YELLOW}⚠️  Not a git repository: $LOCAL_PATH${NC}"
        return 1
    fi

    cd "$LOCAL_PATH"

    # Show current remote
    CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "none")
    echo -e "${YELLOW}Current remote: $CURRENT_REMOTE${NC}"

    # Update origin to openpharma-org
    NEW_REMOTE="git@github.com:openpharma-org/${REPO_NAME}.git"

    if git remote get-url origin >/dev/null 2>&1; then
        git remote set-url origin "$NEW_REMOTE"
        echo -e "${GREEN}✓ Updated origin to: $NEW_REMOTE${NC}"
    else
        git remote add origin "$NEW_REMOTE"
        echo -e "${GREEN}✓ Added origin: $NEW_REMOTE${NC}"
    fi

    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        echo -e "${YELLOW}📝 Found uncommitted changes${NC}"
        git status --short

        # Stage all changes
        git add .

        # Commit
        git commit -m "Sync local changes to openpharma-org

- Update package scope to @openpharma-org
- Sync with organization repository
- Local development changes" || echo "Nothing new to commit"
    else
        echo -e "${GREEN}✓ No uncommitted changes${NC}"
    fi

    # Pull latest from openpharma-org (if exists)
    echo -e "${BLUE}📥 Pulling latest from openpharma-org...${NC}"
    if git pull origin main --rebase 2>/dev/null; then
        echo -e "${GREEN}✓ Pulled latest changes${NC}"
    else
        echo -e "${YELLOW}⚠️  Could not pull (may be first push)${NC}"
    fi

    # Push to openpharma-org
    echo -e "${BLUE}📤 Pushing to openpharma-org...${NC}"
    if git push -u origin main 2>/dev/null; then
        echo -e "${GREEN}✅ Successfully synced: ${REPO_NAME}${NC}"
    else
        # Try force push if regular push fails
        echo -e "${YELLOW}⚠️  Regular push failed, trying force push...${NC}"
        if git push -u origin main --force; then
            echo -e "${GREEN}✅ Successfully synced (force): ${REPO_NAME}${NC}"
        else
            echo -e "${RED}❌ Failed to push: ${REPO_NAME}${NC}"
            return 1
        fi
    fi

    echo -e "${GREEN}🔗 Local repo now connected to: https://github.com/openpharma-org/${REPO_NAME}${NC}"

    cd -
    return 0
}

SUCCESSFUL=0
FAILED=0

for server_info in "${SERVERS[@]}"; do
    IFS='|' read -r LOCAL_PATH REPO_NAME <<< "$server_info"

    if sync_repo "$LOCAL_PATH" "$REPO_NAME"; then
        ((SUCCESSFUL++))
    else
        ((FAILED++))
    fi
done

# Summary
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 Sync Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Successful: ${SUCCESSFUL}${NC}"
echo -e "${RED}❌ Failed: ${FAILED}${NC}"

if [ $SUCCESSFUL -gt 0 ]; then
    echo -e "\n${GREEN}🎉 Local repos synced with OpenPharma organization!${NC}"
    echo -e "${GREEN}You can now develop locally and push to openpharma-org${NC}"
fi
