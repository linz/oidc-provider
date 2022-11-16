# OIDC Provider

[![GitHub Actions Status](https://github.com/linz/oidc-provider/workflows/Build/badge.svg)](https://github.com/linz/oidc-provider/actions)
[![Kodiak](https://badgen.net/badge/Kodiak/enabled?labelColor=2e3a44&color=F39938)](https://kodiakhq.com/)
[![Dependabot Status](https://badgen.net/badge/Dependabot/enabled?labelColor=2e3a44&color=blue)](https://github.com/linz/oidc-provider/network/updates)
[![License](https://badgen.net/github/license/linz/oidc-provider?labelColor=2e3a44&label=License)](https://github.com/linz/oidc-provider/blob/master/LICENSE)
[![Conventional Commits](https://badgen.net/badge/Commits/conventional?labelColor=2e3a44&color=EC5772)](https://conventionalcommits.org)
[![Code Style](https://badgen.net/badge/Code%20Style/black?labelColor=2e3a44&color=000000)](https://github.com/psf/black)
[![Imports: isort](https://img.shields.io/badge/%20imports-isort-%231674b1?style=flat&labelColor=ef8336)](https://pycqa.github.io/isort/)
[![Checked with mypy](http://www.mypy-lang.org/static/mypy_badge.svg)](http://mypy-lang.org/)
[![Code Style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg)](https://github.com/prettier/prettier)

**OIDC** (OpenID Connect) can be used within _GitHub workflows_ to authenticate with Amazon Web
Services. This eliminates the need to store AWS credentials as long-lived GitHub secrets.

This CDK stack enables OpenID Connect in Amazon Web Services. It only needs to be deployed once per
AWS account and can be accessed by one or more GitHub repositories. Restrictions can be put in place
based on a specific repo, event, branch, or tag. Please refer to GitHub documentation on
[Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
for further information.

A single AWS role is created as part of this stack. The role arn is provided as an output of this
cdk and will be displayed post deployment. This should be referenced within GitHub workflows (i.e.
in your application stack) to manage deployment. The role policy should specify which AWS resources
GitHub actions has access to.

### Prerequisites

- An AWS account
- A role policy which specifies the level of access GitHub actions has on AWS (referencing existing
  AWS managed policy is allowed)
- A GitHub repo with predetermined access restrictions (i.e. with reference matching a specific
  branch, event or tag)

It is important to prevent untrusted workflows or repositories from requesting access token to AWS
resources. Please refer to GitHub documentation on
[security hardening with OpenID Connect](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
for further information.

### How to Deploy

This cdk stack can be deployed by running the following:  
`cdk deploy --profile <profile-name> --GithubRepo=<github-repo> --EnvName=<environment-name>`

where

- `<profile-name>` references the
  [named profile for the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
- `<github-repo>` references the GitHub repository that should be granted access to oidc
- `<environment-name>` references to the application environment of your deployment  
  This is used as part of the role creation name (e.g.
  `arn:aws:iam::123456789:role/<environment-name>Oidc`) and is mostly useful in identifying which
  account the role belongs to in a multi account setup.

for example:  
`cdk deploy --profile=li-geostore-ci --parameters=EnvName="Ci" --parameters=GithubRepo="linz/geostore:*"`
