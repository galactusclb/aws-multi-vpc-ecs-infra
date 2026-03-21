#!/usr/bin/env bash
set -e

NLB_NAME=$1
REGION=$2

IPS=$(aws ec2 describe-network-interfaces \
  --region "$REGION" \
  --profile bit \
  --filters "Name=description,Values=ELB net/$NLB_NAME*" \
  --query "NetworkInterfaces[].PrivateIpAddress" \
  --output text)

# Convert space-separated → comma-separated
IPS_CSV=$(echo "$IPS" | tr ' ' ',')

echo "{\"ips\": \"$IPS_CSV\"}"