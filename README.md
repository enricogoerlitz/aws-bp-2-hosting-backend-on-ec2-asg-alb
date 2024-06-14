# Hosting Backend Application on EC2 Instances with Auto-Scaling and Load Balancer

# Init Backend

```bash
python -m venv venv
```

```bash
$ docker build -t enricogoerlitz/bp2-backend -f ./docker/Dockerfile .
$ docker tag enricogoerlitz/bp2-backend enricogoerlitz/bp2-backend:latest
$ docker push enricogoerlitz/bp2-backend:latest
```

https://www.youtube.com/watch?v=GowFk_5Rx_I&ab_channel=CloudScalr

deploy terraform on S3 and manage this in S3