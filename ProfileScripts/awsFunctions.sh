function aws-ListProfiles() {
        aws configure list-profiles
}

function aws-TestConnection() {
        aws sts get-caller-identity --profile $1
}

function aws-ListInstances() {
        aws ec2 describe-instances --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value,Status:State.Name,InstanceID:InstanceId}" --profile $1
}

function aws-Connect() {
        aws ssm start-session --target $1 --profile $2
}

function aws-ConnectRDP() {
        aws ssm start-session --target $1 --document-name AWS-StartPortForwardingSession --parameters "localPortNumber=55678,portNumber=3389" --profile $2
}