# Medicare MCP Formulary Extension Plan

## Executive Summary

Extend the existing medicare-mcp server to include **CMS Part D Formulary and Payer Coverage** data, enabling comprehensive commercial intelligence for Medicare market access.

**Gap Addressed**: Commercial intelligence for payer coverage and plan details
- **Formulary data** (Phase 1-3): Drug coverage, tiers, prior auth, quantity limits
- **Payer data** (Future Phase 4): Plan details, premiums, coverage areas, star ratings

**Answers Questions Like**:
- "Which Medicare plans cover drug X?" → `search_formulary`
- "What tier is this drug on?" → `search_formulary`
- "Is prior authorization required?" → `search_formulary`
- "Which Part D plans are available in Los Angeles?" → `search_payers` (future)
- "What are the cheapest plans covering semaglutide?" → `search_payers` + `search_formulary` (future)

**Data Source**: CMS Monthly Prescription Drug Plan Formulary and Pharmacy Network Information (data.cms.gov)
- 8 CSV files per monthly ZIP
- Formulary: Basic Drugs Formulary + Beneficiary Cost files (Phase 1-3)
- Payers: Geographic Locator + Plan Benefit Package files (Phase 4)

---

## Current Medicare MCP Architecture

### Existing Implementation (`/Users/joan.saez-pons/code/icd-mcp-server/`)

**Technology Stack**:
- TypeScript/Node.js
- MCP SDK (@modelcontextprotocol/sdk)
- CMS Socrata API (fetch-based)
- Supports both stdio (MCP) and HTTP modes

**Current Tool**: `cms_search_providers`

**Dataset Types** (3):
1. **geography_and_service**: Regional service patterns
2. **provider_and_service**: Individual provider performance
3. **provider**: Provider demographics and beneficiary characteristics

**Architecture Pattern**:
- Version maps by year (2013-2023) → Dataset UUIDs
- Socrata API: `https://data.cms.gov/data-api/v1/dataset/{uuid}/data`
- Query construction via URLSearchParams with filters
- TypeScript interfaces for response typing
- Response mapping to normalized JSON

**Key Code Sections**:
- Lines 66-104: Version maps (versionMapGeography, versionMapProviderAndService, versionMapProvider)
- Lines 337-513: Main query function `searchMedicare()`
- Lines 369-416: Query parameter building with filters

---

## CMS Formulary Data Structure

### Data Source Discovery

**Primary Dataset**: Monthly Prescription Drug Plan Formulary and Pharmacy Network Information
- Dataset ID: `cb2a224f-4d52-4cae-aa55-8c00c671384f`
- Format: Monthly ZIP files (released ~26th of each month)
- Latest: 2026_20251114.zip (2025-11-19)
- Download URL pattern: `https://data.cms.gov/sites/default/files/YYYY-MM/{uuid}/{filename}.zip`

**Alternative Dataset**: Quarterly Prescription Drug Plan Formulary, Pharmacy Network, and Pricing Information
- Dataset ID: `a94b1015-1b93-476b-80ec-508b4169c8f5`
- Format: Quarterly ZIP files
- Contains additional pricing data

### File Structure (8 Sub-Files per ZIP)

1. **Geographic Locator** - Plan service areas
2. **Basic Drugs Formulary** ⭐ PRIMARY - NDC codes, tiers, utilization management
3. **Excluded Drugs Formulary** - Non-covered drugs
4. **Beneficiary Cost** ⭐ PRIMARY - Cost sharing by tier
5. **Pharmacy Network** - Network pharmacies
6. **Indication Based Coverage Formulary** - Step therapy requirements
7. **Insulin Beneficiary Cost File** - Insulin-specific costs (Part D Senior Savings Model)
8. **Over-the-Counter Drug** (in some releases)

### Key Variables (Basic Drugs Formulary)

Based on CMS documentation and ResDAC:
- **Plan Identification**: Contract ID, Plan ID, Segment ID, Formulary ID
- **Drug Identification**: NDC (proxy), Brand Name, Generic Name, Dosage Form, Strength
- **Formulary Details**:
  - Tier ID (1-6: preferred generic, generic, preferred brand, non-preferred brand, specialty, select care)
  - Step Therapy Indicator (Y/N)
  - Quantity Limit (Y/N)
  - Prior Authorization (Y/N)
