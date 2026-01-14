#!/bin/bash
# Verification script for QB64PE Docker project

set -e

echo "================================================"
echo "QB64PE Docker - Project Verification"
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

warn() {
    echo -e "${YELLOW}!${NC} $1"
}

# Check required files
echo "Checking required files..."
files=(
    "Dockerfile"
    "docker-compose.yml"
    "action.yml"
    "Makefile"
    "qb64pe-compile.sh"
    "README.md"
    "LICENSE"
    ".github/workflows/docker-build.yml"
    ".github/workflows/test.yml"
    "workspace/hello.bas"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        success "$file exists"
    else
        error "$file is missing"
        exit 1
    fi
done

echo ""
echo "Checking documentation files..."
docs=(
    "QUICKSTART.md"
    "EXAMPLES.md"
    "CONTRIBUTING.md"
    "CHANGELOG.md"
    "SUMMARY.md"
)

for doc in "${docs[@]}"; do
    if [ -f "$doc" ]; then
        success "$doc exists"
    else
        warn "$doc is missing (optional)"
    fi
done

echo ""
echo "Checking permissions..."
if [ -x "qb64pe-compile.sh" ]; then
    success "qb64pe-compile.sh is executable"
else
    error "qb64pe-compile.sh is not executable"
    echo "  Run: chmod +x qb64pe-compile.sh"
fi

echo ""
echo "Checking Docker..."
if command -v docker &> /dev/null; then
    success "Docker is installed"
    docker --version
else
    error "Docker is not installed"
    exit 1
fi

echo ""
echo "Checking Docker Compose..."
if docker compose version &> /dev/null; then
    success "Docker Compose is available"
    docker compose version
else
    warn "Docker Compose is not available (optional)"
fi

echo ""
echo "================================================"
echo "Project structure verification complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo "  1. Build the image:     make build"
echo "  2. Test compilation:    make test"
echo "  3. Read documentation:  cat README.md"
echo "  4. Quick start:         cat QUICKSTART.md"
echo ""
echo "Or simply run:"
echo "  make test"
echo ""
