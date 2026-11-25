---
title: "AtCoder Beginner Contest 170振り返り"
date: 2020-06-21
slug: atcoder-abc170
categories:
  - 勉強
tags:
  - AtCoder
---
AtCoder Beginner Contest170に参加しました。結果は前回と同じくA問題しか解けませんでした。。。精進します。

今回はA、B、C、D問題を振り返ります。

## A - Five Variables
> 5つの変数x1,x2,x3,x4,x5があります。最初、変数xiには整数iが代入されていました。すぬけくんは、これらの変数の中から1つを選んで、その変数に0を代入する操作を行いました。すぬけくんがこの操作を行ったあとの 5つの変数の値が与えられます。すぬけくんが0を代入した変数がどれであったかを答えてください。
> 
> 制約
> 
> 入力として与えられるx1,x2,x3,x4,x5の値は、すぬけくんが操作を行ったあとのものとしてありえるものである。
> 
> [https://atcoder.jp/contests/abc170/tasks/abc170\_a](https://atcoder.jp/contests/abc170/tasks/abc170_a)

0が代入されているインデックス-1を出力しました。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //入力を保持する
        var input = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
        var ans = 0;
        for (var n = 1; n <= input.Length; n++)
        {
            if (input[n - 1] == 0)
            {
                ans = n;
                break;
            }
        }
        Console.WriteLine(ans);
    }
}
```

## B - Crane and Turtle
> 庭に何匹かの動物がいます。これらはそれぞれ、2本の足を持つ鶴か4本の足を持つ亀のいずれかです。高橋くんは、「庭の動物の総数はX匹で、それらの足の総数はY本である」と発言しています。この発言が正しいような鶴と亀の数の組合せが存在するか判定してください。
> 
> 制約
> 
> 1≤X≤100
> 
> 1≤Y≤100
> 
> 入力中のすべての値は整数である。
> 
> [https://atcoder.jp/contests/abc170/tasks/abc170\_b](https://atcoder.jp/contests/abc170/tasks/abc170_b)

まず考えたことは鶴亀の組み合わせをすべて検証するという方法です。ですが具体的にどのように全検索を実現すればいいのかを考えあぐねているうちに時間だけが過ぎていきました。ともかく手を動かそうと別の方法を採用するに至りました。下記がそのコードです。WAではじかれました。この方法では分岐処理が多くなりすぎてしまいます。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello{
    public static void Main()
    {
        //入力を保持する
        var input = Console.ReadLine().Split().Select(v => int.Parse(v)).ToArray();
        var heads =input[0];
        var legs =input[1];
        
        var tempHeads = legs/4;
        var tempLegs = legs%4;
        
        if((tempHeads == 0 && tempLegs==2)&&(heads == 1))
        {
            Console.WriteLine("Yes");
            return;
        }
        if(tempLegs%2 == 1)
        {
            Console.WriteLine("No");
            return;
        }
        else
        {
            if(tempHeads == heads)
            {
                Console.WriteLine("Yes");
                return;
            }
        }
        
        
        while(true)
        {
            tempHeads = tempHeads-1;
            tempLegs = tempLegs + 4;
            if(tempHeads < 0)
            {
                Console.WriteLine("No");
                return;
            }
            if(tempHeads + (tempLegs/2) == heads)
            {
                Console.WriteLine("Yes");
                return;
            }
            if(tempHeads == 0)
            {
                break;
            }
        }
        Console.WriteLine("No");
    }
}

```

