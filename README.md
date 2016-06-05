# ビルド・ステータス

[![wercker status](https://app.wercker.com/status/00ffe257f8c2394ab05e38070a7cf502/m/modifies "wercker status")](https://app.wercker.com/project/bykey/00ffe257f8c2394ab05e38070a7cf502)

# 記事を編集する

[`text`ディレクトリ](https://github.com/u360inc/u360inc.github.io/tree/modifies/text)以下のテキストファイルを編集します。
ファイルは[`haml`形式](http://haml.info/)で記述して、`text`ディレクトリ以下に配置します。

GitHub上で更新を保存する前に`Preview changes`をクリックして、差分の内容を確認してから、保存ボタンを押してください。

## 編集内容を確認する

次に挙げるような文字列はテンプレートシステムの制御構文です。
意図しない記述へ変更したり、インデントを変更したりしないでください。

- `{% block ... %}`
- `{% endblock %}`
- `{% if ... %}`
- `{% endif %}`

インデントの重要性については、haml形式のドキュメントを参照してください。

## 編集例

### 例）記事タイトルを編集する

記事ファイル内で、テンプレートシステムの`title`変数を定義します。

    {% set title = 'U360について' %}

### 例)メンバー欄を編集する

画像pathの対応は次の通りです。外部サイトへアップロードした画像URLでも可です。

    %img.media-object.img-circle(width='72' height='72' src='/img/member/mn.jpg' alt='')
    ↓
    https://github.com/u360inc/u360inc.github.io/tree/modifies/img/member/mn.jpg

円形抜きにするには、class属性に`.img-circle`を指定します。
詳しくは[BootstrapのImage shapesの項](http://getbootstrap.com/css/#images-shapes)を参照してください。

## 表示をカスタマイズするには

試すべき順

1. [BootstrapのInline text elementsの項](http://getbootstrap.com/css/#type-inline-text)を参照して、適用できるHTMLマークアップがあるか確認します。
2. Bootstrapの機能に適用できるマークアップが見つからない場合は、一度お問い合わせください。

## 変数を編集する

[`text/_variable.haml`](https://github.com/u360inc/u360inc.github.io/blob/modifies/text/_variable.haml)に定義されている変数の値を編集します。

# build環境をセットアップする

    $ bundle install
    $ pip install -r requirements.txt

# CSSフレームワーク

CSSフレームワークは[Bootstrap](http://getbootstrap.com/)です。

# テンプレートシステム

テンプレートシステムは[jinja2](http://jinja.pocoo.org/)です。

# 国際化

国際化に対応しており、コンテンツを多言語表示できます。
コンテンツの基本言語は「日本語」(ja)です。

## 翻訳対象のテキストをマークする

[`text`ディレクトリ](https://github.com/u360inc/u360inc.github.io/tree/modifies/text)以下のテキストファイル内で、翻訳したいテキスト部分を`{{_("`と`")}}`で括ってマーキングします。

    %a(href='/#inquiry') {{_("お問い合わせ")}}

## 対応言語を設定する

[`Makefile`ファイル](https://github.com/u360inc/u360inc.github.io/tree/modifies/Makefile)の`LOCALES`値を編集します。

    LOCALES=en fr es ch


## コンテンツを対訳する

[`locale`ディレクトリ](https://github.com/u360inc/u360inc.github.io/tree/modifies/locale)以下の`PO`ファイル（例:`locale/en/LC_MESSAGES/text.po`）を編集します。

    msgid "お問い合わせ"
    msgstr "Contact Us"
