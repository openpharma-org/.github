# OpenPharma

> Open-source Model Context Protocol (MCP) servers for pharmaceutical intelligence and biomedical data access

## Overview

OpenPharma is a collection of 50+ specialized MCP servers that provide AI agents with seamless access to authoritative pharmaceutical and biomedical data sources. Built on Anthropic's Model Context Protocol, these servers enable agentic workflows across drug discovery, genomics, clinical research, health economics, and life sciences innovation.

All servers are bundled into [BioClaw](https://github.com/uh-joan/bioclaw), a biomedical AI assistant that runs them in isolated containers.

## Available MCP Servers

### Drug & Regulatory

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[FDA](https://github.com/openpharma-org/fda-mcp)** | Drug labels, adverse events, recalls, shortages | FDA openFDA API |
| **[EMA](https://github.com/openpharma-org/ema-mcp)** | Drug approvals, EPARs, orphan designations, EU shortages | EMA Public JSON API |
| **[DrugBank](https://github.com/openpharma-org/drugbank-mcp-server)** | Drug information database (17,430+ drugs) | DrugBank (SQLite) |
| **[ChEMBL](https://github.com/openpharma-org/chembl-mcp)** | Bioactive compounds, targets, mechanisms of action | ChEMBL REST API (EMBL-EBI) |
| **[PubChem](https://github.com/openpharma-org/pubchem-mcp)** | Chemical structures and compound properties | PubChem REST API |
| **[Open Targets](https://github.com/openpharma-org/opentargets-mcp)** | Target validation and genetic evidence | Open Targets Platform |
| **[ClinicalTrials](https://github.com/openpharma-org/ct-gov-mcp)** | Clinical trial search and study information | ClinicalTrials.gov API v2 |

### Genomics & Variants

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[NCBI](https://github.com/openpharma-org/ncbi-mcp-server)** | Gene, Protein, Nucleotide, OMIM databases | NCBI E-utilities |
| **[ClinVar](https://github.com/openpharma-org/clinvar-mcp-server)** | Variant interpretation via NCBI E-utilities | ClinVar / NCBI |
| **[COSMIC](https://github.com/openpharma-org/cosmic-mcp-server)** | Somatic mutations in cancer | COSMIC |
| **[GWAS Catalog](https://github.com/openpharma-org/gwas-mcp-server)** | GWAS associations and studies | NHGRI-EBI GWAS Catalog |
| **[gnomAD](https://github.com/openpharma-org/gnomad-mcp-server)** | Population allele frequencies | gnomAD API |
| **[Ensembl](https://github.com/openpharma-org/ensembl-mcp-server)** | Genome annotation and variation | Ensembl REST API |
| **[GTEx](https://github.com/openpharma-org/gtex-mcp-server)** | Tissue-specific gene expression | GTEx Portal |
| **[GEO](https://github.com/openpharma-org/geo-mcp-server)** | Gene expression datasets | NCBI GEO E-utilities |
| **[JASPAR](https://github.com/openpharma-org/jaspar-mcp-server)** | Transcription factor binding profiles | JASPAR REST API |

### Proteomics & Structure

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[UniProt](https://github.com/openpharma-org/uniprot-mcp-server)** | Protein sequences and functional annotation | UniProt REST API |
| **[AlphaFold](https://github.com/openpharma-org/alphafold-mcp-server)** | Predicted protein structures | AlphaFold DB API |
| **[PDB](https://github.com/openpharma-org/pdb-mcp-server)** | Experimental protein structures | RCSB PDB REST API |
| **[STRING-db](https://github.com/openpharma-org/stringdb-mcp-server)** | Protein-protein interaction networks | STRING API |
| **[BindingDB](https://github.com/openpharma-org/bindingdb-mcp-server)** | Binding affinity data | BindingDB |
| **[EMBL-EBI](https://github.com/openpharma-org/embl-mcp-server)** | InterPro domains, Pfam families, protein features | EMBL-EBI APIs |
| **[ChEBI](https://github.com/openpharma-org/chebi-mcp-server)** | Chemical entity classification and ontology | ChEBI / OLS4 API |

### Pathways & Ontology

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[Reactome](https://github.com/openpharma-org/reactome-mcp-server)** | Biological pathways and reactions | Reactome Content Service |
| **[KEGG](https://github.com/openpharma-org/kegg-mcp-server)** | Metabolic and signaling pathways | KEGG REST API |
| **[Gene Ontology](https://github.com/openpharma-org/geneontology-mcp-server)** | Gene function annotations | GO API |
| **[HPO](https://github.com/openpharma-org/hpo-mcp-server)** | Human phenotype ontology | HPO API |
| **[Monarch](https://github.com/openpharma-org/monarch-mcp-server)** | Disease-gene-phenotype knowledge graph | Monarch Initiative API |

### Cancer & Dependencies

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[DepMap](https://github.com/openpharma-org/depmap-mcp-server)** | Cancer dependency map | DepMap Portal |
| **[cBioPortal](https://github.com/openpharma-org/cbioportal-mcp-server)** | Cancer genomics data | cBioPortal API |

### Metabolomics & Pharmacogenomics

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[HMDB](https://github.com/openpharma-org/hmdb-mcp-server)** | Human metabolome database | HMDB |
| **[ClinPGx](https://github.com/openpharma-org/clinpgx-mcp-server)** | Pharmacogenomics data | PharmGKB |

### Literature & Knowledge

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[PubMed](https://github.com/openpharma-org/pubmed-mcp)** | Biomedical literature search | PubMed/NCBI E-utilities |
| **[bioRxiv](https://github.com/openpharma-org/biorxiv-mcp)** | Preprint search and tracking | bioRxiv/medRxiv API |
| **[OpenAlex](https://github.com/openpharma-org/openalex-mcp-server)** | Scholarly works and citations | OpenAlex API |
| **[CrossRef](https://github.com/openpharma-org/crossref-mcp-server)** | DOI metadata, citations, 150M+ scholarly works | CrossRef REST API |
| **[CORE](https://github.com/openpharma-org/core-mcp-server)** | 200M+ open access research papers | CORE API v3 |
| **[NLM Codes](https://github.com/openpharma-org/nlm-codes-mcp)** | Medical coding (ICD-10/11, HCPCS, NPI) | NLM Clinical Tables API |

### Healthcare & Policy

| Server | Description | Data Source |
|--------|-------------|-------------|
| **[CDC](https://github.com/openpharma-org/cdc-mcp)** | Disease surveillance, vaccination data | CDC WONDER, Socrata APIs |
| **[Medicare](https://github.com/openpharma-org/medicare-mcp)** | Medicare claims and provider data | CMS Medicare API |
| **[Medicaid](https://github.com/openpharma-org/medicaid-mcp-server)** | Formularies, drug pricing, enrollment | CMS DKAN, State Formularies |
| **[EU Filings](https://github.com/openpharma-org/eu-filings-mcp-server)** | European financial filings and XBRL data | ESEF/filings.xbrl.org |

## BioClaw

All OpenPharma MCP servers come pre-bundled in [BioClaw](https://github.com/uh-joan/bioclaw), a biomedical AI assistant built on [NanoClaw](https://github.com/qwibitai/nanoclaw). One Docker image, 50 MCP servers, 120+ specialized agent skills, zero configuration.

## Why It Matters

- **Unified data access**: Single protocol for 50 authoritative pharmaceutical and biomedical data sources
- **Beyond pharma**: Genomics, proteomics, pathways, cancer biology, metabolomics, and more
- **Open collaboration**: MIT-licensed servers enable community contributions and customization
- **AI-native workflows**: Built for agentic systems — enables autonomous research and analysis
- **Vendor-neutral**: No proprietary databases or subscriptions required, only public APIs

## Architecture

```
┌─────────────┐
│  AI Agent   │ (Claude, custom agents, BioClaw)
└──────┬──────┘
       │ MCP Protocol (JSON-RPC)
       │
┌──────▼──────────────────────────┐
│  OpenPharma MCP Servers (50)    │
│  ┌───────┐ ┌────────┐ ┌──────┐ │
│  │  FDA  │ │ClinVar │ │PubMed│ │
│  └───┬───┘ └────┬───┘ └──┬───┘ │
└──────┼──────────┼─────────┼─────┘
       │          │         │
  ┌────▼───┐ ┌───▼───┐ ┌──▼────┐
  │openFDA │ │ NCBI  │ │PubMed │
  │  API   │ │E-util │ │E-util │
  └────────┘ └───────┘ └───────┘
```

**Key Design Principles:**
- **Stateless**: No data persistence, servers are pure API gateways
- **Type-safe**: Full TypeScript type definitions
- **Error handling**: Graceful degradation and clear error messages
- **Rate limiting**: Built-in respect for API rate limits
- **Caching**: Caching for expensive queries
