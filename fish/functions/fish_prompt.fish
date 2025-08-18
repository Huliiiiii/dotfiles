function fish_prompt --description 'Informative prompt'
    set_color normal
    set_color green
    echo -n (string replace $HOME "~" $PWD)
    set_color red

    echo -n (fish_git_prompt)
    printf "\n"
    set_color normal
    echo -n "> "
end
