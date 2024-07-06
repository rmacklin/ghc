if not set -q GH_BASE_DIR
    set GH_BASE_DIR $HOME/src
end

function ghc -d "manage git repos"
  set git_host github.com
  set -l repo ""

  if [ (count $argv) -eq 1 ]
    set repo $argv[1]
  else if [ (count $argv) -eq 2 ]
    set repo $argv[1]/$argv[2]
  else
    echo "USAGE: ghc [user] [repo]"
    return 1
  end

  set -l path $GH_BASE_DIR/$git_host/$repo
  if not test -d $path
    git clone --recursive git@$git_host:$repo.git $path
  end

  cd $path
end
