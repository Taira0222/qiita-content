---
title: 【Ruby】今日書いたコードの振り返り#4
tags:
  - Ruby
  - 初心者
  - Object
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-12-14T08:15:51+09:00'
id: 257fc0289f0cb5b8cb42
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカの大学で語学を学びながら、独学でソフトウェアエンジニアを目指している者です。

今回は、**図書館管理システム**を作成する中で発生したミスと、その修正について振り返ります。問題の解決を通して、Rubyのクラス設計や状態管理について学びましょう！

## 今回扱った問題
図書館管理システム (レベル6)
図書館にある書籍を管理するシステムを作成する。

### 要件
* 書籍の情報（タイトル、著者、ISBN、貸出状態）を管理する。
* 書籍を貸し出す、返却する機能を提供する。
* タイトルまたは著者名で書籍を検索する機能を追加する。
* 同じ本を2人以上が同時に借りられないようにする。

## 間違えたコード
### 間違えた原因
1. attr_reader を使っていた
書籍の貸出状態を変更する処理で `book.borrowed = true` と書き込もうとしたが、`attr_reader` のためエラーが発生した。
2. ISBNで書籍を探す処理が欠けていた
`borrowed_book` メソッド内で、ISBNに一致する書籍を探す処理がなく、ループ内で毎回処理を行っていた。


### 間違えたコードの例
```ruby
# Bookクラスに本の情報を記録する
class Book
    attr_reader :title, :author, :isbn, :borrowed

    def initialize(title,author,isbn)
        @title = title
        @author = author
        @isbn = isbn
        @borrowed = false
    end

    # 本の情報を出力するメソッド
    def book_status
        puts "本のタイトル#{@title},著者#{@author},ISBN#{@isbn},貸出状態#{@borrowed}"
    end
end

class Library
    # 配列booksに本を格納するためのメソッド
    def initialize
        @books =[]
    end

    # 書籍を追加するメソッド
    def add_books(book)
        @books << book
        puts "追加されました：#{book.title}"
    end

    # 書籍を貸出するメソッド

    def borrowed_book(borrow_isbn)
        # 貸出状況をみて書籍を貸すことができるかの処理をしている
        @books.each do |book|
            if  book.borrowed == false && book.isbn == borrow_isbn
                puts "ご利用ありがとうございます。"
                book.borrowed = true
            else
                puts "現在ほかの方がご利用されているのでお貸出できません"
            end
            # 図書館にその本がない場合の例外処理
                puts "お探しになっている書籍はこちらの図書館にございません。"  unless borrow_isbn == book.isbn
        end
    end
    
    # 書籍の返却の処理
    def return_book(return_isbn)
        @books.each do |book|
            if  book.borrowed == true && book.isbn == return_isbn
                puts "ご返却ありがとうございます。またのご利用をお待ちしております"
                book.borrowed = false
            elsif book.borrowed == false && book.isbn == return_isbn
                puts "図書館に同じISBNの書籍がありますが、貸出されている記録がありません。もう一度ISBNをご確認ください"
            else
                puts "こちらの書籍と一致するISBNが図書館に存在しません。"
            end
        end
    end

    # 検索機能実装前にミス発覚
        

end
```


## 正しいコード
### 修正ポイント
1. attr_reader → attr_accessor に変更
書籍の貸出状態を変更できるようにした。

2. ISBNで書籍を検索する処理を追加
先にISBNに一致する書籍を探してから、処理を行うように修正した。


### 修正後のコード
```ruby
# Bookクラス: 書籍の情報を管理するクラス
class Book
  attr_accessor :title, :author, :isbn, :borrowed

  def initialize(title, author, isbn)
    @title = title
    @author = author
    @isbn = isbn
    @borrowed = false  # 初期状態では貸し出されていない
  end

  def to_s
    "Title: #{@title}, Author: #{@author}, ISBN: #{@isbn}, Borrowed: #{@borrowed ? 'Yes' : 'No'}"
  end
end

# Libraryクラス: 図書館を管理するクラス
class Library
  def initialize
    @books = []  # Bookインスタンスを格納する配列
  end

  # 書籍の追加
  def add_book(book)
    @books << book
    puts "追加されました: #{book.title}"
  end

  # 書籍の貸し出し
  def borrow_book(isbn)
    book = @books.find { |b| b.isbn == isbn }
    if book
      if book.borrowed
        puts "この本は既に貸し出されています: #{book.title}"
      else
        book.borrowed = true
        puts "貸し出しました: #{book.title}"
      end
    else
      puts "本が見つかりません。"
    end
  end

  # 書籍の返却
  def return_book(isbn)
    book = @books.find { |b| b.isbn == isbn }
    if book
      if book.borrowed
        book.borrowed = false
        puts "返却しました: #{book.title}"
      else
        puts "この本は貸し出されていません: #{book.title}"
      end
    else
      puts "本が見つかりません。"
    end
  end

  # タイトルで書籍を検索
  def search_by_title(title)
    results = @books.select { |b| b.title.include?(title) }
    if results.any?
      results.each { |b| puts b }
    else
      puts "該当する書籍が見つかりません。"
    end
  end

  # 著者で書籍を検索
  def search_by_author(author)
    results = @books.select { |b| b.author.include?(author) }
    if results.any?
      results.each { |b| puts b }
    else
      puts "該当する書籍が見つかりません。"
    end
  end
end

```


