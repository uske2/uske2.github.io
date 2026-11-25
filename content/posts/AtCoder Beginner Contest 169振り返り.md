---
title: "AtCoder Beginner Contest 169振り返り"
date: 2020-06-17
slug: atcoder-abc169
categories:
  - 勉強
tags:
  - AtCoder
---
AtCoder Beginner Contest169に参加しました。結果はA問題しか解けませんでした。B、C問題までは解きたかったのですが残念です。目標はコンスタントにD問題までをACできることなので、まだまだ道のりは長そうです。

今回はA、B、C問題を振り返ります。

## A - Multiplication 1
> 値A×Bを整数として出力せよ。
> 
> [https://atcoder.jp/contests/abc169/tasks/abc169\_a](https://atcoder.jp/contests/abc169/tasks/abc169_a)

A問題は特に問題なくだれでも解けます。そして今回はこれしか解けませんでした。汗

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class AtCoder
{
    public static void Main()
    {
        //入力を保持する
        var AB = Console.ReadLine().Split().Select(v => int.Parse(v)).ToArray();
        var A = AB[0];
        var B = AB[1];

        Console.WriteLine((A * B).ToString());
    }
}
```

## B - Multiplication 2
> 問題文N個の整数A1,…,ANが与えられます。
> 
> A1×…×AN を求めてください。
> 
> ただし、結果が 10^18 を超える場合は、代わりに -1 を出力してください。
> 
> 制約
> 
> 2≤N≤10^5
> 
> 0≤Ai≤10^18
> 
> 入力は全て整数である。
> 
> [https://atcoder.jp/contests/abc169/tasks/abc169\_b](https://atcoder.jp/contests/abc169/tasks/abc169_b)

桁があふれたときにどのように拾えばいいのか全く見当がつきませんでした。結果として大量のWAを出し、あえなく撃沈しました。

解説をみたところ、C#での解法としては下記の２通りがあるようです。

### 多倍長整数を使用する
BigInteger構造体の何たるかをまずは下記のサイトで勉強しました。

[https://docs.microsoft.com/ja-jp/dotnet/api/system.numerics.biginteger?view=netcore-3.1](https://docs.microsoft.com/ja-jp/dotnet/api/system.numerics.biginteger?view=netcore-3.1)

[https://smdn.jp/programming/netfx/mathematics/2\_biginteger/](https://smdn.jp/programming/netfx/mathematics/2_biginteger/)

BitInteger構造体を使用して回答した結果、ACとなりました。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
public class AtCoder
{

    public static void Main()
    {
        //入力を保持する
        var N = int.Parse(Console.ReadLine());
        var As = Console.ReadLine().Split().Select(e => BigInteger.Parse(e)).ToArray();
        //Array.Sort(As);
        foreach (var a in As)
        {
            if (a == 0)
            {
                Console.WriteLine(0);
                return;
            }
        }
        BigInteger ans = 1;
        for (int i = 0; i < N; i++)
        {
            BigInteger work = ans * As[i];
            if (work > 1000000000000000000)
            {
                ans = -1;
                break;
            }
            ans = ans * As[i];
        }
        Console.WriteLine(ans);
    }
}
```

### 除算で10^18を超えたかどうかの判定をする
もうひとつの方法は除算を使用して桁あふれを拾う方法です。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class AtCoder
{

    public static void Main()
    {
        //入力を保持する
        var N = int.Parse(Console.ReadLine());
        var As = Console.ReadLine().Split().Select(e => long.Parse(e)).ToArray();
        //Array.Sort(As);
        foreach (var a in As)
        {
            if (a == 0)
            {
                Console.WriteLine(0);
                return;
            }
        }
        long ans = 1;
        for (int i = 0; i < N; i++)
        {
            //1000000000000000000 < ans * As[i]の式を変形させて
            //--> 1000000000000000000 / As[i] < ans とすることで64bit整数型で対応可能となる。
            if (1000000000000000000 / As[i] < ans)
            {
                ans = -1;
                break;
            }
            ans = ans * As[i];
        }
        Console.WriteLine(ans);
    }
}
```

## C - Multiplication 3
> A×Bの小数点以下を切り捨て、結果を整数として出力してください。
> 
> 制約
> 
> 0≤A≤10^15
> 
> 0≤B\<10
> 
> Aは整数
> 
> Bは小数第2位まで与えられる
> 
> [https://atcoder.jp/contests/abc169/tasks/abc169\_c](https://atcoder.jp/contests/abc169/tasks/abc169_c)

double型を使用して単純計算を試みるもWA。  
かなり初歩的なことですが、2進浮動小数点数の無限小数について考えが及んでいませんでした。  
もう一度double型(64bit型浮動小数点数点型)ではなぜこの問題に対応できなかったのか下記のサイトを使用して復習しました。C#での対応策はdecimal型(128bit浮動小数点数)で対応する、または整数化する方法です。

[https://dobon.net/vb/dotnet/beginner/floatingpointerror.html](https://dobon.net/vb/dotnet/beginner/floatingpointerror.html)

decimal型(128bit浮動小数点数)で対応する方法は単純計算でACになるので割愛します。

### 整数化する
```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //入力を保持する
        var AB = Console.ReadLine().Split().ToArray();
        var A = long.Parse(AB[0]);
        var B = long.Parse(AB[1].Replace(".",""));
        Console.WriteLine(A * B/100);
    }
}

```

double型で入力を保持しようとするとその瞬間に誤差が生じてしまいます。そこで小数点を消去してから整数型に変換して最後に100除算しています。

C問題を通して、浮動小数点数の計算について、さらなる勉強の必要性を感じました。
