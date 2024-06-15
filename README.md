# Hosting Backend Application on EC2 Instances with Auto-Scaling and Load Balancer

[![CI-Backend](https://github.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/actions/workflows/ci-backend-tests.yml/badge.svg)](https://github.com/enricogoerlitz/aws-bp-2-hosting-backend-on-ec2-asg-alb/actions/workflows/ci-backend-tests.yml)

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