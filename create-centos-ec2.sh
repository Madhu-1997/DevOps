
NAME="Node_One"
IMAGE_ID=ami-03265a0778a880afb
INSTANCE_TYPE=t2.micro
SECURITY_GROUP_ID=sg-0ad69d40f72e05b81


echo "creating $NAME instance"
IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$NAME}]" | jq -r '.Instances[0].PrivateIpAddress')
echo "created $NAME instance: $IP_ADDRESS"