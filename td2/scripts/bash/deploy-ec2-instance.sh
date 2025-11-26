#!/usr/bin/env bash
set -e

# Région AWS
export AWS_DEFAULT_REGION="us-east-2"

# Répertoire du script et contenu du user-data
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
user_data=$(cat "$SCRIPT_DIR/user-data.sh")

# Créer un Security Group
security_group_id=$(aws ec2 create-security-group \
  --group-name "sample-app" \
  --description "Allow HTTP traffic into the sample app" \
  --output text \
  --query GroupId)

# Autoriser le trafic HTTP entrant
aws ec2 authorize-security-group-ingress \
  --group-id "$security_group_id" \
  --protocol tcp \
  --port 80 \
  --cidr "0.0.0.0/0" > /dev/null

# Launch multiple EC2 instances
for i in 1 2 3; do
  instance_id=$(aws ec2 run-instances \
    --image-id "ami-0c5ddb3560e768732" \
    --instance-type t3.micro \
    --security-group-ids "$security_group_id" \
    --user-data "$user_data" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=sample-app-$i}]" \
    --output text \
    --query 'Instances[0].InstanceId')

  echo "Instance $i ID = $instance_id"

  # Wait for each instance to be running
  aws ec2 wait instance-running --instance-ids "$instance_id"

  # Get public IP
  public_ip=$(aws ec2 describe-instances \
    --instance-ids "$instance_id" \
    --output text \
    --query 'Reservations[*].Instances[*].PublicIpAddress')

  echo "Instance $i Public IP = $public_ip"
done

# Attendre que l’instance soit en running
aws ec2 wait instance-running --instance-ids "$instance_id"

# Récupérer l’IP publique
public_ip=$(aws ec2 describe-instances \
  --instance-ids "$instance_id" \
  --output text \
  --query 'Reservations[*].Instances[*].PublicIpAddress')

# Affichage des informations
echo "Instance ID = $instance_id"
echo "Security Group ID = $security_group_id"
echo "Public IP = $public_ip"

