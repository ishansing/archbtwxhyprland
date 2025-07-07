zoxide init fish | source
starship init fish | source
alias c='clear'
alias ll='ls -l'
alias la='ls -la'
alias vim="nvim"
alias y="yazi"
alias ls="eza --icons=always"
alias fe="fzf | xargs -r nvim"
alias fd="find . -type d | fzf | xargs -r z"
alias cd="z"
if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
end
