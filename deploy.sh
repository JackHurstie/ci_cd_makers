#!/bin/bash

# Variables
  KEY_PATH=~/.ssh/jack_cloud_deployment.pem
  EC2_HOST=ec2-user@35.176.131.32
  REMOTE_DIR=/home/ec2-user/message-server
  PASSWORD=Millybella1997

# Copy necessary files
echo "> Uploading files to EC2"
scp -i $KEY_PATH app.py requirements.txt Dockerfile $EC2_HOST:$REMOTE_DIR

# Connect and run container
ssh -i $KEY_PATH $EC2_HOST << EOF
  cd message-server
  docker build -t message-server-img .
  docker stop message-server || true
  docker rm message-server || true
  docker run -p 5002:5002 --name message-server\
    -e APP_ENV=PRODUCTION \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=$PASSWORD \
    -e POSTGRES_HOST=jack-message-server-db.cvruukypsgyb.eu-west-2.rds.amazonaws.com \
    -e POSTGRES_DB=postgres \
    message-server
EOF

echo "✅ Deployment complete! Visit: http://35.176.131.32:5002"
