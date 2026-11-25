---
title: "AtCoder Beginner Contest 278振り返り（HashSetについて）"
date: 2022-11-24
slug: atcoder-abc278
categories:
  - 勉強
tags:
  - AtCoder
---
結果は２完（A、B）でしたが後々C問題を取り組んだところACできなかったので復習します。

> C - FF
> 
> [https://atcoder.jp/contests/abc278/tasks/abc278\_c](https://atcoder.jp/contests/abc278/tasks/abc278_c)

最初はListを用いてコーディングしていましたが、何度トライしてみてもTLEとなっていました。解説を読んでHashSetにたどり着きました。

HashSetとListの違いは重複したデータを保持できないという点にあります。

> HashSet\<T> クラス
> 
> [https://learn.microsoft.com/ja-jp/dotnet/api/system.collections.generic.hashset-1?view=net-5.0](https://learn.microsoft.com/ja-jp/dotnet/api/system.collections.generic.hashset-1?view=net-5.0)

最終的にACできたコードを下記に示します。HashSetを用いてユーザーのフォロー追加、解除を行っています。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

public class Hello
{
    public static void Main() {
        var NQ = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();
        //var NQ = int.Parse(Console.ReadLine());
        var N = NQ[0];
        var Q = NQ[1];
        var users = new Dictionary<int, HashSet<int>>();
        //for (int i = 0; i <= N - 1; i++) {
        //    users.Add(i + 1, new List<int>());
        //}
        for (int i = 0; i <= Q - 1; i++) {
            var op = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();

            if (op[0] == 1) {
                //usersDiscにop[1]がなければ生成
                if (users.ContainsKey(op[1]) == false) {
                    users.Add((op[1]), new HashSet<int>() { op[2] });
                }
                //なければ要素op[1]に代入→HashSetの場合重複は生じ得ない
                else {
                    users[op[1]].Add(op[2]);
                }
            }
            else if (op[0] == 2) {
                if (users.ContainsKey(op[1]) == false) {
                    users.Add((op[1]), new HashSet<int>());
                }
                else {
                    users[op[1]].Remove(op[2]);
                }
            }
            else {
                if (users.ContainsKey(op[1])&& users.ContainsKey(op[2])) {
                    if(users[op[1]].Contains(op[2])&& users[op[2]].Contains(op[1])) {
                        Console.WriteLine("Yes");
                    }
                    else {
                        Console.WriteLine("No");
                    }
                }
                else {
                    Console.WriteLine("No");
                }
            }
        }
    }
}
```
