#! /bin/bash

set -x

echo "hi"

git clone https://github.com/google/oss-fuzz.git --depth 1
docker pull gcr.io/oss-fuzz-base/cifuzz-base:latest

docker build -t gcr.io/oss-fuzz-base/build_fuzzers oss-fuzz/infra/cifuzz/actions/build_fuzzers
docker build -t gcr.io/oss-fuzz-base/run_fuzzers oss-fuzz/infra/cifuzz/actions/run_fuzzers

# export GITHUB_REPOSITORY=$REPO_NAME
export GITHUB_REPOSITORY=$REPO_NAME
# TODO: Make this optional.
export GITHUB_EVENT_NAME="push"
export DRY_RUN=0
export CI=true
export SANITIZER='address'
export GITHUB_SHA=$COMMIT_SHA

export WORKDIR='/tmp/cifuzz'
mkdir $WORKDIR
export GITHUB_WORKSPACE=$WORKDIR
echo "OSS_FUZZ_PROJECT_NAME $OSS_FUZZ_PROJECT_NAME"

docker run --name build_fuzzers --rm -ti -e GITHUB_WORKSPACE -e GITHUB_REPOSITORY -e GITHUB_EVENT_NAME -e DRY_RUN -e CI -e SANITIZER -e GITHUB_SHA -v /var/run/docker.sock:/var/run/docker.sock -v $WORKDIR:$WORKDIR gcr.io/oss-fuzz-base/build_fuzzers

docker run --name run_fuzzers --rm -ti -e GITHUB_WORKSPACE -e GITHUB_REPOSITORY -e GITHUB_EVENT_NAME -e DRY_RUN -e CI -e SANITIZER -e GITHUB_SHA -v /var/run/docker.sock:/var/run/docker.sock -v $WORKDIR:$WORKDIR gcr.io/oss-fuzz-base/run_fuzzers
