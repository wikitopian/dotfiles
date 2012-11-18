source-file ~/.tmux.shared

set -g status on

bind-key a send-prefix

# My VimWiki cheat sheet and scratch pad
new -s VIM -n CHEAT 'vim --servername ZERO ~/Dropbox/admin/cheat-sheet/index.md'
neww -n ONE 'vim --servername ONE'
neww -n TWO 'vim --servername TWO'
neww -n THREE 'vim --servername THREE'
neww -n FOUR 'vim --servername FOUR'
neww -n FIVE 'vim --servername FIVE'
neww -n SIX 'vim --servername SIX'
neww -n SEVEN 'vim --servername SEVEN'
neww -n EIGHT 'vim --servername EIGHT'
neww -n NINE 'vim --servername NINE'

selectw -t 1
