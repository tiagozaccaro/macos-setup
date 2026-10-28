# macOS Setup

Bash script to bootstrap a fresh macOS machine: Homebrew, packages/casks, macOS defaults, and dotfiles.

## Usage

```sh
git clone <repo> ~/macos-setup
cd ~/macos-setup
chmod +x setup.sh
./setup.sh
```

Run only parts:

```sh
./setup.sh --brew
./setup.sh --defaults
./setup.sh --dotfiles
```

## Run via curl

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tiagosantana/macos-setup/main/setup.sh)"
```

Or with a custom raw URL:

```sh
RAW_URL=https://raw.githubusercontent.com/you/macos-setup/main /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/you/macos-setup/main/setup.sh)"
```

- Edit the `Brewfile` for apps/tools.
- Edit `apply_defaults()` for macOS settings.


## Notes

- Settings listed are examples/placeholders; replace with your own.
- Re-running is safe (idempotent-ish).
