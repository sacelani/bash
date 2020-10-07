# ==============================================================================
# Auth: Alex Celani
# File: .bash_profile
# Revn: 10-07-2020  1.8
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
# 05-11-2020:  added control structure to detect architecure and make decisions
#                 about directories for grad() and src()
# 09-29-2020:  wrote gitMake()
#              renamed newcd() to mkcd()
# 10-07-2020:  fixed src() and grad() not working on colossus by changing call
#                 to arch from "arch" to "$(arch)"
#              added call to src() at the beginning of the file
#
# ==============================================================================


# User specific aliases and functions
## Aliases

### Shows everything in detail, except . and ..
alias ll="ls -AGhl"
alias  l="ls -AGhl"

### Used for login
alias s="ssh sacelani@colossus.it.mtu.edu"

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

### Detect architecture and load correct source file
src() {
   if [ arch == "x86_64" ]; then    # Check to see if using colossus
      source ~/.bashrc              # Reload colossus bash profile
   else                             # If not colossus, boofnet
      source ~/.bash_profile        # Reload boofnet bash profile
   fi
}


### Change directory and show contents
CD() {
   cd $1    # Move
   clear    # Clear screen
   ll       # Print directory
}

### If cd fails, make the new directory and cd in
mkcd() {
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
   if [ arch == "x86_64" ]; then    # Check to see using colossus
      cd ~/Desktop/grad/            # Jump to grad directory, colossus
   else                             # If not colossus, boofnet
      cd ~/Documents/everything     # Jump to grad directory, boofnet
   fi

   if [ "$#" -eq 1 ]; then          # See if user entered a semester argument
      cd "semester-$1" >/dev/null 2>/dev/null  # Go to semester, error silently
   fi
}

### Take new repository and connect it to a Github repository
gitMake() {
    if [ "$#" -eq 1 ]; then
        # These three lines were given by github.com
        git remote add origin https://github.com/sacelani/$1.git
        git branch -M master
        git push -u origin master
    else                # If the user doesn't give a name for the repo
        echo -e "Usage:: gitMake REPO"          # Print usage
        echo -e "\tConnect local repo REPO to Github repo"
    fi
}

## Functions

# Source global definitions
if [ -f /etc/bashrc ]; then
   . /etc/bashrc
fi
