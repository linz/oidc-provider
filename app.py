"""
CDK application entry point file.
"""
import constructs
from aws_cdk import App, CfnOutput, CfnParameter, Stack, aws_iam


class OidcProviderStack(Stack):
    def __init__(self, scope: constructs.Construct, construct_id: str) -> None:
        super().__init__(scope, construct_id)

        env_name = CfnParameter(self, "EnvName", type="String", description="The environment to deploy the OidcProviderStack")

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
            "OidcDeployRole",
            role_name=f"{env_name.value_as_string}Oidc",
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

        # Set Cfn to output deploy_role arn post CDK deployment.
        # Assign or update this value in AWS_ASSUME_ROLE in GitHub secrets
        CfnOutput(self, "ServiceAccountIamRole", value=oidc_deploy_role.role_arn)


def main() -> None:
    app = App()

    OidcProviderStack(app, "OidcProviderStack")

    app.synth()


if __name__ == "__main__":
    main()
