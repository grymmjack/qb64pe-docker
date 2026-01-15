# .qb64pe-ignore Reference

## Overview

The `.qb64pe-ignore` file allows you to exclude files and directories from your QB64PE release packages. It works similarly to `.gitignore`.

## How It Works

1. Create a `.qb64pe-ignore` file in your project root
2. Add patterns for files/folders to exclude
3. The QB64PE action will automatically read and apply these exclusions when packaging
4. Optionally enable `remove-empty-dirs: true` to clean up empty directories

## Action Parameters

### `remove-empty-dirs` (optional)

Remove empty directories from the final package after exclusions are applied.

- **Default**: `false`
- **Values**: `true` or `false`

**Example usage:**
```yaml
- name: Build for Linux
  uses: grymmjack/qb64pe-docker@main
  with:
    platform: 'linux'
    source-file: 'MyGame.bas'
    project-name: 'MyGame'
    remove-empty-dirs: 'true'  # Clean up empty directories
```

**When to use:**
- When excluded files leave behind empty directories
- To keep your release package clean and minimal
- When directory structure matters for your distribution

## Syntax

- **One pattern per line**
- **Comments**: Lines starting with `#` are ignored
- **Wildcards**: Use `*` for wildcard matching
- **Directories**: End with `/` to match directories (e.g., `includes/`)
- **Case sensitivity**: Patterns are case-insensitive

## Default Exclusions

The action **always excludes** these patterns:
- `*.bas`, `*.bi`, `*.bm`, `*.frm` (source code, case insensitive)
- `.git/`, `.gitmodules`, `submodules/` (git files)
- `.qb64pe-ignore` (this file itself)
- `*.7z` (QB64PE installer archives)
- `qb64pe/` (QB64PE compiler directory)

## Example Patterns

```gitignore
# Exclude specific files
README.dev.md
notes.txt

# Exclude by extension
*.log
*.tmp
*.bak

# Exclude directories
build/
temp/
.vscode/

# Exclude patterns
*-test.bas
*-dev/
test_*

# Exclude build artifacts
*.zip
*.tar.gz
*.7z
```

## Common Use Cases

### Exclude Build Directories
```gitignore
includes/
DRAW-package/
*-package/
```

### Exclude Development Files
```gitignore
.vscode/
.idea/
*.swp
notes.md
TODO.md
```

### Exclude OS Files
```gitignore
.DS_Store
Thumbs.db
desktop.ini
```

### Exclude Build Scripts
```gitignore
*.command
build.sh
deploy.bat
```

## Tips

1. **Test First**: Create a small test project to verify your patterns work correctly
2. **Be Specific**: Use specific patterns to avoid accidentally excluding needed files
3. **Comment Sections**: Use comments to organize your exclusions
4. **Version Control**: Commit your `.qb64pe-ignore` to share with your team

## Example Project Structure

```
MyGame/
├── .qb64pe-ignore          ← Your exclusion rules
├── MyGame.bas              ← Excluded (source code)
├── game.bi                 ← Excluded (source code)
├── README.md               ✓ Included
├── LICENSE                 ✓ Included
├── ASSETS/
│   ├── sprites/            ✓ Included
│   └── sounds/             ✓ Included
├── DATA/
│   └── levels/             ✓ Included
├── includes/               ← Excluded (in .qb64pe-ignore)
├── notes.md                ← Excluded (in .qb64pe-ignore)
└── .github/                ← Excluded (in .qb64pe-ignore)
```

**Release package will contain:**
```
MyGame.exe (or MyGame binary)
README.md
LICENSE
ASSETS/
  sprites/
  sounds/
DATA/
  levels/
```

## Troubleshooting

### Files Still Being Included?

1. Check pattern syntax (no leading/trailing spaces)
2. Verify the pattern matches the file path
3. Check for typos in the pattern
4. Remember patterns are case-insensitive

### Need to Include Source Files?

The action automatically excludes source files. If you need to include specific `.bas` files as data files, you'll need to rename them or modify the action.

### Pattern Not Working?

- Use `*` wildcards: `*-dev/` instead of `-dev/`
- For nested paths: `path/to/file` or `**/file`
- Test locally with similar tools to verify pattern syntax