- **CCW Formulary Drug Identifier** (FRMLRY_RX_ID) - for linking to claims

### API vs File-Based Access

**Current Reality**: CMS formulary data is NOT available via real-time API endpoint like provider data.

**Options**:

1. **File Download Approach** (Recommended for v1):
   - Download latest monthly ZIP from data.cms.gov
   - Extract and parse CSV files
   - In-memory search/filter (fast for single queries)
   - **Pros**: Simple, no external dependencies, complete data
   - **Cons**: ~50-100MB download, preprocessing needed

2. **Pre-Indexed Database** (Future v2):
   - Download and load into SQLite/PostgreSQL
   - Index by NDC, drug name, plan ID
   - **Pros**: Fast multi-query performance
   - **Cons**: Storage, maintenance overhead

3. **FHIR API** (Individual Plan Access):
   - Medicare Advantage plans expose FHIR formulary endpoints (PDex US Drug Formulary IG)
   - **Pros**: Real-time, plan-specific
   - **Cons**: Requires plan identification, fragmented across payers

**Decision for v1**: File Download Approach with intelligent caching

---

## Proposed Extension Architecture

### Unified Tool Pattern (Following OpenPharma MCP Standards)

**IMPORTANT**: Medicare MCP follows the unified tool pattern used across all OpenPharma MCP servers (FDA, Open Targets, PubMed, etc.).

**Single Tool Name**: `medicare_info`

**Pattern**: Single tool with `method` parameter to select operation type

**Rationale**:
- Consistent with all other OpenPharma MCP servers
- Single tool interface reduces complexity for AI agents
- Method-based routing enables future extensibility
- Follows MCP best practices demonstrated in fda-mcp, opentargets-mcp, etc.

**Current Methods** (existing):
- `search_providers` - Search Medicare provider data (geography/service/provider datasets)

**New Methods** (to be added):
- `search_formulary` - Search Part D formulary data for drug coverage, tiers, utilization management
- `search_payers` - Search Medicare Part D plans (payers) - plan details, coverage areas, premiums (future, data available in CMS plan files)

**Tool Interface** (Updated):

```typescript
{
  name: "medicare_info",
  description: "Unified tool for Medicare data operations: provider data, Part D formulary coverage, and plan information. Use the method parameter to specify the operation type.",
  input_schema: {
    type: "object",
    properties: {
      method: {
        type: "string",
        enum: [
          "search_providers",
          "search_formulary",
          "search_payers"  // Future
        ],
        description: "The operation to perform: search_providers (Medicare provider & service data), search_formulary (Part D formulary & drug coverage), or search_payers (Medicare plan/payer information - plan details, premiums, coverage areas)"
      },

      // === search_providers parameters (existing) ===
      dataset_type: {
        type: "string",
        enum: ["geography_and_service", "provider_and_service", "provider"],
        description: "For search_providers: Type of dataset to search"
      },
      year: {
        type: "string",
        description: "For search_providers: Dataset year (2013-2023, defaults to latest)"
      },
      hcpcs_code: {
        type: "string",
        description: "For search_providers: HCPCS code (e.g., '99213')"
      },
      provider_type: {
        type: "string",
        description: "For search_providers: Provider specialty (e.g., 'Cardiology')"
      },
      geo_level: {
        type: "string",
        description: "For search_providers: Geographic level (National/State/County/ZIP)"
      },
      geo_code: {
        type: "string",
        description: "For search_providers: Geographic code (e.g., 'CA', '06037')"
      },
      place_of_service: {
        type: "string",
        description: "For search_providers: Place of service code (F/O/H)"
      },
      sort_by: {
        type: "string",
        description: "For search_providers: Field to sort by"
      },
      sort_order: {
        type: "string",
        enum: ["asc", "desc"],
        description: "For search_providers: Sort order (default: desc)"
      },

      // === search_formulary parameters (NEW) ===
      // Drug Identification (at least one required for search_formulary)
      drug_name: {
        type: "string",
        description: "For search_formulary: Generic or brand drug name (partial match supported)"
      },
      ndc_code: {
        type: "string",
        description: "For search_formulary: National Drug Code (11-digit)"
      },

      // Plan Filters (optional for search_formulary)
      plan_id: {
        type: "string",
        description: "For search_formulary: Specific Medicare plan ID (Contract ID + Plan ID)"
      },
      plan_state: {
        type: "string",
        description: "For search_formulary: State code to filter plans (e.g., 'CA', 'TX')"
      },
      plan_type: {
        type: "string",
        enum: ["PDP", "MAPD"],
        description: "For search_formulary: Type of Medicare plan (PDP=Prescription Drug Plan, MAPD=Medicare Advantage)"
      },

      // Coverage Filters (optional for search_formulary)
      tier: {
        type: "number",
        description: "For search_formulary: Cost sharing tier (1-6)"
      },
      requires_prior_auth: {
        type: "boolean",
        description: "For search_formulary: Filter by prior authorization requirement"
      },
      has_quantity_limit: {
        type: "boolean",
        description: "For search_formulary: Filter by quantity limit presence"
      },
      has_step_therapy: {
        type: "boolean",
        description: "For search_formulary: Filter by step therapy requirement"
      },

      // Data Version (for search_formulary)
      month: {
        type: "string",
        description: "For search_formulary: Formulary data month (YYYY-MM, defaults to latest)"
      },

      // === Shared parameters (all methods) ===
      size: {
        type: "number",
        description: "Number of results to return (default: 10 for search_providers, 25 for search_formulary, max: 5000)"
      },
      offset: {
        type: "number",
        description: "Starting result number for pagination (default: 0)"
      }
    },
    required: ["method"]
  }
}
```

