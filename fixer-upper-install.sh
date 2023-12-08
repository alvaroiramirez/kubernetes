#!/bin/bash
# kubectl apply -f https://github.com/alvaroiramirez/kubernetes/raw/master/fixer-upper-all.yaml

GITHUB_USERNAME="alvaroiramirez"  # Replace with Tony's GitHub username
GITHUB_REPO="kubernetes"          # Replace with the name of Tony's GitHub repo
FILE_PATH="fixer-upper-all.yaml"  # yaml file path

# Set the Kubernetes namespace (if applicable)
NAMESPACE="default"

# GitHub raw content URL
RAW_URL="https://raw.githubusercontent.com/$GITHUB_USERNAME/$GITHUB_REPO/master/$FILE_PATH"   # Replace with main branch if reading from Tony's repo or master branch if Alvaro's repo

# Fetch the YAML file
kubectl apply -f $RAW_URL -n $NAMESPACE       # Execute yaml file

# Check the status of the applied resources
kubectl get all -n $NAMESPACE            


# GET THE LOAD BALANCER IP ADDRESS
# --------------------------------
# Name of the Kubernetes service as defined in yaml
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


# TO EXECUTE THE SCRIPT
# ---------------------

# set execution permissions
# chmod +x fixer-upper-install.sh 

# execute the script
# ./fixer-upper-install.sh