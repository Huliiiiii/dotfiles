function git_clone_worktree
    command git clone --bare $argv[1] .bare
    echo "gitdir: ./.bare" >.git
    command git --git-dir=.bare config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
end
