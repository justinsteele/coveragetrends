coveragetrends
========

![Screenshot 1](https://raw.githubusercontent.com/justinsteele/coveragetrends/screenshots/screenshots/screenshot1.png?raw=true "Screenshot 1")

Graph coverage data over time based on CircleCI's simplecov artifacts

Requirements:
- CIRCLECI_TOKEN environment variable, set to a [freshly minted API key](https://circleci.com/account/api)

Usage:
- Clone repository
- Run CLI: `bin/coveragetrends <username> <project>`
- Open SimpleServer `python -m SimpleHTTPServer`
- Navigate to [http://localhost:8000/output/](http://localhost:8000/output/)
