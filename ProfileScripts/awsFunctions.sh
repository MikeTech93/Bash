## test AWS credentials can authenticate
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

## function to describe ec2 instances using aws vault, prompt the user for a profile if none is specified
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
	fi
}

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

# Function to open an AWS console session in a private/incognito window of your chosen browser
#
# Usage:
#   awslogin [--browser brave|chrome|firefox|edge] [aws_vault_profile]
#
# Examples:
#   awslogin                              	# pick profile then open in Brave private window
#   awslogin --browser firefox             	# pick profile then open in Firefox private window
#   awslogin --browser chrome prod-admin   	# open prod-admin profile in Chrome incognito window
function awslogin() {
  emulate -L zsh
  setopt PIPE_FAIL

  # parse options
  local -a browser_opt
  zparseopts -D -E -browser:=browser_opt
  local browser
  if [[ -n "${browser_opt[2]}" ]]; then
    browser="${browser_opt[2]:l}"   # lowercase
  else
    browser="brave"
  fi

  # pick AWS Vault profile
  local profile
  if [[ -n "$1" ]]; then
    profile="$1"
  else
    if ! command -v fzf >/dev/null 2>&1; then
      echo "fzf is required for interactive profile selection." >&2
      return 1
    fi
    profile=$(aws-vault list 2>/dev/null | awk '{print $1}' | fzf)
    if [[ -z "$profile" ]]; then
      echo "No profile selected."
      return 1
    fi
  fi

  # ensure aws-vault exists
  if ! command -v aws-vault >/dev/null 2>&1; then
    echo "aws-vault not found in PATH." >&2
    return 1
  fi

  # get login URL from aws-vault
  local url
  if ! url=$(aws-vault --debug login "$profile" --stdout); then
    echo "aws-vault login failed for profile: $profile" >&2
    return 1
  fi

  # choose browser command/flags
  local app cmd tmpcache
  case "$browser" in
    brave)
      app="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
      tmpcache=$(mktemp -d /tmp/brave.XXXXXX)
      cmd=( "$app" --no-first-run --new-window --incognito --disk-cache-dir="$tmpcache" "$url" )
      ;;
    chrome|google-chrome)
      app="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
      tmpcache=$(mktemp -d /tmp/chrome.XXXXXX)
      cmd=( "$app" --no-first-run --new-window --incognito --disk-cache-dir="$tmpcache" "$url" )
      ;;
    edge|microsoft-edge)
      app="/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
      tmpcache=$(mktemp -d /tmp/edge.XXXXXX)
      cmd=( "$app" --no-first-run --new-window --inprivate --disk-cache-dir="$tmpcache" "$url" )
      ;;
    firefox)
      app="/Applications/Firefox.app/Contents/MacOS/firefox"
      cmd=( "$app" -private-window "$url" )
      ;;
    *)
      echo "Unsupported browser: $browser. Use brave|chrome|firefox|edge." >&2
      return 1
      ;;
  esac

  # Launch browser
  if [[ ! -x "$app" ]]; then
    echo "Browser not found at: $app" >&2
    return 1
  fi

  # Detach cleanly
  nohup "${cmd[@]}" >/dev/null 2>&1 &
}
