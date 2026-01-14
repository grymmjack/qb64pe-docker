# Quick Start Guide

Get up and running with QB64PE Docker in 5 minutes!

## Option 1: Docker CLI (Fastest)

```bash
# 1. Build the image
docker build -t qb64pe:latest .

# 2. Compile your first program
docker run --rm -v "$(pwd)/workspace:/workspace" qb64pe:latest -x -w hello.bas -o hello

# 3. Success! Your executable is in workspace/hello
```

## Option 2: Helper Script (Easiest)

```bash
# 1. Build the image
docker build -t qb64pe:latest .

# 2. Make the script executable
chmod +x qb64pe-compile.sh

# 3. Compile
./qb64pe-compile.sh workspace/hello.bas hello

# Done!
```

## Option 3: Makefile (Most Convenient)

```bash
# Build and test in one command
make test

# Or step by step:
make build                          # Build image
make compile FILE=workspace/hello.bas OUTPUT=hello  # Compile
make run PROGRAM=hello              # Run
```

## Option 4: Docker Compose

```bash
# Build
docker compose build

# Compile
docker compose run --rm qb64pe -x -w hello.bas -o hello
```

## Using in GitHub Actions

1. Add your QB64 files to your repository
2. Create `.github/workflows/build.yml`:

```yaml
name: Build

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: grymmjack/qb64pe-docker@v1
        with:
          source: main.bas
```

3. Push to GitHub - your program compiles automatically!

## Next Steps

- Read the full [README.md](README.md) for all features
- Check [EXAMPLES.md](EXAMPLES.md) for more use cases
- Explore QB64PE compiler options with `docker run --rm qb64pe:latest --help`

## Troubleshooting

**Image won't build?**
```bash
# Try without cache
docker build --no-cache -t qb64pe:latest .
```

**Permission errors?**
```bash
# Run with your user ID
docker run --rm --user $(id -u):$(id -g) -v "$(pwd):/workspace" qb64pe:latest -x -w program.bas
```

**Need help?**
- Check our [README.md](README.md#troubleshooting)
- Open an issue on GitHub