**Response Schema**:

```typescript
{
  total: number,
  formulary_entries: [
    {
      // Drug Info
      ndc_code: string,
      brand_name: string,
      generic_name: string,
      dosage_form: string,
      strength: string,

      // Plan Info
      contract_id: string,
      plan_id: string,
      plan_name: string,
      plan_type: string,
      segment_id: string,

      // Coverage Details
      tier_id: number,
      tier_description: string,  // e.g., "Preferred Generic", "Specialty"

      // Utilization Management
      prior_authorization_required: boolean,
      quantity_limit: boolean,
      step_therapy_required: boolean,

      // Cost Sharing (from Beneficiary Cost file)
      copay_amount: number | null,
      coinsurance_percent: number | null,

      // Metadata
      formulary_id: string,
      data_month: string
    }
  ],
  data_source: {
    dataset: "Monthly Prescription Drug Plan Formulary",
    month: "2025-11",
    file_date: "2025-11-14"
  }
}
```

### Implementation Notes

**Method Routing**:
```typescript
// In index.ts CallToolRequestSchema handler:
case 'medicare_info': {
  const method = (args as any)?.method;

  switch (method) {
    case 'search_providers':
      return await searchMedicare(...);  // Existing implementation

    case 'search_formulary':
      return await searchFormulary(...);  // NEW implementation

    case 'search_payers':
      throw new Error('search_payers not yet implemented');  // Future

    default:
      throw new McpError(-32602, `Unknown method: ${method}`);
  }
}
```

**Benefits**:
- Single tool name reduces agent cognitive load
- Method-based routing is clean and extensible
- Consistent with FDA MCP (`fda_info`), Open Targets MCP (`opentargets_info`), etc.
- Future methods (search_payers, search_pharmacies) can be added without breaking changes

---

## Implementation Plan

### Phase 0: Refactor Existing Tool (Critical First Step)

**REQUIRED**: Convert `cms_search_providers` to `medicare_info` with method-based routing

**Why this is critical**:
- Current tool is `cms_search_providers` (non-standard naming)
- Must adopt unified tool pattern before adding formulary features
- Ensures consistency with all other OpenPharma MCP servers

**Steps**:

