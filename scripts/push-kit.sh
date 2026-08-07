#!/usr/bin/env bash
set -euo pipefail
#
# Push the whalesay kit to Docker Hub as an OCI artifact.
#
#   ./scripts/push-kit.sh          -> docker.io/ajeetraina777/sbx-whalesay-kits:latest
#   TAG=v1 ./scripts/push-kit.sh   -> ...:v1
#
# Requires: `docker login` (the kit push uses the Docker credential store).
namespace="${DOCKERHUB_NAMESPACE:-ajeetraina777}"
tag="${TAG:-latest}"
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
ref="docker.io/$namespace/sbx-whalesay-kits:$tag"

sbx kit validate "$repo_root/kit"
sbx kit push "$repo_root/kit" "$ref"

echo "Pushed $ref"
echo "Consume it with:  sbx run --kit $ref shell"
