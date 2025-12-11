# OpenPharma Repository Template

This template provides a standardized structure for all OpenPharma MCP servers.

## Repository Structure

```
{server-name}-mcp/
├── README.md                    # Main documentation
├── LICENSE                      # MIT License
├── CHANGELOG.md                 # Version history
├── CONTRIBUTING.md              # Contribution guidelines
├── package.json                 # npm package config (if Node.js)
├── pyproject.toml               # Python package config (if Python)
├── src/                         # Source code
│   ├── index.ts                 # Main entry point (TypeScript)
│   ├── __init__.py              # Main entry point (Python)
│   ├── server.ts/server.py      # MCP server implementation
│   ├── client.ts/client.py      # API client wrapper
│   └── types.ts/types.py        # Type definitions
├── tests/                       # Test suite
│   ├── integration/             # Integration tests
│   └── unit/                    # Unit tests
├── examples/                    # Usage examples
│   ├── basic.ts/basic.py        # Basic usage
│   └── advanced.ts/advanced.py  # Advanced patterns
└── docs/                        # Additional documentation
    ├── api.md                   # API reference
    ├── installation.md          # Installation guide
    └── troubleshooting.md       # Common issues
```

## README.md Template

```markdown
# {Server Name} MCP Server

> MCP server for {data source description}

[![MCP](https://img.shields.io/badge/MCP-Compatible-blue)](https://modelcontextprotocol.io)
[![npm version](https://badge.fury.io/js/@openpharma%2F{server-name}-mcp.svg)](https://www.npmjs.com/package/@openpharma/{server-name}-mcp)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

## Overview

{2-3 paragraph description of what this server does and why it's useful}

### Key Features

- ✅ Feature 1
- ✅ Feature 2
- ✅ Feature 3

### Data Source

This server connects to **{Official API Name}** ({url})

- **Authority**: {e.g., FDA, NIH, WHO}
- **Update Frequency**: {e.g., Daily, Real-time}
- **Rate Limits**: {e.g., 1000 requests/hour}
- **API Key Required**: {Yes/No}

## Installation

### npm (Node.js)

```bash
npm install -g @openpharma/{server-name}-mcp
```

### pip (Python)

```bash
pip install openpharma-{server-name}-mcp
```

## Configuration

### Claude Desktop

Add to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "{server-name}": {
      "command": "{server-name}-mcp",
      "env": {
        "API_KEY": "your_api_key_here"
      }
    }
  }
}
```

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `API_KEY` | No/Yes | API key for {service} |
| `CACHE_DIR` | No | Cache directory (default: ~/.cache/{server-name}-mcp) |

## Usage

### Available Methods

#### `method_1`

Description of what this method does.

**Parameters:**
- `param1` (string, required): Description
- `param2` (number, optional): Description

**Returns:** Description of return value

**Example:**
```json
{
  "method": "method_1",
  "param1": "value",
  "param2": 123
}
```

#### `method_2`

...

### Example Queries

**Basic Search:**
```
Find FDA approved drugs for diabetes
```

**Advanced Query:**
```
Search clinical trials for GLP-1 agonists in Phase 3, recruiting status,
with results posted in last 2 years
```

## Development

### Setup

```bash
git clone https://github.com/openpharma/{server-name}-mcp.git
cd {server-name}-mcp
npm install  # or pip install -e .
```

### Testing

```bash
npm test  # or pytest
```

### Building

```bash
npm run build  # or python -m build
```

## API Reference

See [docs/api.md](docs/api.md) for complete API documentation.

## Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md) for common issues and solutions.

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Related Projects

- [OpenPharma](https://github.com/openpharma) - Full MCP server collection
- [{Related Server 1}](https://github.com/openpharma/{server1}-mcp)
- [{Related Server 2}](https://github.com/openpharma/{server2}-mcp)

## Citation

```bibtex
@software{{server-name}_mcp,
  title = {{Server Name} MCP Server},
  author = {OpenPharma Contributors},
  year = {2025},
  url = {https://github.com/openpharma/{server-name}-mcp}
}
```

## Support

- **Issues**: [GitHub Issues](https://github.com/openpharma/{server-name}-mcp/issues)
- **Discussions**: [GitHub Discussions](https://github.com/openpharma/community/discussions)
- **Documentation**: [docs/](docs/)
```

## CONTRIBUTING.md Template

```markdown
# Contributing to {Server Name} MCP

Thank you for your interest in contributing! This document provides guidelines for contributions.

## Code of Conduct

Be respectful, constructive, and collaborative.

## How to Contribute

### Reporting Bugs

1. Check existing issues first
2. Use the bug report template
3. Include:
   - MCP server version
   - Operating system
   - Steps to reproduce
   - Expected vs actual behavior
   - Error messages/logs

### Suggesting Features

1. Check existing feature requests
2. Use the feature request template
3. Describe:
   - Use case and motivation
   - Proposed solution
   - Alternatives considered

### Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass: `npm test`
6. Update documentation
7. Commit with clear messages: `git commit -m "Add amazing feature"`
8. Push to your fork: `git push origin feature/amazing-feature`
9. Open a pull request

### Development Guidelines

**Code Style:**
- Follow existing code style
- Use TypeScript/Python type hints
- Run linter: `npm run lint` or `ruff check`

**Testing:**
- Write unit tests for new functions
- Write integration tests for API calls
- Aim for >80% code coverage

**Documentation:**
- Update README.md for new features
- Add JSDoc/docstrings for public APIs
- Include usage examples

**Commits:**
- Use conventional commits format
- Examples:
  - `feat: add drug search method`
  - `fix: handle pagination edge case`
  - `docs: update installation guide`

## Development Setup

See README.md for setup instructions.

## Testing

```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run integration tests only
npm run test:integration
```

## Release Process

(Maintainers only)

1. Update CHANGELOG.md
2. Bump version in package.json
3. Create git tag: `git tag v1.2.3`
4. Push tag: `git push origin v1.2.3`
5. GitHub Actions will publish to npm/PyPI

## Questions?

Open a discussion in [GitHub Discussions](https://github.com/openpharma/community/discussions)
```

## CHANGELOG.md Template

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Feature additions

### Changed
- Changes to existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security fixes

## [1.0.0] - YYYY-MM-DD

### Added
- Initial release
- Method 1 implementation
- Method 2 implementation
- Comprehensive documentation

[Unreleased]: https://github.com/openpharma/{server-name}-mcp/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/openpharma/{server-name}-mcp/releases/tag/v1.0.0
```

## LICENSE Template

```
MIT License

Copyright (c) 2025 OpenPharma Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR DEALINGS IN THE
SOFTWARE.
```

## Quality Checklist

Before publishing a new OpenPharma server, ensure:

### Documentation
- [ ] README.md follows template
- [ ] API reference complete
- [ ] Usage examples provided
- [ ] Troubleshooting guide included

### Code Quality
- [ ] Type definitions complete
- [ ] Error handling comprehensive
- [ ] Rate limiting implemented
- [ ] Caching strategy documented

### Testing
- [ ] Unit tests >80% coverage
- [ ] Integration tests for all methods
- [ ] CI/CD pipeline configured

### Publishing
- [ ] Package.json/pyproject.toml configured
- [ ] License file included
- [ ] GitHub topics added
- [ ] npm/PyPI keywords set

### Community
- [ ] CONTRIBUTING.md present
- [ ] Issue templates configured
- [ ] PR template configured
- [ ] Code of conduct included
