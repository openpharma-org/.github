# OpenPharma

> Open-source Model Context Protocol (MCP) servers for pharmaceutical intelligence and biomedical data access

## Overview

OpenPharma is a collection of specialized MCP servers that provide AI agents with seamless access to authoritative pharmaceutical and biomedical data sources. Built on Anthropic's Model Context Protocol, these servers enable agentic workflows for drug discovery, clinical research, regulatory intelligence, and competitive analysis.

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
| **[sec-mcp](https://github.com/openpharma-org/sec-mcp)** | Company financials and SEC filings | SEC EDGAR API |
| **[medicare-mcp](https://github.com/openpharma-org/medicare-mcp)** | Medicare claims and provider data | CMS Medicare API |
| **[medicaid-mcp-server](https://github.com/openpharma-org/medicaid-mcp-server)** | Medicaid drug pricing, enrollment, utilization | CMS DKAN (data.medicaid.gov) |
| **[patents-mcp](https://github.com/openpharma-org/patents-mcp)** | Patent search and IP intelligence | USPTO, Google Patents |
| **[financials-mcp](https://github.com/openpharma-org/financials-mcp)** | Stock data, economic indicators, FRED | Yahoo Finance, FRED API |

## Use Cases

### Drug Discovery Research
- Identify therapeutic targets with genetic evidence
- Search chemical libraries and compounds
- Analyze clinical trial landscapes
- Track competitive intelligence

### Clinical Development
- Design trial protocols based on precedent
- Monitor recruiting trials in therapeutic area
- Track adverse events and safety signals
- Analyze trial success rates by indication

### Regulatory Intelligence
- Research FDA approval precedents
- Track drug label changes
- Monitor recalls and shortages
- Analyze approval timelines

### Competitive Analysis
- Map company pipelines and R&D spend
- Track patent landscapes
- Analyze market positioning
- Monitor partnership activity

### Market Access Strategy
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

---

**Made with ❤️**
