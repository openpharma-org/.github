# OpenPharma Server Catalog

Complete catalog of all OpenPharma MCP servers with standardized descriptions for migration to GitHub organization.

---

## 1. FDA MCP Server

**Repository**: `fda-mcp`
**Package Name**: `@openpharma/fda-mcp` (npm) / `openpharma-fda-mcp` (pip)
**Current Location**: Local development
**Language**: Python

### Description
MCP server providing access to FDA drug information including drug labels, adverse events (FAERS), enforcement reports, recalls, and drug shortages through the openFDA API.

### Key Features
- Drug label search and retrieval
- Adverse event reporting (FAERS)
- Drug recalls and enforcement actions
- Drug shortage information
- Medical device data (510k, PMA, recalls)

### Data Source
- **API**: FDA openFDA REST API
- **Authority**: U.S. Food and Drug Administration
- **Update Frequency**: Daily
- **Rate Limits**: 1000 requests/minute (240/minute without API key)
- **API Key**: Optional (increases rate limits)

### Methods
- `lookup_drug`: Search drugs by name or compound
- `get_adverse_events`: Query FAERS adverse event data
- `get_recalls`: Search drug/device recalls
- `get_shortages`: Current drug shortage information
- `get_device_info`: Medical device registration data

---

## 2. ClinicalTrials.gov MCP Server

**Repository**: `ct-gov-mcp`
**Package Name**: `@openpharma/ct-gov-mcp` (npm) / `openpharma-ct-gov-mcp` (pip)
**Current Location**: Local development
**Language**: Python

### Description
MCP server for searching and retrieving clinical trial information from ClinicalTrials.gov using the official API v2. Supports advanced filtering by phase, status, condition, intervention, and location.

### Key Features
- Clinical trial search with advanced filters
- Study detail retrieval by NCT ID
- Term suggestions for search refinement
- Support for complex queries with boolean operators
- Pagination handling for large result sets

### Data Source
- **API**: ClinicalTrials.gov API v2
- **Authority**: U.S. National Library of Medicine
- **Update Frequency**: Daily
- **Rate Limits**: None specified
- **API Key**: Not required

### Methods
- `search`: Search trials by condition, intervention, phase, status
- `get_study`: Retrieve complete study information by NCT ID
- `suggest`: Get term suggestions for search fields
- Complex query support with AREA[], RANGE[], boolean operators

---

## 3. PubMed MCP Server

**Repository**: `pubmed-mcp`
**Package Name**: `@openpharma/pubmed-mcp` (npm) / `openpharma-pubmed-mcp` (pip)
**Current Location**: Local development
**Language**: Python

### Description
MCP server for searching biomedical literature and retrieving article metadata from PubMed/NCBI. Provides access to 35+ million citations with full-text PDF download when available.

### Key Features
- Keyword and advanced search across 35M+ articles
- Article metadata retrieval (title, abstract, authors, journal)
- Full-text PDF download (when available)
- PubMed search operators support (AND, OR, NOT)
- Date range filtering

### Data Source
- **API**: NCBI E-utilities API
- **Authority**: National Center for Biotechnology Information
- **Update Frequency**: Real-time
- **Rate Limits**: 3 requests/second (10/second with API key)
- **API Key**: Optional (recommended)

### Methods
- `search_keywords`: Keyword-based literature search
- `search_advanced`: Advanced search with filters (author, journal, dates)
- `get_article_metadata`: Retrieve detailed article information
- `get_article_pdf`: Download full-text PDF

---

## 4. NLM Codes MCP Server

**Repository**: `nlm-codes-mcp`
**Package Name**: `@openpharma/nlm-codes-mcp` (npm) / `openpharma-nlm-codes-mcp` (pip)
**Current Location**: Local development
**Language**: Python

### Description
MCP server for searching medical coding systems including ICD-10-CM, ICD-11, HCPCS, NPI provider registry, HPO phenotypes, RxTerms drugs, LOINC, and NCBI genes through NLM Clinical Tables API.

