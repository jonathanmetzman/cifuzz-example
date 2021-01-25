#! /bin/bash

git clone https://github.com/google/oss-fuzz.git
docker pull gcr.io/oss-fuzz-base/cifuzz-base:latest

docker build -t build_fuzzers oss-fuzz/infra/build_fuzzers.Dockerfile
docker build -t build_fuzzers oss-fuzz/infra/run_fuzzers.Dockerfile

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

docker run --name build_fuzzers --rm -ti -e GITHUB_WORKSPACE -e GITHUB_REPOSITORY -e GITHUB_EVENT_NAME -e DRY_RUN -e CI -e SANITIZER -e GITHUB_SHA -v /var/run/docker.sock:/var/run/docker.sock -v $WORKDIR:$WORKDIR build_fuzzers

docker run --name run_fuzzers --rm -ti -e GITHUB_WORKSPACE -e GITHUB_REPOSITORY -e GITHUB_EVENT_NAME -e DRY_RUN -e CI -e SANITIZER -e GITHUB_SHA -v /var/run/docker.sock:/var/run/docker.sock -v $WORKDIR:$WORKDIR run_fuzzers
