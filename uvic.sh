#!/bin/sh

[ -z "$1" ] && {
	[ -f "$HOME/.bash_profile" ] && {
		BASHFILE="$HOME/.bash_profile"
	} || {
		BASHFILE="$HOME/.bashrc"
	}
} || {
	BASHFILE="$1"
}

addToFile(){
	file="${1:-${BASHFILE}}"
	read line
	grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

EC2=

echo 'setupAwsCli() { curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" ; unzip awscliv2.zip ; rm awscliv2.zip ; ./aws/install -i /home/$HOME/aws-cli ; ~/aws-cli/v2/current/bin/aws configure ; }' | addToFile
echo 'startEc2() { ~/aws-cli/v2/current/bin/aws ec2 start-instances --instance-ids i-0fb1b5499918be07f ; } ' | addToFile
echo 'stopEc2() { ~/aws-cli/v2/current/bin/aws ec2 stop-instances --instance-ids i-0fb1b5499918be07f ; } ' | addToFile
echo 'printEc2() { ~/aws-cli/v2/current/bin/aws ec2 describe-instances --filters Name=instance-id,Values=i-0fb1b5499918be07f --output text | grep -oE "ec2-[0-9-]*.us-west-.*.compute.amazonaws.com" | head -n1 ; } ' | addToFile
echo 'alias ec2="~/aws-cli/v2/current/bin/aws ec2 describe-instances --filters Name=instance-id,Values=i-0fb1b5499918be07f --output text | grep -oE "ec2-[0-9-]*.us-west-.*.compute.amazonaws.com" | head -n1 | xargs -I {} ssh ubuntu@{}"' | addToFile


#GIT Aliases (logg, st, p, etc)
curl -Ls 'https://raw.githubusercontent.com/brennanwilkes/dev-setup/main/gitAliases.sh' | sh

#fancy GIT prompt displaying meta data
curl -Ls 'https://raw.githubusercontent.com/brennanwilkes/dev-setup/main/gitPrompt.sh' | sh

#Misc functions and aliases
curl -Ls 'https://raw.githubusercontent.com/brennanwilkes/dev-setup/main/miscUtilities.sh' | sh

#IMPORTANT
source ~/.bashrc

