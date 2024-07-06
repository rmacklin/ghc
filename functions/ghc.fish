function ghc -d "manage git repos"
  if set -q GH_BASE_DIR
    set gh_base_dir $GH_BASE_DIR
  else
    set gh_base_dir $HOME/src
  end

  set git_host github.com
  set -l repo ""

  if [ (count $argv) -eq 1 ]
    set repo $argv[1]
  else if [ (count $argv) -eq 2 ]
    set repo $argv[1]/$argv[2]
  else
    echo "USAGE: ghc [user] [repo]" >&2
    return 1
  end

  set -l path $gh_base_dir/$git_host/$repo
  if not test -d $path
    git clone --recursive git@$git_host:$repo.git $path
  end

  cd $path
end
