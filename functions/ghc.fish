function ghc -d "manage git repos"
  if set -q GH_BASE_DIR
    set gh_base_dir $GH_BASE_DIR
  else
    set gh_base_dir $HOME/src
  end

  set git_host github.com

  if [ (count $argv) -eq 1 ]
    set -l parts (string split / $argv[1])
    set user $parts[1]
    set repo $parts[2]
  else if [ (count $argv) -eq 2 ]
    set user $argv[1]
    set repo $argv[2]
  else
    echo "USAGE: ghc [user] [repo]" >&2
    return 1
  end

  set -l user_path $gh_base_dir/$git_host/$user
  if test -d $user_path
    set user_path_already_existed true
  else
    set user_path_already_existed false
  end

  set -l path $user_path/$repo
  if not test -d $path
    git clone --recursive git@$git_host:$user/$repo.git $path
  end

  # If git exited uncleanly, clean up the created user directory (if it exists)
  # and don't try to `cd` into it.

  set -l git_exit_code $status
  if test $git_exit_code -ne 0
    if test -d $user_path
      rm -d $user_path/$repo
      if not $user_path_already_existed
        rm -d $user_path
      end
    end
    return $git_exit_code
  else
    cd $path
  end
end
