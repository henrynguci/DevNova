#!/bin/bash

alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias ld='lazydocker'
alias lg='lazygit'

dnuke() {
    echo "WARNING: This will remove ALL Docker containers, images, volumes, and networks!"
    read -p "Are you sure? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        docker stop $(docker ps -aq) 2>/dev/null
        docker rm $(docker ps -aq) 2>/dev/null
        docker rmi $(docker images -q) 2>/dev/null
        docker volume rm $(docker volume ls -q) 2>/dev/null
        docker network prune -f
        docker system prune -af --volumes
        echo "Docker completely cleaned!"
    else
        echo "Cancelled."
    fi
}

alias cls='clear'
alias c='clear'
alias update='sudo apt update && sudo apt upgrade'
alias upgrade='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias search='apt search'
alias autoremove='sudo apt autoremove'
alias autoclean='sudo apt autoclean'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'
alias md='mkdir -p'
alias rd='rmdir'

if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
    alias less='bat'
    alias more='bat'
elif command -v batcat >/dev/null 2>&1; then
    alias cat='batcat'
    alias less='batcat'
    alias more='batcat'
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias myps='ps -f -u $USER'
alias cpu='top -o cpu'
alias mem='top -o rsize'
alias kill9='kill -9'
alias jobs='jobs -l'

alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias ports='netstat -tulanp'
alias listening='lsof -i -P | grep LISTEN'
alias myip='curl -s checkip.dyndns.org | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"'
alias localip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}'"

alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'
alias dprune='docker system prune -a'
alias dclean='docker system prune -af --volumes'

alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'
alias kex='kubectl exec -it'
alias klog='kubectl logs'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kctx='kubectl config current-context'
alias kns='kubectl config set-context --current --namespace'

alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gl='git log --oneline'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gm='git merge'
alias gd='git diff'
alias gf='git fetch'
alias gr='git reset'
alias grh='git reset --hard'
alias gst='git stash'
alias gstp='git stash pop'

gfeat()   { git commit -m "feat: $*"; }
gfix()    { git commit -m "fix: $*"; }
gref()    { git commit -m "refactor: $*"; }
gperf()   { git commit -m "perf: $*"; }
gstyle()  { git commit -m "style: $*"; }
gtest()   { git commit -m "test: $*"; }
gdocs()   { git commit -m "docs: $*"; }
gbuild()  { git commit -m "build: $*"; }
gci()     { git commit -m "ci: $*"; }
gchore()  { git commit -m "chore: $*"; }
grevert() { git commit -m "revert: $*"; }

gafeat()   { git add . && git commit -m "feat: $*"; }
gafix()    { git add . && git commit -m "fix: $*"; }
garef()    { git add . && git commit -m "refactor: $*"; }
gaperf()   { git add . && git commit -m "perf: $*"; }
gastyle()  { git add . && git commit -m "style: $*"; }
gatest()   { git add . && git commit -m "test: $*"; }
gadocs()   { git add . && git commit -m "docs: $*"; }
gabuild()  { git add . && git commit -m "build: $*"; }
gaci()     { git add . && git commit -m "ci: $*"; }
gachore()  { git add . && git commit -m "chore: $*"; }

alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tff='terraform fmt'
alias tfw='terraform workspace'
alias tfs='terraform show'

alias ans='ansible'
alias ap='ansible-playbook'
alias av='ansible-vault'
alias ag='ansible-galaxy'

alias ni='npm install'
alias nis='npm install --save'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nu='npm uninstall'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nls='npm list'
alias nlsg='npm list -g --depth=0'
alias y='yarn'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn remove'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'

alias df='df -H'
alias du='du -ch'
alias free='free -m'
alias pscpu='ps auxf | sort -nr -k 3'
alias psmem='ps auxf | sort -nr -k 4'

alias tarc='tar -czf'
alias tarx='tar -xzf'
alias untar='tar -xzf'
alias zip='zip -r'

alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime='now'
alias nowdate='date +"%d-%m-%Y"'
alias week='date +%V'

if command -v fzf >/dev/null 2>&1; then
    alias ff='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
    alias fh='history | fzf'
    alias fp='ps aux | fzf'
    alias fk='ps aux | fzf | awk "{print \$2}" | xargs kill'
    alias fd='find . -type d | fzf'
    alias fcd='cd $(find . -type d | fzf)'
    alias fe='nvim $(fzf)'
    alias fgb='git branch | fzf | xargs git checkout'
fi

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

qcommit() {
    git add .
    git commit -m "$*"
    git push
}

backup() {
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
}

duh() {
    du -h --max-depth=1 | sort -hr
}

clip() {
    if [ -z "$1" ]; then
        echo "Usage: clip <file>"
        return 1
    fi
    if [ ! -f "$1" ]; then
        echo "File not found: $1"
        return 1
    fi
    if command -v xclip >/dev/null 2>&1; then
        cat "$1" | xclip -selection clipboard
    elif command -v xsel >/dev/null 2>&1; then
        cat "$1" | xsel --clipboard --input
    else
        echo "Install xclip or xsel: sudo apt install xclip"
        return 1
    fi
    echo "Copied: $1"
}