### Key Features
- ICD-10-CM diagnosis codes (110,000+ codes)
- ICD-11 international classification
- HCPCS Level II procedure codes
- NPI provider search (organizations and individuals)
- HPO phenotype vocabulary
- Medical conditions with ICD mappings
- RxTerms drug terminology
- LOINC questions and forms
- NCBI gene information

### Data Source
- **API**: NLM Clinical Tables Search API
- **Authority**: National Library of Medicine
- **Update Frequency**: Monthly
- **Rate Limits**: None specified
- **API Key**: Not required

### Methods
- `search_codes`: Universal search across 11 coding systems
- Methods for ICD-10-CM, ICD-11, HCPCS, NPI, HPO, conditions, RxTerms, LOINC, genes

---

## 5. WHO MCP Server

**Repository**: `who-mcp`
**Package Name**: `@openpharma/who-mcp` (npm) / `openpharma-who-mcp` (pip)
**Current Location**: Local development (`who-mcp-server`)
**Language**: Python

### Description
MCP server providing access to WHO Global Health Observatory data including health indicators, country statistics, disease burden, and mortality data through the OData API.

### Key Features
- 2000+ health indicators
- Country-level health statistics
- Regional aggregations
- Time series data
- Disease burden metrics
- Life expectancy and mortality data

### Data Source
- **API**: WHO Global Health Observatory OData API
- **Authority**: World Health Organization
- **Update Frequency**: Annually (varies by indicator)
- **Rate Limits**: None specified
- **API Key**: Not required

### Methods
- `get_health_data`: Query specific health indicators
- `search_indicators`: Find indicators by keyword
- `get_country_data`: Country-specific health data
- `get_cross_table`: Tabular data view across countries/years

---

## 6. CDC MCP Server

**Repository**: `cdc-mcp`
**Package Name**: `@openpharma/cdc-mcp` (npm) / `openpharma-cdc-mcp` (pip)
**Current Location**: Local development (needs to be added to catalog)
**Language**: Python

### Description
MCP server for CDC public health data including PLACES disease prevalence, BRFSS behavioral risk factors, YRBSS youth surveillance, respiratory surveillance, vaccination coverage, and vital statistics.

### Key Features
- PLACES local disease prevalence (county, ZIP, census tract)
- BRFSS chronic disease risk factors (2011-present)
- YRBSS youth risk behaviors
- COVID-19/RSV/Flu respiratory surveillance
- Vaccination coverage tracking
- Birth statistics and vital records
- NNDSS notifiable disease surveillance
- Drug overdose surveillance

### Data Source
- **API**: CDC Socrata Open Data API (SODA)
- **Authority**: Centers for Disease Control and Prevention
- **Update Frequency**: Varies by dataset (daily to annually)
- **Rate Limits**: 1000 requests/rolling hour (no throttling)
- **API Key**: Optional (removes throttling)

### Methods
- `get_places_data`: Local disease prevalence
- `get_brfss_data`: Behavioral risk factors
- `get_yrbss_data`: Youth surveillance
- `get_respiratory_surveillance`: COVID/RSV/Flu tracking
- `get_vaccination_coverage`: Immunization rates
- `get_nndss_surveillance`: Notifiable diseases

---

## 7. SEC EDGAR MCP Server

**Repository**: `sec-mcp`
**Package Name**: `@openpharma/sec-mcp` (npm) / `openpharma-sec-mcp` (pip)
**Current Location**: Local development (`sec-mcp-server`)
**Language**: Python

### Description
MCP server for accessing SEC EDGAR filings, company financials, and XBRL data. Provides comprehensive access to public company disclosures and financial statements.

### Key Features
- Company search and CIK lookup
- Filing history (10-K, 10-Q, 8-K, etc.)
- XBRL financial data extraction
- Company facts and metrics
- Dimensional financial analysis (segments, geography)
- Time series financial analysis

