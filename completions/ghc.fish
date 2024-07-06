function __ghc_base_dir
  if set -q GH_BASE_DIR
    echo "$GH_BASE_DIR"
  else
    echo "$HOME/src"
  end
end

function __ghc_user_completion
  command ls -L $(__ghc_base_dir)/github.com
end

function __ghc_repo_completion
  set -l cmd (commandline -o)
  set -l user $cmd[2]
  command ls -L $(__ghc_base_dir)/github.com/$user
end

complete -c ghc -n '__fish_is_token_n 1' --arguments '(__ghc_user_completion)' --no-files
complete -c ghc -n '__fish_is_token_n 2' --arguments '(__ghc_repo_completion)' --no-files
