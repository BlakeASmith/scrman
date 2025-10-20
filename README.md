# scrman - Script Manager

A command-line tool to create and manage scripts in multiple languages.

## Features

- 📝 Create scripts in multiple languages (Ruby, Python, JavaScript, TypeScript, Bash, Zsh)
- 🔗 Automatically link scripts to your bin directory
- ✏️ Open scripts in your editor immediately after creation
- ⚙️ Configurable via YAML config file

## Usage

### Create a new script

```bash
# Create a Ruby script (default language)
scrman new my_script

# Create a Python script
scrman new my_script --lang python

# Create a script without linking to bin
scrman new my_script --no-link

# Create a script without opening in editor
scrman new my_script --no-edit
```

### List scripts

```bash
# List all scripts
scrman ls

# List scripts matching a pattern
scrman ls my_*

# List scripts for a specific language
scrman ls --lang python

# List scripts in different output formats
scrman ls --format json
scrman ls --format tsv
scrman ls --format yml
scrman ls --format csv
```

### Remove scripts

```bash
# Remove a script (with confirmation)
scrman rm my_script

# Remove a script from a specific language
scrman rm my_script --lang python

# Force remove without confirmation
scrman rm my_script --force
```

### Options

- `-l, --lang LANGUAGE` - Specify the language (ruby, python, javascript, typescript, bash, zsh)
- `-b, --link` - Link the script to your bin directory (default: true)
- `-e, --edit` - Open the script in your editor (default: true)
- `-f, --format FORMAT` - Output format for ls command (tsv, json, yml, csv)
- `-f, --force` - Force removal without confirmation for rm command

## Configuration

On first run, scrman creates a configuration file at `~/.scrman/config.yml`:

```yaml
version: 0.0.1
editor: vim
bin: ~/.local/bin
languages:
  ruby:
    interpreter: ruby
    extension: rb
  python:
    interpreter: python
    extension: py
  javascript:
    interpreter: node
    extension: js
  typescript:
    interpreter: bun run
    extension: ts
  bash:
    interpreter: bash
    extension: sh
  zsh:
    interpreter: zsh
    extension: sh
default_language: ruby
```

Scripts are stored in `~/.scrman/scripts/` organized by language. You can add your own languages,
or repeats of the same language using a different interpreter (under a different name)

For example, to specifically use `node`
```yaml
languages:
  node:
    interpreter: "node"
    extension: "js" 
```

## Installation

### Homebrew (macOS/Linux)

```bash
brew tap BlakeASmith/tap
brew install scrman
```

### From Source

```bash
git clone https://github.com/BlakeASmith/scrman.git
cd scrman
bundle install
chmod +x bin/scrman
ln -s $(pwd)/bin/scrman /usr/local/bin/scrman
```

## License

MIT

