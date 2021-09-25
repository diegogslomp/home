#!/bin/bash
#set -xe

_help() {
  echo
  echo 'Run `bash install function`:'
  echo
  grep "()\ {" `basename "$0"` | awk -F '(' '{ print substr($1,2) }' | sort
  echo
}

_bat() {
  local _VERSION='0.13.0'
  local _URL="https://github.com/sharkdp/bat/releases/download/v${_VERSION}/bat_${_VERSION}_amd64.deb"
  local _FILE='/tmp/bat_latest.deb'
  curl -L ${_URL} -o ${_FILE}
  sudo dpkg -i ${_FILE}
  sudo rm -f ${_FILE}
}

_check-dns-servers() {
  for dns in $(awk '{print $2 "\n" $3}' external-dns-servers.txt); do \
    ping $dns -c 1 | \
    grep icmp;
  done | \
  awk '{print $4 $7}' | \
  awk -F ':time=' '{print $2 " - " $1}' | \
  sort -h
}

_docker() {
  curl -L https://get.docker.com | bash
}

_docker-compose() {
  local _VERSION='1.25.4'
  local _SYSTEM="$(uname -s)-$(uname -m)"
  local _URL="https://github.com/docker/compose/releases/download/${_VERSION}/docker-compose-${_SYSTEM}"
  local _COMPOSE='/usr/local/bin/docker-compose'
  sudo curl -L ${_URL} -o ${_COMPOSE}
  sudo chmod +x ${_COMPOSE}
  docker-compose --version
}

_go() {
  local _VERSION='1.14.1'
  local _ZIPFILE="/usr/local/src/go${_VERSION}.linux-amd64.tar.gz"

  if [ ! -f ${_ZIPFILE} ]; then
    sudo curl -L https://dl.google.com/go/go${_VERSION}.linux-amd64.tar.gz \
      -o ${_ZIPFILE}
  fi

  if [ ! -d /usr/local/go ]; then
    sudo tar -zxvf ${_ZIPFILE} -C /usr/local
    cd -
  fi

}

_home() {
  # MOC Music Player Config
  mkdir ~/.moc
  echo 'Theme = transparent-background' >> ~/.moc/config
  # Profile
  cat dotfiles/profile > ~/.profile
  # Vim config
  cat dotfiles/vimrc > ~/.vimrc
  # inputrc file for bash navigation
  cat dotfiles/inputrc > ~/.inputrc
  # bin executables folder
  mkdir ~/bin
  cp -r bin ~/
  chmod u+x ~/bin/*
  # git configuration
  cat dotfiles/gitconfig > ~/.gitconfig
}

_kubectl() {
  sudo apt-get update && sudo apt-get install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
  # Autocompletion
  kubectl completion bash >/etc/bash_completion.d/kubectl
}

_nodejs() {
  local _VERSION='12'
  local _URL="https://deb.nodesource.com/setup_${_VERSION}.x"
  curl -sL ${_URL} | sudo -E bash -
  sudo apt-get install -y nodejs
}

_pathogen() {
  if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  fi
}

_vundle() {
  if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
  fi
}

_python() {
  local _VERSION='3.8.2'

  sudo apt install build-essential libbz2-dev libsqlite3-dev libreadline-dev \
    zlib1g-dev libncurses5-dev libssl-dev libgdbm-dev libffi-dev -y

  if [ ! -f /usr/local/src/Python-${_VERSION}.tar.xz ]; then
    sudo curl -L https://www.python.org/ftp/python/${_VERSION}/Python-${_VERSION}.tar.xz \
      -o /usr/local/src/Python-${_VERSION}.tar.xz
  fi

  if [ ! -d /usr/local/src/Python-${_VERSION} ]; then
    cd /usr/local/src
    sudo tar xvf Python-${_VERSION}.tar.xz
    cd -
  fi

  if [ -d /usr/local/src/Python-${_VERSION} ]; then
    cd /usr/local/src/Python-${_VERSION}
    sudo ./configure
    sudo make
    sudo make install
    cd -
  fi
}

_terminator-themes() {
  sudo apt install python-requests python-certifi -y
  mkdir -p $HOME/.config/terminator/plugins
  # For terminator >= 1.9
  wget https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"
  # For terminator < 1.9
  # wget https://git.io/v5Zwz -O $HOME"/.config/terminator/plugins/terminator-themes.py"
  echo -e "\nCheck the TerminatorThemes option under terminator > preferences > plugins\n"
}

_vim-sensible() {
  if [ ! -d ~/.vim/bundle/vim-sensible ]; then
    git clone git://github.com/tpope/vim-sensible.git ~/.vim/bundle/vim-sensible
  fi
}

_vim-surround() {
  if [ ! -d ~/.vim/bundle/vim-surround ]; then
    git clone git://github.com/tpope/vim-surround.git ~/.vim/bundle/vim-surround
  fi
}

_youcompleteme() {
  if [ ! -d ~/.vim/bundle/YouCompleteMe ]; then
    sudo apt install vim-nox build-essential cmake python3-dev python-dev
    git clone --recursive https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
    sudo ~/.vim/bundle/YouCompleteMe/install.sh
  fi
}
_vim-plug() {
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

[ $# -ne 1 ] && _help || "_$@"

