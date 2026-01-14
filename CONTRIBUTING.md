# Contributing to QB64PE Docker

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Ways to Contribute

1. **Report Bugs** - Open an issue describing the bug
2. **Suggest Features** - Open an issue with your feature request
3. **Submit Pull Requests** - Fix bugs or implement features
4. **Improve Documentation** - Help make the docs clearer
5. **Share Examples** - Show how you're using the action

## Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test your changes locally
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your fork (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/qb64pe-docker.git
cd qb64pe-docker

# Build the Docker image
docker build -t qb64pe:dev .

# Test compilation
./qb64pe-compile.sh workspace/hello.bas
```

## Testing

Before submitting a PR, ensure:

1. Docker image builds successfully
2. Sample program compiles
3. GitHub Actions pass (if modified)
4. Documentation is updated

```bash
# Test the build
docker build -t qb64pe:test .

# Test compilation
docker run --rm -v "$(pwd)/workspace:/workspace" qb64pe:test -x -w hello.bas -o hello

# Verify
ls -lh workspace/hello
```

## Code Style

- Use clear, descriptive variable names
- Comment complex logic
- Follow existing formatting patterns
- Keep Dockerfile commands efficient

## Commit Messages

- Use present tense ("Add feature" not "Added feature")
- Be concise but descriptive
- Reference issues when applicable

Examples:
```
Add support for QB64PE v3.16.0
Fix compilation error with spaces in filenames
Update documentation for new flags
```

## Questions?

Feel free to open an issue for any questions about contributing!
