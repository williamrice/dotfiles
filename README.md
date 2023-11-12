# dotfiles
new manjaro dotfiles


New PC steps

- Commit to bashrc
```
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

```
echo ".cfg" >> .gitignore
```

```
git clone --bare <git-repo-url> $HOME/.cfg
```

```
config checkout
```

- If issues, 

```
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```

```
config config --local status.showUntrackedFiles no
```
