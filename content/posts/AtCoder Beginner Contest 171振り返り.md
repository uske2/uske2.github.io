---
title: "AtCoder Beginner Contest 171振り返り"
date: 2020-07-04
slug: atcoder-abc171
categories:
  - 勉強
tags:
  - AtCoder
---
AtCoder Beginner Contest171に参加しました。B問題までは15分ほどで解けましたが、C問題を解くことができませんでした。。

今回はA、B、C問題を振り返ります。

## A - αlphabet
> 英大文字か英小文字のいずれか1文字αが入力されます。αが英大文字なら'A'、英小文字なら'a'と出力してください。
> 
> 制約
> 
> αは英大文字('A' - 'Z')または英小文字('a' - 'z')である。
> 
> [https://atcoder.jp/contests/abc171/tasks/abc171\_a](https://atcoder.jp/contests/abc171/tasks/abc171_a)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //入力を保持する
        var chara = Char.Parse(Console.ReadLine());
        if (Char.IsUpper(chara))
        {
            Console.WriteLine("A");
        }
        else
        {
            Console.WriteLine("a");
        }
    }
}
```

## B - Mix Juice
> ある店でN種類の果物、果物1,…,Nが売られており、それぞれの価格は一個あたりp1,…,pN円です。
> 
> この店でK種類の果物を一個ずつ買うとき、それらの合計価格として考えられる最小の金額を求めてください。
> 
> 制約
> 
> 1≤K≤N≤1000
> 
> 1≤pi≤1000
> 
> 入力中の値はすべて整数である。
> 
> [https://atcoder.jp/contests/abc171/tasks/abc171\_b](https://atcoder.jp/contests/abc171/tasks/abc171_b)

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
        //果物の種類
        var N = NK[0];
        //選択する数
        var K = NK[1];
        //価格をあらかじめソートしておく
        var Ps = Console.ReadLine().Split().Select(e => int.Parse(e)).OrderBy(e => e).ToArray();
        var ans = 0;
        //小さい順になっているのでK回ループして回答とする
        for (var n = 0; n < K; n++)
        {
            ans += Ps[n];
        }
        Console.WriteLine(ans);
    }
}
```

## C - One Quadrillion and One Dalmatians
本問に苦戦して最終的に解くことができませんでした。こういった数学的な要素が入った問題では、地道に似た問題をコツコツ解いて力をつけていくことが大切だと思いました。

本問の復習に取り組む前に他の競技プログラミングサイトの類似問題に取り組むことにしました。こちらの問題のほうが素直で理解に役立つと考えたからです。

> 0から始まる数値Nを対応するアルファベット列に変換したいです。アルファベット列とは,26文字の大文字アルファベットで数値を表現したものです。具体的には以下のような順序になります。(カンマごとに1つのアルファベット列です）
> 
> A,B,C,…,Z,AA,AB,…,AZ,BA,BB,…,ZZ,AAA,…,ZZZ,AAAA,…整数Nが与えられるのでN番目のアルファベット列を求めてください。
> 
> [https://yukicoder.me/problems/no/327](https://yukicoder.me/problems/no/327)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //アルファベットテーブルを作成する
        var alpha = new string[26] { "A", "B", "C", "D", "E",
                                     "F", "G", "H", "I", "J", "K",
                                     "L", "M", "N", "O", "P", "Q",
                                     "R", "S", "T", "U", "V", "W", 
                                     "X", "Y", "Z" };
        var N = long.Parse(Console.ReadLine());
        var e = 1L;
        var cnt = 1;
		//while (26 <= N)
		//=> 最初このような書き方をしていたが、
		//この書き方だとN=701のようなときNが負の値になってしまい、実行時エラーとなる。
        while (e * 26 <= N)
        {
            N = N- (long)Math.Pow(26, cnt);
			//26の階乗の数より小さいかチェックするための変数を設ける
            e *=26;
            cnt++;
        }        
        var ans = "";
		//最後尾の文字列から順に回答を組み立てていく
        for(int num=cnt-1;0<=num;num--)
        {
            ans=ans +alpha[N%26];
            N /= 26;
        }
        Console.WriteLine(String.Join("", ans.Reverse()));
    }
}
```

その後、C問題に取り掛かりました。

> ロジャーは、彼のもとに突如現れた1000000000000001匹の犬をすべて飼うことを決意しました。
> 
> 犬たちにはもともと 1から1000000000000001までの番号がふられていましたが、ロジャーは彼らに以下のルールで名前を授けました。
> 
> 1,2,,26番の番号がついた犬はその順に a,b,…,z と命名されます。
> 
> 27,28,29,⋯,701,702番の番号がついた犬はその順にaa,ab,ac,…,zy,zzと命名されます。
> 
> 703,704,705,⋯,18277,18278 番の番号がついた犬はその順に aaa,aab,aac,…,zzy,zzzと命名されます。
> 
> 18279,18280,18281,⋯,475253,475254 番の番号がついた犬はその順に aaaa,aaab,aaac,…,zzzy,zzzzと命名されます。
> 
> 475255,475256,⋯ 番の番号がついた犬はその順に aaaaa,aaaab,…と命名されます。(以下省略)
> 
> つまり、ロジャーが授けた名前を番号順に並べると:a,b,…,z,aa,ab,…,az,ba,bb,…,bz,…,za,zb,…,zz,aaa,aab,…,aaz,aba,abb,…,abz,…,zzz,aaaa,… のようになります。
> 
> ロジャーはあなたに問題を出しました。「番号 N の犬の名前を答えよ。」
> 
> 制約
> 
> Nは整数1≤N≤1000000000000001
> 
> [https://atcoder.jp/contests/abc171/tasks/abc171\_c](https://atcoder.jp/contests/abc171/tasks/abc171_c)

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
public class Hello
{
    public static void Main()
    {
        //アルファベットテーブルを作成する
        var alpha = new string[26] { "a", "b", "c", "d", "e",
                                     "f", "g", "h", "i", "j", "k",
                                     "l", "m", "n", "o", "p", "q",
                                     "r", "s", "t", "u", "v", "w",
                                     "x", "y", "z" };
        var N = long.Parse(Console.ReadLine());
        var e = 1L;
        var cnt = 1;
        while (e * 26 < N)
        {
            N = N - (long)Math.Pow(26, cnt);
            //26の階乗の数より小さいかチェックするための変数を設ける
            e *= 26;
            cnt++;
        }
        N--;
        var ans = "";
        //最後尾の文字列から順に回答を組み立てていく
        for (int num = cnt - 1; 0 <= num; num--)
        {
            ans = ans + alpha[N % 26];
            N /= 26;
        }
        //順番が逆順なので反転して直す
        Console.WriteLine(String.Join("", ans.Reverse()));
    }
}
```
