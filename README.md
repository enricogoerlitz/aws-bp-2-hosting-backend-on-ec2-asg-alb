# Hosting Backend Application on EC2 Instances with Auto-Scaling and Load Balancer

[![CI-Backend](https://github.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/actions/workflows/ci-backend.yml/badge.svg)](https://github.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/actions/workflows/ci-backend.yml)
[![CD-Backend](https://github.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/actions/workflows/cd-backend.yml/badge.svg)](https://github.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/actions/workflows/cd-backend.yml)
[![Deploy Infrastructure](https://github.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/actions/workflows/cd-terraform.yml/badge.svg)](https://github.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/actions/workflows/cd-terraform.yml)
[![Destroy Infrastructure](https://github.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/actions/workflows/cd-terraform-destroy.yml/badge.svg)](https://github.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/actions/workflows/cd-terraform-destroy.yml)

# Init Backend

```bash
python -m venv venv
python -m unittest ./tests/test_app.py
```

```bash
$ docker build -t enricogoerlitz/bp2-backend -f ./docker/Dockerfile .
$ docker build --platform linux/amd64/v2 -t enricogoerlitz/bp2-backend-amd64v2 -f ./docker/Dockerfile .

$ docker push enricogoerlitz/bp2-backend:latest
$ docker push enricogoerlitz/bp2-backend-amd64v2:latest
```

https://www.youtube.com/watch?v=GowFk_5Rx_I&ab_channel=CloudScalr

deploy terraform on S3 and manage this in S3

## Doku OpenIDConnect

aws > IAM > Identity Provider > new Identity Provider
    - url=https://token.actions.githubusercontent.com
    - audience=sts.amazonaws.com

enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb

aws > s3 > create bucket
    - name
    - enable enrcyption

aws > IAM > roles > create role > custom trusted policy
policy:
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::YOUR_ACCOUNT_NUMBER:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:YOUR_GITHUB_USERNAME/YOUR_REPO_NAME:*"
                }
            }
        }
    ]
}

GitHub Secrets:
- AWS_BUCKET_NAME=bp2-terraform-deployment-state
- AWS_BUCKET_KEY_NAME=infra.tfstate
- AWS_REGION=eu-central-1
- AWS_ROLE=arn:aws:iam::533267024986:role/github-oicd-bp2-terraform-deployment-role