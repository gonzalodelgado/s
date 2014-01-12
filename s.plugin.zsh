s ()    # Starts or restores named screens
{
    if [ -n "$1" ]; then
        VIRTUALENV=$1
        if [[ -n $(screen -ls|egrep "^\s+[1-9]+\.$VIRTUALENV") ]]; then
            screen -r $VIRTUALENV
        else
            shift   # Drops $1 from args
            screen -S $VIRTUALENV -t $VIRTUALENV -U ${@}
        fi
    else
        screen ${@}
    fi
}

virtualenvwrapper='virtualenvwrapper_lazy.sh'
if (( $+commands[$virtualenvwrapper] )); then
  source ${${virtualenvwrapper}:c}

    # If inside a screen, and the screen name matches a virtualenv, switch to it
    if [ -n "$STY" ]; then 
        SESSION_NAME=$(echo $STY | cut -f 2 -d ".")
        # FIXME: This breaks if virtualenvwrapper isn't loaded yet
        if [ $(workon | grep "$SESSION_NAME") ]; then
            workon $SESSION_NAME
        fi
    fi
else
  print "zsh virtualenvwrapper plugin: Cannot find ${virtualenvwrapper}. Please install with \`pip install virtualenvwrapper\`."
fi
