# Example: Using QB64PE Docker Action

This directory contains examples of how to use the QB64PE Docker action in various scenarios.

## Example 1: Simple Program Compilation

Create a workflow file `.github/workflows/build.yml`:

```yaml
name: Build QB64 Program

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

## Example 2: Multiple Programs

```yaml
name: Build All Programs

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        program:
          - main.bas
          - tools/utility.bas
          - games/snake.bas
    steps:
      - uses: actions/checkout@v4
      - uses: grymmjack/qb64pe-docker@v1
        with:
          source: ${{ matrix.program }}
          output: ${{ matrix.program | replace('.bas', '') }}
```

## Example 3: Release Build

```yaml
name: Release Build

on:
  release:
    types: [created]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Compile program
        uses: grymmjack/qb64pe-docker@v1
        with:
          source: src/app.bas
          output: myapp-${{ github.ref_name }}
      
      - name: Upload to release
        uses: softprops/action-gh-release@v1
        with:
          files: src/myapp-${{ github.ref_name }}
```

## Example 4: Scheduled Nightly Build

```yaml
name: Nightly Build

on:
  schedule:
    - cron: '0 0 * * *'  # Midnight UTC daily
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Compile
        uses: grymmjack/qb64pe-docker@v1
        with:
          source: nightly.bas
          output: nightly-${{ github.run_number }}
      
      - name: Archive
        uses: actions/upload-artifact@v4
        with:
          name: nightly-build
          path: nightly-*
          retention-days: 7
```

## Example 5: With Optimization Flags

```yaml
name: Optimized Build

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Compile with optimization
        uses: grymmjack/qb64pe-docker@v1
        with:
          source: game.bas
          output: game-optimized
          additional-flags: -f:OptimizeForSpeed
```
