---
title: "AtCoder Beginner Contest 188振り返り"
date: 2021-04-23
slug: atcoder-abc188
categories:
  - 勉強
tags:
  - AtCoder
---
2021年1月10日(日)に開催されたABC188に参加しました。ABC3問を復習します。

## A - Three-Point Shot
> バスケットボールの試合が行われており、現在の両チームの得点はX対Yです。  
> ここでX≠Yであることが保証されます。現在劣勢であるチームが、3ポイントシュートを一本成功させて優勢に立つことはできますか？  
> つまり、現在得点が低い側のチームが3点を得た場合、そのチームの得点が他方のチームの得点より真に高くなるかを判定してください。  
> ◆制約  
> 0≤X≤100  
> 0≤Y≤100  
> X≠Y  
> X,Yは整数である
> 
> [https://atcoder.jp/contests/abc188/tasks/abc188\_a](https://atcoder.jp/contests/abc188/tasks/abc188_a)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

class Hello
{
    static void Main(string[] args)
    {
        //X,Yの値を保持する
        var X_Y = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();
        var X = X_Y[0];
        var Y = X_Y[1];
        //回答用変数
        var ans = "No";
        if (X < Y)
        {
            if (Y < X + 3)
            {
                ans = "Yes";
            }
        }
        else
        {
            if (X < Y + 3)
            {
                ans = "Yes";
            }
        }
        Console.WriteLine(ans);
    }
}
```

## **B - Orthogonality**
> 2つのN次元ベクトルA=(A1,A2,A3,…,AN),B=(B1,B2,B3,…,BN)が与えられます。AとBの内積が0かどうかを判定してください。  
> すなわち、A1B1+A2B2+A3B3+⋯+ANBN=0 かどうかを判定してください。  
> ◆制約  
> 1≤N≤100000  
> −100≤Ai≤100  
> −100≤Bi≤100  
> 入力に含まれる値は全て整数である
> 
> [https://atcoder.jp/contests/abc188/tasks/abc188\_b](https://atcoder.jp/contests/abc188/tasks/abc188_b)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

class Hello
{
    static void Main(string[] args)
    {
        //Nの値を保持する
        //var X_Y = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();
        var N = int.Parse(Console.ReadLine());
        //AとBの値を保持する
        var As = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();
        var Bs = Console.ReadLine().Split().Select(x => int.Parse(x)).ToArray();
        //Nの数分ループしてAiとBiの積の和を計算する
        var ans = 0;
        for (int i = 0; i < N; i++)
        {
            ans += As[i] * Bs[i];
        }
        if (ans == 0)
        {
            Console.WriteLine("Yes");
        }
        else
        {
            Console.WriteLine("No");
        }
    }
}
```

## C - ABC Tournament
> 選手1から選手2^Nまでの2^N人の選手がトーナメント形式のプログラミング対決をします。  
> 選手iのレートはAiです。  
> どの2人の選手のレートも異なり、2人の選手が対戦すると常にレートが高い方が勝ちます。  
> トーナメント表は完全二分木の形をしています。  
> より正確には、このトーナメントは以下の要領で行われます。  
> i=1,2,3,…,Nについて順に、以下のことが行われる。  
> 各整数 j(1≤j≤2^(N−i)) について、まだ負けたことのない選手のうち、 2j−1番目に番号の小さい選手と2j番目に番号の小さい選手が対戦する。  
> 準優勝する、すなわち最後に行われる対戦において負ける選手の番号を求めてください。  
> ◆制約  
> 1≤N≤16  
> 1≤Ai≤10^9  
> Aiは相異なる  
> 入力に含まれる値は全て整数である
> 
> [https://atcoder.jp/contests/abc188/tasks/abc188\_c](https://atcoder.jp/contests/abc188/tasks/abc188_c)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
//using System.Array;
class Hello
{
    static void Main(string[] args)
    {
        //Nの値を保持する
        var N = (int)Math.Pow(2,int.Parse(Console.ReadLine()));
        //トーナメントの右左のブロックで最強のメンバーを特定するためNの半分の値を保持する
	var half = N/2;
        var orgArray = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
        var aArray = new int[half];
        var bArray = new int[half];
	//全参加者の半分ずつ（トーナメントの半分ずつ）で分ける
        Array.Copy(orgArray,0,aArray,0,half);
        Array.Copy(orgArray,half,bArray,0,half);
	//各ブロックの最強メンバーを特定する
        var aMax = aArray.Max();
        var bMax = bArray.Max();
        if(aMax < bMax)
        {
	    //Bブロック(全メンバーの後半)の優勝ならAブロックの最強メンバーが優勝
            Console.WriteLine(Array.IndexOf(aArray,aMax)+1);
        }
        else
        {
	    //Aブロック(全メンバーの前半)の優勝ならBブロックの最強メンバーが優勝
            Console.WriteLine(Array.IndexOf(bArray,bMax)+1+half);
        }
    }
}
```