### 動作の確認
```ruby
library = Library.new

# 書籍の追加
library.add_book(Book.new("The Great Gatsby", "F. Scott Fitzgerald", "9780743273565"))
library.add_book(Book.new("1984", "George Orwell", "9780451524935"))
library.add_book(Book.new("To Kill a Mockingbird", "Harper Lee", "9780060935467"))
library.add_book(Book.new("Brave New World", "Aldous Huxley", "9780060850524"))

# 書籍の一覧表示
puts "\n--- 図書館の書籍一覧 ---"
library.list_books

# 書籍の貸し出し
puts "\n--- 書籍の貸し出し ---"
library.borrow_book("9780451524935")
library.borrow_book("9780451524935")  # 2回目の貸し出しはエラー

# 書籍の返却
puts "\n--- 書籍の返却 ---"
library.return_book("9780451524935")
library.return_book("9780451524935")  # 2回目の返却はエラー

# タイトルで検索
puts "\n--- タイトルで検索 ('Brave') ---"
library.search_by_title("Brave")

# 著者で検索
puts "\n--- 著者で検索 ('George Orwell') ---"
library.search_by_author("George Orwell")
```

## コードの解説と自分がわからなかったところの解説

### `attr_accessor` と `initialize` メソッドについて
#### `attr_accessor` の役割:
```ruby
attr_accessor :title, :author, :isbn, :borrowed
```

`attr_accessor` は、`title`、`author`、`isbn`、`borrowed` という4つのインスタンス変数に対して、読み書き可能なゲッターメソッドとセッターメソッドを自動生成します。
例えば、`book.title` でタイトルを取得し、`book.title = "新しいタイトル"` でタイトルを設定することができます。

#### initialize メソッドの役割:
```ruby
def initialize(title, author, isbn)
  @title = title
  @author = author
  @isbn = isbn
  @borrowed = false  # 初期状態では貸し出されていない
end
```
`initialize` メソッドは、`Book` クラスのインスタンスが生成されたときに呼ばれる特別なメソッドです。
`@title`、`@author`、`@isbn`、`@borrowed` に初期値を設定します。
`@borrowed` を `false` にすることで、新しく作られた本は「貸し出されていない」状態になります。

#### なぜ両方定義するのか？
`attr_accessor` は メソッド（ゲッターとセッター） を生成しますが、インスタンス変数自体の初期値を設定するわけではありません。
初期値を設定するためには initialize メソッド内で明示的に代入する必要があります。

### `Array#find` メソッドについて
find メソッドは、配列の中から**ブロックの条件に合う最初の要素**を返します。
```ruby
book = @books.find { |b| b.isbn == "9780451524935" }
```
このコードは、`@books` 配列の中で `isbn` が `"9780451524935"` に一致する最初の `Book` インスタンスを返します。
条件に合う要素が見つからない場合は `nil` を返します。
### `Array#select` メソッドについて
`select` メソッドは、配列の中から**ブロックの条件に合うすべての要素を配列**として返します。
```ruby
results = @books.select { |b| b.title.include?("Great") }
```

このコードは、`@books` 配列の中でタイトルに `"Great"` を含むすべての `Book` インスタンスを新しい配列として返します。
条件に合う要素がない場合は空配列 [] を返します。


### `results.any?` メソッドについて
`any?` メソッドは、配列やコレクションに1つ以上の要素が存在する場合に `true` を返します。
逆に、配列が空の場合は `false` を返します。
```ruby
results = @books.select { |b| b.title.include?("Great") }
if results.any?
  results.each { |b| puts b }
else
  puts "該当する書籍が見つかりません。"
end
```
`results.any?` が `true` の場合、検索結果が1つ以上あるため、`results` の内容を出力します。
`results` が空の場合、`else` ブロックの `"該当する書籍が見つかりません。"` が実行されます。


## まとめ

1. アクセサメソッドの選択
attr_reader は読み取り専用、書き込みが必要なら attr_accessor を使う。
2. 処理の順序
処理は分割し、最初に行った方がいいものを考えてからコードを書く
3. `attr_accessor`はインスタンス変数を読み書き可能なメソッドとして自動生成する
4. `initialize`はインスタンス変数の初期値を代入するためのメソッド
5. `find`は配列の中からブロックの条件にあう**最初の要素**を返し、`select`は配列の中からブロックの条件に合う**すべての要素を配列**として返します。

