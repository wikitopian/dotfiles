#we know
startup_message off

maxwin 99

# more scrollbacks!
defscrollback 10000

# disable use of the "alternate" terminal
# thus allowing scrollbars to function as normal in
# many terminal emulators! <3 it
termcapinfo xterm* ti@:te@

# have screen update terminal emulators titlebar
termcapinfo xterm* 'hs:ts=\E]0;:fs=\007:ds=\E]0;\007'
defhstatus "screen ^E (^Et) | $USER@^EH"

# but dont print i.e. "bell in window 0" status craps
hardstatus off

#default shell title. for bash, place in .bashrc to update titles to current running program:
# export PS1='\[\033k\033\\\]\u@\h:\w\$ '
shelltitle "$ |ash"

# turn off XON/XOFF, wow. seriously. whys it default, ick.
defflow off

caption always "Vim: %?%{ Wk}%-Lw%?%{Rk}%n*%f %t%?(%u)%?%?%{Wk}%+Lw%? %{Rk}%=%c %{rk}%d/%M/%Y"
"hardstatus string "%{+b Rk}(%{-b g}$LOGNAME@%H%{+b R}) (%{-b g}%C %a%{+b R}) %{-b g} %n %t %h"

nonblock on

screen -t "cheat" 0 /usr/bin/vim --servername CHEAT -s ~/Dropbox/admin/dotfiles/vimwiki.vim
screen -t "one" 1 /usr/bin/vim --servername ONE
screen -t "two" 2 /usr/bin/vim --servername TWO
screen -t "three" 3 /usr/bin/vim --servername THREE
screen -t "four" 4 /usr/bin/vim --servername FOUR
screen -t "five" 5 /usr/bin/vim --servername FIVE
screen -t "six" 6 /usr/bin/vim --servername SIX
screen -t "seven" 7 /usr/bin/vim --servername SEVEN
screen -t "eight" 8 /usr/bin/vim --servername EIGHT
screen -t "nine" 9 /usr/bin/vim --servername NINE


select 0
