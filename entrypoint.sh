#!/bin/bash
set -e

cat << EOS > $HOME/.netrc
machine github.com
login ${GITHUB_ACTOR}
password ${GITHUB_TOKEN}
EOS

git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global user.name "${GITHUB_ACTOR}"

cd "${VARIANT_WORKING_DIR:-.}"

set +e
variant "$@" 2>&1 | tee log.txt
SUCCESS=${PIPESTATUS[0]}
OUTPUT=$(cat log.txt)
echo "$OUTPUT"
set -e

set -vx

if [ "$VARIANT_COMMENT" = "0" ] || [ "$VARIANT_COMMENT" = "false" ]; then
    exit $SUCCESS
fi

if [ $SUCCESS -eq 0 -a "$VARIANT_COMMENT_ON_SUCCESS" = "0" ]; then
    exit 0
fi

if [ $SUCCESS -ne 0 -a "$VARIANT_COMMENT_ON_FAILURE" = "0" ]; then
    exit $SUCCESS
fi


VARIANT_NAME=${variant:-variant}

COMMENT="#### \`$VARIANT_NAME $*\` Status: ${SUCCESS}
\`\`\`
$OUTPUT
\`\`\`"
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')

# Try to report the error either via a pull request comment or an issue comment
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url || true)
if [ "$COMMENTS_URL" == "null" -o "$COMMENTS_URL" != "" ]; then
  COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .issue.comments_url || true)
fi
if [ "$COMMENTS_URL" != "null" -a "$COMMENTS_URL" != "" ]; then
  curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null
fi

exit $SUCCESS
