#!/bin/bash
set -eu
function usage() {
cat <<EOF
使い方: markdown-tree [-h|--help] [-L|-l|--level 階層] [Markdownファイル]

  説明:Markdownファイル(.md)の見出しをツリー状に変換して出力するコマンド
  引数:
    [Markdownファイル]  : 見出しをツリーで出力したいMarkdownファイルを引数に渡す

  オプション:
    -h|--help)         ヘルプを表示
    -L|-l|--level)     指定した階層を表示(デフォルトは「6」)

EOF
}
print_depth=6
while [ -n "${1:-}" ]; do
    case "$1" in
      -h|--help) usage; exit 0;;
      -L|-l|--level) print_depth=$2 ;;
      -*) echo -e 'エラー : 不正なオプションです。「-h」を使用してください。'; exit 1;;
      [0-9]) ;;
      *) filename="$1";;
      "") break;;
    esac
    shift
done

## 処理部分

### 一行毎に「  」や「│  」､「├──」や「└──」を作る関数
function print_branch() {
  local key=1
  while [[ $key -le 6 ]]; do
    if [[ $key -lt $1 ]]; then
      if [[ ${dict[$key]} == "exist" ]]; then
        printf "│  "
        dict[$key]="exist"
      else
        printf "   "
      fi
    elif [[ $key -eq $1 ]]; then
      if [[ ${dict[$key]} == "exist" ]]; then
        printf "├── %s\n" "$2"
      else
        printf "└── %s\n" "$2"
      fi
      dict[$key]="exist"
    else
      dict[$key]="none"
    fi
    ((key++))
  done
}


### Markdownを全体を読み込んで､「#」がある行をツリー状に出力する関数
function print_tree() {
  local current_depth=0
  local last_depth=6
  local current_name=""
  local dict
  declare -A dict=(
    [1]="none" 
    [2]="none"
    [3]="none"
    [4]="none"
    [5]="none" 
    [6]="none"
  )
  
  while read -r line; do
    current_depth=`expr $(echo "$line" | grep -Eo '^#+ ' | wc -c) - 2`
    current_name=$(echo "$line" | sed -E 's/^#+ //g')
    if [[ $current_depth -le $2 ]]; then
      print_branch $current_depth "$current_name"
    fi
    last_depth=$current_depth
  done < <(grep "# " "$1" | tac)
}

### 実行部分
if [[ $print_depth -lt 1 || $print_depth -gt 6 ]]; then
  echo "エラー : 階層は1から6までです｡"
  exit 1
fi
print_tree $filename $print_depth | tac
