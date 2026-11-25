---
title: "AtCoder Beginner Contest 173振り返り"
date: 2020-07-13
slug: atcoder-abc173
categories:
  - 勉強
tags:
  - AtCoder
---
AtCoder Beginner Contest173に参加しました。依然としてC問題を解くことができません。A、B、Cを振り返ります。

## A - Payment
> お店でN円の商品を買います。
> 
> 1000 円札のみを使って支払いを行う時、お釣りはいくらになりますか？
> 
> ただし、必要最小限の枚数の1000円札で支払いを行うものとします。
> 
> 制約
> 
> 1≤N≤10000
> 
> N は整数
> 
> [https://atcoder.jp/contests/abc173/tasks/abc173\_a](https://atcoder.jp/contests/abc173/tasks/abc173_a)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //商品の値段を保持する
        var price = int.Parse(Console.ReadLine());
        //最小限のお金1000円
        var min = 1000;
        var ans = 0;
        //おつりがプラスで戻ってくるまでループし続ける
        for (var cnt = 1; cnt <= 10; cnt++)
        {
            if (0 <= min - price)
            {
                //おつりがプラスで戻ってきたらループを抜ける
                ans = min - price;
                break;
            }
            min += 1000;
        }
        Console.WriteLine(ans);
    }
}
```

## B - Judge Status Summary
> 高橋君は、プログラミングコンテストAXC002に参加しており、問題Aにコードを提出しました。
> 
> この問題にはN個のテストケースがあります。
> 
> 各テストケースi(1≤i≤N)について、ジャッジ結果を表す文字列Siが与えられるので、ジャッジ結果がAC,WA,TLE,REであったものの個数をそれぞれ求めてください。出力形式は、出力欄を参照してください。
> 
> 制約
> 
> 1≤N≤10^5
> 
> Si は AC, WA, TLE, RE のいずれか
> 
> [https://atcoder.jp/contests/abc173/tasks/abc173\_b](https://atcoder.jp/contests/abc173/tasks/abc173_b)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //テストケース数を保持する
        var cases = int.Parse(Console.ReadLine());
        //回答用配列を用意
        var ans = new int[4];
        //テストケース数分ループする
        for (var cnt = 0; cnt < cases; cnt++)
        {
            //テストケースによって配列をカウントアップする
            var rslt = Console.ReadLine();
            switch (rslt)
            {
                case "AC":
                    ans[0] += 1;
                    break;
                case "WA":
                    ans[1] += 1;
                    break;
                case "TLE":
                    ans[2] += 1;
                    break;
                case "RE":
                    ans[3] += 1;
                    break;
            }

        }
        Console.WriteLine("AC x " + ans[0]);
        Console.WriteLine("WA x " + ans[1]);
        Console.WriteLine("TLE x " + ans[2]);
        Console.WriteLine("RE x " + ans[3]);
    }
}
```

## C - H and V
> H行W列に並ぶマスからなるマス目があります。上からi行目、左からj列目(1≤i≤H,1≤j≤W)のマスの色は文字ci,jとして与えられ、ci,jが"."のとき白、"#"のとき黒です。
> 
> 次の操作を行うことを考えます。
> 
> 行を何行か選び(0行でもよい)、列を何列か選ぶ(0列でもよい)。そして、選んだ行に含まれるマスと、選んだ列に含まれるマスをすべて赤く塗る。
> 
> 正の整数Kが与えられます。操作後に黒いマスがちょうどK個残るような行と列の選び方は何通りでしょうか。ここで、二つの選び方は、一方においてのみ選ばれる行または列が存在するときに異なるとみなされます。
> 
> 制約
> 
> 1≤H,W≤6
> 
> 1≤K≤HW
> 
> ci,jは"."または"#"
> 
> [https://atcoder.jp/contests/abc173/tasks/abc173\_c](https://atcoder.jp/contests/abc173/tasks/abc173_c)

解説を参照しながらビット全検索で回答を作成しました。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

class Hello
{
    static void Main(string[] args)
    {
        //行数、列数、Kの値を保持する
        var HWK = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
        var rows = HWK[0];
        var cols = HWK[1];
        var k = HWK[2];
        //表内容をstring型で保持する
        var table = new string[rows];
        for (var cnt = 0; cnt < rows; cnt++)
        {
            table[cnt] = Console.ReadLine();
        }
        var ans = 0;
        var kCnt = 0;
        //行数 + 1分ループして行の全検索を実施
        //for (var i = 0; i < (1  << rows); i++)
        for (var i = 0; i < (Math.Pow(2,rows)); i++)
        {
            //列数 + 1分ループして列の全検索を実施
            //行列合わせて、最大で2^12回
            //for (var j = 0; j < (1  << cols); j++)
            for (var j = 0; j < Math.Pow(2,cols); j++)
            {
                kCnt = 0;
                for (var y = 0; y < rows; y++)
                {
                    //iをy分シフト演算して行を塗りつぶしていないかどうかチェックする
                    if ((i >> y & 1) == 1)
                    {
                        continue;
                    }
                    for (var x = 0; x < cols; x++)
                    {
                        //jをx分シフト演算して列を塗りつぶしていないかどうかチェックする
                        if ((j >> x & 1) == 1)
                        {
                            continue;
                        }
                        if (table[y][x] == '#')
                        {
                            kCnt++;
                        }
                    }
                }
                if (kCnt == k)
                {
                    ans++;
                }
            }
        }
        Console.WriteLine(ans);
    }
}
```
