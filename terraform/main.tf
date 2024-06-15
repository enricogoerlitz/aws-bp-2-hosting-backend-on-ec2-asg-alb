# CREATE SECURITY GROUP
#   - name=bp2-hosting-backend
#   - allow only http traffic

# CREATE TARGET GROUP FOR LB
#   - name=tg-bp2-hosting-backend

# CREATE APPLICATION LOAD BALANCER
#   - name=lb-bp2-hosting-backend
#   - internet facing, IPv4, AZ=1a+b+c

# CREATE LAUNCH TEMPLATE (EC2 Launch-Template)
#   - name, AMI, t2.micro, no keypair, sg = sg-0f38bf63879bf9a9,
#     default storage, AND User data = script!

# CREATE AUTOSCALING GROUP
#   - name=asg-bp2-hosting-backend, vpc=default, AZ=eu-central-1a + 1b + 1c