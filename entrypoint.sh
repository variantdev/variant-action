#!/bin/bash
set -e

echo "HOME: $HOME"

cat << EOS > $HOME/.netrc
machine github.com
login ${GITHUB_ACTOR}
password ${GITHUB_TOKEN}
EOS

git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global user.name "${GITHUB_ACTOR}"

cd "${VARIANT_WORKING_DIR:-.}"

variant "$@"
