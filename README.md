<div align="center">
  <img src="logo.png" alt="Alpine Variations Logo" width="200">
</div>
<p align="center">

<a href="https://github.com/aagjalpankaj/alpine-variations/actions/workflows/ci.yml">
  <img src="https://github.com/aagjalpankaj/alpine-variations/actions/workflows/ci.yml/badge.svg" alt="ci">
</a>

<a href="https://hub.docker.com/r/aagjalpankaj/alpine">
  <img src="https://img.shields.io/docker/pulls/aagjalpankaj/alpine?logo=docker" alt="Docker Pulls">
</a>
</p>

# alpine-variations

Secure, minimal & up-to-date Alpine Linux Docker image variations.

## Features

- **🪶 Lightweight** — Minimal images built on Alpine Linux
- **🔧 Tool variations** — Preconfigured images with useful CLI tools
- **🔒 Secure by default** — Non-root execution with minimal attack surface
- **📦 Multi-architecture** — Supports multiple CPU platforms
- **⚙️ CI pipeline** — Images are automatically built, tested, and pushed

## Available Variations
Choose the variation that fits your needs. All images follow below pattern:

```
aagjalpankaj/alpine:{{version}}-{{variation}}
```

### Variations

| Variation      | Docker Hub                                                                                                                                                                                                                                         |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
| **[jq](https://github.com/jqlang/jq)** | [![aagjalpankaj/alpine:latest-jq](https://img.shields.io/docker/image-size/aagjalpankaj/alpine/latest-jq?label=aagjalpankaj%2Falpine%3Alatest-jq)](https://hub.docker.com/r/aagjalpankaj/alpine/tags?name=latest-jq&page=1&ordering=-name) <br /> [![aagjalpankaj/alpine:3.23-jq](https://img.shields.io/docker/image-size/aagjalpankaj/alpine/3.23-jq?label=aagjalpankaj%2Falpine%3A3.23-jq)](https://hub.docker.com/r/aagjalpankaj/alpine/tags?name=3.23-jq&page=1&ordering=-name)         |
| **[yq](https://github.com/mikefarah/yq)** | [![aagjalpankaj/alpine:latest-yq](https://img.shields.io/docker/image-size/aagjalpankaj/alpine/latest-yq?label=aagjalpankaj%2Falpine%3Alatest-yq)](https://hub.docker.com/r/aagjalpankaj/alpine/tags?name=latest-yq&page=1&ordering=-name) <br /> [![aagjalpankaj/alpine:3.23-yq](https://img.shields.io/docker/image-size/aagjalpankaj/alpine/3.23-yq?label=aagjalpankaj%2Falpine%3A3.23-yq)](https://hub.docker.com/r/aagjalpankaj/alpine/tags?name=3.23-yq&page=1&ordering=-name)         |
| **[curl](https://github.com/curl/curl)** | [![aagjalpankaj/alpine:latest-curl](https://img.shields.io/docker/image-size/aagjalpankaj/alpine/latest-curl?label=aagjalpankaj%2Falpine%3Alatest-curl)](https://hub.docker.com/r/aagjalpankaj/alpine/tags?name=latest-curl&page=1&ordering=-name) <br /> [![aagjalpankaj/alpine:3.23-curl](https://img.shields.io/docker/image-size/aagjalpankaj/alpine/3.23-curl?label=aagjalpankaj%2Falpine%3A3.23-curl)](https://hub.docker.com/r/aagjalpankaj/alpine/tags?name=3.23-curl&page=1&ordering=-name) |
| **[git](https://github.com/git/git)** | [![aagjalpankaj/alpine:latest-git](https://img.shields.io/docker/image-size/aagjalpankaj/alpine/latest-git?label=aagjalpankaj%2Falpine%3Alatest-git)](https://hub.docker.com/r/aagjalpankaj/alpine/tags?name=latest-git&page=1&ordering=-name) <br /> [![aagjalpankaj/alpine:3.23-git](https://img.shields.io/docker/image-size/aagjalpankaj/alpine/3.23-git?label=aagjalpankaj%2Falpine%3A3.23-git)](https://hub.docker.com/r/aagjalpankaj/alpine/tags?name=3.23-git&page=1&ordering=-name)     |

**Missing a variation?** [Request](https://github.com/aagjalpankaj/alpine-variations/issues/new?assignees=&labels=enhancement&template=new-variation-request.md&title=%5BVariation+Request%5D) by creating an issue!

## Quick Start Example

### jq
```bash
docker pull aagjalpankaj/alpine:latest-jq
```

```bash
echo '{"name": "alpine-variations", "version": "1.0.0"}' | docker run --rm -i aagjalpankaj/alpine:latest-jq jq '.name'
```

### yq
```bash
docker pull aagjalpankaj/alpine:latest-yq
```

```bash
echo 'name: alpine-variations
version: 1.0.0' | docker run --rm -i aagjalpankaj/alpine:latest-yq yq '.name'
```

### curl
```bash
docker pull aagjalpankaj/alpine:latest-curl
```

```bash
docker run --rm aagjalpankaj/alpine:latest-curl curl -s https://api.github.com/users/aagjalpankaj
```

### git
```bash
docker pull aagjalpankaj/alpine:latest-git
```

```bash
docker run --rm -v $(pwd):/data aagjalpankaj/alpine:latest-git git clone https://github.com/aagjalpankaj/alpine-variations.git
```
