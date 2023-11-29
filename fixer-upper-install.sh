#!/bin/bash
#kubectl apply -f https://github.com/alvaroiramirez/kubernetes/raw/master/fixer-upper-all.yaml
# Replace 'your-github-username', 'your-github-repo', and 'path/to/your/file.yaml' with the actual GitHub details
GITHUB_USERNAME="alvaroiramirez"
GITHUB_REPO="kubernetes"
FILE_PATH="fixer-upper-all.yaml"

# Set the Kubernetes namespace (if applicable)
NAMESPACE="default"

# GitHub raw content URL
RAW_URL="https://raw.githubusercontent.com/$GITHUB_USERNAME/$GITHUB_REPO/master/$FILE_PATH"

# Fetch the YAML file
kubectl apply -f $RAW_URL -n $NAMESPACE

# Check the status of the applied resources
kubectl get all -n $NAMESPACE


# get the load balancer ip address 

# Replace 'your-service-name' with the name of your Kubernetes service
SERVICE_NAME="fixer-upper-svc"

# Set the maximum number of attempts
MAX_ATTEMPTS=30

# Set the delay between attempts in seconds
DELAY_SECONDS=10

# Initialize the counter
attempts=0

# Loop until the external IP is obtained or max attempts are reached
while [ $attempts -lt $MAX_ATTEMPTS ]; do
  EXTERNAL_IP=$(kubectl get svc $SERVICE_NAME -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

  if [ -z "$EXTERNAL_IP" ]; then
    echo "Attempt $((attempts + 1)): External IP not yet available. Retrying in $DELAY_SECONDS seconds..."
    sleep $DELAY_SECONDS
    attempts=$((attempts + 1))
  else
    echo "External IP Address: $EXTERNAL_IP"
    break
  fi
done

if [ $attempts -eq $MAX_ATTEMPTS ]; then
  echo "Timed out. External IP address not obtained after $((MAX_ATTEMPTS * DELAY_SECONDS)) seconds."
fi
