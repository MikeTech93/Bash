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
	if [ -z "$1" ]; then
		profile=$(aws-vault list | awk '{print $1}' | fzf)
		if [ -z "$profile" ]; then
			echo "No profile selected."
			return 1
		fi

		instances=$(aws-vault exec $profile -- aws ec2 describe-instances --query "Reservations[*].Instances[*].[Tags[?Key=='Name']|[0].Value,InstanceId]" --output text | awk -F '\t' '{gsub(/ /,"-", $1); print $1","$2}' | fzf)
		
		if [ -z "$instances" ]
		then
			echo "No instances found."
			return 1
		fi

		target=$(echo "$instances" | grep -o 'i-[[:alnum:]]\+' | fzf)

		if [ -z "$target" ]
		then
			echo "No target selected."
			return 1
		fi
		aws-vault exec $profile -- aws ssm start-session --target $target
	else
		aws-vault exec $1 -- aws ssm start-session --target $target
	

## function to connect to an ec2 instance via SSM (RDP Connection via port forwarding)
function aws-ConnectRDP() {
    localPortNumber=55678
    if [ -z "$1" ]; then
        profile=$(aws-vault list | awk '{print $1}' | fzf)
        if [ -z "$profile" ]; then
            echo "No profile selected."
            return 1
        fi

		instances=$(aws-vault exec $profile -- aws ec2 describe-instances --query "Reservations[*].Instances[*].[Tags[?Key=='Name']|[0].Value,InstanceId]" --output text | awk -F '\t' '{gsub(/ /,"-", $1); print $1","$2}' | fzf)

		if [ -z "$instances" ]
		then
			echo "No instances found."
			return 1
		fi

		target=$(echo "$instances" | grep -o 'i-[[:alnum:]]\+' | fzf)

		if [ -z "$target" ]
		then
			echo "No target selected."
			return 1
		fi
    else
        profile="$1"
        target="$2"
    fi

    while true; do
        if lsof -Pi :$localPortNumber -sTCP:LISTEN -t >/dev/null; then
            echo "A service is already running on port $localPortNumber. Please enter a different port number:"
            read -r localPortNumber
        elif lsof -Pi :$localPortNumber -sTCP:LISTEN -t >/dev/null; then
            echo "Port $localPortNumber is already in use. Please enter a different port number:"
            read -r localPortNumber
        else
            break
        fi
    done

    aws-vault exec $profile -- aws ssm start-session --target "$target" --document-name AWS-StartPortForwardingSession --parameters "localPortNumber=$localPortNumber,portNumber=3389"
}
