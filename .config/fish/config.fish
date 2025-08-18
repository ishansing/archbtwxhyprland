zoxide init fish | source
starship init fish | source
fzf --fish | source

# Aliases

alias c='clear'
alias ll='ls -l'
alias la='ls -la'
alias vim="nvim"
alias y="yazi"
alias ls="eza --icons=always"
alias cd="z"
alias ytmd="yt-dlp -x --audio-format flac --embed-thumbnail --add-metadata --yes-playlist"

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
end

# Scripts

function zf
    set dir (zoxide query -l | fzf --height 40% --layout reverse --border --query "$argv")
    if test -n "$dir"
        cd "$dir"
    end
end
function vf
    set file (find ~ -type f | fzf --height 40% --layout reverse --border --query "$argv" --preview 'bat --color=always {} 2>/dev/null')
    if test -n "$file"
        vim "$file"
    end
end
function vfg
    set repo (zoxide query -l | fzf --height 40% --layout reverse --border --query "$argv" --preview 'git -C {} status 2>/dev/null || echo "Not a git repository"')
    if test -n "$repo"
        cd "$repo"
        vim .
    end
end
function zt
    set dir (zoxide query -l | fzf --height 40% --layout reverse --border --query "$argv")
    if test -n "$dir"
        cd "$dir"
        # Replace with your terminal command, e.g., `itermocil` or `gnome-terminal`
        ghostty --directory "$dir" &
    end
end
function hf
    set cmd (history | fzf --height 40% --layout reverse --border --query "$argv")
    if test -n "$cmd"
        eval "$cmd"
    end
end
# function rgf
#     set dir (zoxide query -l | fzf --height 40% --layout reverse --border --query "$argv")
#     if test -n "$dir"
#         set pattern (read -P "Enter search pattern: ")
#         rg --color=always --line-number "$pattern" "$dir"
#     end
# end
function rgf
    # Check if ripgrep is installed
    if not command -v rg >/dev/null
        echo "Error: ripgrep (rg) is not installed. Install it or use the grep alternative."
        return 1
    end

    # Select a directory with zoxide and fzf
    set dir (zoxide query -l | fzf --height 40% --layout reverse --border --query "$argv" --preview 'tree -C {} | head -20 2>/dev/null || ls -l {}')
    if test -z "$dir"
        echo "No directory selected."
        return 1
    end

    # Prompt for search pattern
    echo -n "Enter search pattern: "
    read pattern
    if test -z "$pattern"
        echo "No search pattern provided."
        return 1
    end

    # Run ripgrep in the selected directory
    rg --color=always --line-number "$pattern" "$dir" 2>/dev/null || echo "No matches found or error occurred."
end
function pf
    set dir (zoxide query -l | fzf --height 40% --layout reverse --border --query "$argv")
    if test -n "$dir"
        set file (fd --type f . "$dir" | fzf --height 40% --layout reverse --border --preview 'bat --color=always {} 2>/dev/null || cat {}')
        if test -n "$file"
            vim "$file"
        end
    end
end
function sf
    set script (zoxide query -l | fzf --height 40% --layout reverse --border --query "$argv" --preview 'bat --color=always {} 2>/dev/null || cat {}')
    if test -n "$script"
        if string match -q "*.sh" "$script"
            bash "$script"
        else if string match -q "*.py" "$script"
            python "$script"
        else
            echo "Unsupported script type. Please run manually."
        end
    end
end
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
        cd "$cwd"
    end
    rm -f -- "$tmp"
end
# Colors

set -Ux FZF_DEFAULT_OPTS "
	--color=fg:#908caa,bg:#010102,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#010102
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

set -gx EDITOR nvim

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
