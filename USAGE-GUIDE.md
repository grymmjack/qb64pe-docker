# QB64PE Docker - Reusable Multi-Platform Build Action

## 🎯 What This Provides

You now have a **complete, production-ready solution** for building QB64PE projects that:

### ✅ Multi-Platform Builds
- **Linux** (x64) - via Docker
- **macOS** (x64) - native QB64PE
- **Windows** (x64) - native QB64PE  

All platforms build **in parallel** using GitHub Actions matrix strategy.

### ✅ Automatic Releases
- Tag your code (e.g., `v1.0.0`)
- GitHub Actions automatically creates a release
- All platform binaries uploaded to the release
- Release notes auto-generated

### ✅ Three Ways to Use

#### 1. Reusable Workflow (Easiest)
Drop this into any QB64PE project's `.github/workflows/build.yml`:

```yaml
name: Build My Game

on:
  push:
    tags: [ 'v*' ]

jobs:
  build:
    uses: grymmjack/qb64pe-docker/.github/workflows/reusable-build.yml@main
    with:
      source-file: 'game.bas'
      project-name: 'my-awesome-game'
```

#### 2. Direct Action Use (More Control)
```yaml
jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        include:
          - os: ubuntu-latest
            platform: linux
          - os: macos-latest
            platform: macos
          - os: windows-latest
            platform: windows
    steps:
      - uses: actions/checkout@v4
      - uses: grymmjack/qb64pe-docker@main
        with:
          source-file: 'src/main.bas'
          project-name: 'my-game'
          platform: ${{ matrix.platform }}
```

#### 3. Local Docker (Development)
```bash
# Build the Docker image
make build

# Compile your program
docker run --rm -v "$(pwd):/workspace" qb64pe:latest -x -w game.bas -o game

# Or use the helper script
./qb64pe-compile.sh workspace/game.bas
```

## 📦 What Gets Created

### Artifacts (Every Build)
- `my-game-lnx-x64.tar.gz` - Linux binary
- `my-game-osx-x64.tar.gz` - macOS binary  
- `my-game-win-x64.zip` - Windows binary

### Releases (On Tags)
When you push a tag like `v1.0.0`:
1. GitHub Actions builds all platforms
2. Creates a new GitHub Release
3. Uploads all binaries to the release
4. Generates release notes from commits

## 🚀 Quick Start for Your QB64PE Projects

### Step 1: Add Workflow to Your Project

Create `.github/workflows/build.yml` in your QB64PE project:

```yaml
name: Build and Release

on:
  push:
    branches: [ main ]
    tags: [ 'v*' ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    uses: grymmjack/qb64pe-docker/.github/workflows/reusable-build.yml@main
    with:
      source-file: 'src/main.bas'  # Your main .bas file
      project-name: 'my-game'       # Your project name
      qb64pe-version: 'v4.3.0'      # QB64PE version
```

### Step 2: Commit and Push

```bash
git add .github/workflows/build.yml
git commit -m "Add multi-platform build workflow"
git push
```

### Step 3: Create a Release

```bash
git tag v1.0.0
git push origin v1.0.0
```

Done! Your game is now built for all platforms and released on GitHub! 🎉

## 🔧 Configuration Options

### Workflow Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `source-file` | Path to your .bas file | ✅ Yes | - |
| `project-name` | Project name for artifacts | ✅ Yes | - |
| `qb64pe-version` | QB64PE version | ❌ No | `v4.3.0` |
| `create-release` | Auto-create releases | ❌ No | `true` |

### Example: Different QB64PE Version

```yaml
with:
  source-file: 'game.bas'
  project-name: 'retro-racer'
  qb64pe-version: 'v4.2.0'  # Use older version
```

### Example: Build Without Releases

```yaml
with:
  source-file: 'app.bas'
  project-name: 'my-app'
  create-release: false  # Disable auto-releases
```

## 🏗️ Architecture

### Docker Image (Linux Builds)
- **Base**: Debian 12 Slim
- **Size**: ~1.4GB
- **Contains**: QB64PE v4.3.0 + build tools + runtime libraries
- **Built**: From QB64PE source via multi-stage build
- **Cached**: Available at `ghcr.io/grymmjack/qb64pe:v4.3.0`

### macOS/Windows Builds
- Downloads official QB64PE releases
- Runs setup scripts
- Compiles natively on each platform

### Why Docker for Linux?
- Pre-compiled QB64PE (faster builds)
- Consistent environment
- Works on any system with Docker
- Easy local development

## 📋 Files in This Repository

### Core Files
- `action.yml` - GitHub Action definition
- `Dockerfile` - Multi-stage Docker build
- `.github/workflows/reusable-build.yml` - Reusable workflow
- `.github/workflows/build-example.yml` - Example usage

### Helper Scripts
- `qb64pe-compile.sh` - Local compilation script
- `Makefile` - Build automation
- `demo.sh` - Demonstration script
- `verify.sh` - Verification script

### Documentation
- `README.md` - Main documentation
- `docs/REUSABLE-ACTION.md` - **Complete guide for using in your projects**
- `QUICKSTART.md` - Getting started guide
- `EXAMPLES.md` - Usage examples
- `CONTRIBUTING.md` - Contribution guidelines

## 🎮 Example Projects

### Simple Console Game
```yaml
jobs:
  build:
    uses: grymmjack/qb64pe-docker/.github/workflows/reusable-build.yml@main
    with:
      source-file: 'game.bas'
      project-name: 'text-adventure'
```

### Multi-File Project
```yaml
jobs:
  build:
    uses: grymmjack/qb64pe-docker/.github/workflows/reusable-build.yml@main
    with:
      source-file: 'src/main.bas'  # Main file that includes others
      project-name: 'my-rpg'
```

Make sure your main.bas includes other modules:
```basic
'$INCLUDE: 'src/player.bi'
'$INCLUDE: 'src/enemy.bi'
```

## 🐛 Troubleshooting

### Build Fails on macOS/Windows
- Ensure QB64PE version exists: https://github.com/QB64-Phoenix-Edition/QB64pe/releases
- Check network connectivity (downloads QB64PE)
- Use specific version: `qb64pe-version: 'v4.3.0'`

### Linux Build Works, Others Don't
- Linux uses pre-built Docker image (fast)
- macOS/Windows download and compile QB64PE (slower, can fail)
- Pin to known-good version

### Compilation Errors
- Test locally first: `make test`
- Check console output mode for headless builds
- Ensure all included files are in repository

## 💡 Best Practices

1. **Version Pinning**: Always specify `qb64pe-version` for reproducible builds
2. **Tag Format**: Use semantic versioning: `v1.0.0`, `v2.1.3`, `v1.0.0-beta`
3. **Testing**: Test with `make test` before pushing
4. **Console Mode**: Use `$CONSOLE:ONLY` for CLI programs
5. **File Organization**: Keep source in `src/` directory
6. **Dependencies**: Include all .bi files in repository

## 📚 Additional Documentation

- [Full Reusable Action Guide](docs/REUSABLE-ACTION.md) - **Start here!**
- [QB64PE Wiki](https://github.com/QB64-Phoenix-Edition/QB64pe/wiki)
- [GitHub Actions Docs](https://docs.github.com/actions)
- [Docker Documentation](https://docs.docker.com/)

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📝 License

This project is licensed under the MIT License. QB64PE is licensed under its own terms.

---

**Made with ❤️ for the QB64 community**

**Ready to use in your projects!** Just add the workflow file and start building! 🚀
