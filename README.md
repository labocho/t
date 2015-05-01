# t

Customized `tmux new-window` command.

# Installation

    $ git clone https://github.com/labocho/t.git
    # make symlink to executable path
    $ ln -s t/t.rb /usr/local/bin/t

# Usage

    $ tmux
    # create new window
    $ t
    # create new window and run sleep
    $ t sleep 3
    # -n to name window
    $ t -n "deep sleep" sleep 10

# Feature

- No quote for command with arguments (`tmux new-window 'sleep 3'` vs `t sleep 3`).
- Use `direnv exec` if direnv and .envrc exist.
- Use `reattach-to-user-namespace` if exists.
- Inherit environment variables.

# License

MIT License. Copyright 2015 labocho.
