# ==============================================================================
# Auth: Alex Celani
# File: .bash_profile
# Revn: 03-25-2020  0.4
# Func: Define user-made aliases and functions to make using the terminal easier
#
# TODO:  Fix alias to cd
# ==============================================================================
# CHANGE LOG
# ------------------------------------------------------------------------------
# ??-??-2018:  init
# 05-31-2019:  added header comment block
# 06-01-2019:  fixed newcd, added alias of cc to newcd
#              commented functions
#              removed mkcd
#              made hide, ssy, and SSY aliases instead of functions
# 06-21-2019:  finally wrote Func field in header
# 03-25-2020:  copied from .bashrc
#              removed school-based functions to go to directories that do not
#                 exist on boofnet
#
# ==============================================================================


# User specific aliases and functions
## Aliases

### Shows everything in detail, except . and ..
alias ll="ls -AGhl"
alias  l="ls -AGhl"

### Make cd work even if directory doesn't exist
alias cc="newcd"

### Used for login
alias s="ssh sacelani@colossus.it.mtu.edu"

### Reload source
alias src="source ~/.bash_profile"

### Move to desktop fast
alias desk="cd ~/Desktop"

### Move to desktop fast, verbose
alias DESK="CD ~/Desktop"

### Go home
alias home="cd ~"

### Go home, verbose
alias HOME="CD ~"

## Aliases


## Functions

### Change directory and show contents
CD() {
   cd $1    # Move
   clear    # Clear screen
   ll       # Print directory
}

### If cd fails, make the new directory and cd in
newcd() {
   oldD=$(pwd)                   # Snag the current directory
   cd $1 >/dev/null 2>/dev/null  # cd, direct error output to null
   newD=$(pwd)                   # Snag current directory again

   if [ $oldD == $newD ]; then   # If new is same as old, didn't move
      mkdir $1                   # Make the new directory
      cd $1                      # cd in
   fi
}

### Jump to grad school directory, user specified semester if possible
grad() {
   cd ~/Desktop/grad                # Jump to grad directory
   if [ "$#" -eq 1 ]; then          # See if user entered a semester argument
      cd "semester-$1" >/dev/null 2>/dev/null  # Go to semester, or error silently
   fi
}

## Functions

# Source global definitions
if [ -f /etc/bashrc ]; then
   . /etc/bashrc
fi
