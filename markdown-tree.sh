#!/bin/bash

# Markdownファイルが渡されてない場合の注意表示
if [[ $# -eq 0 ]]; then
  echo "注意: 引数に「markdown_file.md」が必要です｡"
  exit 1
fi

# pandocがインストールされていない場合の注意表示
if ! command -v pandoc >/dev/null; then
  echo "注意: 「pandoc」がインストールされていません｡"
  exit 1
fi

# 引数に渡したMarkdownをHTMLに変換し､変数に格納
html=$(pandoc -f markdown -t html "$1" 2>/dev/null)

# HTMLファイルが生成されず､変数が空だった場合のエラー表示
if [[ -z "$html" ]]; then
  echo "エラー: $1 から HTMLへのコンバートは失敗しました｡"
  exit 1
fi


echo "$html" | grep -Eo '<h[1-6][^>]*>(.*?)<\/h[1-6]>' | while read -r line; do
  header=$(echo "$line" | sed -E 's/<h[1-6][^>]*>//g' | sed -E 's/<\/h[1-6]>//g' )
  level=$(echo "$line" | grep -Eo '<\/?h([1-6])>' | sed -E 's/<\/?h([1-6])>/\1/')
  if [[ "$level" -eq 1 ]]; then
    printf "%s\n" "$header"
  else
    prefix=$(printf "%$((level-1))s" " ")
    printf "%s└── %s\n" "$prefix" "$header"
  fi
done


