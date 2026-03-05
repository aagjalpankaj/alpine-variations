#!/bin/bash

# Alpine Variations - Docker Build and Push Script
# Builds multi-architecture images for linux/amd64 and linux/arm64
# Usage: ./scripts/deploy.sh <variation-name> [alpine-version] [--build-only]
#
# Examples:
#   ./scripts/deploy.sh jq
#   ./scripts/deploy.sh jq 3.21
#   ./scripts/deploy.sh jq latest
#   ./scripts/deploy.sh jq latest --build-only

set -e  # Exit on any error

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_usage() {
    echo "Usage: $0 <variation-name> [alpine-version] [--build-only]"
    echo ""
    echo "Arguments:"
    echo "  variation-name      : Name of the variation to build (e.g., jq)"
    echo "  alpine-version      : Alpine version to use (optional, defaults to 'latest')"
    echo "  --build-only        : Only build the image, do not push to registry"
    echo ""
    echo "Examples:"
    echo "  $0 jq                                    # Creates and pushes multi-arch aagjalpankaj/alpine:latest-jq"
    echo "  $0 jq 3.19                               # Creates and pushes multi-arch aagjalpankaj/alpine:3.19-jq"
    echo "  $0 curl latest                           # Creates and pushes multi-arch aagjalpankaj/alpine:latest-curl"
    echo "  $0 git latest --build-only               # Creates multi-arch but does not push"
    echo ""
    echo "Multi-Architecture Support:"
    echo "  All images are built for both linux/amd64 and linux/arm64 platforms"
    echo ""
    echo "Supported Platforms:"
    echo "  linux/amd64         : x86_64 architecture"
    echo "  linux/arm64         : ARM64 architecture"
    echo "  linux/arm/v7        : ARM v7 architecture"
    echo "  (leave empty for native platform detection)"
    echo ""
    echo "Image Format: aagjalpankaj/alpine:<alpine-version>-<variation>"
    echo ""
    echo "Environment Variables:"
    echo "  DOCKER_PASSWORD     : Docker Hub password/token (for automated login)"
}

