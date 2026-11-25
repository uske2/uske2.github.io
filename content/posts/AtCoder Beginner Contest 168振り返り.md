---
title: "AtCoder Beginner Contest 168振り返り"
date: 2020-06-17
slug: atcoder-abc168
categories:
  - 勉強
tags:
  - AtCoder
---
AtCoder Beginner Contest168に参加しました。A、B問題は問題なく解けましたが、C問題に関しては余弦の定理がなんなのかさえわからず、D以降は問題文を読むことだけで精一杯でした。今回は備忘録としてD問題について下記に記します。

**問題**D - .. (Double Dots)****

[https://atcoder.jp/contests/abc168/tasks/abc168\_d](https://atcoder.jp/contests/abc168/tasks/abc168_d)

まず幅優先探索については下記のWebページで勉強しました。

[https://qiita.com/drken/items/996d80bcae64649a6580](https://qiita.com/drken/items/996d80bcae64649a6580)

その後、もっとイメージを具体的にするためにAtCoderの典型問題例を解きました。

**A - 幅優先探索**

[https://atcoder.jp/contests/atc002/tasks/abc007\_3](https://atcoder.jp/contests/atc002/tasks/abc007_3)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AtCoder
{
    class Program
    {
        static void Main(string[] args)
        {

            var rc = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
            var strt = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
            var goal = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();

            int row = rc[0], col = rc[1], sy = strt[0] - 1, sx = strt[1] - 1, gy = goal[0] - 1, gx = goal[1] - 1;

            //解答用の迷路マッピング配列
            var ans = new int[row, col];
            //迷路を保持するための配列
            var meiro = new string[row];
            //迷路を配列に保持する
            for (var i = 0; i < row; i++)
            {
                meiro[i] = Console.ReadLine();
            }
            //未達のノードを記録するためのキューを用意する
            var qu = new Queue<Tuple<int, int>>();
            //スタート地点をキューに格納
            qu.Enqueue(new Tuple<int, int>(sy, sx));
            //現地点から東西南北へ移動する時に使う配列を用意
            var x = new int[] { 1, 0, -1, 0 };
            var y = new int[] { 0, -1, 0, 1 };
            //キューがなくなるまでループする
            while (qu.Count != 0)
            {
                var now = qu.Dequeue();
                for (int p = 0; p < 4; p++)
                {
                    if (meiro[now.Item1 + y[p]][now.Item2 + x[p]] == '.' && ans[now.Item1 + y[p], now.Item2 + x[p]] == 0)
                    {
                        ans[now.Item1 + y[p], now.Item2 + x[p]] = ans[now.Item1, now.Item2] + 1;
                        qu.Enqueue(new Tuple<int, int>(now.Item1 + y[p], now.Item2 + x[p]));
                    }
                }
            }
            Console.WriteLine(ans[gy, gx]);
        }
    }
}
```

その後いよいよ問題Dを解きました。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

namespace AtCoder
{
    public static class program
    {
        public static void Main()
        {
            //入力を保持する
            var NM = Console.ReadLine().Split().Select(v => int.Parse(v)).ToArray();
            var N = NM[0];
            var M = NM[1];

            //部屋間は行き来できるためA、B二つの配列を用意
            var As = new int[M];
            var Bs = new int[M];

            //Keyに部屋番号Valueに行先の道順を保持するためのDictionanyを用意
            var conns = new Dictionary<int, List<int>>();
            for (int n = 0; n < M; n++)
            {
                //道順を順番に保持していく
                var path = Console.ReadLine().Split().Select(v => int.Parse(v)).ToArray();
                As[n] = path[0];
                Bs[n] = path[1];

                //部屋Aからの道順が存在しなけば、新たに要素を追加する。
                //部屋A(Key) --> B(Value)
                if (!conns.ContainsKey(As[n]))
                {
                    conns[As[n]] = new List<int> { Bs[n] };
                }
                //部屋Aからの道順がすでに存在すれば、追加する。
                //部屋A(Key) --> B(Value)
                else
                {
                    conns[As[n]].Add(Bs[n]);
                }
                //部屋Bも同様に処理する
                if (!conns.ContainsKey(Bs[n]))
                {
                    conns[Bs[n]] = new List<int> { As[n] };
                }
                else
                {
                    conns[Bs[n]].Add(As[n]);
                }
            }
            var visit = Enumerable.Repeat(-1, N + 1).ToArray();
            var ans = new int[N + 1];
            var q = new Queue<int>();
            q.Enqueue(1);
            visit[1] = 0;
            while (q.Count != 0)
            {
                var now = q.Dequeue();                
                foreach (var conn in conns[now])
                {
                    if (visit[conn] != -1) continue;
                    q.Enqueue(conn);
                    visit[conn] = visit[now] + 1;
                    ans[conn] = now;
                }
            }

            Console.WriteLine("Yes");
            for (int i = 2;i < ans.Length;i++)
            {
                Console.WriteLine(ans[i]);
            }
            Console.ReadLine();

        }
    }
}
```
