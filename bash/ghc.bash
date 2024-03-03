function ghc() {
  local gh_base_dir=${GH_BASE_DIR:-$HOME/src}
  local gh_protocol=${GH_PROTO:-"ssh"}

  if [[ $# -ne 2 ]]; then
    echo "USAGE: ghc [user] [repo]" >&2
    return 1
  fi

  local user=$1
  local repo=$2

  local user_path=$gh_base_dir/github.com/$user
  local local_path=$user_path/$repo/$repo
  test -d $user_path && local user_path_already_existed=true

  if [[ ! -d $local_path ]]; then
     if [[ $gh_protocol == "ssh" ]]; then
      git clone --recursive git@github.com:$user/$repo.git $local_path
     elif [[ $gh_protocol == "https" ]]; then
      git clone --recursive https://github.com/$user/$repo.git $local_path
     else
      echo "GH_PROTO must be set to ssh or https" >&2
      return 1
    fi
  fi

  # If git exited uncleanly, clean up the created user directory (if exists)
  # and don't try to `cd` into it.

  local git_exit_code=$?
  if [[ $git_exit_code -ne 0 ]]; then
    if [[ -d $user_path ]]; then
      rm -d $user_path/$repo
      if [[ -z $user_path_already_existed ]]; then
        rm -d $user_path
      fi
    fi
    return $git_exit_code
  else
    cd $local_path
  fi
}
