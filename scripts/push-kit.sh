#!/usr/bin/env bash
set -euo pipefail
#
# Build and push the whalesay kit (sandbox-kit v3) to Docker Hub.
#
#   ./scripts/push-kit.sh          -> docker.io/ajeetraina777/sbx-whalesay-kits:latest + :1.0.0
#   TAG=v1 ./scripts/push-kit.sh   -> ...:v1 (plus :1.0.0)
#
# A v3 kit is a single OCI image: the recipe builds the content and the
# frontend (docker/sandbox-kit:3, pulled automatically from the descriptor's
# `# syntax=` line) annotates it as a kit. No `sbx kit push` of a source dir
# anymore — one `docker buildx build --push` is the whole publish.
#
# Requires: `docker login` and a buildx builder.
namespace="${DOCKERHUB_NAMESPACE:-ajeetraina777}"
version="1.0.0"               # keep in step with `version:` in whalesay.yaml
tag="${TAG:-latest}"
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
kit_dir="$repo_root/whalesay"
repo="docker.io/$namespace/sbx-whalesay-kits"

# Publish a version-shaped tag beside the bare moving tag: the latter says
# nothing about which build it points at.
docker buildx build "$kit_dir" -f "$kit_dir/whalesay.yaml" \
  --platform linux/amd64,linux/arm64 --provenance=true --push \
  -t "$repo:$tag" -t "$repo:$version"

echo "Pushed $repo:$tag and $repo:$version"
echo "Consume it with:  sbx run --kit $repo:$tag shell"