if [ $# -lt 1 ]; then
    print_error "Variation name is required!"
    show_usage
    exit 1
fi

# Parse arguments
BUILD_ONLY=false
VARIATION_NAME="$1"
ALPINE_VERSION="${2:-latest}"

# Parse named arguments starting from the third argument
shift 2 2>/dev/null || true  # Remove first two positional args, ignore error if less than 2 args

while [[ $# -gt 0 ]]; do
    case $1 in
        --build-only)
            BUILD_ONLY=true
            shift
            ;;
        *)
            print_error "Unknown argument: $1"
            show_usage
            exit 1
            ;;
    esac
done

VARIATION_PATH="src/variations/$VARIATION_NAME"
DOCKERFILE_PATH="$VARIATION_PATH/Dockerfile"

if [ ! -d "$VARIATION_PATH" ]; then
    print_error "Variation '$VARIATION_NAME' not found in $VARIATION_PATH"
    exit 1
fi

if [ ! -f "$DOCKERFILE_PATH" ]; then
    print_error "Dockerfile not found at $DOCKERFILE_PATH"
    exit 1
fi

# Check if Docker Buildx is available for multi-platform builds
if ! docker buildx version >/dev/null 2>&1; then
    print_error "Docker Buildx is required for multi-platform builds"
    print_info "Please install Docker Buildx or update your Docker installation"
    exit 1
fi

print_info "Setting up cross-platform emulation..."
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes >/dev/null 2>&1 || {
    print_warning "Failed to set up QEMU emulation. Multi-platform build may fail."
}

# Create and use a multi-platform builder
BUILDER_NAME="alpine-variations-builder"
print_info "Setting up buildx builder for multi-platform builds..."

if ! docker buildx inspect $BUILDER_NAME >/dev/null 2>&1; then
    print_info "Creating new buildx builder: $BUILDER_NAME"
    docker buildx create --name $BUILDER_NAME --driver docker-container --bootstrap
else
    print_info "Using existing buildx builder: $BUILDER_NAME"
fi

docker buildx use $BUILDER_NAME
DOCKER_USERNAME="aagjalpankaj"
REPO_NAME="alpine"

# image name: aagjalpankaj/alpine:<alpine-version>-<variation>
IMAGE_NAME="$DOCKER_USERNAME/$REPO_NAME"
FULL_TAG="$ALPINE_VERSION-$VARIATION_NAME"
FULL_IMAGE_NAME="$IMAGE_NAME:$FULL_TAG"

print_info "Building multi-platform Docker image for variation: $VARIATION_NAME"
print_info "Image name: $FULL_IMAGE_NAME"
print_info "Build context: $VARIATION_PATH"
print_info "Alpine base version: $ALPINE_VERSION"
print_info "Target platforms: linux/amd64, linux/arm64"

PLATFORMS="linux/amd64,linux/arm64"

# Prepare build arguments
BUILD_ARGS="--build-arg ALPINE_VERSION=$ALPINE_VERSION"

print_info "Starting multi-platform build..."

if [ "$BUILD_ONLY" = true ]; then
    # Build-only mode: use --load to load image locally (single platform for testing)
    BUILD_CMD="docker buildx build --platform linux/amd64 $BUILD_ARGS -t \"$FULL_IMAGE_NAME\" -f \"$DOCKERFILE_PATH\" \"$VARIATION_PATH\" --load"
    print_info "Build command (local testing): $BUILD_CMD"
    print_warning "Build-only mode: Building single platform (linux/amd64) for local testing"

    if docker buildx build --platform linux/amd64 $BUILD_ARGS -t "$FULL_IMAGE_NAME" -f "$DOCKERFILE_PATH" "$VARIATION_PATH" --load; then
        print_success "Build completed successfully!"
    else
        print_error "Build failed!"
        exit 1
    fi
else
    # Full build and push mode: build multi-platform and push directly
    BUILD_CMD="docker buildx build --platform $PLATFORMS $BUILD_ARGS -t \"$FULL_IMAGE_NAME\" -f \"$DOCKERFILE_PATH\" \"$VARIATION_PATH\" --push"
    print_info "Build command (multi-platform): $BUILD_CMD"

    # Ensure Docker Hub login before building and pushing
    if ! docker info | grep -q "Username"; then
        print_info "Logging in to Docker Hub..."
        if [ -n "$DOCKER_PASSWORD" ]; then
            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
        else
            docker login -u "$DOCKER_USERNAME"
        fi

        if [ $? -ne 0 ]; then
            print_error "Docker Hub login failed!"
            exit 1
        fi
        print_success "Logged in to Docker Hub successfully!"
    else
        print_info "Already logged in to Docker Hub"
    fi

    if docker buildx build --platform $PLATFORMS $BUILD_ARGS -t "$FULL_IMAGE_NAME" -f "$DOCKERFILE_PATH" "$VARIATION_PATH" --push; then
        print_success "Multi-platform build and push completed successfully!"
    else
        print_error "Multi-platform build failed!"
        exit 1
    fi
fi

if [ "$BUILD_ONLY" = true ]; then
    print_success "Build completed! (Push skipped due to --build-only flag)"
    print_info "Your image is available locally as:"
    print_info "  $FULL_IMAGE_NAME"
    print_info "Note: Only linux/amd64 platform built for local testing"
else
    print_success "Multi-platform build and push completed!"
    print_info "Your multi-architecture image is now available on Docker Hub:"
    print_info "  docker pull $FULL_IMAGE_NAME"
    print_info ""
    print_info "Supported architectures:"
    print_info "  ├ linux/amd64"
    print_info "  └ linux/arm64"
fi

print_info "Image details:"
docker images "$IMAGE_NAME" --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"
