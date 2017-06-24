Mirror a github repo somewhere else
-----------------------------------

In contrast to what [`repo-make-public`](bin/repo-make-public) does
where the master is not on github, in this case the github repo is the
master. All sync happens over https rather than ssh. Clone the repo
somewhere via:

```
git clone --mirror https://github.com/:user/:repo
```

Add a `push` github repository webhook with secret `$SECRET` that hits
this cgi script in the same directory as the bare directory created
above:

```shell
#!/bin/sh

JQ=jq
KEY="$SECRET"
BODY=$(cat -) 
HMAC="sha1="$(echo -n $BODY | openssl dgst -binary -sha1 -hmac $KEY | xxd -p)

if [ "$HMAC" = "$HTTP_X_HUB_SIGNATURE" ]; then 
    REPO_NAME=$(echo -n $BODY | $JQ --raw-output ".repository.name")
    git -C $REPO_NAME.git remote update --prune > /dev/null
    echo "Status: 200"
    echo "Content-type: text/plain"
    echo ""
    echo "Updated $REPO_NAME"
else
    echo "Status: 401"
    echo "Content-type: text/plain"
    echo ""
    echo "Payload HMAC validation failure"
    echo "Expected: $HTTP_X_HUB_SIGNATURE"
    echo "Found: $HMAC"
fi
```



