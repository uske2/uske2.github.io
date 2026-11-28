<#
  sync-publish.ps1
  Obsidianの 09_Publish の中身を、Hugoのサイトにコピーする。

  - 09_Publish 直下の記事（.md）        → content/posts
  - 09_Publish/pages の固定ページ（.md） → content 直下（例：about.md → content/about.md）
  - 09_Publish/images の画像            → static/images
  - 記事・固定ページの中の画像リンクは /images/ファイル名 に書き換える
    （Obsidian側の元ファイルは変更しない）
  - 09_Publish から消した記事・固定ページ・画像は、Hugo側からも消す（09_Publishと同じ状態にそろえる）
    ただし 09_Publish/pages のフォルダがないときは、固定ページには何もしない（警告だけ出す）
  - 必須プロパティがないものや、見つからない画像は警告を出す
    記事：title・date・slug　固定ページ：title・url

  準備（最初の1回だけ）:
    scripts\publish-path.txt に、09_Publish フォルダの場所を1行で書く。
    このファイルは .gitignore で除外しているので、GitHubには送られない。

  使い方（サイトのフォルダで実行）:
    powershell -ExecutionPolicy Bypass -File .\scripts\sync-publish.ps1
#>

param(
    [string]$PublishDir = '',
    [string]$SiteDir    = (Split-Path -Parent $PSScriptRoot)
)
$ErrorActionPreference = 'Stop'

# エラーで止まったときも、画面がすぐ閉じないように内容を表示して待つ
trap {
    Write-Host ""
    Write-Host "エラー: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Enterキーを押すと閉じます"
    exit 1
}

if (-not $PublishDir) {
    $pathFile = Join-Path $PSScriptRoot 'publish-path.txt'
    if (-not (Test-Path $pathFile)) { throw "scripts\publish-path.txt がありません。09_Publish の場所を1行で書いて保存してください。" }
    $PublishDir = ([System.IO.File]::ReadAllText($pathFile, [System.Text.Encoding]::UTF8)).Trim()
}

$publishDir = $PublishDir
$siteDir    = $SiteDir
$contentDir = Join-Path $siteDir 'content'
$postsDir   = Join-Path $siteDir 'content\posts'
$pagesSrc   = Join-Path $publishDir 'pages'
$imagesSrc  = Join-Path $publishDir 'images'
$imagesDst  = Join-Path $siteDir 'static\images'

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$warnings  = New-Object System.Collections.Generic.List[string]

if (-not (Test-Path $publishDir)) { throw "09_Publish が見つかりません: $publishDir" }
New-Item -ItemType Directory -Force $postsDir  | Out-Null
New-Item -ItemType Directory -Force $imagesDst | Out-Null

# ---- 画像：09_Publish/images と同じ状態にそろえる ----
$imageNames = @{}
if (Test-Path $imagesSrc) {
    Get-ChildItem $imagesSrc -File | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $imagesDst $_.Name) -Force
        $imageNames[$_.Name] = $true
    }
}
Get-ChildItem $imagesDst -File | Where-Object { -not $imageNames.ContainsKey($_.Name) } | ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Host "削除（画像）: $($_.Name)"
}

# ---- 記事・固定ページ：.md をコピーし、画像リンクを書き換える ----
#   記事    ：09_Publish 直下       → content/posts（必須：title・date・slug）
#   固定ページ：09_Publish/pages 直下 → content 直下（必須：title・url）
$items = New-Object System.Collections.Generic.List[object]
foreach ($f in Get-ChildItem $publishDir -File -Filter *.md) {
    $items.Add([pscustomobject]@{ File = $f; Label = $f.Name; Keys = @('title', 'date', 'slug'); Dest = $postsDir; IsPage = $false })
}
$hasPages = Test-Path $pagesSrc
if ($hasPages) {
    foreach ($f in Get-ChildItem $pagesSrc -File -Filter *.md) {
        $items.Add([pscustomobject]@{ File = $f; Label = "pages/$($f.Name)"; Keys = @('title', 'url'); Dest = $contentDir; IsPage = $true })
    }
} else {
    $warnings.Add("09_Publish/pages がありません。固定ページ（About）はコピーも削除もしていません")
}

$postNames = @{}
$pageNames = @{}
foreach ($item in $items) {
    $md    = $item.File
    $label = $item.Label
    $text  = [System.IO.File]::ReadAllText($md.FullName, [System.Text.Encoding]::UTF8)

    # 必須プロパティの確認（ファイル先頭の --- で囲まれた部分）
    $fm = [regex]::Match($text, '\A---\r?\n(.*?)\r?\n---', 'Singleline')
    if (-not $fm.Success) {
        $warnings.Add("${label}: 先頭にプロパティ（---で囲まれた部分）がありません")
    } else {
        foreach ($key in $item.Keys) {
            if ($fm.Groups[1].Value -notmatch "(?m)^$key\s*:\s*\S") {
                $warnings.Add("${label}: 必須プロパティ $key がありません")
            }
        }
    }

    # 画像リンク ![説明](パス) → ![説明](/images/ファイル名)
    $text = [regex]::Replace($text, '!\[([^\]]*)\]\(([^)\s]+)\)', {
        param($m)
        $target = $m.Groups[2].Value
        if ($target -match '^(https?:)?//') { return $m.Value }   # 外部の画像はそのまま
        $name = Split-Path $target -Leaf
        if (-not $imageNames.ContainsKey([uri]::UnescapeDataString($name))) {
            $warnings.Add("${label}: 画像 $([uri]::UnescapeDataString($name)) が 09_Publish/images にありません")
        }
        "![$($m.Groups[1].Value)](/images/$name)"
    })

    if ($text -match '!?\[\[[^\]]+\]\]') {
        $warnings.Add("${label}: Wikiリンク（[[ ]]）が残っています。公開先ではリンクになりません")
    }

    [System.IO.File]::WriteAllText((Join-Path $item.Dest $md.Name), $text, $utf8NoBom)
    if ($item.IsPage) { $pageNames[$md.Name] = $true } else { $postNames[$md.Name] = $true }
    Write-Host "コピー: $label"
}
Get-ChildItem $postsDir -File -Filter *.md | Where-Object { -not $postNames.ContainsKey($_.Name) } | ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Host "削除（記事）: $($_.Name)"
}
# 固定ページ：content 直下の .md だけを見る（categories・tags などのフォルダの中は触らない）
if ($hasPages) {
    Get-ChildItem $contentDir -File -Filter *.md | Where-Object { -not $pageNames.ContainsKey($_.Name) } | ForEach-Object {
        Remove-Item $_.FullName -Force
        Write-Host "削除（固定ページ）: $($_.Name)"
    }
}

Write-Host ""
Write-Host "記事 $($postNames.Count) 件、固定ページ $($pageNames.Count) 件、画像 $($imageNames.Count) 件をコピーしました。"
if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "警告 $($warnings.Count) 件:" -ForegroundColor Yellow
    $warnings | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
}

# 結果を読めるように、Enterキーが押されるまで画面を閉じない
Write-Host ""
Read-Host "Enterキーを押すと閉じます"
