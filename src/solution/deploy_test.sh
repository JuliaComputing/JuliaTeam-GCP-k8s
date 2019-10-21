cat manifest/manifests.yaml \
    | sed "s/\$IMAGE_JULIATEAM_APP/gcr.io\/juliacomputing-public\/juliateam-app@sha256:4fbb7ed6046e8e4ef09dc4067037258c29dd507982de376385e7257828c9bf9/g" \
    | sed "s/\$IMAGE_UBBAGENT/gcr.io\/juliacomputing-public\/ubbagent@sha256:147fb153cce0988e27e09cddc74dfbb0917b60bbe666946f684deba360908a22/g" \
    | sed "s/\$IMAGE_BILLING_USAGE_REPORT_APP/gcr.io\/juliacomputing-public\/jtbillingapp@sha256:acebf3cd34a76e927cad9c89590e38db118e91ab72a807810006b1915153d35/g" \
    | sed "s/\$JULIATEAM_HOSTNAME//g" \
    | sed "s/\$OVERWRITE/true/g" \
    | sed "s/\$POOL_NAME/pool-1/g" \
    | sed "s/\$JC_AUTH_TOKEN/buildbot:eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6ImtleS0yMDE4LTEyLTE0In0.eyJuYW1lIjoiSnVsaWFDb21wdXRpbmcgQnVpbGRCb3QiLCJleHAiOjE5MzYwODA2NTEsImF1ZCI6Imp1bGlhdGVhbS1wcm9kIiwic3ViIjoiYnVpbGRib3QiLCJpYXQiOjE1MzU5OTQyNTEsImlzcyI6Imh0dHBzOi8vYXV0aDIuanVsaWFjb21wdXRpbmcuaW8vZGV4IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImVtYWlsIjoiYnVpbGRib3RAanVsaWFjb21wdXRpbmcuY29tIn0.ZnZhogLk-YsvxVagrHN5AG0pGGS0xh20r6pCjioZths/g" \
    | kubectl create -f -


# export REGISTRY=gcr.io/$(gcloud config get-value project | tr ':' '/')
# export TAG=1.2