### Data Source
- **API**: SEC EDGAR REST API
- **Authority**: U.S. Securities and Exchange Commission
- **Update Frequency**: Real-time
- **Rate Limits**: 10 requests/second
- **API Key**: Not required (User-Agent required)

### Methods
- `search_companies`: Find companies by name/ticker
- `get_company_submissions`: Filing history
- `get_company_facts`: All XBRL financial data
- `get_company_concept`: Specific financial metrics
- `get_dimensional_facts`: Segment/geographic breakdowns
- `time_series_dimensional_analysis`: Multi-period analysis

---

## 7b. EU Filings MCP Server

**Repository**: `eu-filings-mcp-server`
**Package Name**: `@openpharma/eu-filings-mcp` (npm)
**Current Location**: https://github.com/openpharma-org/eu-filings-mcp-server
**Language**: Node.js

### Description
MCP server providing comprehensive access to European financial filings via ESEF (European Single Electronic Format). Enables access to company filings, financial statements, and XBRL data from 27+ European countries using the filings.xbrl.org API.

### Key Features
- Pan-European coverage (France, Germany, Italy, Spain, Netherlands, UK, Denmark, Switzerland, and more)
- Company search by name or LEI (Legal Entity Identifier)
- Complete filing access with XHTML, JSON, and package formats
- XBRL data extraction with IFRS taxonomy support
- Advanced dimensional fact extraction (geography, segments, products)
- Fact table builder with business intelligence summaries
- Time-series financial analysis with growth rates
- Swiss company integration via GLEIF and SIX Exchange
- German company support via GLEIF (DAX 40 companies)
- Filing validation and quality metrics

### Data Source
- **API**: filings.xbrl.org (ESEF Filings Database)
- **Secondary APIs**: GLEIF (Global LEI Foundation) for German/Swiss companies
- **Authority**: ESMA (European Securities and Markets Authority)
- **Update Frequency**: Real-time as filings are published
- **Rate Limits**: No official limits (conservative 200ms pacing implemented)
- **API Key**: Not required

### Methods
- `search_companies`: Find companies by name with country filtering
- `get_company_by_lei`: Look up company using Legal Entity Identifier
- `get_company_filings`: Retrieve filing history for a company
- `get_country_companies`: List all companies filing in specific country
- `get_entity_details`: Get detailed entity information
- `get_filing_facts`: Extract XBRL financial data from filing
- `get_filing_validation`: Retrieve validation messages and quality metrics
- `filter_filings`: Filter filing arrays by date, country, validation quality
- `get_dax40_companies`: Get list of major German companies with LEIs
- `search_swiss_companies`: Search Swiss companies via GLEIF
- `get_swiss_company_info`: Get Swiss company details by LEI
- `get_six_listed_companies`: Curated list of major SIX-listed companies
- `get_dimensional_facts`: Extract XBRL facts with dimensional breakdowns
- `build_fact_table`: Build comprehensive fact table with BI summaries
- `search_facts_by_value`: Search for facts by value range
- `time_series_analysis`: Multi-period growth and trend analysis

### Coverage
- **EU Countries**: 27+ member states with ESEF filings
- **Total Filings**: 23,000+ accessible filings
- **Major Markets**: France (1,001+ companies), UK (2,445+ companies), Denmark, Italy, Spain, Netherlands
- **Germany**: DAX 40 companies via GLEIF (Bundesanzeiger manual links)
- **Switzerland**: Top 10 SIX-listed companies with investor relations links

### Technical Features
- IFRS taxonomy support (vs US-GAAP)
- LEI-based company identification (vs CIK)
- Multi-jurisdiction support (EU + UK + Norway + Ukraine + Switzerland)
- Geographic and segment dimensional reporting
- 98% feature parity with SEC MCP server

---

## 7c. Asia Filings MCP Server