1. **Rename Tool** (`index.ts` line ~110-242):
   ```typescript
   // OLD:
   export const SEARCH_MEDICARE_TOOL: Tool = {
     name: "cms_search_providers",
     description: "Search Medicare Physician & Other Practitioners data...",
     // ...
   }

   // NEW:
   export const MEDICARE_INFO_TOOL: Tool = {
     name: "medicare_info",
     description: "Unified tool for Medicare data operations: provider data, Part D formulary coverage, and plan information. Use the method parameter to specify the operation type.",
     input_schema: {
       type: "object",
       properties: {
         method: {
           type: "string",
           enum: ["search_providers"],  // Will add search_formulary in Phase 1
           description: "The operation to perform: search_providers (Medicare provider & service data)"
         },
         dataset_type: { ... },  // Existing params
         // ... all existing parameters ...
       },
       required: ["method"]  // Add method as required
     }
   }
   ```

2. **Add Method Routing** (`index.ts` line ~546-573):
   ```typescript
   // OLD:
   server.setRequestHandler(CallToolRequestSchema, async (request) => {
     const toolName = request.params?.name;
     const args = request.params?.arguments;
     try {
       switch (toolName) {
         case 'cms_search_providers': {
           const result = await searchMedicare(...);
           return { content: [...], isError: false };
         }
         default:
           throw new McpError(-32603, 'Unknown tool');
       }
     } catch (error) { ... }
   });

   // NEW:
   server.setRequestHandler(CallToolRequestSchema, async (request) => {
     const toolName = request.params?.name;
     const args = request.params?.arguments;
     try {
       switch (toolName) {
         case 'medicare_info': {
           const method = (args as any)?.method;

           switch (method) {
             case 'search_providers': {
               const result = await searchMedicare(...);  // Unchanged
               return { content: [...], isError: false };
             }
             default:
               throw new McpError(-32602, `Unknown method: ${method}`);
           }
         }
         default:
           throw new McpError(-32603, 'Unknown tool');
       }
     } catch (error) { ... }
   });
   ```

3. **Update Tool List Handler** (`index.ts` line ~536-544):
   ```typescript
   // OLD:
   server.setRequestHandler(ListToolsRequestSchema, async () => ({
     tools: [
       {
         name: SEARCH_MEDICARE_TOOL.name,  // "cms_search_providers"
         description: SEARCH_MEDICARE_TOOL.description,
         inputSchema: SEARCH_MEDICARE_TOOL.input_schema
       }
     ]
   }));

   // NEW:
   server.setRequestHandler(ListToolsRequestSchema, async () => ({
     tools: [
       {
         name: MEDICARE_INFO_TOOL.name,  // "medicare_info"
         description: MEDICARE_INFO_TOOL.description,
         inputSchema: MEDICARE_INFO_TOOL.input_schema
       }
     ]
   }));
   ```

4. **Update HTTP Mode Handler** (`index.ts` line ~620):
   ```typescript
   // OLD:
   if (url === '/cms_search_providers') {
     result = await searchMedicare(...);
   }

   // NEW:
   if (url === '/medicare_info') {
     const method = data.method;
     switch (method) {
       case 'search_providers':
         result = await searchMedicare(...);
         break;
       default:
         throw new Error(`Unknown method: ${method}`);
     }
   }
   ```

5. **Update README.md**:
   - Change all references from `cms_search_providers` to `medicare_info`
   - Add method parameter to all examples
   - Update tool description

6. **Test Refactored Tool**:
   ```bash
   # Test with method parameter
   echo '{"method": "search_providers", "dataset_type": "provider", "provider_type": "Cardiology", "size": 5}' | \
     node dist/index.js medicare_info
   ```

**Timeline**: 2-3 hours

**Deliverables**:
- ✅ Tool renamed to `medicare_info`
- ✅ Method-based routing implemented
- ✅ Backward compatibility NOT maintained (breaking change is intentional)
- ✅ README updated
- ✅ Existing functionality still works with `method: "search_providers"`

---

### Phase 1: Core Infrastructure (Week 1)

**Tasks**:

1. **Download and Cache Manager** (`src/formulary/cache.ts`):
   ```typescript
   class FormularyCache {
     private cacheDir: string;
     private maxAge: number = 30 * 24 * 60 * 60 * 1000; // 30 days

     async getLatestFormulary(): Promise<FormularyDataset>
     async downloadFormulary(month?: string): Promise<string>
     async extractZip(zipPath: string): Promise<string[]>
     async loadCSV(filename: string): Promise<any[]>
     isCached(month: string): boolean
     clearCache(): void
   }
   ```

