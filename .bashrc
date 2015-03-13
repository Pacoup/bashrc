# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# SSH Agent Autostart and Autokill
case $- in
    *i*)
        SSH_ENV=$HOME/.ssh/environment

        function start_agent {
            echo "Initialising new SSH agent..."
            /usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
            echo succeeded
            chmod 600 ${SSH_ENV}
            . ${SSH_ENV} > /dev/null
            /usr/bin/ssh-add;
        }

        # Source SSH settings, if applicable
        if [ -f "${SSH_ENV}" ]; then
            . ${SSH_ENV} > /dev/null
            #ps ${SSH_AGENT_PID} doesn't work under cywgin
            ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
                start_agent;
            }
        else
            start_agent;
        fi

        # Set autokill trap
        trap 'test -n "$SSH_AGENT_PID" && eval `/usr/bin/ssh-agent -k`' 0
esac