**Repository**: `asia-filings-mcp-server`
**Package Name**: `@openpharma/asia-filings-mcp` (npm)
**Current Location**: https://github.com/openpharma-org/asia-filings-mcp-server
**Language**: Node.js

### Description
MCP server providing comprehensive access to Asian financial filings via Japan's EDINET and South Korea's DART systems. Enables access to company filings, financial statements, and XBRL data from 7,700+ Asian companies using free public APIs.

### Key Features
- Japan (EDINET): 5,000+ companies + 3,000 investment funds via Financial Services Agency
- Korea (DART): 2,700+ companies (KOSPI, KOSDAQ, KONEX) via Financial Supervisory Service
- Company search by name (Japanese, Korean, English)
- Complete filing access with multiple document formats
- Advanced XBRL analysis with J-GAAP and K-GAAP taxonomy support (Phase 2)
- Fact table builder with BI-ready summaries and value search
- Time-series analysis with growth rates and trend detection
- Advanced dimensional extraction (geography, segment, product)
- 21+ business fact classifications with multi-language support
- Financial statements (balance sheets, income statements, cash flow)
- Major shareholder tracking and ownership analysis
- Executive and officer information
- Dividend allocation data
- Multi-market coverage across East Asia

### Data Source
- **APIs**:
  - EDINET API v2 (Japan FSA)
  - Open DART API (Korea FSS)
- **Authority**: Japan Financial Services Agency (FSA), Korea Financial Supervisory Service (FSS)
- **Update Frequency**: Real-time as filings are published
- **Rate Limits**:
  - EDINET: Not officially specified (conservative pacing)
  - DART: 1,000 requests/minute
- **API Key**: Required for both (free registration)

### Methods
**Japan (EDINET):**
- `search_japan_companies`: Search companies by name (Japanese/English)
- `get_japan_company_by_code`: Get company by EDINET code
- `get_japan_company_filings`: Retrieve filing history
- `get_japan_filing_document`: Download specific document (submission, PDF, XBRL)
- `get_japan_documents_by_date`: Get all filings for specific date

**Korea (DART):**
- `search_korea_companies`: Search companies by name
- `get_korea_company_by_code`: Get company by corporate code
- `get_korea_company_filings`: Retrieve filing history
- `get_korea_financial_statements`: Get XBRL financial data
- `get_korea_major_shareholders`: Get shareholder information
- `get_korea_executive_info`: Get executive/officer information
- `get_korea_dividend_info`: Get dividend allocation data

**XBRL Analysis:**
- `parse_xbrl_facts`: Parse XBRL data from EDINET/DART filings
- `filter_facts`: Filter XBRL facts by concept, context, period
- `classify_fact`: Classify XBRL facts into business categories (21+ types)
- `extract_dimensions`: Extract geographic, segment, product dimensions
- `build_fact_table`: Build comprehensive BI-ready fact table with value search
- `search_facts_by_value`: Search facts around target value with deviation analysis
- `time_series_analysis`: Multi-period analysis with growth rates and trends

**Utilities:**
- `filter_filings`: Filter filing arrays by criteria

### Coverage
- **Japan**:
  - ~5,000 listed companies (Tokyo Stock Exchange - Prime, Standard, Growth)
  - ~3,000 investment funds
  - 65 document types
  - Historical data from 2008+ (XBRL mandate)
- **Korea**:
  - KOSPI: ~880 companies
  - KOSDAQ: ~1,700 companies
  - KONEX: ~129 companies
  - Multiple disclosure types (annual, quarterly, equity, issuance)

### Technical Features
- Advanced XBRL fact table builder with BI summaries (Phase 2)
- Time-series analyzer with growth rates and trend detection (Phase 2)
- 21+ business fact classifications (Revenue, Cost of Sales, Operating Income, etc.)
- Advanced dimensional extraction (geography, segment, product)
- J-GAAP taxonomy support (Japan)
- K-GAAP/IFRS taxonomy support (Korea)
- EDINET code and corporate code identification systems
- Multi-language support (Japanese kanji/hiragana/katakana, Korean hangul, English)
- UTF-8 encoding for Asian characters
- Currency formatting for Japanese Yen (¥) and Korean Won (₩)
- Free API access with key registration
- 100% test coverage (52 comprehensive tests)

