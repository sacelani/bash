# ==============================================================================
# Auth: Sam Celani
# File: .bashrc
# Revn: 05-11-2020  1.5
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
# 05-11-2020:  added control structure to detect architecture and make decisions
#                 about directoriesfor grad() and src()
#
# ==============================================================================

src

# User specific aliases and functions
## Aliases

### Shows everything in detail, except . and ..
alias ll="ls -Ahl"
alias  l="ls -Ahl"

### Make cd work even if directory doesn't exist
alias cc="newcd"

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

### Move to fifth year folder
alias ssy="cd ~/Desktop/ssy"

### Move to fifth year folder, verbose
alias SSY="CD ~/Desktop/ssy"

### Open .pdf's in Adobe from terminal
alias acro="/c/Program\ Files\ \(x86\)/Adobe/Acrobat\ DC/Acrobat/Acrobat.exe $1"

## Aliases


## Functions

### 
src() {
   if [ arch == "i834" ]; then   # Check to see if using boofnet
      source ~/.bash_profile     # Reload boofnet bash profile
   else                          # If not boofnet, colossus
      source ~/.bashrc           # Reload colossus bash profile
   fi
}
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
   if [ arch == "i834" ]; then      # Check to see if using boofnet
       cd ~/Documents/everything    # Jump to grad directory
   else                             # If not boofnet, colossus
       cd ~/Desktop/grad            # Jump to grad directory
   fi

   if [ "$#" -eq 1 ]; then          # See if user entered a semester argument
      cd "semester-$1" >/dev/null 2>/dev/null  # Go to semester, or error silently
   fi
}



### Go directly to HwSw Lab folder
### I don't think any of these are necessary anymore, but I'll leave them
hsi() {
   cd ~/Desktop/ssy/ee3173/lab      # Move to lab folder for hw/sw
   if [ -f $1/prelab ]; then        # If there is a folder for that prelab...
      cd $1/prelab                  # Go there
   fi                               # But cd works even if it's not there...
}

### Go directly to HwSw Lab folder,
### and show contents
HSI() {
   cd ~/Desktop/ssy/ee3173/lab      # Move to lab folder for hw/sw
   if [ -f $1/prelab ]; then        # If there is a folder for that prelab...
      CD $1/prelab                  # Go there, verbose
   else                             # If it doesn't exist...
      ll                            # Just be verbose in pwd
   fi                               # But cd works even if it's not there...
}

### Go directly to Systems homework folder
sys() {
   cd ~/Desktop/ssy/cs3411/homework # Move to homework folder for systems
   if [ -f $1 ]; then               # If there is a folder for that program
      cd $1                         # Go there
   fi                               # But cd works even if it's not there...
}


### Go directly to Systems homework folder,
### and show contents
SYS() {
   cd ~/Desktop/ssy/cs3411/homework # Move to homework folder for systems
   if [ -f $1 ]; then               # If there is a folder for that program
      CD $1                         # Go there, verbose
   else                             # If it doesn't exist...
      ll                            # Just be verbose is pwd
   fi                               # But cd works even if it's not there...
}


### Go directly to Networks programs folder
nw() {
   cd ~/Desktop/ssy/cs4461/         # Move to networks folder
   if [ -e programs/$1 ]; then      # If there exists a folder for that program
      cd programs/$1                # Go there
   fi                               # But cd works even if it's not there...
}


### Go directly to Networks programs folder,
### and show contents
NW() {
   cd ~/Desktop/ssy/cs4461/         # Move to networks folder
   if [ -e programs/$1 ]; then      # If there exists a folder for that program
      CD programs/$1                # Go there, verbose
   else                             # If it doesn't exist...
      ll                            # Just be verbose in pwd
   fi                               # But cd works even if it's not there...
}


### Go directly to Embedded lab folder
esi() {
   cd ~/Desktop/ssy/ee4737/lab      # Move to ESI lab folder
   if [ -e $1 ]; then               # If a folder for that lab exists
      cd $1                         # Go there
   fi                               # But cd works even if it's not there...
}


### Go directly to Embedded lab folder
### and show contents
ESI() {
   cd ~/Desktop/ssy/ee4737/lab      # Move to ESI lab folder
   if [ -e $1 ]; then               # If a folder for that lab exists
      CD $1                         # Go there, verbose
   else                             # If it doesn't exist...
      ll                            # Just be verbose in pwd
   fi                               # But cd works even if it's not there...
}


### Go directly to Architecture homework folder
arc() {
   cd ~/Desktop/ssy/EE4173/Homework # Move to architecture homework folder
   if [ -e $1 ]; then               # If there's a folder for that assignment
      cd $1                         # Go there
   fi                               # But cd works even if it's not there...
}


### Go directly to Architecture homework folder
### and show contents
ARC() {
   arc $1                           # Literally just pass to architecture func
   ll                               # Just be verbose in pwd
                                    # This is so much easier, I'm retarded
}

## Functions

# Source global definitions
if [ -f /etc/bashrc ]; then
   . /etc/bashrc
fi
