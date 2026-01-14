# QB64PE Docker - Complete Multi-Platform Build System ✅

## 🎉 **STATUS: FULLY FUNCTIONAL**

Your QB64PE Docker project now provides a **complete, production-ready solution** for building QB64PE projects across multiple platforms with automatic releases!

## 🚀 What You Can Do Now

### Use in Other QB64PE Projects (Recommended)

Add one file `.github/workflows/build.yml` to any QB64PE project:

```yaml
name: Build My QB64PE Project

on:
  push:
    tags: [ 'v*' ]

jobs:
  build:
    uses: grymmjack/qb64pe-docker/.github/workflows/reusable-build.yml@main
    with:
      source-file: 'src/main.bas'
      project-name: 'my-awesome-game'
```

Then:
```bash
git tag v1.0.0
git push origin v1.0.0
```

✨ **Automatic builds for Linux, macOS, and Windows with releases!**

## 📦 What Was Created

### Workflows
- `.github/workflows/reusable-build.yml` - Multi-platform reusable workflow ⭐
- `.github/workflows/build-example.yml` - Example usage
- `.github/workflows/docker-build.yml` - Docker image publishing
- `action.yml` - Direct action for custom builds

### Documentation
- `USAGE-GUIDE.md` - Complete overview
- `docs/REUSABLE-ACTION.md` - Full guide for other projects ⭐
- Updated `README.md` with multi-platform info

## 🎯 Key Features

✅ **Multi-Platform**: Linux, macOS, Windows (parallel builds)  
✅ **Automatic Releases**: Tag-based release creation  
✅ **Artifacts**: Platform-specific archives (.tar.gz, .zip)  
✅ **Reusable**: Drop into any QB64PE project  
✅ **Docker**: Pre-built image for fast Linux builds  
✅ **Tested**: Working console program compilation  

## 📚 Quick Links

- [Reusable Action Guide](docs/REUSABLE-ACTION.md) - **Start here for your projects!**
- [Usage Guide](USAGE-GUIDE.md) - Complete documentation
- [Examples](EXAMPLES.md) - Practical examples

---

**Ready to use in your QB64PE projects!** 🚀
