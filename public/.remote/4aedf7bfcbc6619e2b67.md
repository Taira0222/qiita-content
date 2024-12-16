---
title: 【Ruby】今日書いたコードの振り返り#5
tags:
  - Ruby
  - If
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-12-16T14:22:10+09:00'
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
task1 = Task.new("Write Report", TeamMember.new("Takeshi"), "高")
task2 = Task.new("Fix Bug", TeamMember.new("Alex"), "中")
task3 = Task.new("Prepare Presentation", TeamMember.new("Takeshi"), "低")

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
## 上記の問題の回答
もしよかったら一緒に解いてから一緒に見てみてください。
なお、以下の回答よりも運用や効率的な面でいい書き方があればフィードバックいただけると励みになります。

```ruby
class Task
    attr_accessor :name, :assignee, :status

    def initialize(name,assignee)
        @name = name
        @assignee = assignee
        @status = "未着手" # 新しいタスクはすべて未着手
    end
end
class TeamMember
    attr_accessor :name, :tasks
    def initialize(name)
        @name = name
        @tasks =[]
    end

    def add_task(task)
        tasks << task
    end
end

class TaskManager
    def initialize
        @tasks = []
    end

    def add_task(task,member)
        member.add_task(task) # メンバーにタスクを追加
        @tasks << task # TaskManager内のタスクリストにもタスクを追加
        puts "タスク「#{task.name}」が担当者「#{member.name}」に追加されました"
    end
    
    def start_task(task)
        if task.status == "未着手"
            task.status = "進行中"
            puts "タスク「#{task.name}」が進行中に変わりました"
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
            puts "タスク「#{task.name}」は進行中でないため、保留にすることができません"
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
            @tasks.delete(task) # Taskmanagerクラスのインスタンス変数@tasks配列内のtaskをdelete
            task.assignee.tasks.delete(task)
            puts "タスク「#{task.name}」が削除されました"
        else
            puts "タスク「#{task.name}」が未着手または完了でないため、削除できません"
        end
    end

    def list_tasks
        puts "\n=== タスク一覧 ==="
        @tasks.each {|task| puts task}
        puts "=================\n\n"
    end
end

# タスクの作成
task1 = Task.new("Write Report", TeamMember.new("Takeshi"), "高")
task2 = Task.new("Fix Bug", TeamMember.new("Alex"), "中")
task3 = Task.new("Prepare Presentation", TeamMember.new("Takeshi"), "低")

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

私は`TaskMember`クラスの`add_task`と`TaskManager`の`add.task`と`delete_task(task)`が難しく解けませんでした。
上記のコードで学んだ点をそれぞれ箇条書きで書いていきたいと思います。

### 私が理解に苦労した点

1. `TeamMember`の`add_task`メソッド
`add_task` メソッドは、`TeamMember` クラスで定義されており、その目的は チームメンバーにタスクを追加することです。
```ruby
class TeamMember
  attr_accessor :name, :tasks

  def initialize(name)
    @name = name
    @tasks = []  # 担当するタスクを格納するための配列
  end

  def add_task(task)
    tasks << task  # タスクをメンバーのタスクリストに追加
  end
end
```
`add_task` メソッドは、引数として渡されたタスク（`task`）を、そのメンバーのタスクリスト（`tasks`）に追加します。
`tasks` << `task` で配列にタスクを追加しています。
2. `TaskManager`の`add_task`
```ruby
class TaskManager
  def initialize
    @tasks = []  # 管理するタスクを格納する配列
  end

  def add_task(task, member)
    member.add_task(task)  # メンバーにタスクを追加
    @tasks << task  # TaskManager内のタスクリストにもタスクを追加
    puts "タスク「#{task.name}」が担当者「#{member.name}」に追加されました"
  end
end
```
`TaskManager` と `TeamMember` は異なるクラスですが、`add_task` メソッドを通じて、`TaskManager` は `TeamMember` にタスクを割り当てることができる仕組みになっています。
`member.add_task(task)` を呼ぶことで、実際に `TeamMember` クラスの `tasks` 配列にタスクを追加していますが、同時に `TaskManager` 内の `@tasks` 配列にもタスクが追加されている点が少し複雑に感じました

3. TaskManagerのdelete_task(task)
```ruby
class TaskManager
  def delete_task(task)
    if task.status == "未着手" || task.status == "完了"
      @tasks.delete(task)  # TaskManagerのタスクリストから削除
      task.assignee.tasks.delete(task)  # 担当者のタスクリストから削除
      puts "タスク「#{task.name}」が削除されました"
    else
      puts "タスク「#{task.name}」が未着手または完了でないため、削除できません"
    end
  end
end
```
`task.assignee` は、タスクがどのメンバーに割り当てられているかを示すもので、`assignee` に格納されているのは `TeamMember` のインスタンスであることが最初見てもわかりませんでした。

# まとめ
今回はタスク管理システムの作成を通じて、クラス間でどのように情報を管理するか、タスクの状態に応じた操作をどう扱うかを学びました。`add_task`や`delete_task`の処理が複雑に感じましたが、コードを読み進めることで各クラスの責任とタスクの流れを理解できました。
理解をしている内に再度復習もして自分の実力していきたいと思いました。
