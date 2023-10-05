#!/bin/bash

  set -ex

  API_KEY='90f9489f7a7cf524'
  BASE_API_URL='https://api.qualiti-dev.com'
  PROJECT_ID='3'
  CLIENT_ID='2dc006bd2468ae362ce391b184964a1d'
  API_KEYS_URL='public/api-keys'
  API_JWT_TOKEN='e6a1bafa93342bfa70f8a2d4ba30bcab714ac000eb5b91484585ad8c38dfd5897c406f31c83ae00f95e87c31f982de2a02f5fa3e2433d8d2f185c2d377c98494cd26ada81f4f6e02b1ae042d6f2db5596de42cf3ca2b4300739fc0ce0d810f86919cccd4945e25f3022e02ba39d8c433e83cd7ce56ca5a755841933bbe5e0925af20a4f61320b003f1b88c6d3197b95906480658c0c5c24b89bd62f4b6489b5338f86c9e6b9a3473a8a5601685dda9353203ad6e07261e129b7b0441af6a1c1534f7c4fad5a3236c12acf74d3d4bb5adbf920440d905d093605e872b325e9722dcfd017fe189ece24375d82201c1c84423d54c377d2684c297414b9647c77190fd08cd7afe032da7934967c71385599b|86da863c93d7fe2343fe81635479ebdb|911b2ffe93424aa5029fccc5a0187a87'

  sudo apt-get update -y
  sudo apt-get install -y jq

  #Trigger test run
  TEST_RUN_ID="$( \
    curl -X POST -G ${BASE_API_URL}/integrations/github/${PROJECT_ID}/trigger-test-run \
      -d 'token='$API_JWT_TOKEN''\
      -d 'triggeredBy=Deploy'\
      -d 'triggerType=automatic'\
    | jq -r '.test_run_id')"

  # Wait until the test run has finished
  TOTAL_ITERATION=50
  I=1
  STATUS="Pending"
  
  while [ "${STATUS}" = "Pending" ]
  do
     if [ "$I" -ge "$TOTAL_ITERATION" ]; then
      echo "Exit qualiti execution for taking too long time.";
      exit 1;
    fi
    echo "We are on iteration ${I}"

    STATUS="$( \
      curl -X GET ${BASE_API_URL}/integrations/github/${PROJECT_ID}/test-run-status?token=${API_JWT_TOKEN}\&testRunId=${TEST_RUN_ID} \
        | jq -r '.status' \
    )"

    ((I=I+1))

    sleep 15;
  done

  echo "Qualiti E2E Tests returned ${STATUS}"
  if [ "$STATUS" = "Passed" ]; then
    exit 0;
  fi
  exit 1;
  
