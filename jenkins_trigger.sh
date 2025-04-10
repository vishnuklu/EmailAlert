#!/bin/bash

# whole bash script is nothing but breaking of following jenkins triggering command
# curl  http://username:password@jenkins_url/job/job_name/build?token=token_name

# Define the Jenkins user and password
JENKINS_USER=localhost
JENKINS_PASS=localhost

# Define the Jenkins server URL
JENKINS_URL=http://$JENKINS_USER:$JENKINS_PASS@192.168.1.8:8080

# Define Jenkins api token name
JENKINS_API_TOKEN_NAME=jenkins-trigger

# ================================================

# put exact job name as you have in jenkins

JENKINS_JOBS=(
    "vishalk17-docker"
    "demo2"
    "demo3"
    "google"
)

# ================================================
# Print the jobs to the console
echo "Select the Jenkins jobs to trigger:"
for i in $(seq 1 ${#JENKINS_JOBS[@]}); do
  echo "$i. ${JENKINS_JOBS[$i - 1]}"
done

# Option to trigger all jobs
echo "0. Trigger all jobs"

# Prompt the user to enter the numbers of the jobs they want to trigger
read -p "Enter the numbers of the jobs you want to trigger (comma-separated, 0 to trigger all): " SELECTED_JOBS

# Split the SELECTED_JOBS variable into an array
SELECTED_JOBS_ARRAY=(${SELECTED_JOBS//,/ })

# Trigger the selected Jenkins jobs
for job in ${SELECTED_JOBS_ARRAY[@]}; do
  if [ "$job" -eq "0" ]; then
    echo "Triggering all jobs..."
    for j in "${JENKINS_JOBS[@]}"; do
      echo "Triggering job $j..."
      curl "$JENKINS_URL/job/$j/build?token=$JENKINS_API_TOKEN_NAME"
    done
    break
  fi

  if [ "$job" -gt "0" ] && [ "$job" -le "${#JENKINS_JOBS[@]}" ]; then
    job_name="${JENKINS_JOBS[$job - 1]}"
    echo "Triggering job $job_name..."
    curl "$JENKINS_URL/job/$job_name/build?token=$JENKINS_API_TOKEN_NAME"
  else
    echo "Invalid selection: $job"
  fi
done
