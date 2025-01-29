# CAP Cloud Community Version

Welcome to the CAP Cloud Community Edition! This is the open-source version of CAP Cloud, providing core functionality for cloud infrastructure management and automation.

## Overview

CAP Cloud Community Edition provides essential features for cloud infrastructure management while maintaining simplicity and ease of use. This repository contains the core piece of the community-supported version of CAP Cloud.


<img src="./docs/images/LangGraph-ECS-Architecture.png" alt="CAP Architecture" width="100%" />


Start your project with the ingestion service. The quality of the data ingested is a key factor for the performance of the CAP. As the langgraph ECS Service is not part of the community edtion, open an account at [LangGraph](https://langchain.com/langgraph) and follow the instructions to install the service. Then follow the instructions in the [CAP INGESTION](https://github.com/Agaile-com/cap-ingestion-community) repository to install the ingestion service.

You also need to install the CAP ENGINE. Follow the instructions in the [CAP ENGINE](https://github.com/Agaile-com/cap-engine-community) and use the resulting image to deploy what we call ENGINE-Lite service on the LangGraph Platform. ([Langsmith](https://smith.langchain.com/))

and [CAP FRONTEND](https://github.com/Agaile-com/cap-frontend-community) repositories.


## Getting Started

1. **Prerequisites**
   - Git
   - Shell environment (Bash/Zsh)
   - Required dependencies (listed in documentation)

2. **Installation**
   ```bash
   # Clone the repository
   git clone https://github.com/Agaile-com/cap-cloud-community-repo.git
   cd cap-cloud-community-repo

   # Run the deployment script
   ./scripts/deploy-community.sh
   ```

## Documentation

Detailed documentation is available in the `/docs` directory:
- Setup Guide
- Usage Instructions
- API Reference
- Contributing Guidelines

## Contributing

We welcome contributions from the community! Please see our [Contributing Guide](CONTRIBUTING.md) for details on:
- Code of Conduct
- Development Process
- Pull Request Guidelines
- Community Guidelines

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- GitHub Issues: For bug reports and feature requests
- Discussions: For questions and community support
- Wiki: For additional documentation and guides

## Related Projects

- [CAP Cloud Documentation](https://docs.cap-cloud.com)
- [Community Plugins](https://plugins.cap-cloud.com)

## Status

[![Community Repository CI](https://github.com/Agaile-com/cap-cloud-community-repo/workflows/Community%20Repository%20CI/badge.svg)](https://github.com/Agaile-com/cap-cloud-community-repo/actions)
