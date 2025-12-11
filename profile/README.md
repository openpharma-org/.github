# OpenPharma

> Open-source Model Context Protocol (MCP) servers for pharmaceutical intelligence and biomedical data access

[![MCP](https://img.shields.io/badge/MCP-Compatible-blue)](https://modelcontextprotocol.io)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

## Overview

OpenPharma is a collection of specialized MCP servers that provide AI agents with seamless access to authoritative pharmaceutical and biomedical data sources. Built on Anthropic's Model Context Protocol, these servers enable agentic workflows for drug discovery, clinical research, regulatory intelligence, and competitive analysis.

### Key Features

✅ **Authoritative Data Sources**: FDA, ClinicalTrials.gov, PubMed, WHO, CDC, USPTO, SEC, and more
✅ **Production-Ready**: Battle-tested in pharmaceutical research workflows
✅ **Type-Safe**: Full TypeScript/Python type definitions
✅ **Well-Documented**: Comprehensive API docs and usage examples
✅ **Composable**: Designed to work together for multi-source intelligence
✅ **Open Source**: MIT licensed, community-driven development

## Available MCP Servers

### 🏥 Clinical & Regulatory (Core)

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[fda-mcp](https://github.com/openpharma/fda-mcp)** | FDA drug labels, adverse events, recalls, shortages | FDA openFDA API |
| **[ct-gov-mcp](https://github.com/openpharma/ct-gov-mcp)** | Clinical trial search and study information | ClinicalTrials.gov API v2 |
| **[pubmed-mcp](https://github.com/openpharma/pubmed-mcp)** | Biomedical literature search and retrieval | PubMed/NCBI E-utilities |
| **[nlm-codes-mcp](https://github.com/openpharma/nlm-codes-mcp)** | Medical coding systems (ICD-10/11, HCPCS, NPI) | NLM Clinical Tables API |

### 🌍 Public Health & Epidemiology

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[who-mcp](https://github.com/openpharma/who-mcp)** | Global health statistics and indicators | WHO Global Health Observatory |
| **[cdc-mcp](https://github.com/openpharma/cdc-mcp)** | Disease surveillance, BRFSS, vaccination data | CDC WONDER, Socrata APIs |
| **[datacommons-mcp](https://github.com/openpharma/datacommons-mcp)** | Population statistics and disease burden | Google Data Commons |

### 💊 Drug Discovery & Chemistry

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[opentargets-mcp](https://github.com/openpharma/opentargets-mcp)** | Target validation and genetic evidence | Open Targets Platform |
| **[pubchem-mcp](https://github.com/openpharma/pubchem-mcp)** | Chemical structures and compound properties | PubChem REST API |

### 📊 Business Intelligence

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[sec-mcp](https://github.com/openpharma/sec-mcp)** | Company financials and SEC filings | SEC EDGAR API |
| **[healthcare-mcp](https://github.com/openpharma/healthcare-mcp)** | Medicare claims and provider data | CMS Medicare API |
| **[patents-mcp](https://github.com/openpharma/patents-mcp)** | Patent search and IP intelligence | USPTO, Google Patents |

### 📈 Financial & Economic (Third-Party)

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[financials-mcp](https://github.com/openpharma/financials-mcp)** | Stock data, economic indicators, FRED | Yahoo Finance, FRED API |

## Quick Start

See individual server repositories for installation and configuration instructions.

## Use Cases

### 🔬 Drug Discovery Research
- Identify therapeutic targets with genetic evidence
- Search chemical libraries and compounds
- Analyze clinical trial landscapes
- Track competitive intelligence

### 🏥 Clinical Development
- Design trial protocols based on precedent
- Monitor recruiting trials in therapeutic area
- Track adverse events and safety signals
- Analyze trial success rates by indication

### 📋 Regulatory Intelligence
- Research FDA approval precedents
- Track drug label changes
- Monitor recalls and shortages
- Analyze approval timelines

### 💼 Competitive Analysis
- Map company pipelines and R&D spend
- Track patent landscapes
- Analyze market positioning
- Monitor partnership activity

### 📊 Market Access Strategy
- Analyze disease burden and epidemiology
- Research payer coverage and reimbursement
- Track prescriber patterns
- Evaluate health economics data

## Architecture

OpenPharma servers follow the Model Context Protocol specification:

```
┌─────────────┐
│  AI Agent   │ (Claude, custom agents)
└──────┬──────┘
       │ MCP Protocol (JSON-RPC)
       │
┌──────▼──────────────────────────┐
│  OpenPharma MCP Servers         │
│  ┌───────────┐  ┌────────────┐ │
│  │  FDA MCP  │  │ CT.gov MCP │ │
│  └─────┬─────┘  └──────┬─────┘ │
└────────┼────────────────┼───────┘
         │                │
    ┌────▼────┐      ┌───▼────┐
    │ FDA API │      │CT.gov  │
    │openFDA  │      │API v2  │
    └─────────┘      └────────┘
```

**Key Design Principles:**
- **Stateless**: No data persistence, servers are pure API gateways
- **Type-safe**: Full TypeScript/Python type definitions
- **Error handling**: Graceful degradation and clear error messages
- **Rate limiting**: Built-in respect for API rate limits
- **Caching**: Optional caching for expensive queries

## Contributing

We welcome contributions! Each server repository has its own contribution guidelines.

**General Contribution Process:**
1. Fork the relevant server repository
2. Create a feature branch
3. Make your changes with tests
4. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

**Made with ❤️ by the pharmaceutical AI community**
