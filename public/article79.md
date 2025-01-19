---
title: 【Ruby】今日書いたコードの振り返り(条件判断)#5
tags:
  - Ruby
  - If
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-12-18T07:09:03+09:00'
id: 4aedf7bfcbc6619e2b67
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカに住みながら独学でソフトウェアエンジニアを目指しているものです。
本日は条件判断の問題を解いたのでそのコードについての振り返りをしていきたいと思います。
勉強記録的な意味合いが強いので見ていただける方がいれば幸いです。

## 問題の概要
複数のチームメンバーがタスクを管理するシステムを作成してください。タスクには「未着手」「進行中」「完了」「保留」の状態があり、状態に応じた操作や制限が存在します。

## 要件
1. タスクには以下の情報が含まれます：
* タスク名
* 担当者
* ステータス（"未着手"、"進行中"、"完了"、"保留"）
2. 以下の操作を実装してください：
* タスクの開始: 「未着手」状態のタスクのみ「進行中」にできます。
* タスクの完了: 「進行中」のタスクのみ「完了」にできます。
* タスクの保留: 「進行中」のタスクを「保留」にできます。保留中のタスクは再開可能です。
* タスクの削除: 「未着手」または「完了」のタスクのみ削除できます。
3. 担当者ごとにタスクを管理し、タスク一覧を表示する機能を実装してください。
4. タスクの状態は以下のように遷移します：
* 「未着手」→「進行中」
* 「進行中」→「完了」
* 「進行中」→「保留」
* 「保留」→「進行中」
## クラス設計
* Taskクラス: タスクの情報と状態を管理。
* TeamMemberクラス: チームメンバーと担当タスクを管理。
* TaskManagerクラス: タスクの追加、状態変更、削除、一覧表示を管理。
実装例
```ruby
# タスクの作成
task1 = Task.new("Write Report", TeamMember.new("Takeshi"))
task2 = Task.new("Fix Bug", TeamMember.new("Alex"))
task3 = Task.new("Prepare Presentation", TeamMember.new("Takeshi"))

# チームメンバーの作成
member1 = TeamMember.new("Takeshi")
member2 = TeamMember.new("Alex")

# タスクの管理
manager = TaskManager.new
manager.add_task(task1, member1)
manager.add_task(task2, member2)
manager.add_task(task3, member1)

# タスクの状態変更
manager.start_task(task1)     # 「未着手」→「進行中」
manager.complete_task(task1)  # 「進行中」→「完了」
manager.hold_task(task2)      # 「未着手」のため、保留不可
manager.start_task(task2)     # 「未着手」→「進行中」
manager.hold_task(task2)      # 「進行中」→「保留」
manager.resume_task(task2)    # 「保留」→「進行中」

# タスクの削除
manager.delete_task(task1)    # 削除成功（完了済み）
manager.delete_task(task2)    # 削除失敗（進行中）

# タスク一覧の表示
manager.list_tasks
```
## 上記の問題の回答例
AIを用いて解答例を作成しました。(追記 修正後のコードは以下に記述)

```ruby
class Task
    attr_accessor :name, :assignee, :status

    def initialize(name, assignee)
        @name = name
        @assignee = assignee
        @status = "未着手" # 新しいタスクはすべて未着手
    end

end

class TeamMember
    attr_accessor :name, :tasks
    def initialize(name)
        @name = name
        @tasks = []
    end

    def add_task(task)
        tasks << task
    end
end

class TaskManager
    def initialize
        @tasks = []
    end

    def add_task(task, member)
        # タスクをメンバーに割り当て
        member.add_task(task)
        # タスクマネージャー内にも記録
        @tasks << task
        puts "タスク「#{task.name}」が担当者「#{member.name}」に追加されました"
    end
    
    def start_task(task)
        if task.status == "未着手"
            task.status = "進行中"
            puts "タスク「#{task.name}」が進行中になりました"
        else
            puts "タスク「#{task.name}」は未着手でないため、開始できません"
        end
    end

    def complete_task(task)
        if task.status == "進行中"
            task.status = "完了"
            puts "タスク「#{task.name}」は完了しました"
        else
            puts "タスク「#{task.name}」は進行中でないため、完了できません"
        end
    end

    def hold_task(task)
        if task.status == "進行中"
            task.status = "保留"
            puts "タスク「#{task.name}」は保留になりました"
        else
            puts "タスク「#{task.name}」は進行中でないため、保留にできません"
        end
    end

    def resume_task(task)
        if task.status == "保留"
            task.status = "進行中"
            puts "タスク「#{task.name}」は再開され、進行中になりました"
        else
            puts "タスク「#{task.name}」は保留でないため、再開できません"
        end
    end

    def delete_task(task)
        if task.status == "未着手" || task.status == "完了"
            @tasks.delete(task)
            task.assignee.tasks.delete(task)
            puts "タスク「#{task.name}」が削除されました"
        else
            puts "タスク「#{task.name}」が未着手または完了でないため、削除できません"
        end
    end

    def list_tasks
        puts "\n=== タスク一覧 ==="
        @tasks.each { |task| puts task }
        puts "=================\n\n"
    end
end

# チームメンバーの作成
member1 = TeamMember.new("Takeshi")
member2 = TeamMember.new("Alex")

# タスクの作成
task1 = Task.new("Write Report", member1)
task2 = Task.new("Fix Bug", member2)
task3 = Task.new("Prepare Presentation", member1)

# タスクの管理
manager = TaskManager.new
manager.add_task(task1, member1)
manager.add_task(task2, member2)
manager.add_task(task3, member1)

# タスクの状態変更
manager.start_task(task1)     # 「未着手」→「進行中」
manager.complete_task(task1)  # 「進行中」→「完了」
manager.hold_task(task2)      # 「未着手」のため、保留不可
manager.start_task(task2)     # 「未着手」→「進行中」
manager.hold_task(task2)      # 「進行中」→「保留」
manager.resume_task(task2)    # 「保留」→「進行中」

# タスクの削除
manager.delete_task(task1)    # 削除成功（完了済み）
manager.delete_task(task2)    # 削除失敗（進行中）

# タスク一覧の表示
manager.list_tasks

```

