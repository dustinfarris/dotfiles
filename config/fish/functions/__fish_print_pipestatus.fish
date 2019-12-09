# Copied from https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_print_pipestatus.fish
# because this is not included with current fish share files (still waiting on fish 3.1.0 release which does have this)
function __fish_print_pipestatus --description "Print pipestatus for prompt"
    set -l left_brace $argv[1]
    set -l right_brace $argv[2]
    set -l separator $argv[3]
    set -l brace_sep_color $argv[4]
    set -l status_color $argv[5]
    set -e argv[1 2 3 4 5]

    # only output $pipestatus if there was a pipe and any part of it had non-zero exit status
    if set -q argv[2] && string match -qvr '^0$' $argv
        set -l sep (set_color normal){$brace_sep_color}{$separator}(set_color normal){$status_color}
        set -l last_pipestatus_string (string join "$sep" (__fish_pipestatus_with_signal $argv))
        printf "%s%s%s%s%s%s%s%s%s%s" (set_color normal )$brace_sep_color $left_brace \
            (set_color normal) $status_color $last_pipestatus_string (set_color normal) \
            $brace_sep_color $right_brace (set_color normal)
    end
end
