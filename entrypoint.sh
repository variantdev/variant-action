#!/bin/sh
set -e
cd "${VARIANT_WORKING_DIR:-.}"

set +e
OUTPUT=$(sh -c "variant $*" 2>&1)
SUCCESS=$?
echo "$OUTPUT"
set -e

if [ $SUCCESS -eq 0 ]; then
    exit 0
fi

if [ "$VARIANT_COMMENT" = "1" ] || [ "$VARIANT_COMMENT" = "false" ]; then
    exit $SUCCESS
fi

VARIANT_NAME=${variant:-variant}

COMMENT="#### \`$VARIANT_NAME $*\` Failed
\`\`\`
$OUTPUT
\`\`\`"
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null

exit $SUCCESS
