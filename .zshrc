eval "$(rbenv init -)" 
# zsh config file dir
export ZDOTDIR=${HOME}
export EDITOR=emacs
bindkey "^?" backward-delete-char

FORTUNE2CH=0

export LS_PATH='/bin/ls'

# 以下、広瀬レコメンドは小文字、そうでないのは大文字にしてある
setopt auto_cd 			# コマンドが省略されていたら cd とみなす
setopt AUTO_PUSHD		# cd 時にOldDir を自動的にスタックに積む
setopt correct			# コマンドのスペルチェック
setopt auto_name_dirs		# よく判らん
setopt auto_remove_slash	# 補完が/で終って、つぎが、語分割子か/かコマンド
				# の後(; とか & )だったら、補完末尾の/を取る
setopt extended_history 	# ヒストリに時刻情報もつける
setopt extended_glob		# グロブで、特殊文字"#,~,^"を使う、
setopt FUNCTION_ARGZERO 	#  $0 にスクリプト名/シェル関数名を格納

setopt hist_ignore_dups		# 前のコマンドと同じならヒストリに入れない
setopt hist_ignore_space	# 空白ではじまるコマンドをヒストリに保持しない
setopt HIST_IGNORE_ALL_DUPS	# 重複するヒストリを持たない
setopt HIST_NO_FUNCTIONS	# 関数定義をヒストリに入れない
setopt HIST_NO_STORE		# history コマンドをヒストリに入れない
setopt HIST_REDUCE_BLANKS	# 履歴から冗長な空白を除く
setopt MULTIOS			# 名前付きパイプ的に入出力を複数開ける
setopt NUMERIC_GLOB_SORT	# グロブの数のマッチを辞書式順じゃなくって数値の順
setopt prompt_subst		# プロンプト文字列で各種展開を行なう
setopt no_promptcr              # 改行コードで終らない出力もちゃんと出力する
setopt pushd_ignore_dups	# ディレクトリスタックに、同じディレクトリを入れない
#setopt rm_star_silent		# rm * とかするときにクエリしない
#setopt no_beep			# ZLE のエラーでビープしない
#setopt cdable_vars		# cd の引数のdir がないとき ~をつけてみる
setopt SHARE_HISTORY		# 複数プロセスで履歴を共有
setopt SHORT_LOOPS		# loop の短縮形を許す
setopt sh_word_split		# よく判らん
setopt RC_EXPAND_PARAM		# {}をbash ライクに展開
setopt TRANSIENT_RPROMPT 	# 右プロンプトに入力がきたら消す

# Ctrl-D でログアウトするのを抑制する。
setopt  ignore_eof

# グロブがマッチしないときエラーにしない
# http://d.hatena.ne.jp/amt/20060806/ZshNoGlob
setopt null_glob

# 小文字に対して大文字も補完する
# http://www.ex-machina.jp/zsh/index.cgi?FAQ%40zsh%A5%B9%A5%EC#l1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'



autoload -U colors  ; colors
#### スーパーユーザのプロンプトは赤にする
if [ $UID = 0 ] ; then 
    PSCOLOR='01;04;31'      # 太字;下線;赤
    USERNAME=root
else
    PSCOLOR='00;04;33'      # 細字;下線;緑
    USERNAME=%(!..%n)
fi
RPROMPT=$'%{\e[${PSCOLOR}m%}%F{white}[`rprompt-git-current-branch`%~]%f%{\e[00m%}' # 右プロンプト
# %#	%記号
# %m	マシン名
PROMPT=$'%{\e[${PSCOLOR}m%}${USERNAME}@${HOST} %#%{\e[m%} '

#### 個人用設定ファイルがあればそれを読み込む
if [ -e ~/DotFiles/.zshrc_private ]; then
    source ~/DotFiles/.zshrc_private
fi

if [ -e ~/DotFiles/.zshrc_alias ]; then
    source ~/DotFiles/.zshrc_alias
fi


# 前方予測する
# autoload predict-on
# predict-on


# lsを弄る
# http://nao.no-ip.info/index.cgi?.zsh_common
export LS_OPTIONS='-v --show-control-chars -h --color=auto'
# デフォルトから、拡張子ごとの設定を除いた物
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43'
export LS_COLORS=$LS_COLORS':tw=30;42:ow=34;42:st=37;44:ex=01;32'
# http://d.hatena.ne.jp/kujirahand/20070204/1170547240
export LS_COLORS=$LS_COLORS':no=00:fi=00:di=01;34;04:ln=01;36:ex=01;32'
# stickyビットのない、othersが書き込み可能なファイル
export LS_COLORS=$LS_COLORS':ow=31'
# アーカイブ系
export LS_COLORS=$LS_COLORS':*.tar=35:*.gz=35:*.bz2=35:*.zip=35:*.lha=35:*.z=35:*.Z=35:*.tgz=35'


