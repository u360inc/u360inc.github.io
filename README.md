記事を編集する
---

[`text`ディレクトリ](https://github.com/u360inc/u360inc.github.io/tree/modifies/text)以下のテキストファイルを編集します。
ファイルは[`haml`形式](http://haml.info/)で記述して、`text`ディレクトリ以下に配置します。

GitHub上で更新を保存する前に`Preview changes`をクリックして、差分の内容を確認してから、保存ボタンを押してください。

次に挙げるような文字列はテンプレートシステムの制御構文です。
意図しない記述へ変更したり、インデントを変更したりしないでください。

- `{% block ... %}`
- `{% endblock %}`
- `{% if ... %}`
- `{% endif %}`

インデントの重要性については、haml形式のドキュメントを参照してください。

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

