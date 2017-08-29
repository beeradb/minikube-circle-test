#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset


DEPLOYMENT=
NAMESPACE=

get_generation() {
  get_deployment_jsonpath '{.metadata.generation}'
}

get_observed_generation() {
  get_deployment_jsonpath '{.status.observedGeneration}'
}

get_replicas() {
  get_deployment_jsonpath '{.spec.replicas}'
}

get_available_replicas() {
  get_deployment_jsonpath '{.status.availableReplicas}'
}

get_deployment_jsonpath() {
  local readonly _jsonpath="$1"

  ./kubectl get deployment "${DEPLOYMENT}" -n "${NAMESPACE}" -o "jsonpath=${_jsonpath}"
}

if [[ $# != 2 ]]; then
  echo "usage: $(basename $0) <namespace> <deployment>" >&2
  exit 1
fi

readonly DEPLOYMENT=$2
readonly NAMESPACE=$1

readonly generation=$(get_generation)
echo "waiting for specified generation ${generation} to be observed"
while [[ $(get_observed_generation) -lt ${generation} ]]; do
  sleep .5
done
echo "specified generation observed."

readonly replicas="$(get_replicas)"
echo "specified replicas: ${replicas}"

available=-1
while [[ ${available} -ne ${replicas} ]]; do
  sleep .5
  available=$(get_available_replicas)
  echo "available replicas: ${available}"
done

echo "deployment ${DEPLOYMENT} found."