# hisotry
# setopt share_history # 前のほうですでに設定してある。
HISTFILE=$HOME/.zsh-history           # 履歴をファイルに保存する
HISTSIZE=100000                       # メモリ内の履歴の数
SAVEHIST=100000                       # 保存される履歴の数
setopt extended_history               # 履歴ファイルに時刻を記録
function history-all { history -E 1 } # 全履歴の一覧を出力する


# urlエンコード
function url-encode { E=${${(j: :)@}//(#b)(?)/%$[[##16]##${match[1]}]} }
function url-decode { D=${1//\%(#b)([0-F][0-F])/\\\x$match[1]} }

function EUCL(){
    cat $1 EUC L
}
function SJISL(){
    cat $1 SJIS L
}

# 全プロセスから引数の文字列を含むものを grep する
function psg() {
    ps aux | head -n 1		 # ラベルを表示
    ps aux | 'grep' $* | 'grep' -v "ps -aux" | 'grep' -v 'grep' # grep プロセスを除外
}

# sub shell で sudo
function sudo-command(){
	sudo sh -c "$@"
}

# man を pdf で見る。
function man-pdf(){
	pdfPath=$TMPDIR/man.$1.pdf
	man -t $1 | ps2pdf - $pdfPath
	if [ -f /usr/bin/open ]; then
		/usr/bin/open $pdfPath
	else
		echo "PDF generated: $pdfPath"
	fi
}

# tar.bz2解凍
function untarbz2(){
	bzip2 -dc $1 | tar xvf -
}

# tar.gz解凍
function untargz(){
	tar -zxvf $1
}

# .diffをカレントディレクトリに適用
function diffApply(){
	patch -p0 -d . < $1
}


# 引数を数式として計算
# ex: calc '1. + sin(1)'
function calc () {
    echo $(($@))
}
# sin といった数学関数も使える
zmodload -i zsh/mathfunc



# Begin: .ssh/known_hosts による補完。
# known_hostsがハッシュ化されていると腐るので注意

make_p () {
    local t s
    t="$1"; shift

    [ -f $t ] || return 0

    for s; do
	[ $s -nt $t ] && return 0
    done

    return 1
}

cache_hosts_file="$ZDOTDIR/.cache_hosts"
known_hosts_file="$HOME/.ssh/known_hosts"

print_cache_hosts () {
    if [ -f $known_hosts_file ]; then
	awk '{ if (split($1, a, ",") > 1) for (i in a) { if (a[i] ~ /^[a-z]/) print a[i] } else print $1 }' $known_hosts_file
    fi
}

update_cache_hosts () {
    print_cache_hosts | sort -u > $cache_hosts_file
}

make_p $cache_hosts_file $known_hosts_file && update_cache_hosts

_cache_hosts=( $(< $cache_hosts_file) )

# End: .ssh/known_hosts による補完


autoload -U compinit
compinit

# Gem executable directory
which lsb_release >/dev/null 2>&1 && lsb_release -si | grep -E 'Ubuntu|Debian' >/dev/null 2>/dev/null && {
  export GEM_BIN=$(ruby -e 'require "rubygems"; puts Gem::bindir')
  export PATH=$GEM_BIN:$PATH
}

#export PATH=/Users/shinnosuke/bin:/opt/local/bin:/opt/local/sbin:/Users/shinnosuke/ruby:/Users/shinnosuke/.gem/ruby/1.8/bin:$PATH

export PATH=/sbin:$PATH

# Show branch name in right prompt
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null
function rprompt-git-current-branch {
    local name st color gitdir action
    if [[ "$PWD" =~ '/¥.git(/.*)?$' ]]; then
        return
    fi
    name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
    if [[ -z $name ]]; then
        return
    fi
    gitdir=`git rev-parse --git-dir 2> /dev/null`
    action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"
    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        color=%F{white}
    elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
        color=%F{blue}
    elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
        color=%B%F{red}
    else
        color=%F{red}
    fi
    echo "${color}(${name}${action})%f%b"
}
# For RDS
export JAVA_HOME=/Library/Java/Home
export AWS_RDS_HOME=$HOME/aws/RDSCli-1.8.002
export PATH=$AWS_RDS_HOME/bin:$PATH
export EC2_CERT=$HOME/aws/cert-42Y3SXC3CI326GRV3RTD4XK4DECAH6P2.pem
export EC2_PRIVATE_KEY=$HOME/aws/pk-42Y3SXC3CI326GRV3RTD4XK4DECAH6P2.pem
export EC2_URL=https://iettydbinstance.cytknjddip5r.us-east-1.rds.amazonaws.com
export EC2_REGION=us-east-1

export PATH=$PATH:/usr/local/Cellar/emacs/24.3/bin

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PHP_HOME=$HOME/local/php/versions

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
