#!/bin/sh

filterByRegex() {
	while read line; do
		echo "$line" | grep -oE "$1" | sed -E "s/$1/\\1/g";
	done;
}

repoId="$1"
baseURL=https://gitlab.com/api/v4
debugOutput=./curlRespLog.json

[ -z "$repoId" ] && {
	echo "Project ID not set"
	echo "the project ID can be found on the repo overview page, directly under the repo name"
	echo "Usage: "
	echo "GITLAB_TOKEN=[token] $0 [ID]"
	exit 1
}

[ -z "$GITLAB_TOKEN" ] && {
	echo "GitLab Token not set"
	echo "GitLab token can be aquired from https://gitlab.com/-/profile/personal_access_tokens"
	echo "Usage: "
	echo "GITLAB_TOKEN=[token] $0 [ID]"
	exit 1
}

curlResp=$( curl -sL -X POST --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$baseURL/projects/$repoId/fork" )

[ "$?" -ne 0 ] && {
	echo "Fork failed"
	echo "$curlResp" > "$debugOutput"
	echo "Check \"$debugOutput\" for more information"
	exit 2
}

newRepoId=$( echo "$curlResp" | sed -E 's/^..id.:([0-9]+),.*/\1/' )
sshURL=$( echo "$curlResp" | filterByRegex 'ssh_url_to_repo. *: *.(git@gitlab\.com:[a-zA-Z0-9\-]+\/[a-zA-Z0-9\-]+\.git)' | head -n1 )
httpURL=$( echo "$curlResp" | filterByRegex 'http_url_to_repo. *: *.(https:\/\/gitlab\.com\/[a-zA-Z0-9\-]+\/[a-zA-Z0-9\-]+\.git)' | head -n1 )
repoName=$( echo "$curlResp" | filterByRegex '.name. *: *.([a-zA-Z0-9\-]+).' | head -n1 )

curl -sL -X DELETE --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$baseURL/projects/$newRepoId/fork" >/dev/null
[ "$?" -ne 0 ] && {
	echo "Removal of fork relationship failed"
	echo "$curlResp" > "$debugOutput"
	echo "Check \"$debugOutput\" for more information"
	exit 3
}

curl -sL -X PUT --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$baseURL/projects/$newRepoId?visibility=private" >/dev/null
[ "$?" -ne 0 ] && {
	echo "Setting visibility to private failed"
	echo "$curlResp" > "$debugOutput"
	echo "Check \"$debugOutput\" for more information"
	exit 4
}

git clone "$sshURL" || git clone "$httpURL" || {
	echo Failed to clone to $( pwd )/$repoName
	echo "$curlResp" > "$debugOutput"
	echo "Check \"$debugOutput\" for more information"
}
