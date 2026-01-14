#!/bin/bash
# Demo script showing all the ways to use QB64PE Docker

echo "=========================================="
echo "QB64PE Docker - Interactive Demo"
echo "=========================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker first."
    exit 1
fi

# Function to pause
pause() {
    echo ""
    read -p "Press Enter to continue..."
    echo ""
}

# Check if image exists
if ! docker image inspect qb64pe:latest > /dev/null 2>&1; then
    echo "QB64PE image not found. Building it now..."
    echo "This will take 5-10 minutes on first build..."
    make build
    if [ $? -ne 0 ]; then
        echo "Build failed. Please check the error messages above."
        exit 1
    fi
    echo ""
    echo "Build complete!"
    pause
fi

echo "Demo 1: Using Makefile (Recommended)"
echo "======================================"
echo "Command: make test"
echo ""
make test
pause

echo "Demo 2: Using Helper Script"
echo "======================================"
echo "Command: ./qb64pe-compile.sh workspace/hello.bas hello-script"
echo ""
./qb64pe-compile.sh workspace/hello.bas hello-script
echo ""
echo "Compiled executable: workspace/hello-script"
ls -lh workspace/hello-script
pause

echo "Demo 3: Using Docker CLI Directly"
echo "======================================"
echo "Command: docker run --rm -v \"\$(pwd)/workspace:/workspace\" qb64pe:latest -x -w hello.bas -o hello-docker"
echo ""
docker run --rm -v "$(pwd)/workspace:/workspace" qb64pe:latest -x -w hello.bas -o hello-docker
echo ""
echo "Compiled executable: workspace/hello-docker"
ls -lh workspace/hello-docker
pause

echo "Demo 4: Using Docker Compose"
echo "======================================"
echo "Command: docker compose run --rm qb64pe -x -w hello.bas -o hello-compose"
echo ""
docker compose run --rm qb64pe -x -w hello.bas -o hello-compose
echo ""
echo "Compiled executable: workspace/hello-compose"
ls -lh workspace/hello-compose
pause

echo "Demo 5: Interactive Shell"
echo "======================================"
echo "Opening a shell inside the container..."
echo "Try: ./qb64pe -x -w hello.bas -o hello-interactive"
echo "Type 'exit' to leave the container"
echo ""
pause
docker run --rm -it -v "$(pwd)/workspace:/workspace" --entrypoint /bin/bash qb64pe:latest

echo ""
echo "Demo 6: Image Information"
echo "======================================"
make info
pause

echo "=========================================="
echo "Demo Complete!"
echo "=========================================="
echo ""
echo "All methods successfully demonstrated:"
echo "  ✓ Makefile (make test, make compile)"
echo "  ✓ Helper script (./qb64pe-compile.sh)"
echo "  ✓ Docker CLI (docker run)"
echo "  ✓ Docker Compose (docker compose run)"
echo "  ✓ Interactive shell"
echo ""
echo "Check out these compiled files:"
ls -lh workspace/hello* 2>/dev/null || echo "No executables found"
echo ""
echo "Next steps:"
echo "  - Read QUICKSTART.md for quick start"
echo "  - Read README.md for full documentation"
echo "  - Read EXAMPLES.md for GitHub Actions examples"
echo "  - Try 'make help' to see all available commands"
echo ""
echo "Happy coding with QB64PE!"
