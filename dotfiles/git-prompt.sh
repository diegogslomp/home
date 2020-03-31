# Better PS1 for windows git bash
# ~/.config/git/git-prompt.sh
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
PS1="$PS1\[\033[90;1m\]\u\[\033[93;1m\]@\h:\[\033[92;1m\]\w"
if test -z "$WINELOADERNOEXEC"
then
	GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
	COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
	COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
	COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
	if test -f "$COMPLETION_PATH/git-prompt.sh"
	then
		. "$COMPLETION_PATH/git-completion.bash"
		. "$COMPLETION_PATH/git-prompt.sh"
		PS1="$PS1"'\[\033[91;1m\]' 
		PS1="$PS1"'`__git_ps1`'   # bash function
	fi
fi
PS1="$PS1\[\033[00m\] "
