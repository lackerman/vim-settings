# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# 256 colors
dgb='\[\e[48;5;239m\]'      # Dark Grey bg
dgf='\[\e[38;5;239m\]'      # Dark Grey fg
lbf='\[\e[38;5;32m\]'       # Light blue fg

# Normal colours

bfg_wbg='\[\e[1;34;107m\]'  # blue fg, white bg
wfg='\[\e[97m\]'            # white fg
gfg='\[\e[92m\]'            # green fg
rfg='\[\e[91m\]'            # red fg
rbg='\[\e[41m\]'            # red bg

dg_w='\[\e[90;107m\]'       # dark grey fg, white bg
r_w='\[\e[31;107m\]'        # red fg, white bg
lg_dg='\[\e[37;100m\]'      # light grey, dark grey bg
r_dg='\[\e[31;100m\]'       # red fg, dark grey bg

end='\[\e[0m\]'             # stop formatting

function context {
    echo "$bfg_wbg ⎈ \$(kctx) ⎈ $end${wfg}$end"
}
function pointer {
    echo "${gfg}➜$end"
}
function cdir {
    echo "${gfg}\w$end"
}
function chost {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        echo "${rbg}☞  \h ☜ ${end}${r_w}${end}"
    else
        echo "${lg_dg} \h ${end}${dg_w}${end}"
    fi
}
function cuser {
    echo "${lg_dg} \u${end}"
}
function parse_git_dirty {
	[[ "$(git status 2> /dev/null)" =~ working\ tree\ clean ]] || echo " ✘"
}
function cbranch {
	if [[ -d .git ]]; then
    	branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
		echo "($branch$(parse_git_dirty))"
	else
		echo ""
	fi
}
function ctelepresence {
    if [ -n "$TELEPRESENCE_ROOT" ]; then
        echo "${rbg}☞ TELEPRESENCE ☜ ${end}${r_dg}${end}"
    else
        echo ""
    fi
}
# Simple PS1:
# export PS1="$(pointer) \$ "
export PS1="$(ctelepresence)$(chost)$(context)\n$(cdir) \$(cbranch) $(pointer) \$ "
