---
title: "AtCoder Beginner Contest 172振り返り"
date: 2020-07-09
slug: atcoder-abc172
categories:
  - 勉強
tags:
  - AtCoder
---
AtCoder Beginner Contest172に参加しました。今回も前回と同じくB問題までは開始早々解くことができました。しかしC問題を解くことができませんでした。当初の目標としてD問題までを継続的に解く実力をつけることでしたが、目標を下方修正し、まずはC問題までを安定して解くことを目指そうと思います。

## A - Calc
> 整数aが入力されます。値a+a^2+a^3 を出力してください。
> 
> 制約
> 
> 1≤a≤10
> 
> a は整数である。
> 
> [https://atcoder.jp/contests/abc172/tasks/abc172\_a](https://atcoder.jp/contests/abc172/tasks/abc172_a)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        var a = int.Parse(Console.ReadLine());
        var ans = Math.Pow(a, 1) + Math.Pow(a, 2) + Math.Pow(a, 3);
        Console.WriteLine(ans);
    }
}
```

## B - Minor Change
> 文字列S,Tが与えられます。
> 
> 次の操作を繰り返してSをTに変更するとき、操作回数の最小値を求めてください。
> 
> 操作：Sの1文字を選んで別の文字に書き換える
> 
> 制約
> 
> S,Tは長さ1以上2×10^5以下
> 
> S,Tは英小文字のみからなる
> 
> SとTの長さは等しい
> 
> [https://atcoder.jp/contests/abc172/tasks/abc172\_b](https://atcoder.jp/contests/abc172/tasks/abc172_b)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        var S = Console.ReadLine();
        var T = Console.ReadLine();
        var ans = 0;
        for (var chaCnt = 0; chaCnt < S.Length; chaCnt++)
        {
            if (S[chaCnt] != T[chaCnt])
            {
                ans++;
            }
        }Console.WriteLine(ans);
    }
}
```

## **C - Tsundoku**
> 二台の机A,Bがあります。
> 
> 机AにはN冊の本が、机BにはM冊の本が、それぞれ縦に積まれています。
> 
> 机Aに現在上からi番目に積まれている本(1≤i≤N)は読むのにAi分を要し、机Bに現在上からi番目に積まれている本 (1≤i≤M)は読むのにBi分を要します。
> 
> 次の行為を考えます。
> 
> 本が残っている机を選び、その机の最も上に積まれた本を読んで机から取り除く。
> 
> 合計所要時間が K 分を超えないようにこの行為を繰り返すとき、最大で何冊の本を読むことができるでしょうか。
> 
> 本を読むこと以外に要する時間は無視します。
> 
> 制約
> 
> 1≤N,M≤200000
> 
> 1≤K≤10^9
> 
> 1≤Ai,Bi≤10^9
> 
> 入力中の値はすべて整数である。
> 
> [https://atcoder.jp/contests/abc172/tasks/abc172\_c](https://atcoder.jp/contests/abc172/tasks/abc172_c)

所要時間内で最大で何冊読むことができるかはAB上にある本を上から順番に所要時間の短いものを選んでいけば回答が得られると考えました。しかし、この解釈では下記のような入力ときに誤答となってしまいます。

2 2 4  
3 1  
2 3

この時正解は2となりますが、自分が提出した下記のコードでは回答が1となってしまいます。コンテスト時間内に解釈の誤りに気づけませんでした。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
		//AB上の本の冊数及び制限時間を保持する
        var NMK = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
        var cntA = NMK[0];
        var cntB = NMK[1];
        var min = NMK[2];
		//本の所要時間配列
        var minAs = Console.ReadLine().Split().Select(e => int.Parse(e)).ToList();
        var minBs = Console.ReadLine().Split().Select(e => int.Parse(e)).ToList();
        var ans = 0;
        var minArray = new int[cntA + cntB];
        var a = 0;
        var b = 0;
		//ABの冊数分入力できるminArray配列を作成する
        for (var num = 0; num < cntA + cntB; num++)
        {
			//A上に本が存在しない場合
            if (a == cntA)
            {
                minArray[num] = minBs[b];
                b += 1;
                continue;
            }
			//B上に本が存在しない場合
            if (b == cntB)
            {
                minArray[num] = minAs[a];
                a += 1;
                continue;
            }
            if (minAs[a] <= minBs[b])
            {
                minArray[num] = minAs[a];
                a += 1;
            }
            else
            {
                minArray[num] = minBs[b];
                b += 1;
            }
        }
		//配列の最初から制限時間内に何冊読めるのかカウントしていく
        foreach (var val in minArray)
        {
            if (min - val < 0) break;
            ans++;
            min -= val;                
        }
        Console.WriteLine(ans);
    }
}
```

解説に目を通しながら、写経を実施しました。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //AB上にある本の冊数、および所要時間を保持する
        var HWK = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
        var aCnt = HWK[0];
        var bCnt = HWK[1];
        var k = HWK[2];
        var aArray = Console.ReadLine().Split().Select(e => long.Parse(e)).ToArray();
        var bArray = Console.ReadLine().Split().Select(e => long.Parse(e)).ToArray();
        //AB上の本にかかる所要時間を累積和で保存しておく
        var sumA = new long[aCnt + 1];
        var sumB = new long[bCnt + 1];
        //0冊読んだ場合からN冊読んだ場合までの累積和配列を作成
        for (var i = 1; i <= aCnt; i++)
        {
            sumA[i] = sumA[i - 1] + aArray[i - 1];
        }
        for (var i = 1; i <= bCnt; i++)
        {
            sumB[i] = sumB[i - 1] + bArray[i - 1];
        }
        var ans = 0;
        var j = bCnt;
		//A上の本の冊数(i)が0の場合からNの場合まで検証する
        for (var i = 0; i <= aCnt; i++)
        {
            if (sumA[i] > k) continue;
			//B上の本の冊数(j)がMの場合から0の場合まで検証する
            while (sumB[j] > k - sumA[i])
            {
                j--;
            }
            ans = Math.Max(ans, i + j);
        }
        Console.WriteLine(ans);
    }
}
```

問題文の意図を素早く正確に理解できるよう反復して継続していきます。
