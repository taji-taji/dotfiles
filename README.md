# dotfiles

## Premise

`git` and `vim` is installed.

## Usage

```
$ cd ~
$ git clone https://github.com/taji-taji/dotfiles.git
$ cd dotfiles
$ sh install.sh
```

### Setup Mac

```
$ sh mac/settings.sh
```

### Install Homebrew

```
$ sh tools/brew.sh
```

### Install languages

```
$ sh tools/pyenv.sh
$ sh tools/rbenv.sh
$ sh tools/swiftenv.sh
$ sh tools/pupenv.sh
```

## Environment Variables

- `$GOPATH: $HOME/go`
