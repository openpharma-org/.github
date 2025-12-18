# OpenPharma

> Open-source Model Context Protocol (MCP) servers for pharmaceutical intelligence and biomedical data access

## Overview

OpenPharma is a collection of specialized MCP servers that provide AI agents with seamless access to authoritative pharmaceutical and biomedical data sources. Built on Anthropic's Model Context Protocol, these servers enable agentic workflows across drug discovery, medical devices, health economics, policy research, and life sciences innovation.

## Available MCP Servers

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[fda-mcp](https://github.com/openpharma-org/fda-mcp)** | FDA drug labels, adverse events, recalls, shortages | FDA openFDA API |
| **[ema-mcp](https://github.com/openpharma-org/ema-mcp)** | EMA drug approvals, EPARs, orphan designations, EU shortages | EMA Public JSON API |
| **[ct-gov-mcp](https://github.com/openpharma-org/ct-gov-mcp)** | Clinical trial search and study information | ClinicalTrials.gov API v2 |
| **[pubmed-mcp](https://github.com/openpharma-org/pubmed-mcp)** | Biomedical literature search and retrieval | PubMed/NCBI E-utilities |
| **[nlm-codes-mcp](https://github.com/openpharma-org/nlm-codes-mcp)** | Medical coding systems (ICD-10/11, HCPCS, NPI) | NLM Clinical Tables API |
| **[who-mcp](https://github.com/openpharma-org/who-mcp)** | Global health statistics and indicators | WHO Global Health Observatory |
| **[cdc-mcp](https://github.com/openpharma-org/cdc-mcp)** | Disease surveillance, BRFSS, vaccination data | CDC WONDER, Socrata APIs |
| **[datacommons-mcp](https://github.com/openpharma-org/datacommons-mcp)** | Population statistics and disease burden | Google Data Commons |
| **[opentargets-mcp](https://github.com/openpharma-org/opentargets-mcp)** | Target validation and genetic evidence | Open Targets Platform |
| **[pubchem-mcp](https://github.com/openpharma-org/pubchem-mcp)** | Chemical structures and compound properties | PubChem REST API |
| **[drugbank-mcp](https://github.com/openpharma-org/drugbank-mcp-server)** | Drug information database (17,430+ drugs) with fast SQLite queries | DrugBank (SQLite) |
| **[sec-mcp](https://github.com/openpharma-org/sec-mcp)** | Company financials and SEC filings | SEC EDGAR API |
| **[eu-filings-mcp](https://github.com/openpharma-org/eu-filings-mcp-server)** | European financial filings and XBRL data | ESEF/filings.xbrl.org |
| **[asia-filings-mcp](https://github.com/openpharma-org/asia-filings-mcp-server)** | Asian financial filings from Japan and Korea | EDINET/DART APIs |
| **[medicare-mcp](https://github.com/openpharma-org/medicare-mcp)** | Medicare claims and provider data | CMS Medicare API |
| **[medicaid-mcp-server](https://github.com/openpharma-org/medicaid-mcp-server)** | Medicaid formularies, drug pricing, enrollment | CMS DKAN, State Formularies |
| **[patents-mcp](https://github.com/openpharma-org/patents-mcp)** | Patent search and IP intelligence | USPTO, Google Patents |
| **[financials-mcp](https://github.com/openpharma-org/financials-mcp)** | Stock data, economic indicators, FRED | Yahoo Finance, FRED API |

## Why It Matters

- **Unified data access**: Single protocol for authoritative pharmaceutical and biomedical data sources
- **Beyond pharma**: While pharma-focused, servers support medical devices, health economics, policy research, financial analysis, and life sciences innovation
- **Open collaboration**: MIT-licensed servers enable community contributions and customization
- **AI-native workflows**: Built for agentic systems, not just humans—enables autonomous research and analysis
- **Vendor-neutral**: No proprietary databases or subscriptions required, only public APIs

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
- **Caching**: Caching for expensive queries

---

**Made with ❤️**