2. **CSV Parser** (`src/formulary/parser.ts`):
   ```typescript
   interface FormularyRecord {
     contractId: string;
     planId: string;
     segmentId: string;
     formularyId: string;
     ndcCode: string;
     brandName: string;
     genericName: string;
     dosageForm: string;
     strength: string;
     tierId: number;
     priorAuthRequired: boolean;
     quantityLimit: boolean;
     stepTherapy: boolean;
   }

   function parseBasicFormularyCSV(csvData: string): FormularyRecord[]
   function parseBeneficiaryCostCSV(csvData: string): CostRecord[]
   function mergeFormularyWithCosts(formulary: FormularyRecord[], costs: CostRecord[]): FormularyEntry[]
   ```

3. **Search Logic** (`src/formulary/search.ts`):
   ```typescript
   async function searchFormulary(
     params: FormularySearchParams
   ): Promise<FormularySearchResult> {
     // 1. Load data (cached or download)
     const dataset = await cache.getLatestFormulary();

     // 2. Filter by drug (name or NDC)
     let results = filterByDrug(dataset.formulary, params);

     // 3. Filter by plan
     if (params.plan_id || params.plan_state) {
       results = filterByPlan(results, params);
     }

     // 4. Filter by coverage attributes
     results = filterByCoverage(results, params);

     // 5. Join with cost data
     results = joinWithCosts(results, dataset.costs);

     // 6. Paginate
     return paginate(results, params.size, params.offset);
   }
   ```

### Phase 2: MCP Integration (Week 1)

**Tasks**:

1. **Update Tool Definition** (`index.ts`):
   - Add `search_formulary` to method enum in `MEDICARE_INFO_TOOL`
   - Add all formulary-specific parameters to properties
   - Tool description already updated in Phase 0

2. **Add Method Handler** in `CallToolRequestSchema`:
   ```typescript
   case 'medicare_info': {
     const method = (args as any)?.method;

     switch (method) {
       case 'search_providers': {
         // Existing implementation
         const result = await searchMedicare(...);
         return { content: [...], isError: false };
       }

       case 'search_formulary': {
         // NEW implementation
         const result = await searchFormulary({
           drug_name: (args as any)?.drug_name,
           ndc_code: (args as any)?.ndc_code,
           plan_id: (args as any)?.plan_id,
           plan_state: (args as any)?.plan_state,
           tier: (args as any)?.tier,
           // ... other formulary params
         });
         return {
           content: [{ type: 'text', text: JSON.stringify(result, null, 2) }],
           isError: false
         };
       }

       default:
         throw new McpError(-32602, `Unknown method: ${method}`);
     }
   }
   ```

3. **Error Handling**:
   - Network errors (file download failures)
   - Parse errors (malformed CSV)
   - Validation errors (missing drug identifier)

### Phase 3: Testing and Documentation (Week 1)

**Testing**:

1. **Unit Tests**:
   - CSV parsing edge cases
   - Search filtering logic
   - Cache hit/miss scenarios

2. **Integration Tests**:
   - Download and parse real CMS data
   - Full query workflow
   - MCP protocol compliance

3. **Example Queries**:
   - "Find all Medicare plans covering semaglutide"
   - "What tier is Ozempic on in California plans?"
   - "Which plans require prior authorization for SGLT2 inhibitors?"
   - "Compare coverage for liraglutide across plans"

**Documentation**:

1. Update `README.md`:
   - Add `cms_search_formulary` tool documentation
   - Parameter descriptions
   - Response schema
   - Example queries
   - Known limitations

2. Add `.claude/.context/mcp-tool-guides/medicare-formulary.md`:
   - Detailed API guide for pharma-search-specialist agent
   - Search patterns
   - Data interpretation notes

3. Update `package.json`:
   - Add dependencies: `unzipper`, `csv-parser`, `fast-csv`
   - Version bump to 0.3.0

---

## Technical Considerations

### Dependencies

