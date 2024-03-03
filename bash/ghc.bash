GH_BASE_DIR=${GH_BASE_DIR:-$HOME/src}
GH_PROTO=${GH_PROTO:-"ssh"}
function ghc() {
  if [[ $# -ne 2 ]]; then
    echo "USAGE: ghc [user] [repo]" >&2
    return 1
  fi

  user=$1
  repo=$2

  user_path=$GH_BASE_DIR/github.com/$user
  local_path=$user_path/$repo/$repo

  if [[ ! -d $local_path ]]; then
     if [[ $GH_PROTO == "ssh" ]]; then 
      git clone --recursive git@github.com:$user/$repo.git $local_path
     elif [[ $GH_PROTO == "https" ]]; then
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
      rm -d $user_path
    fi
    return $git_exit_code
  else
    cd $local_path
  fi
}
