#!/bin/bash

# Cleanup script to remove secrets before migration

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🧹 OpenPharma Secrets Cleanup${NC}\n"

# Function to add file to .gitignore if not already there
add_to_gitignore() {
    local DIR=$1
    local PATTERN=$2

    if [ -f "$DIR/.gitignore" ]; then
        if ! grep -q "^$PATTERN$" "$DIR/.gitignore"; then
            echo "$PATTERN" >> "$DIR/.gitignore"
            echo -e "${GREEN}   ✓ Added '$PATTERN' to .gitignore${NC}"
        fi
    else
        echo "$PATTERN" > "$DIR/.gitignore"
        echo -e "${GREEN}   ✓ Created .gitignore with '$PATTERN'${NC}"
    fi
}

# Function to create .env.example from .env
create_env_example() {
    local DIR=$1

    if [ -f "$DIR/.env" ] && [ ! -f "$DIR/.env.example" ]; then
        # Create .env.example with placeholders
        sed 's/=.*/=your_api_key_here/' "$DIR/.env" > "$DIR/.env.example"
        echo -e "${GREEN}   ✓ Created .env.example${NC}"
    fi
}

# Function to remove secrets from .mcp.json
clean_mcp_json() {
    local DIR=$1

    if [ -f "$DIR/.mcp.json" ]; then
        echo -e "${YELLOW}   ⚠️  Found .mcp.json with potential secrets${NC}"
        add_to_gitignore "$DIR" ".mcp.json"

        # Create .mcp.json.example if doesn't exist
        if [ ! -f "$DIR/.mcp.json.example" ]; then
            # Replace all API keys/tokens with placeholder
            cat "$DIR/.mcp.json" | \
                sed 's/"[A-Za-z0-9_+/=]\{20,\}"/"your_api_key_here"/g' \
                > "$DIR/.mcp.json.example"
            echo -e "${GREEN}   ✓ Created .mcp.json.example${NC}"
        fi
    fi
}

# Clean fda-mcp-server
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔧 Cleaning: fda-mcp-server${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
DIR="/Users/joan.saez-pons/code/fda-mcp-server"
cd "$DIR"
add_to_gitignore "$DIR" ".env"
add_to_gitignore "$DIR" ".mcp.json"
create_env_example "$DIR"
clean_mcp_json "$DIR"

# Remove hardcoded key from test file
if [ -f "tests/integration/test-claude-desktop.js" ]; then
    sed -i.backup 's/FDA_API_KEY: '"'"'[^'"'"']*'"'"'/FDA_API_KEY: process.env.FDA_API_KEY || '"'"'test_key'"'"'/' tests/integration/test-claude-desktop.js
    rm -f tests/integration/test-claude-desktop.js.backup
    echo -e "${GREEN}   ✓ Removed hardcoded key from test file${NC}"
fi

# Clean yahoo-finance-mcp-server (financials-mcp)
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔧 Cleaning: yahoo-finance-mcp-server${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
DIR="/Users/joan.saez-pons/code/yahoo-finance-mcp-server"
if [ -d "$DIR" ]; then
    cd "$DIR"
    add_to_gitignore "$DIR" ".env"
    create_env_example "$DIR"
fi

# Clean datacommons-mcp
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔧 Cleaning: datacommons-mcp${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
DIR="/Users/joan.saez-pons/code/datacommons-mcp"
if [ -d "$DIR" ]; then
    cd "$DIR"
    add_to_gitignore "$DIR" ".env"
    create_env_example "$DIR"
fi

# Clean patent_mcp_server (credentials.json)
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔧 Cleaning: patent_mcp_server${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
DIR="/Users/joan.saez-pons/code/patent_mcp_server"
if [ -d "$DIR" ]; then
    cd "$DIR"
    add_to_gitignore "$DIR" "*-credentials.json"
    add_to_gitignore "$DIR" "credentials.json"

    # Create credentials.json.example
    if [ -f "toolrowai-credentials.json" ] && [ ! -f "credentials.json.example" ]; then
        cat > credentials.json.example <<EOF
{
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "your-private-key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----\\nYOUR_PRIVATE_KEY_HERE\\n-----END PRIVATE KEY-----\\n",
  "client_email": "your-service-account@your-project.iam.gserviceaccount.com",
  "client_id": "your-client-id",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/your-service-account%40your-project.iam.gserviceaccount.com"
}
EOF
        echo -e "${GREEN}   ✓ Created credentials.json.example${NC}"
    fi
fi

# Clean cdc-mcp-server
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔧 Cleaning: cdc-mcp-server${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
DIR="/Users/joan.saez-pons/code/cdc-mcp-server"
if [ -d "$DIR" ]; then
    cd "$DIR"
    add_to_gitignore "$DIR" ".env"
    create_env_example "$DIR"
fi

echo -e "\n${GREEN}✅ Cleanup complete!${NC}"
echo -e "\n${YELLOW}⚠️  IMPORTANT: Review changes before committing${NC}"
echo -e "${YELLOW}   - Check that .env files are in .gitignore${NC}"
echo -e "${YELLOW}   - Verify .env.example files have placeholders${NC}"
echo -e "${YELLOW}   - Ensure credential files are ignored${NC}"
