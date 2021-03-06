# http://lua.org
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](lua) %{
    set-option buffer filetype lua
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

remove-highlighter shared/lua

add-highlighter shared/lua regions
add-highlighter shared/lua/code default-region group
add-highlighter shared/lua/double_string region '"'   (?<!\\)(?:\\\\)*" fill string
add-highlighter shared/lua/single_string region "'"   (?<!\\)(?:\\\\)*' fill string
add-highlighter shared/lua/comment       region '--'  $                 fill comment
add-highlighter shared/lua/raw_string  region -match-capture '\[(=*)\['   '\](=*)\]'       fill string
add-highlighter shared/lua/raw_comment region -match-capture '--\[(=*)\[' '\](=*)\]'       fill comment


add-highlighter shared/lua/code/ regex \b(false|nil|true)\b 0:value
add-highlighter shared/lua/code/ regex \b(and|or|not)\b 0:operator
add-highlighter shared/lua/code/ regex \b(break|do|else|elseif|end|for|function|goto|if|in|local|repeat|return|then|until|while)\b 0:keyword
add-highlighter shared/lua/code/ regex \b(assert|collectgarbage|dofile|getfenv|getmetatable|ipairs|load|loadfile|loadstring|next|pairs|pcall|print|rawequal|rawget|rawset|select|setfenv|setmetatable|tonumber|tostring|type|unpack|xpcall)\b 0:builtin
add-highlighter shared/lua/code/ regex function\s*(\w+)\( 1:function 
add-highlighter shared/lua/code/ regex function\s*(\w+):(\w+)\( 1:type 2:function 
add-highlighter shared/lua/code/ regex function\s*(\w+)\.(\w+)\( 1:module 2:function 
add-highlighter shared/lua/code/ regex \w+:(\w+)\( 1:function 

# Commands
# ‾‾‾‾‾‾‾‾

define-command lua-alternative-file -override -docstring 'Jump to the alternate file (implementation ↔ test)' %{ %sh{
    case $kak_buffile in
        *spec/*_spec.lua)
            altfile=$(eval printf %s\\n $(printf %s\\n $kak_buffile | sed s+spec/+'*'/+';'s/_spec//))
            [ ! -f $altfile ] && echo "echo -markup '{Error}implementation file not found'" && exit
        ;;
        *.lua)
            path=$kak_buffile
            dirs=$(while [ $path ]; do printf %s\\n $path; path=${path%/*}; done | tail -n +2)
            for dir in $dirs; do
                altdir=$dir/spec
                if [ -d $altdir ]; then
                    altfile=$altdir/$(realpath $kak_buffile --relative-to $dir | sed s+[^/]'*'/++';'s/.lua$/_spec.lua/)
                    break
                fi
            done
            [ ! -d $altdir ] && echo "echo -markup '{Error}spec/ not found'" && exit
        ;;
        *)
            echo "echo -markup '{Error}alternative file not found'" && exit
        ;;
    esac
    printf %s\\n "edit $altfile"
}}

define-command -hidden -override lua-indent-on-char %{
    evaluate-commands -no-hooks -draft -itersel %{
        # align middle and end structures to start and indent when necessary, elseif is already covered by else
        try %{ execute-keys -draft <a-x><a-k>^\h*(else)$<ret><a-\;><a-?>^\h*(if)<ret>s\A|\z<ret>)<a-&> }
        try %{ execute-keys -draft <a-x><a-k>^\h*(end)$<ret><a-\;><a-?>^\h*(for|function|if|while)<ret>s\A|\z<ret>)<a-&> }
    }
}

define-command -hidden -override lua-indent-on-new-line %{
    evaluate-commands -no-hooks -draft -itersel %{
        # preserve previous line indent
        try %{ execute-keys -draft <space>K<a-&> }
        # remove trailing white spaces from previous line
        try %{ execute-keys -draft k<a-x>s\h+$<ret>d }
        # indent after start structure
        try %{ execute-keys -draft k<a-x><a-k>^\h*(else|elseif|for|function|if|while)\b<ret>j<a-gt> }
    }
}

define-command -hidden -override lua-insert-on-new-line %[
    evaluate-commands -no-hooks -draft -itersel %[
        # copy -- comment prefix and following white spaces
        try %{ execute-keys -draft k<a-x>s^\h*\K--\h*<ret>yghjP }
        # wisely add end structure
        evaluate-commands -save-regs x %[
            try %{ execute-keys -draft k<a-x>s^\h+<ret>"xy } catch %{ reg x '' } # Save previous line indent in register x
            try %[ execute-keys -draft k<a-x> <a-k>^<c-r>x(for|function|if|while)<ret> J}iJ<a-x> <a-K>^<c-r>x(else|end|elseif)$<ret> # Validate previous line and that it is not closed yet
                   execute-keys -draft o<c-r>xend<esc> ] # auto insert end
        ]
    ]
]

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook -group lua-highlight global WinSetOption filetype=lua %{ add-highlighter window ref lua }

hook global WinSetOption filetype=lua %{
    hook window InsertChar .* -group lua-indent lua-indent-on-char
    hook window InsertChar \n -group lua-indent lua-indent-on-new-line
    hook window InsertChar \n -group lua-insert lua-insert-on-new-line

    lua-enable-autocomplete

    alias window alt lua-alternative-file
}

hook -group lua-highlight global WinSetOption filetype=(?!lua).* %{ remove-highlighter window/lua }

hook global WinSetOption filetype=(?!lua).* %{
    remove-hooks window lua-indent
    remove-hooks window lua-insert

    unalias window alt lua-alternative-file
}
