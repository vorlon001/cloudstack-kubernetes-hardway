#!/usr/bin/bash

git add . && git commit -m "fix $1" && git tag $1
git push --tags
git push --set-upstream origin $1

