---
title: "AtCoder Beginner Contest 236振り返り"
date: 2022-01-24
slug: atcoder-abc236
categories:
  - 勉強
tags:
  - AtCoder
---
2022年1月24日(日)に開催されたABC236に参加しました。ABC3問を復習します。

**A - chukodai**

> https://atcoder.jp/contests/abc236/tasks/abc236\_a

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

class Hello
{
    static void Main(string[] args)
    {
        var str = Console.ReadLine();
        var nums = Console.ReadLine().Split().Select(n => int.Parse(n)).ToArray();
        var a = str.Substring(nums[0] - 1, 1);
        var b = str.Substring(nums[1] - 1, 1);
        var cnt = 1;
        var ans = "";
        foreach(char s in str)
        {
            if (cnt == nums[0])
            {
                ans = ans + b;
            }
            else if(cnt == nums[1])
            {
                ans = ans + a;
            }
            else
            {
                ans = ans + s;
            }
            cnt++;
        }
        Console.WriteLine(ans);
    }
}
```

**B - Who is missing?**

> https://atcoder.jp/contests/abc236/tasks/abc236\_b

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

class Hello
{
    static void Main(string[] args)
    {
        var total = int.Parse(Console.ReadLine());
        var nums = Console.ReadLine().Split().Select(n => int.Parse(n)).ToArray();
        var ans = 0;
        var cdArray = new Card[total];
        
        foreach (int num in nums)
        {
            if (cdArray[num - 1] == null)
            {
                cdArray[num - 1] = new Card();
            }
            cdArray[num - 1].cd = num;
            cdArray[num - 1].cdCnt++;

        }
        foreach (Card cd in cdArray)
        {
            if (cd.cdCnt != 4)
            {
                ans = cd.cd;
                break;
            }
        }
        Console.WriteLine(ans);

    }
    public class Card
    {
        public int cd { get; set; }
        public bool flg { get; set; }
        public int cdCnt { get; set; }
    }
}
```

**C - Route Map**

> https://atcoder.jp/contests/abc236/tasks/abc236\_c

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

class Hello
{
    static void Main(string[] args)
    {
        var numsStation = Console.ReadLine().Split().Select(n => int.Parse(n)).ToArray();
        var N = numsStation[0];
        var M = numsStation[1];
        var stationSs = Console.ReadLine().Split().ToArray();
        var stationTs = Console.ReadLine().Split().ToArray();
        
        var stationArray = new Station[N];
        var Scnt = 0;
        var Tcnt = 0;
        foreach (string s in stationSs)
        {
            if (s == stationTs[Tcnt])
            {
                Console.WriteLine("Yes");
                Tcnt++;
                Scnt++;
                continue;
            }
            else
            {
                Console.WriteLine("No");
                Scnt++;
                continue;
            }
        }
    }
    public class Station
    {
        public int num { get; set; }
        public string name { get; set; }
    }
}
```
