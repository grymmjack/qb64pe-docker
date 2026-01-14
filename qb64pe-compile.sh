#!/bin/bash
# QB64PE Docker Compile Helper Script
# Usage: ./qb64pe-compile.sh <source.bas> [output-name]

set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <source.bas> [output-name]"
    echo "Example: $0 hello.bas hello"
    exit 1
fi

SOURCE_FILE="$1"
OUTPUT_NAME="${2:-$(basename "$SOURCE_FILE" .bas)}"

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: Source file '$SOURCE_FILE' not found"
    exit 1
fi

# Get absolute path to source directory
SOURCE_DIR="$(cd "$(dirname "$SOURCE_FILE")" && pwd)"
SOURCE_BASENAME="$(basename "$SOURCE_FILE")"

echo "Compiling $SOURCE_FILE..."
echo "Output: $OUTPUT_NAME"

# Run QB64PE in Docker
docker run --rm \
    -v "$SOURCE_DIR:/workspace" \
    -w /workspace \
    qb64pe:latest \
    -x -w "$SOURCE_BASENAME" -o "$OUTPUT_NAME"

echo "Compilation complete!"
