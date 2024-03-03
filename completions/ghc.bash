# Add this to your .bashrc
_complete_ghc ()
{
        local gh_base_dir=${GH_BASE_DIR:-$HOME/src}
        COMPREPLY=()
        if [[ $COMP_CWORD -eq 1 ]]; then
          comp_arr=$(ls $gh_base_dir/github.com;\
            ls $gh_base_dir/github.com/$GITHUB)
        elif [[ $COMP_CWORD -eq 2 ]]; then
          local user=${COMP_WORDS[COMP_CWORD-1]}
          comp_arr=$(ls $gh_base_dir/github.com/$user)
        else
          return 0
        fi
        cur="${COMP_WORDS[COMP_CWORD]}"
        COMPREPLY=( $(compgen -W "${comp_arr}" -- $cur))
        return 0
}
complete -F _complete_ghc ghc
