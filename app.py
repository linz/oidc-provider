"""
CDK application entry point file.
"""
import constructs
from aws_cdk import App, CfnParameter, Stack, aws_iam


class OidcProviderStack(Stack):
    def __init__(self, scope: constructs.Construct, construct_id: str) -> None:
        super().__init__(scope, construct_id)

        github_repo = CfnParameter(
            self,
            "GithubRepo",
            type="String",
            description="Specify the parameters that limit which GitHub repo has access to AWS",
        )

        aws_iam.OpenIdConnectProvider(
            self,
            "GithubAwsOidcProvider",
            url="https://token.actions.githubusercontent.com",
            client_ids=["sts.amazonaws.com"],
        )

        account_id = aws_iam.AccountRootPrincipal().account_id

        oidc_deploy_role = aws_iam.Role(
            self,
            "GitHubOidcDeployer",
            role_name="GitHubOidcDeployer",
            assumed_by=aws_iam.WebIdentityPrincipal(
                f"arn:aws:iam::{account_id}:oidc-provider/token.actions.githubusercontent.com",
                {
                    "StringLike": {
                        "token.actions.githubusercontent.com:aud": ["sts.amazonaws.com"],
                        "token.actions.githubusercontent.com:sub": [f"repo:{github_repo.value_as_string}"],
                    }
                },
            ),
        )

        oidc_deploy_role.add_managed_policy(aws_iam.ManagedPolicy.from_aws_managed_policy_name("AdministratorAccess"))


def main() -> None:
    app = App()

    OidcProviderStack(app, "OidcProvider")

    app.synth()


if __name__ == "__main__":
    main()
