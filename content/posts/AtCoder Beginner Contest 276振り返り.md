---
title: "AtCoder Beginner Contest 276振り返り"
date: 2022-11-06
slug: atcoder-abc276
categories:
  - 勉強
tags:
  - AtCoder
  - C#
---
2022年11月5日（土）に開催されたABC276に参加しました。A問題のみ１完というしょっぱい結果に終わりました。どうしてもB問題でACすることができずTLEで阻まれてしまいました。プログラムのロジックは間違っていないはず。なので書き方の問題というのははっきりしていたのですが、最後まで原因を突き止めることができませんでした。

今回の記事ではB問題の復習をしていこうと思います。

> B - Adjacency List
> 
> [https://atcoder.jp/contests/abc276/tasks/abc276\_b](https://atcoder.jp/contests/abc276/tasks/abc276_b)

まず最初に、提出してたコードを下記に示します。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

public class Hello
{
    public static void Main()
    {
        var NM = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();
        var N = NM[0];
        var M = NM[1];
        var cities = new List<List<int>>();
        for (int i = 0; i <= N; i++)
        {
            cities.Add(new List<int>());
        }
        for (int i = 0; i <= M - 1; i++)
        {
            var road = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();
            cities[road[0]].Add(road[1]);
            cities[road[1]].Add(road[0]);
        }
        for (int i = 1; i <= cities.Count - 1; i++)
        {
            if (cities[i].Count == 0)
            {
                Console.WriteLine(0);
                continue;
            }
            var ans = cities[i].Count.ToString();
            cities[i].Sort();
            foreach (var r in cities[i])
            {
                ans = ans + " " + r.ToString();
            }
            Console.WriteLine(ans);
        }
    }
}
```

![](/images/ABC276_TLE.png)

実行結果と実行時間

他ユーザのACを獲得した提出コードを比較してみても（自分とは比べ物にならないスマートな書き方をされていますが）極端に自分のものが遅くなりそうな感じはありませんでした。。。と思いきや一点気になる点として、上記コードの３２行目～３８行目の部分について他のユーザの回答では下記２点に回答が分かれていました。

- StringBuilderでまとめて回答となる文字列を作成して出力
- 変数をつかわずConsole.WriteメソッドあるいはWritelineメソッドを使って回答を出力

私のように１行ずつ文字列を作成して出力という方法を取っている人は一人もいません。

これが原因か…？試しに下記の通りのコード（Consoleクラスを使用）に編集を加えて提出してみると…

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

public class Hello
{
    public static void Main()
    {
        var NM = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();
        var N = NM[0];
        var M = NM[1];
        var cities = new List<List<int>>();
        for (int i = 0; i <= N; i++)
        {
            cities.Add(new List<int>());
        }
        for (int i = 0; i <= M - 1; i++)
        {
            var road = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();
            cities[road[0]].Add(road[1]);
            cities[road[1]].Add(road[0]);
        }
        for (int i = 1; i <= cities.Count - 1; i++)
        {
            if (cities[i].Count == 0)
            {
                Console.WriteLine(0);
                continue;
            }
            Console.Write(cities[i].Count.ToString());
            cities[i].Sort();
            foreach (var r in cities[i])
            {
                Console.Write(" " + r.ToString());
            }
            Console.WriteLine();
        }
    }
}
```

![](/images/ABC276_AC_Console.png)

実行結果と実行時間

できました！

実行時間はなんと８７９msでだいぶ差が生じました。こんなに違うものなんですね、知りませんでした。ちなみにStringBuilderで回答をまとめて出力すると…

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

public class Hello
{
    public static void Main()
    {
        var NM = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();
        var N = NM[0];
        var M = NM[1];
        var cities = new List<List<int>>();
        for (int i = 0; i <= N; i++)
        {
            cities.Add(new List<int>());
        }
        for (int i = 0; i <= M - 1; i++)
        {
            var road = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();
            cities[road[0]].Add(road[1]);
            cities[road[1]].Add(road[0]);
        }
        var str = new StringBuilder();
        for (int i = 1; i <= cities.Count - 1; i++)
        {
            cities[i].Sort();
            str.Append(string.Format("{0} {1}\n", cities[i].Count.ToString(), string.Join(" ", cities[i])));
        }
        Console.WriteLine(str);
    }
}
```

![](/images/ABC276_AC_Append.png)

実行結果と実行時間

さらに早くなります！

今回のコンテストを通して回答の作り方によって実行時間に大きく差がでることを学びました。