**New npm packages needed**:
```json
{
  "dependencies": {
    "unzipper": "^0.12.3",     // ZIP extraction
    "fast-csv": "^5.0.1",       // CSV parsing (fast, streaming)
    "node-fetch": "^3.3.2"      // Already installed
  }
}
```

### Performance

**Download Size**: ~50-100MB per monthly ZIP
**Extraction**: ~200-500MB uncompressed (8 CSV files)
**Load Time**:
- First query (cold cache): 30-60 seconds (download + parse)
- Subsequent queries (warm cache): < 1 second

**Optimization Strategies**:
1. Cache downloaded ZIP files (30-day TTL)
2. Lazy-load only Basic Formulary + Beneficiary Cost (not all 8 files)
3. Stream CSV parsing (don't load entire file into memory)
4. Index by NDC and drug name after first load (in-memory)

### Caching Strategy

**Cache Location**: `~/.cache/medicare-mcp/formulary/`

**Cache Structure**:
```
~/.cache/medicare-mcp/formulary/
├── 2025-11/
│   ├── 2026_20251114.zip
│   ├── BasicDrugsFormulary.csv
│   ├── BeneficiaryCost.csv
│   └── index.json  # Metadata (download date, file hashes)
└── cache-manifest.json
```

**Cache Invalidation**:
- Auto-refresh if data > 30 days old
- Manual refresh via environment variable: `FORMULARY_CACHE_REFRESH=true`
- Cache purge: Delete cache directory

### Data Quality Notes

**Known Issues** (from CMS):
- October 2023 - November 2024: 15% coinsurance listed instead of 25% in Beneficiary Cost file
- Corrected data being re-posted through May 2025

**Workarounds**:
- Document known data issues in README
- Add data quality warnings in responses
- Allow users to specify preferred data month

---

## Migration and Deployment

### Repository Structure Changes

```
icd-mcp-server/  (rename to medicare-mcp)
├── src/
│   ├── index.ts                    # Main MCP server (existing)
│   ├── types.ts                    # Shared types (existing)
│   ├── formulary/                  # NEW
│   │   ├── cache.ts
│   │   ├── parser.ts
│   │   ├── search.ts
│   │   └── types.ts
│   └── providers/                  # REFACTOR (move existing code)
│       ├── search.ts
│       └── types.ts
├── test/
│   ├── providers.test.ts           # Existing tests
│   └── formulary.test.ts           # NEW
├── .cache/                         # NEW (gitignored)
├── README.md                       # UPDATE
└── package.json                    # UPDATE
```

### GitHub Sync

After implementation:
1. Commit changes: "Add CMS Part D formulary coverage tool"
2. Push to openpharma-org/medicare-mcp
3. Update openpharma-org/README.md with formulary capabilities

### Version Bump

- Current: `0.2.14`
- New: `0.3.0` (minor version - new feature)

---

## Success Metrics

**Functionality**:
- ✅ Download and parse latest CMS formulary data
- ✅ Search by drug name (partial match)
- ✅ Search by NDC code (exact match)
- ✅ Filter by plan, state, tier, utilization management
- ✅ Return coverage details with cost sharing
- ✅ Cache management (download, refresh, purge)

**Performance**:
- ✅ First query: < 60 seconds (including download)
- ✅ Cached queries: < 2 seconds
- ✅ Support 1000+ result sets

**Integration**:
- ✅ MCP protocol compliance
- ✅ Works with pharma-search-specialist agent
- ✅ Example skills in `.claude/skills/` library

**Documentation**:
- ✅ README updated
- ✅ MCP tool guide created
- ✅ Example queries documented

---

## Future Enhancements (v2+)

### search_payers Method (Phase 4 - Future)

**Purpose**: Search Medicare Part D plans (payers) with plan details, coverage areas, and premiums

**Data Source**: CMS Monthly Plan files (part of same ZIP as formulary)
- Geographic Locator file: Plan service areas by county/ZIP
- Plan Benefit Package (PBP) files: Plan details, premiums, deductibles

**Example Queries**:
- "Which Medicare Part D plans are available in Los Angeles County?"
- "Find low-premium Part D plans in Texas"
- "Compare plan premiums for plans covering semaglutide"

**search_payers Parameters**:
```typescript
{
  method: "search_payers",
  state: "CA",              // State code
  county: "06037",          // County FIPS code
  plan_type: "PDP",         // PDP or MAPD
  max_premium: 50.00,       // Filter by monthly premium
  includes_drug: "semaglutide"  // Plans that cover this drug (joins with formulary)
}
```

**Response**:
```typescript
{
  total: number,
  plans: [
    {
      contract_id: string,
      plan_id: string,
      plan_name: string,
      organization_name: string,
      plan_type: "PDP" | "MAPD",
      monthly_premium: number,
      annual_deductible: number,
      coverage_areas: [
        { state: "CA", counties: ["06037", "06059"] }
      ],
      star_rating: number,  // CMS quality rating
      formulary_id: string  // Link to formulary data
    }
  ]
}
```

**Benefits**:
- Complete commercial intelligence: drug coverage + payer details + pricing
- Answer "Which plans should patients consider?" questions
- Plan comparison for market access analysis

---

### Other Future Enhancements

1. **Quarterly Pricing Data**: Integrate pricing information from quarterly dataset
2. **Historical Trends**: Track formulary changes over time (drug moved to different tier)
3. **Geographic Network Analysis**: Link to Pharmacy Network file for access analysis
4. **Excluded Drugs**: Surface non-covered drugs
5. **Indication-Based Coverage**: Parse step therapy by indication
6. **SQL Database Backend**: For faster multi-query performance
7. **FHIR Integration**: Fetch real-time data from individual plan FHIR endpoints
8. **Drug Comparison**: Side-by-side coverage comparison for therapeutic alternatives

---

## Risk Assessment

**Low Risk**:
- Well-documented CMS data source
- Proven architecture pattern (existing provider tool)
- No API keys or authentication required

**Medium Risk**:
- Download performance (mitigated by caching)
- CSV parsing robustness (use battle-tested libraries)

**Mitigation**:
- Comprehensive error handling
- Fallback to cached data on download failure
- Clear user messaging about data freshness

---

## Implementation Timeline

**Week 1** (5-7 days):
- Day 1-2: Core infrastructure (cache manager, CSV parser)
- Day 3-4: Search logic and MCP integration
- Day 5: Testing and documentation
- Day 6-7: Polish, examples, deployment

**Total Effort**: ~20-30 hours

---

## Questions for User

1. **Priority**: Should this be high priority for immediate implementation?
2. **Scope**: Start with v1 (file-based) or build v2 (database) from the start?
3. **Cost Data**: Include beneficiary cost data (copay/coinsurance) in v1 or defer to v2?
4. **Historical Data**: Support multiple months or just latest?

---

## Appendix: CMS Data Dictionary

### Basic Drugs Formulary File Fields

(Based on ResDAC and CMS documentation)

| Field | Type | Description |
|-------|------|-------------|
| Contract_ID | String | 5-character contract identifier |
| Plan_ID | String | 3-digit plan identifier |
| Segment_ID | String | Segment within plan |
| Formulary_ID | String | Unique formulary identifier |
| RxCUI | String | RxNorm Concept Unique Identifier |
| NDC | String | 11-digit National Drug Code (proxy) |
| Drug_Name | String | Brand or generic drug name |
| Tier_ID | Integer | 1-6 (cost sharing tier) |
| Prior_Auth | String | Y/N prior authorization required |
| Step_Therapy | String | Y/N step therapy required |
| Quantity_Limit | String | Y/N quantity limit applies |

### Tier Level Definitions

| Tier | Description | Typical Drugs |
|------|-------------|---------------|
| 1 | Preferred Generic | Metformin, lisinopril |
| 2 | Generic | Non-preferred generics |
| 3 | Preferred Brand | Brand drugs on formulary |
| 4 | Non-Preferred Brand | Brand drugs not preferred |
| 5 | Specialty Tier | High-cost specialty drugs (biologics, rare disease) |
| 6 | Select Care Drugs | Injectable/infusion drugs |

---

**Status**: Draft for Review
**Author**: Claude Code
**Date**: 2025-12-11
**Version**: 1.0
