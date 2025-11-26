 #!/usr/bin/env bash
set -e
name=$(npm pkg get name | tr -d '"')
version=$(npm pkg get version | tr -d '"')
docker buildx build --load -t "$name:$version" .