### API Keys Required
- **EDINET**: Free registration at disclosure.edinet-fsa.go.jp
- **DART**: Free registration at opendart.fss.or.kr

---

## 8. Healthcare (CMS Medicare) MCP Server

**Repository**: `healthcare-mcp`
**Package Name**: `@openpharma/healthcare-mcp` (npm) / `openpharma-healthcare-mcp` (pip)
**Current Location**: Local development
**Language**: Python

### Description
MCP server for accessing Medicare physician and provider data from CMS. Includes information about services, procedures, payments, and provider specialties.

### Key Features
- Provider search by specialty, location, procedure
- Medicare Part B payment data
- Geographic analysis (national, state, county, ZIP)
- HCPCS procedure code analysis
- Provider-level service patterns
- Beneficiary demographics

### Data Source
- **API**: CMS Medicare Physician & Other Practitioners API
- **Authority**: Centers for Medicare & Medicaid Services
- **Update Frequency**: Annually
- **Rate Limits**: None specified
- **API Key**: Not required

### Methods
- `search_providers`: Search by provider type, location, procedure
- Three dataset types:
  - `geography_and_service`: Regional analysis
  - `provider_and_service`: Provider-level data
  - `provider`: Provider demographics

---

## 8b. Medicaid MCP Server

**Repository**: `medicaid-mcp-server`
**Package Name**: `@openpharma/medicaid-mcp-server` (npm) / `openpharma-medicaid-mcp` (pip)
**Current Location**: https://github.com/openpharma-org/medicaid-mcp-server
**Language**: Node.js

### Description
MCP server for accessing Medicaid public data from data.medicaid.gov. Provides drug pricing (NADAC), state enrollment trends, federal upper limits, drug rebate program data, and state drug utilization statistics. Uses hybrid CSV + DKAN API architecture optimized for large datasets.

### Key Features
- NADAC drug pricing (1.5M records, weekly updates)
- State-by-state Medicaid enrollment trends
- Federal Upper Limits (FUL) pricing for generic drugs
- Drug Rebate Program (MDRP) product information
- State Drug Utilization Data (prescription volume by state)
- Hybrid architecture: CSV for small datasets, DKAN API for large datasets
- Memory-optimized (~215 MB total vs ~4+ GB for all CSV)

### Data Source
- **API**: DKAN platform (data.medicaid.gov)
- **Authority**: Centers for Medicare & Medicaid Services
- **Update Frequency**: Weekly (NADAC), Monthly (Enrollment, FUL), Quarterly (Rebate, Utilization)
- **Rate Limits**: None specified (DKAN API)
- **API Key**: Not required

### Methods
- `get_nadac_pricing`: Drug pricing lookup by NDC or name
- `compare_drug_pricing`: Multi-drug or temporal price comparison
- `get_enrollment_trends`: State enrollment over time
- `compare_state_enrollment`: Multi-state enrollment comparison
- `get_federal_upper_limits`: FUL pricing lookup by ingredient
- `get_drug_rebate_info`: Rebate program data (NDC, manufacturer, FDA approval)
- `get_state_drug_utilization`: Utilization by state, drug, quarter
- `list_available_datasets`: Show available datasets
- `search_datasets`: Generic dataset search

### Architecture
- **Small datasets (<50 MB)**: CSV download + in-memory cache
  - NADAC: 123 MB → cached in memory
  - Enrollment: 3.6 MB → cached in memory
- **Large datasets (>100 MB)**: DKAN API queries
  - Federal Upper Limits: 196 MB, 2.1M records
  - Drug Rebate: 291 MB, ~3M records
  - Drug Utilization: 192 MB, 5.3M records

---

