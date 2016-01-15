記事を編集する
---

[`text`ディレクトリ](https://github.com/u360inc/u360inc.github.io/tree/modifies/text)以下のテキストファイルを編集します。
ファイルは[`haml`形式](http://haml.info/)で記述して、`text`ディレクトリ以下に配置します。

変数を編集する
---

[`text/_variable.haml`](https://github.com/u360inc/u360inc.github.io/blob/modifies/text/_variable.haml)に定義されている変数の値を編集します。

ビルド・ステータス
---

[![wercker status](https://app.wercker.com/status/00ffe257f8c2394ab05e38070a7cf502/m/modifies "wercker status")](https://app.wercker.com/project/bykey/00ffe257f8c2394ab05e38070a7cf502)

build環境をセットアップする
---

    $ bundle install
    $ pip install -r requirements.txt

テンプレートシステム
---

テンプレートシステムは[jinja2](http://jinja.pocoo.org/)です。

