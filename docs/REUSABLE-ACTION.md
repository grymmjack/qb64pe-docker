# Using QB64PE Docker as a Reusable Action

This guide explains how to use the QB64PE Docker action in your own QB64PE projects.

## 🎯 Overview

The QB64PE Docker action provides:
- ✅ **Multi-platform builds**: Compile for Linux, macOS, and Windows
- ✅ **Automatic releases**: Create GitHub releases with binaries
- ✅ **Artifact uploads**: Download builds from GitHub Actions
- ✅ **Easy integration**: Just add one workflow file

## 📦 Quick Setup

### 1. Create Workflow File

In your QB64PE project, create `.github/workflows/build.yml`:

```yaml
name: Build MyQB64PE-Program

on:
  push:
    branches: [ main ]
    tags: [ 'v*' ]
  pull_request:
    branches: [ main ]

jobs:
  build-linux:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Build for Linux
        uses: grymmjack/qb64pe-docker@main
        with:
          platform: 'linux'
          source-file: 'MyQB64PE-Program.BAS'
          project-name: 'MyQB64PE-Program'
          qb64pe-version: 'v4.3.0'
  
  build-windows:
    runs-on: windows-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Build for Windows
        uses: grymmjack/qb64pe-docker@main
        with:
          platform: 'windows'
          source-file: 'MyQB64PE-Program.BAS'
          project-name: 'MyQB64PE-Program'
          qb64pe-version: 'v4.3.0'
  
  build-macos:
    runs-on: macos-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Build for macOS
        uses: grymmjack/qb64pe-docker@main
        with:
          platform: 'macos'
          source-file: 'MyQB64PE-Program.BAS'
          project-name: 'MyQB64PE-Program'
          qb64pe-version: 'v4.3.0'
```

### 2. Push to GitHub

```bash
git add .github/workflows/build.yml
git commit -m "Add multi-platform build workflow"
git push
```

Your project will now build for all platforms on every push!

### 3. Create a Release

```bash
git tag v1.0.0
git push origin v1.0.0
```

This automatically creates a GitHub release with binaries for:
- `my-awesome-game-lnx-x64.tar.gz` (Linux)
- `my-awesome-game-osx-x64.tar.gz` (macOS)
- `my-awesome-game-win-x64.zip` (Windows)

## 🔧 Configuration

### Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `source-file` | Path to your .bas source file | Yes | - |
| `project-name` | Name for artifacts and releases | Yes | - |
| `qb64pe-version` | QB64PE version to use | No | `v4.3.0` |
| `create-release` | Create releases on tags | No | `true` |

### Example Configurations

#### Different QB64PE Version

```yaml
jobs:
  build:
    uses: grymmjack/qb64pe-docker/.github/workflows/reusable-build.yml@main
    with:
      source-file: 'game.bas'
      project-name: 'retro-racer'
      qb64pe-version: 'v4.2.0'
```

#### Disable Automatic Releases

```yaml
jobs:
  build:
    uses: grymmjack/qb64pe-docker/.github/workflows/reusable-build.yml@main
    with:
      source-file: 'src/app.bas'
      project-name: 'my-app'
      create-release: false
```

## 🎮 Example Projects

### Simple Console Game

```yaml
# .github/workflows/build.yml
name: Build Console Game

on:
  push:
    tags: [ 'v*' ]

jobs:
  build:
    uses: grymmjack/qb64pe-docker/.github/workflows/reusable-build.yml@main
    with:
      source-file: 'game.bas'
      project-name: 'text-adventure'
```

### Multi-File Project

For projects with multiple .bas files, compile your main file:

```yaml
jobs:
  build:
    uses: grymmjack/qb64pe-docker/.github/workflows/reusable-build.yml@main
    with:
      source-file: 'src/main.bas'  # Main entry point
      project-name: 'my-rpg'
```

Make sure your main.bas includes other modules:

```basic
'$INCLUDE: 'src/player.bi'
'$INCLUDE: 'src/enemy.bi'
```

## 🚀 Advanced Usage

### Custom Matrix Build

If you need more control over the build process:

```yaml
name: Custom Build

on: [push]

jobs:
  build:
    name: Build for ${{ matrix.platform }}
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
      
      - name: Build with QB64PE
        uses: grymmjack/qb64pe-docker@main
        with:
          source-file: 'src/game.bas'
          project-name: 'my-game'
          platform: ${{ matrix.platform }}
      
      - name: Run tests
        run: |
          # Your custom test commands here
```

## 📋 Release Process

### Automated Releases

1. Develop your QB64PE project
2. Commit and push changes
3. When ready to release:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
4. GitHub Actions automatically:
   - Builds for all platforms
   - Creates a new release
   - Uploads all binaries
   - Generates release notes

### Manual Releases

Disable automatic releases and create them manually:

```yaml
jobs:
  build:
    uses: grymmjack/qb64pe-docker/.github/workflows/reusable-build.yml@main
    with:
      source-file: 'src/main.bas'
      project-name: 'my-app'
      create-release: false  # Disable auto-release
```

Then download artifacts and create releases manually from the GitHub UI.

## 🐛 Troubleshooting

### Build Fails on macOS

QB64PE downloads may be slow or fail. Use a specific version:

```yaml
with:
  qb64pe-version: 'v4.3.0'  # Ensure this version exists
```

### Windows Build Issues

Make sure your source code uses CRLF line endings for Windows compatibility.

### Linux Build Works, Others Don't

The Linux build uses Docker (pre-compiled QB64PE). macOS/Windows download and compile QB64PE on each run, which can fail if:
- QB64PE version doesn't exist
- Network issues during download
- Missing dependencies

## 💡 Tips

1. **Version Pinning**: Always specify `qb64pe-version` for reproducible builds
2. **Tag Format**: Use semantic versioning tags: `v1.0.0`, `v2.1.3`
3. **Testing**: Test locally with Docker before pushing
4. **Artifacts**: Download artifacts from Actions tab for testing before tagging
5. **Console Only**: Use `$CONSOLE:ONLY` for headless programs

## 📚 Additional Resources

- [QB64PE Documentation](https://github.com/QB64-Phoenix-Edition/QB64pe/wiki)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Semantic Versioning](https://semver.org/)
