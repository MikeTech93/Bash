## test AWS credentials can authenticate to an account
function aws-TestAccount() {
	if [ -z "$1" ]
	then
		profile=$(aws-vault list | awk '{print $1}' | fzf)
		if [ -z "$profile" ]
		then
			echo "No profile selected."
			return 1
		fi
		aws-vault exec $profile -- aws sts get-caller-identity
	else
		aws-vault exec $1 -- aws sts get-caller-identity
	fi
}

## function to describe ec2 instances
function aws-ListInstances() {
	if [ -z "$1" ]
	then
		profile=$(aws-vault list | awk '{print $1}' | fzf)
		if [ -z "$profile" ]
		then
			echo "No profile selected."
			return 1
		fi
		aws-vault exec $profile -- aws ec2 describe-instances --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value,Status:State.Name,InstanceID:InstanceId}" --output table
	else
		aws-vault exec $1 -- aws ec2 describe-instances --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value,Status:State.Name,InstanceID:InstanceId}" --output table
	fi
}

## function to connect to an ec2 instance via SSM (CLI Connection)
function aws-Connect() {
	if [ -z "$1" ]
	then
		profile=$(aws-vault list | awk '{print $1}' | fzf)
		if [ -z "$profile" ]
		then
			echo "No profile selected."
			return 1
		fi
		instances=$(aws-vault exec $profile -- aws ec2 describe-instances --query "Reservations[*].Instances[*].[Tags[?Key=='Name']|[0].Value,InstanceId]" --output text)
		if [ -z "$instances" ]
		then
			echo "No instances found."
			return 1
		fi
		target=$(echo "$instances" | fzf | awk '{print $2}')
		if [ -z "$target" ]
		then
			echo "No target selected."
			return 1
		fi
		aws-vault exec $profile -- aws ssm start-session --target $target
	else
		aws-vault exec $1 -- aws ssm start-session --target $target
	fi
}

## function to connect to an ec2 instance via SSM (RDP Connection via port forwarding)
function aws-ConnectRDP() {
	if [ -z "$1" ]
	then
		profile=$(aws-vault list | awk '{print $1}' | fzf)
		if [ -z "$profile" ]
		then
			echo "No profile selected."
			return 1
		fi
		instances=$(aws-vault exec $profile -- aws ec2 describe-instances --query "Reservations[*].Instances[*].[Tags[?Key=='Name']|[0].Value,InstanceId]" --output text)
		if [ -z "$instances" ]
		then
			echo "No instances found."
			return 1
		fi
		target=$(echo "$instances" | fzf | awk '{print $2}')
		if [ -z "$target" ]
		then
			echo "No target selected."
			return 1
		fi
		aws-vault exec $profile -- aws ssm start-session --target $target --document-name AWS-StartPortForwardingSession --parameters "localPortNumber=55678,portNumber=3389"
	else
		aws-vault exec $1 -- aws ssm start-session --target $target --document-name AWS-StartPortForwardingSession --parameters "localPortNumber=55678,portNumber=3389"
	fi
}
