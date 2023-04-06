# markdown-tree
![license](https://img.shields.io/github/license/yusu79/markdown-tree)
![languges](https://img.shields.io/github/languages/top/yusu79/markdown-tree)
![ppa](https://img.shields.io/badge/PPA-ppa:yusu79/markdown-tree.svg)



## 1.はじめに
`markdown-tree`は「**Markdownのファイルを読み込み､木構造のように表示するシェルスクリプト**」です｡

`markdown-tree foo.md`とターミナルで入力すれば､Markdownファイルの見出し(`#`や`##`など)を読み込み､それぞれの「`#`」の数に応じて､自動で`tree`コマンド形式で出力してくれます｡


## 2.インストール
```bash:インストール
$ sudo add-apt-repository ppa:yusu79/markdown-tree
$ sudo apt update && sudo apt install markdown-tree
```



## 3.使い方
```bash:使い方
$ markdown-tree【オプション】【foo.md】
```

例として､この「**README.md**」の構造を出力してみる｡
```bash:「README.md」を出力
$ markdown-tree README.md
└── markdown-tree
   ├── 1.はじめに
   ├── 2.インストール
   ├── 3.使い方
   ├── 4.ライセンス
   └── 5.作者情報
```


## 4.ライセンス
MITライセンス

## 5.作者情報
- [Twitter](https://l.pg1x.com/p5xn)
- [Qiita](https://l.pg1x.com/tGxZ)
- [はてなブログ](https://l.pg1x.com/yFNF)

