---
title: "過去問トライアル AtCoder Beginner Contest 166"
date: 2020-07-16
slug: atcoder-abc166
categories:
  - 勉強
tags:
  - AtCoder
---
ABC166のABC問題を制限時間なしで挑戦してみました。時間はかかりましたがABCすべてにACすることができました。ABC3問を復習します。

## A - A?C
> AtCoder社は、毎週土曜日にコンテストを開催しています。コンテストにはABCとARCの2つの種類があり、毎週どちらか一方が開催されます。  
> ABCが開催された次の週にはARCが開催され、ARCが行われた次の週にはABCが開催されます。  
> 先週開催されたコンテストを表す文字列Sが与えられるので、今週開催されるコンテストを表す文字列を出力してください。  
> 制約  
> SはABCまたはARC
> 
> [https://atcoder.jp/contests/abc166/tasks/abc166\_a](https://atcoder.jp/contests/abc166/tasks/abc166_a)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //入力を保持する
        var S = Console.ReadLine();
        
        if (S.Equals("ABC"))
        {
            Console.WriteLine("ARC");
            return;
        }
        if (S.Equals("ARC"))
        {
            Console.WriteLine("ABC");
            return;
        }
    }
}
```

## B - Trick or Treat
> ある街に、N人のすぬけ君(すぬけ君1 、すぬけ君2、…、すぬけ君N)が住んでいます。  
> この街には、K種類のお菓子(お菓子1、お菓子2、….、お菓子K)が売られています。  
> お菓子iを持っているのは、すぬけ君Ai,1,Ai,2,⋯,Ai,diの計di 人です。  
> 高橋君は今からこの街を回り、お菓子を 1 つも持っていないすぬけ君にいたずらをします。このとき、何人のすぬけ君がいたずらを受けるでしょうか。  
> 制約  
> 入力は全て整数  
> 1≤N≤100  
> 1≤K≤100  
> 1≤di≤N  
> 1≤Ai,1\<…\<Ai,di≤N
> 
> [https://atcoder.jp/contests/abc166/tasks/abc166\_b](https://atcoder.jp/contests/abc166/tasks/abc166_b)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //入力を保持する
        var NK = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
        //すぬけ君の数
        var N = NK[0];
        //お菓子の種類
        var K = NK[1];
        var candyFlgs = new bool[N + 1];
        //K種のお菓子分入力を受ける
        for(var n = 0;n < K; n++)
        {
            //お菓子を持っている人数分ループを実施する
            var loop = int.Parse(Console.ReadLine());
            //お菓子を持っている個人の配列を保持する
            var people = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
            for( var l = 0; l < loop; l++)
            {
                //お菓子を持っているすぬけ君をtrueとする
                candyFlgs[people[l]] = true;
            }
        }
        var ans =0;
        //お菓子を持っていないすぬけ君の数を数える
        for(var indx = 1;indx < candyFlgs.Length;indx++)
        {
            if(candyFlgs[indx] == false)
            {
                ans++;
            }
        }
        Console.WriteLine(ans);
    }
}
```

## C - Peaks
> AtCoder丘陵にはN個の展望台があり、展望台iの標高はHiです。また、異なる展望台どうしを結ぶM本の道があり、道jは展望台Ajと展望台Bjを結んでいます。  
> 展望台iが良い展望台であるとは、展望台iから一本の道を使って辿り着けるどの展望台よりも展望台iの方が標高が高いことをいいます。  
> 展望台iから一本の道を使って辿り着ける展望台が存在しない場合も、展望台iは良い展望台であるといいます。  
> 良い展望台がいくつあるか求めてください。  
> 制約  
> 2≤N≤10^5  
> 1≤M≤10^5  
> 1≤Hi≤10^9  
> 1≤Ai,Bi≤N  
> Ai≠Bi  
> 同じ展望台の組を結ぶ道が複数あることもある。  
> 入力中の値はすべて整数である。
> 
> [https://atcoder.jp/contests/abc166/tasks/abc166\_c](https://atcoder.jp/contests/abc166/tasks/abc166_c)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        
        var NM = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
        //展望台の数
        var N = NM[0];
        //道の数
        var M = NM[1];
        //高さを高さ配列に保持する
        var height = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
        var conn = new Dictionary<int,List<int>>();
        //pathをもたない展望台を記録するための配列
        var havePath = new bool[N];
        for(int num = 0;num < M;num++)
        {
            //pathの入力
            var path = Console.ReadLine().Split().Select(e => int.Parse(e)).ToArray();
            var A = path[0];
            var B = path[1];
            //起点となる展望台がすでに存在すれば行き先を追加
            // 存在しなければ生成する
            if(!conn.ContainsKey(A))
            {
                conn[A] = new List<int>();
                conn[A].Add(B);
            }
            else
            {
                conn[A].Add(B);
            }
            if(!conn.ContainsKey(B))
            {
                conn[B] = new List<int>();
                conn[B].Add(A);
            }
            else
            {
                conn[B].Add(A);
            }
            //行き先をもつ展望台を記録する
            havePath[A-1]=true;
            havePath[B-1]=true;
        }
        var ans = 0;
        //生成したDictionaryをすべてループする
        foreach(var c in conn)
        {
            //Keyとなる展望台の標高を保持する
            var heightNow = height[c.Key-1];
            var flg = true;
            foreach(var val in c.Value)
            {
                //標高が他の展望台以下であるなら回答になりえない
                if(heightNow <= height[val-1])
                {
                    flg =false;
                    break;
                }
            }
            if(flg)
            {
                ans++;
            }
        }
        Console.WriteLine(ans + havePath.Count(e => e == false));
    }
}
```