競技終了後解説を参照すると、全検索して求める方法が紹介さていました。自分なりにコーディングしてみるとACすることができました。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //入力を保持する
        var input = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
        //鶴のカウントとして控えておく
        var c = input[0];
        var legs = input[1];
        //亀は0匹スタートとする
        int t = 0;
        for (var n = 0; n <= input[0]; n++)
        {
            if (4 * t + 2 * c == legs)
            {
                Console.WriteLine("Yes");
                return;
            }
            c -= 1;
            t += 1;
        }
        Console.WriteLine("No");
    }
}
```

## **C - Forbidden List**
> 整数Xと、長さNの整数列p1,…,pNが与えられます。
> 
> 整数列p1,…,pNに含まれない整数(正とは限らない)のうちXに最も近いもの、つまりXとの差の絶対値が最小のものを求めてください。そのような整数が複数存在する場合は、そのうち最も小さいものを答えてください。
> 
> 制約
> 
> 1≤X≤100
> 
> 0≤N≤100
> 
> 1≤pi≤100
> 
> p1,…,pNはすべて異なる。
> 
> 入力中のすべての値は整数である。
> 
> [https://atcoder.jp/contests/abc170/tasks/abc170\_c](https://atcoder.jp/contests/abc170/tasks/abc170_c)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //入力を保持する
        var XN = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
        var X = XN[0];
        var N = XN[1];
        //Ps配列が空の場合はXを出力して回答とする
        if (N == 0)
        {
            Console.WriteLine(X);
            return;
        }
        var Ps = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
        //Psを昇順に並び替える
        Array.Sort(Ps);
        //NのPs内に存在するかチェック
        var idx = Array.IndexOf(Ps, X);
        //NがPs配列に存在しない場合はXを出力して回答とする
        if (idx == -1)
        {
            Console.WriteLine(X);
            return;
        }
        //Ps内に含まれないXに最も近い数字を±1をしながら検索する
        var n = 1;
        while (true)
        {
            if (Array.IndexOf(Ps, X - n) == -1)
            {
                Console.WriteLine(X - n);
                break;
            }
            if (Array.IndexOf(Ps, X + n) == -1)
            {
                Console.WriteLine(X + n);
                break;
            }
            n += 1;
        }
    }
}

```

## D - Not Divisible
> 長さNの数列Aが与えられます。
> 
> 次の性質を満たす整数i(1≤i≤N)の数を答えてください。
> 
> i≠jである任意の整数j(1≤j≤N)についてAiはAjで割り切れない。
> 
> 制約
> 
> 入力は全て整数
> 
> 1≤N≤2×10^5
> 
> 1≤Ai≤10^6
> 
> [https://atcoder.jp/contests/abc170/tasks/abc170\_d](https://atcoder.jp/contests/abc170/tasks/abc170_d)

まず最初に考えたのは任意のAについてその他のAによって割り切れるかどうかチェックしていく方法ですが、Aの数は2\*10^5ありうるためTLEしてしまいます。そこから先、自分ではどう頭をひねっても適切な解答方法が絞り出せませんでした。  
解説を参照してみると、割り切れない=任意のAがその他のAの約数になっていない、という見方をすればよいのだとわかりました。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //入力を保持する
        var N = int.Parse(Console.ReadLine());
        var As = Console.ReadLine().Split().Select(e => int.Parse(e)).OrderBy(e => e).ToArray();
        //As配列内に1が1つ存在している場合は1以外は1によりすべて割り切れるため1が回答となる
        if ((As.Count(e => e == 1) == 1))
        {
            Console.WriteLine("1");
            return;
        }
        //1が1よりも多く存在している場合、1も1で割り切れるため0が回答となる
        if ((As.Count(e => e == 1) > 1))
        {
            Console.WriteLine("0");
            return;
        }
        //As配列に含まれる数字の数をカウントするためNがとりうる最大の数分配列を準備する
        var cnt = new int[1000001];
        for (var num = 0; num < N; num++)
        {
            cnt[As[num]] = cnt[As[num]] + 1;
        }
        //Asに含まれる数字の倍数すべてをbool型で保持する
        //-->割り切れないというのは言い換えればAiがその他の数の倍数にならないということ
        var baisuFlgs = new bool[1000001];
        for (var num = 0; num < N; num++)
        {
            var temp = As[num];
            while(temp + As[num] <= 1000000)
            {
                temp = temp + As[num];
                baisuFlgs[temp] = true;
            }
        }
        //cnt配列内にAiの数が1であり、かつbaisuFlags配列内にAiの倍数のインデックスがFalseであればカントアップしていく
        var ans = 0;
        foreach (var i in As)
        {
            if (baisuFlgs[i] == false && cnt[i] == 1)
            {
                ans = ans + 1;
            }
        }
        Console.WriteLine(ans);
    }
}

```
