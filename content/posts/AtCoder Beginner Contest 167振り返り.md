---
title: "AtCoder Beginner Contest 167振り返り"
date: 2020-06-07
slug: atcoder-abc167
categories:
  - 勉強
tags:
  - AtCoder
---
AtCoder Beginner Contest 167に参加しました。全検索を用いて解くC問題に歯が立ちませんでした。

**問題C - Skill Up**

[https://atcoder.jp/contests/abc167/tasks/abc167\_c](https://atcoder.jp/contests/abc167/tasks/abc167_c)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello{
    public static void Main()
    {
        var NMX = Console.ReadLine().Split().Select(v => int.Parse(v)).ToArray();
        var N = NMX[0];					//本の種類N
        var M = NMX[1];					//アルゴリズムの種類M
        var X = NMX[2];					//目標経験値
        var exs = new int[N, M + 1];	//経験値群の二次元配列
        var prices = new int[N];		//書籍の値段リスト
        var index = new int[N];			//全件検索チェック用の配列
		
		//書籍から得られるアルゴリズムごとの経験値を二次元配列で保持する
        for (int n = 0; n < N; n++)
        {
            var ex = Console.ReadLine().Split().Select(v => int.Parse(v)).ToArray();
            prices[n] = ex[0];
            index[n] = n;
            for (int m = 1; m < M + 1; m++)
            {
                exs[n, m-1] = ex[m];
            }
        }
        
        var ans =int.MaxValue;
		//書籍の数分ループする
        for (int cnt = 1; cnt < N + 1; cnt++)
        {
			//全件検索のためIEnumerableインターフェースを返すメソッドをループする
            foreach (var cases in CasesReturn<int>(index, cnt))
            {
                var contFlg = true;	//Xを上回っているか判断するためのフラグ
                for(var m = 0;m < M;m++)
                {
					//チェック変数ですべての書籍による経験値がXを上回っていることを確認する
                    var check = 0;
                    foreach(var c in cases)
                    {
                        check = check + exs[c,m];
                    }
                    
					//Xより下回っている場合、ループを抜ける、また継続フラグをfalseにする
                    if(check < X) 
                    {
                        contFlg = false;
                        break;
                    }
                }
                if (contFlg)
                {
					//継続フラグ==>Trueの場合、条件を満たすので、解答用変数に結果を入力する
                    var priceCheck = 0;
                    foreach(var c in cases)
                    {
                        priceCheck = priceCheck + prices[c];
                    }
                    if (priceCheck < ans)
                    {
						//最小値を算出するため、これまでの最小値であることを確かめる
                        ans = priceCheck;
                    }
                }
            }
        }
        if(ans == int.MaxValue)
        {
            Console.WriteLine("-1");
        }
        else
        {
            Console.WriteLine(ans);
        }
    }
	
	//
    public static IEnumerable<T[]> CasesReturn<T>(IEnumerable<T> prices, int cnt)
    {
		//カウントが1の場合、配列の要素をひとつずつ返却する
        if (cnt == 1)
        {
            foreach (var p in prices)
            {
                yield return new T[] { p };
            }
            yield break;
        }
        else
        {
			//カウントが1より大きい場合、再帰的にCaseReturnを呼び出す
            foreach(var p in prices)
            {
                var left = new T[] { p };
                
                //pより前にある要素をすべてスキップして要素pもスキップする
                var used = prices.SkipWhile(e => !e.Equals(p)).Skip(1).ToArray();
                foreach (var cases in CasesReturn(used,cnt-1))
                {
					//最も左側の要素と返された配列の要素を結合する
                    yield return left.Concat(cases).ToArray();
                }
            }
        }
    }
}
```

**問題D - Teleporter**

[https://atcoder.jp/contests/abc167/tasks/abc167\_d](https://atcoder.jp/contests/abc167/tasks/abc167_d)

時間には間に合いませんでしたが、後日自力で解きました。ACを出せましたが、自分で見返してもかなり可読性の低いコードになってしまいました。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello{
    public static void Main()
    {
        var NK = Console.ReadLine().Split().Select(e=>long.Parse(e)).ToArray();
        var next = Console.ReadLine().Split().Select(e=>int.Parse(e)).ToArray();
        //町の数
        var N = NK[0];
        //移動回数
        var K = NK[1];
        var comb = new Dictionary<long,Tuple<long,bool,long>>();
        for(long n=1;n<N+1;n++)
        {
            comb.Add(n,new Tuple<long,bool,long>(next[n-1],false,0L));
        }
        var ans =0;
        var nextT = 1L;
        var roopCnt = 1L;
        for(long visitCnt=K;0<visitCnt;visitCnt--)
        {
            if(comb[nextT].Item2==true)
            {
                var remain = visitCnt%(roopCnt-comb[nextT].Item3);
                for(long r=0;r<remain;r++)
                {
                    nextT =comb[nextT].Item1; 
                }
                Console.WriteLine(nextT);
                return;
            
            }
            else
            {
                long n = comb[nextT].Item1;
                comb.Remove(nextT);
                comb.Add(nextT,new Tuple<long,bool,long>(n,true,roopCnt));
            }
            roopCnt = roopCnt +1;
            nextT = comb[nextT].Item1;
        }
        Console.WriteLine(nextT);
    }
}
```

ほかの方がどのように実装しているか研究して下記のコードを見つけました。（一部手を加えて修正しています。）これだけ短くきれいに書けるようになりたいものです。

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class FootPrint
{

    public long First { get; set; }
    public FootPrint(long t)
    {
        First = t;
    }
}
public class AtCoder
{

    public static void Main()
    {
        //入力を保持する
        var input = Console.ReadLine().Split().Select(e => long.Parse(e)).ToArray();
        var N = input[0];
        var K = input[1];

        var teleport = Console.ReadLine().Split().Select(e => long.Parse(e)).ToArray();

        var position = 1L;
        var count = 0L;
        var footprints = new FootPrint[N];
        footprints[0] = new FootPrint(0);

        for (var i = K - 1; i >= 0; i--)
        {
            position = teleport[position - 1];
            count++;
            if (footprints[position - 1] != null)
            {
                i = i % (count - footprints[position - 1].First);
            }
            else 
            {
                footprints[position - 1] = new FootPrint(count);
            }
        }
        Console.WriteLine(position);
    }
}
```
