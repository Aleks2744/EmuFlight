#!/bin/bash -x
#
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
#GIT_COMMIT_DATE=$(git log -1 --date=short --format="%cd")
#GIT_REVISION=$(git rev-parse --short HEAD)
TRAVIS_BUILD_NUMBER=${TRAVIS_BUILD_NUMBER:=undefined}
#TRAVIS_REPO_SLUG=${TRAVIS_REPO_SLUG:=$USER/undefined}
CODE_VERSION=$(make version)

MAKE="make EXTRA_FLAGS=-Werror"

TARGET="$1"
$MAKE $TARGET || exit $?
jq --arg version "$CODE_VERSION-$TRAVIS_BUILD_NUMBER" --arg branch "$GIT_BRANCH" '.version.name = $version, .package.name = $branch' bintray-conf.json > bintray-conf.json

cat bintray-conf.json # DEBUG
