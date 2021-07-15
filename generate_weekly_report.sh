#!/bin/bash

WEEKAGO=$(date -v7d +%F)
WEEK_NO=$(date +"%U %Y")
TEMPLATE="{{range .}}* [#{{.number}}]({{.url}}):  {{.title}}{{\"\n\"}}{{end}}"
REPO_NAME=$1
ORG_NAME="$(gh api -X GET 'orgs/rancher/members' -F per_page=100 --paginate --cache 1h --template='{{range .}}-author:{{.login}} {{end}}')"


if [ -z "$1" ]; then
  echo "Please supply a repo in the form of org/repo"
  exit 1
fi

CLOSED_PR=$(gh pr list --repo $1 -S "closed:>$WEEKAGO" -s closed -t="$TEMPLATE" --json=title,milestone,url,number)
OPENED_PR=$(gh pr list --repo $1 -S "created:>$WEEKAGO" -s all -t="$TEMPLATE" --json=title,milestone,url,number)
CLOSED_ISSUES=$(gh issue list --repo $1 -S "closed:>$WEEKAGO" -s closed -t="$TEMPLATE" --json=title,milestone,url,number)
OPENED_ISSUES=$(gh issue list --repo $1 -S "created:>$WEEKAGO" -s all -t="$TEMPLATE" --json=title,milestone,url,number)

echo "# Weekly Report"
echo "Weekly status report for $REPO_NAME Week #$WEEK_NO"
echo ""
echo ""
echo "## Here's what the team has focused on this week:"
echo "* "

echo ""

echo "## Weekly Stats"
echo "| | Opened this week| Closed this week|"
echo "|--|---|-----|"
echo "|Issues| " $(wc -l <<< "$OPENED_ISSUES") "| "$(wc -l <<< "$CLOSED_ISSUES")"|"
echo "|PR's| " $(wc -l <<< "$OPENED_PR") "| " $(wc -l <<< "$CLOSED_PR")"|"


echo "## PR's Closed"
#closed PRs in the last week
echo "$CLOSED_PR"

echo ""

echo "## PR's Opened"
#opened PRSs last week
echo "$OPENED_PR"
echo ""

echo "## Issues Opened"
#opened issuess in the last week
echo "$OPENED_ISSUES"
echo "" 


echo "## Issues Closed"
#closed issues in the last week
echo "$CLOSED_ISSUES"
echo ""

echo "## Community PRs Closed"
#Community PR's closed
COMMUNITY_PR_CLOSED=$(gh pr list --repo $1 -S "closed:>$WEEKAGO $ORG_NAME" -s closed -t="$TEMPLATE" --json=title,milestone,url,number)

if [ -z "$COMMUNITY_PR_CLOSED" ]; then
  echo "None"
else
  echo "$COMMUNITY_PR_CLOSED"
fi

echo ""

echo "## Community PRs Opened"
#Community PR's
COMMUNITY_PR_OPEN=$(gh pr list --repo $1 -S "created:>$WEEKAGO $ORG_NAME" -s all -t="$TEMPLATE" --json=title,milestone,url,number)

if [ -z "$COMMUNITY_PR_OPEN" ]; then
  echo "None"
else
  echo "$COMMUNITY_PR_OPEN"
fi
