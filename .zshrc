# ~/.zshrc
# Original:
# $Id: zshrc 144 2012-04-19 23:01:12Z gnitset $
#source ~/.zshrc_lib

setopt NO_CLOBBER
setopt NO_PROMPT_CR
setopt NO_BEEP
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt EXTENDED_GLOB
setopt AUTOCD
setopt INTERACTIVE_COMMENTS
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' special-dirs true

autoload -U compinit
compinit -d ~/.zcompdump.`hostname`

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^r' history-incremental-search-backward
bindkey '^y' yank
bindkey '^t' delete-word
bindkey '^x' copy-prev-shell-word
bindkey '^z' vi-undo-change
bindkey "\e[A" history-search-backward            # up
bindkey "\e[B" history-search-forward             # down
bindkey "\e[C" vi-forward-char                    # right
bindkey "\e[D" vi-backward-char                   # left
bindkey "\e[1~" shell-backward-word               # home
bindkey "\e[2~" quoted-insert                     # insert
bindkey "\e[3~" delete-char                       # delete
bindkey "\e[4~" shell-forward-word                # end
bindkey "\e[5~" history-beginning-search-backward # pgup
bindkey "\e[6~" history-beginning-search-forward  # pgdn
#bindkey "\e[7~" beginning-of-line
#bindkey "\e[8~" end-of-line
#bindkey "\e[H" beginning-of-line
#bindkey "\e[F" end-of-line
#bindkey "\eOH" beginning-of-line
#bindkey "\eOF" end-of-line
#bindkey "\eOd" backward-word
#bindkey "\eOc" forward-word

alias py=python
alias find='noglob find'

update-configs() {
	emulate -L zsh

   git clone https://github.com/Ankmeister/configs.git /tmp/tmpconfigs && echo "Cloned source successfully"
   rsync -a /tmp/tmpconfigs/.[^.(git)]* ~ && echo "Synced successfully"
   rm -rf /tmp/tmpconfigs && echo "Removed temporary source successfully"

	zcompile ~/.zprofile 2> /dev/null
	zcompile ~/.zshrc 2> /dev/null
	zcompile ~/.zprofile.local 2> /dev/null
	zcompile ~/.zshrc.local 2> /dev/null
}

precmd() {
	if [ "$TERM" != "linux" ]; then
		echo -ne "\033]0;${USER}@${HOST}: ${PWD}\007"
	fi
}

shell-backward-word() {
	emulate -L zsh
	local words word spaces
	words=(${(z)LBUFFER})
	word=$words[-1]
	spaces=-1
	while [[ $LBUFFER[$spaces] == " " ]]; do
			(( spaces-- ))
	done
	(( CURSOR -= $#word - $spaces - 1 ))
}
shell-forward-word() {
	emulate -L zsh
	local words word spaces
	words=(${(z)RBUFFER})
	word=$words[1]
	spaces=1
	while [[ $RBUFFER[$spaces] == " " ]]; do
		(( spaces++ ))
	done
	(( CURSOR += $#word + $spaces - 1 ))
}
shell-backward-kill-word() {
	emulate -L zsh
	local words word spaces
	words=(${(z)LBUFFER})
	word=$words[-1]
	if [[ -n ${word[2,-2]//[^\/]} ]]; then
		word=${word##*/?}o
	fi
	spaces=-1
	while [[ $LBUFFER[$spaces] == " " ]]; do
			(( spaces-- ))
	done
	#killring=("$CUTBUFFER" "${(@)killring[1,-2]}")
	#CUTBUFFER=$LBUFFER[$((-$#word + $spaces + 1)),-1]
	LBUFFER=$LBUFFER[0,$((-$#word + $spaces))]
}
zle -N shell-backward-word
zle -N shell-forward-word
zle -N shell-backward-kill-word
bindkey '^w' shell-backward-kill-word
bindkey '\e[5D' shell-backward-word
bindkey '\e[5C' shell-forward-word

if [ "$HAVE_RUN_ZPROFILE" != "Y" ]; then
  . ~/.zprofile
fi
if [[ -f ~/.zshrc.local ]]; then
  . ~/.zshrc.local
fi

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias se='setxkbmap se'
alias dv='setxkbmap dvorak se'
