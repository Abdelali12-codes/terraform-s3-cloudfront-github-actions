resource "aws_iam_openid_connect_provider" "github_account1" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1" # GitHub's public certificate thumbprint
  ]
  provider = aws.account1
}

resource "aws_iam_role" "github_oidc_role_account1" {
  name               = "GitHubOIDCRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${local.account1}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          },
          StringLike = {
                    "token.actions.githubusercontent.com:sub": "repo:${var.github_org}/${var.github_repo}:*"
                }
        }
      }
    ]
  })
  provider = aws.account1
}

resource "aws_iam_openid_connect_provider" "github_account2" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1" # GitHub's public certificate thumbprint
  ]
  provider = aws.account2
}

resource "aws_iam_role" "github_oidc_role_account2" {
  name               = "GitHubOIDCRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${local.account2}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          },
          StringLike = {
                    "token.actions.githubusercontent.com:sub": "repo:${var.github_org}/${var.github_repo}:*"
                }
        }
      }
    ]
  })
  provider = aws.account2
}

resource "aws_iam_role_policy_attachment" "admin_access_account1" {
  role     = aws_iam_role.github_oidc_role_account1.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "admin_access_account2" {
  role     = aws_iam_role.github_oidc_role_account2.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}