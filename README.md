# OIDC Provider

[![GitHub Actions Status](https://github.com/linz/template-python-hello-world/workflows/Build/badge.svg)](https://github.com/linz/template-python-hello-world/actions)
[![Alerts](https://badgen.net/lgtm/alerts/g/linz/template-python-hello-world?labelColor=2e3a44&label=Alerts&color=3dc64b)](https://lgtm.com/projects/g/linz/template-python-hello-world/context:python)
[![Language grade: Python](https://img.shields.io/lgtm/grade/python/g/linz/template-python-hello-world.svg?logo=lgtm&logoWidth=18)](https://lgtm.com/projects/g/linz/template-python-hello-world/context:python)
[![Coverage: 100% branches](https://img.shields.io/badge/Coverage-100%25%20branches-brightgreen.svg)](https://pytest.org/)
[![Kodiak](https://badgen.net/badge/Kodiak/enabled?labelColor=2e3a44&color=F39938)](https://kodiakhq.com/)
[![Dependabot Status](https://badgen.net/badge/Dependabot/enabled?labelColor=2e3a44&color=blue)](https://github.com/linz/template-python-hello-world/network/updates)
[![License](https://badgen.net/github/license/linz/template-python-hello-world?labelColor=2e3a44&label=License)](https://github.com/linz/template-python-hello-world/blob/master/LICENSE)
[![Conventional Commits](https://badgen.net/badge/Commits/conventional?labelColor=2e3a44&color=EC5772)](https://conventionalcommits.org)
[![Code Style](https://badgen.net/badge/Code%20Style/black?labelColor=2e3a44&color=000000)](https://github.com/psf/black)
[![Imports: isort](https://img.shields.io/badge/%20imports-isort-%231674b1?style=flat&labelColor=ef8336)](https://pycqa.github.io/isort/)
[![Checked with mypy](http://www.mypy-lang.org/static/mypy_badge.svg)](http://mypy-lang.org/)
[![Code Style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg)](https://github.com/prettier/prettier)

**OIDC** (OpenID Connect) can be used within _GitHub workflows_ to authenticate with Amazon Web Services. 
This eliminates the need to store AWS credentials as long-lived GitHub secrets.

This CDK stack enables OpenID Connect in Amazon Web Services. 
It only needs to be deployed once per AWS account and can be accessed by one or more GitHub repositories. 
Restrictions can be put in place based on a specific repo, event, branch, or tag. 
Please refer to GitHub documentation on [Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) 
for further information.

A single AWS role is created as part of this stack. 
This role is assumed by GitHub actions during workflow execution to deploy AWS resources. 
The role policy should specify which AWS resources GitHub actions has access to.

### Prerequisites
- An AWS account
- A role policy which specifies the level of access GitHub actions has on AWS (referencing existing AWS managed policy is allowed) 
- A GitHub repo with predetermined access restrictions (i.e. with reference matching a specific branch, event or tag)\
It is important to prevent untrusted workflows or repositories from requesting access token to AWS resources. 
Please refer to GitHub documentation on [security hardening with OpenID Connect](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect) for further information.

  
### How to Deploy
cdk deploy --profile <profile-name>


