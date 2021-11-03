#!/bin/sh

# Deletes deploy keys from supplied repos
# Useful for resetting when testing etc.

set -e

if [ -z "$GITHUB_TOKEN" ]
then
    echo "Error. GITHUB_TOKEN is not set"
    exit 1
fi

unset DOIT
while getopts 'y' o
do
    case "$o" in
        y)
            DOIT='y'
            ;;
        *)
            echo "Unknown option $o"
            exit 1
            ;;
    esac
done
shift $(expr $OPTIND - 1)

if [ -z "$1" ]
then
    echo "Using default repos"
    REPOS="steveww/gitops steveww/podinfo-deploy"
else
    REPOS="$*"
fi

clear
for REPO in $REPOS
do
    echo "$REPO"
done

echo " "
if [ -z "$DOIT" ]
then
    /bin/echo -n "Delete all deployment keys from these repos? <y/n> "
    read ANS

    if [ "$ANS" != "y" ]
    then
        echo "Bye"
        exit
    fi
fi

AUTH_HEADER="Authorization: token $GITHUB_TOKEN"
VERSION_HEADER="Accept: application/vnd.github.v3+json"

for REPO in $*
do
    # Get all deploy keys for REPO
    for KEY in $(curl \
        -sL \
        -H "$AUTH_HEADER" \
        -H "$VERSION_HEADER" \
        https://api.github.com/repos/$REPO/keys | jq -r '.[].id')
    do
        echo "Deleting key $KEY from $REPO"
        curl \
            -sL \
            -X DELETE \
            -H "$AUTH_HEADER" \
            -H "$VERSION_HEADER" \
            -w '%{http_code}' \
            https://api.github.com/repos/$REPO/keys/$KEY
        echo " "
    done
done