一見問題なさそうなコードですが、以下の点について問題があります。
それはタスクとチームメンバーの紐づけが二重で行われているということです。

Task.newでタスクに担当者を設定し、TaskManager#add_taskでも担当者にタスクを追加しています。
これにより、タスクと担当者の関連付けが二重に行われ、整合性が崩れやすくなっています。
また、`p task1`で中を見てみるとtask1の中の担当者(assignee)はTakeshiであり、member1と紐づけているのですが、
その中の@tasksが空となりそれぞれの整合性がとれていません。

```ruby
# task1の中身
task1--- @name = "Write Report" 
       |
       |_@assignee-------@name = "Takeshi" 
       |                |
       |_@status        |_@tasks =[]  #task1の担当者はTakeshiなのに
       
```

## 上記のコードを改善したもの
Taskの初期値には担当者を設定せず、add_taskメソッドのみで担当者とタスクを関連付けるようにしています

```ruby
class Task
  attr_accessor :name, :assignee, :status

  def initialize(name)
    @name = name
    @assignee = nil
    @status = "未着手" # 新しいタスクはすべて未着手
  end

  def to_s
    assignee_name = assignee ? assignee.name : "未割り当て"
    "#{name} (担当者: #{assignee_name}, 状態: #{status})"
  end
end

class TeamMember
  attr_accessor :name, :tasks

  def initialize(name)
    @name = name
    @tasks = []
  end

  def add_task(task)
    tasks << task
  end
end

class TaskManager
  def initialize
    @tasks = []
  end

  # タスクを担当者に割り当て、整合性を保つ
  def add_task(task, member)
    # タスクに担当者を設定
    task.assignee = member
    # 担当者にタスクを追加
    member.add_task(task)
    # TaskManagerのリストにもタスクを追加
    @tasks << task
    puts "タスク「#{task.name}」が担当者「#{member.name}」に追加されました"
  end
  
  def start_task(task)
    if task.status == "未着手"
      task.status = "進行中"
      puts "タスク「#{task.name}」が進行中になりました"
    else
      puts "タスク「#{task.name}」は未着手でないため、開始できません"
    end
  end

  def complete_task(task)
    if task.status == "進行中"
      task.status = "完了"
      puts "タスク「#{task.name}」は完了しました"
    else
      puts "タスク「#{task.name}」は進行中でないため、完了できません"
    end
  end

  def hold_task(task)
    if task.status == "進行中"
      task.status = "保留"
      puts "タスク「#{task.name}」は保留になりました"
    else
      puts "タスク「#{task.name}」は進行中でないため、保留にできません"
    end
  end

  def resume_task(task)
    if task.status == "保留"
      task.status = "進行中"
      puts "タスク「#{task.name}」は再開され、進行中になりました"
    else
      puts "タスク「#{task.name}」は保留でないため、再開できません"
    end
  end

  def delete_task(task)
    if task.status == "未着手" || task.status == "完了"
      @tasks.delete(task)
      task.assignee.tasks.delete(task) if task.assignee
      puts "タスク「#{task.name}」が削除されました"
    else
      puts "タスク「#{task.name}」が未着手または完了でないため、削除できません"
    end
  end

  def list_tasks
    puts "\n=== タスク一覧 ==="
    @tasks.each { |task| puts task }
    puts "=================\n\n"
  end
end

# チームメンバーの作成
member1 = TeamMember.new("Takeshi")
member2 = TeamMember.new("Alex")

# タスクの作成（担当者はここではまだ設定しない）
task1 = Task.new("Write Report")
task2 = Task.new("Fix Bug")
task3 = Task.new("Prepare Presentation")

# タスクの管理（ここでタスクと担当者を関連付ける）
manager = TaskManager.new
manager.add_task(task1, member1)
manager.add_task(task2, member2)
manager.add_task(task3, member1)

# タスクの状態変更
manager.start_task(task1)     # 「未着手」→「進行中」
manager.complete_task(task1)  # 「進行中」→「完了」
manager.hold_task(task2)      # 「未着手」のため、保留不可
manager.start_task(task2)     # 「未着手」→「進行中」
manager.hold_task(task2)      # 「進行中」→「保留」
manager.resume_task(task2)    # 「保留」→「進行中」

# タスクの削除
manager.delete_task(task1)    # 削除成功（完了済み）
manager.delete_task(task2)    # 削除失敗（進行中）

# タスク一覧の表示
manager.list_tasks
```


# まとめ
今回はタスク管理システムの作成を通じて、クラス間でどのように情報を管理するか、タスクの状態に応じた操作をどう扱うかを学びました。`add_task`や`delete_task`の処理が複雑に感じましたが、コードを読み進めることで各クラスの責任とタスクの流れを理解できました。
理解をしている内に再度復習もして自分の実力していきたいと思いました。

