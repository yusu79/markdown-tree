#!/bin/bash
set -eu
# 使い方: markdown-tree [オプション] [Markdownファイル] [出力する階層]
#
#   説明: Markdownファイル(.md)の見出しをツリー状に変換して出力する
#   引数:
#    ・Markdownファイル     見出しをツリーで出力したいファイルを指定｡
#    ・階層                 出力する階層を指定｡デフォルトは6(######)｡
#
#   オプション:
#       -h         ヘルプを表示  
#
function usage() {
    sed -rn '/^# 使い方/,${/^#/!q;s/^# ?//;p}' "$0"
    exit
}
while getopts "h" opt;do
  case $opt in
      h) usage;;
      *) echo -e "\n「-h」を使用してください。"; exit 1;;
  esac
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
  local filename="$1"
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
  done < <(grep "# " "$filename" | tac)
}

print_depth=${2:-6}
if [[ $print_depth -lt 1 || $print_depth -gt 6 ]]; then
  echo "エラー : 階層は1から6までです｡"
  exit 1
fi
print_tree "$1" $print_depth | tac