## 9. Data Commons MCP Server

**Repository**: `datacommons-mcp`
**Package Name**: `@openpharma/datacommons-mcp` (npm) / `openpharma-datacommons-mcp` (pip)
**Current Location**: Local development
**Language**: Python

### Description
MCP server providing access to Google Data Commons knowledge graph for population statistics, disease prevalence, demographics, and economic indicators across 50+ data sources.

### Key Features
- 250,000+ statistical variables
- Population and demographic data
- Disease prevalence and health indicators
- Economic indicators
- Geographic data (country, state, county, city)
- Time series analysis

### Data Source
- **API**: Google Data Commons REST API
- **Authority**: Google (aggregates 50+ sources)
- **Update Frequency**: Varies by source
- **Rate Limits**: None specified
- **API Key**: Optional

### Methods
- `search_indicators`: Find statistical variables
- `get_observations`: Retrieve data for variable/place
- Support for child place analysis (e.g., all counties in a state)

---

## 10. Open Targets MCP Server

**Repository**: `opentargets-mcp`
**Package Name**: `@openpharma/opentargets-mcp` (npm) / `openpharma-opentargets-mcp` (pip)
**Current Location**: Local development (`opentargets-mcp-server`)
**Language**: Python

### Description
MCP server for accessing Open Targets platform data including target-disease associations, genetic evidence, drug-target relationships, and target validation information.

### Key Features
- Target search by gene symbol/name
- Disease search by name/EFO ID
- Target-disease associations with evidence scores
- Genetic evidence for target validation
- Known drugs and clinical precedence
- Tractability assessments

### Data Source
- **API**: Open Targets Platform GraphQL API (v25.0.1)
- **Authority**: Open Targets consortium (EMBL-EBI, Wellcome Sanger)
- **Update Frequency**: Quarterly releases
- **Rate Limits**: None specified
- **API Key**: Not required

### Methods
- `search_targets`: Find therapeutic targets
- `search_diseases`: Search diseases/conditions
- `get_target_disease_associations`: Association evidence
- `get_disease_targets_summary`: All targets for disease
- `get_target_details`: Comprehensive target info
- `get_disease_details`: Comprehensive disease info

---

## 11. PubChem MCP Server

**Repository**: `pubchem-mcp`
**Package Name**: `@openpharma/pubchem-mcp` (npm) / `openpharma-pubchem-mcp` (pip)
**Current Location**: Local development (`pubchem-mcp-server`)
**Language**: Python

### Description
MCP server for accessing PubChem chemical database with 110+ million compounds. Provides structure search, property calculation, bioassay data, and safety information.

### Key Features
- Compound search by name, CAS, SMILES, InChI
- 3D conformer generation
- Molecular property calculation (MW, logP, TPSA)
- Similarity search (Tanimoto)
- Bioassay data retrieval
- GHS safety classifications
- Batch compound lookup (up to 200)

### Data Source
- **API**: PubChem PUG REST API
- **Authority**: National Center for Biotechnology Information
- **Update Frequency**: Daily
- **Rate Limits**: 5 requests/second
- **API Key**: Not required

### Methods
- `search_compounds`: Search by name/CAS/formula
- `get_compound_info`: Detailed compound data
- `search_by_smiles`: Exact structure match
- `search_similar_compounds`: Similarity search
- `get_3d_conformers`: 3D structural data
- `analyze_stereochemistry`: Chirality analysis
- `get_compound_properties`: Calculated properties
- `get_safety_data`: GHS classifications
- `batch_compound_lookup`: Bulk processing

---

## 12. Patents MCP Server

**Repository**: `patents-mcp`
**Package Name**: `@openpharma/patents-mcp` (npm) / `openpharma-patents-mcp` (pip)
**Current Location**: Local development (`patents-mcp-server`)
**Language**: Python

### Description
MCP server for searching USPTO and Google Patents databases. Provides access to granted patents, applications, full-text documents, and patent metadata.

