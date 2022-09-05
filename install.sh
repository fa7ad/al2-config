#!/usr/bin/bash

$SCRIPT=$(pwd)

cd /etc/yum.repos.d/
sudo wget https://download.opensuse.org/repositories/shells:fish:release:4/CentOS_7/shells:fish:release:3.repo

sudo yum install fish git fortune-mod rsync

curl -L https://bit.ly/n-install | bash -s -- -y lts

curl -sS https://starship.rs/install.sh | sh

cat <<'EOF' > $HOME/.config/fish/config.fish
set cwd (dirname (status -f))

# load env
. $cwd/env.fish

# load aliases
. $cwd/alias.fish

if status is-interactive
  function fish_greeting
    fortune -s
  end
  starship init fish | source
end

if test -f $HOME/.run-omf-install
  echo Run 'omf install' to install omf packages
  rm -f $HOME/.run-omf-install
end

bind \cs sudope

function clear_prompt
  clear
  fish_prompt
end

bind \cl clear_prompt

set -x N_PREFIX "$HOME/n"; contains $N_PREFIX $PATH; or set -a PATH $N_PREFIX
EOF

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

cat <<'EOF' > $HOME/.config/omf/bundle
package bang-bang
package bass
package sudope
package z
theme default
EOF

touch $HOME/.run-omf-install

$HOME/n/bin/npm i -g tldr eslint prettier

rsync $SCRIPT/fish/ $HOME/ -avhP

chsh -s $(which fish)