### Key Features
- USPTO patent and application search
- Google Patents BigQuery search
- Full-text document retrieval
- PDF download for granted patents
- Patent metadata (inventors, assignees, classifications)
- CPC classification search
- Inventor and assignee portfolio analysis

### Data Source
- **APIs**:
  - USPTO Public Search & PatentsView API
  - Google Patents Public Datasets (BigQuery)
- **Authority**: U.S. Patent and Trademark Office / Google
- **Update Frequency**: Weekly (USPTO), Daily (Google)
- **Rate Limits**: Varies by API
- **API Key**: Not required (BigQuery may require config)

### Methods
- `ppubs_search_patents`: Search granted patents
- `ppubs_search_applications`: Search applications
- `ppubs_get_full_document`: Get full patent text
- `ppubs_download_patent_pdf`: Download PDF
- `google_search_patents`: Search Google Patents
- `google_search_by_inventor`: Inventor portfolio
- `google_search_by_assignee`: Company portfolio
- `google_search_by_cpc`: Technology classification

---

## 13. Financials MCP Server

**Repository**: `financials-mcp`
**Package Name**: `@openpharma/financials-mcp` (npm) / `openpharma-financials-mcp` (pip)
**Current Location**: Local development (`financials-mcp-server`)
**Language**: Python

### Description
MCP server for financial market data and economic indicators. Provides stock data from Yahoo Finance and economic data from Federal Reserve (FRED).

### Key Features
- Stock profiles, financials, and pricing
- Analyst estimates and recommendations
- Dividend history and technicals
- ESG scores
- News sentiment analysis
- Stock screening and correlation analysis
- Economic indicators (GDP, unemployment, inflation)
- FRED economic data (800,000+ series)

### Data Source
- **APIs**:
  - Yahoo Finance (unofficial API)
  - FRED (Federal Reserve Economic Data)
- **Authority**: Public market data / Federal Reserve
- **Update Frequency**: Real-time (stocks), Daily (FRED)
- **Rate Limits**: Varies
- **API Key**: Required for FRED

### Methods
- `stock_profile`: Company information
- `stock_financials`: Financial statements
- `stock_estimates`: Analyst estimates
- `stock_news`: News with sentiment analysis
- `stock_screener`: Multi-criteria stock discovery
- `economic_indicators`: Macro dashboard
- `fred_series_search`: Search 800K+ economic series
- `fred_series_data`: Fetch economic data

---

## Migration Checklist

For each server, complete the following before making repository public:

### Pre-Migration
- [ ] Review code for sensitive information (API keys, internal URLs)
- [ ] Add comprehensive README following template
- [ ] Write unit and integration tests
- [ ] Add CI/CD pipeline (GitHub Actions)
- [ ] Create examples directory with usage samples

### Documentation
- [ ] API reference documentation
- [ ] Installation guide
- [ ] Troubleshooting guide
- [ ] CONTRIBUTING.md
- [ ] CHANGELOG.md
- [ ] LICENSE (MIT)

### Package Configuration
- [ ] Configure package.json or pyproject.toml
- [ ] Set up npm/@openpharma scope or PyPI organization
- [ ] Add package metadata (description, keywords, repository)
- [ ] Configure publishConfig for scoped package

### Quality
- [ ] Code linting configured
- [ ] Type checking enabled
- [ ] Test coverage >80%
- [ ] Error handling comprehensive
- [ ] Rate limiting implemented

### GitHub
- [ ] Create repository in openpharma organization
- [ ] Add topics/tags (mcp, pharmaceutical, biomedical, etc.)
- [ ] Configure issue templates
- [ ] Configure PR template
- [ ] Add branch protection rules
- [ ] Enable Discussions

### Publishing
- [ ] Publish to npm (@openpharma scope)
- [ ] Publish to PyPI (openpharma-* prefix)
- [ ] Create GitHub release
- [ ] Update organization README with link
- [ ] Announce in community discussions
