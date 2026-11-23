<#
  sync-publish.ps1
  Obsidianの 09_Publish の中身を、Hugoのサイトにコピーする。

  - 09_Publish 直下の記事（.md）      → content/posts
  - 09_Publish/images の画像          → static/images
  - 記事の中の画像リンクは /images/ファイル名 に書き換える
    （Obsidian側の元ファイルは変更しない）
  - 09_Publish から消した記事・画像は、Hugo側からも消す（09_Publishと同じ状態にそろえる）
  - 必須プロパティ（title・date・slug）がない記事や、見つからない画像は警告を出す

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
$postsDir   = Join-Path $siteDir 'content\posts'
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

# ---- 記事：09_Publish 直下の .md をコピーし、画像リンクを書き換える ----
$postNames = @{}
foreach ($md in Get-ChildItem $publishDir -File -Filter *.md) {
    $text = [System.IO.File]::ReadAllText($md.FullName, [System.Text.Encoding]::UTF8)

    # 必須プロパティの確認（ファイル先頭の --- で囲まれた部分）
    $fm = [regex]::Match($text, '\A---\r?\n(.*?)\r?\n---', 'Singleline')
    if (-not $fm.Success) {
        $warnings.Add("$($md.Name): 先頭にプロパティ（---で囲まれた部分）がありません")
    } else {
        foreach ($key in 'title', 'date', 'slug') {
            if ($fm.Groups[1].Value -notmatch "(?m)^$key\s*:\s*\S") {
                $warnings.Add("$($md.Name): 必須プロパティ $key がありません")
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
            $warnings.Add("$($md.Name): 画像 $([uri]::UnescapeDataString($name)) が 09_Publish/images にありません")
        }
        "![$($m.Groups[1].Value)](/images/$name)"
    })

    if ($text -match '!?\[\[[^\]]+\]\]') {
        $warnings.Add("$($md.Name): Wikiリンク（[[ ]]）が残っています。公開先ではリンクになりません")
    }

    [System.IO.File]::WriteAllText((Join-Path $postsDir $md.Name), $text, $utf8NoBom)
    $postNames[$md.Name] = $true
    Write-Host "コピー: $($md.Name)"
}
Get-ChildItem $postsDir -File -Filter *.md | Where-Object { -not $postNames.ContainsKey($_.Name) } | ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Host "削除（記事）: $($_.Name)"
}

Write-Host ""
Write-Host "記事 $($postNames.Count) 件、画像 $($imageNames.Count) 件をコピーしました。"
if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "警告 $($warnings.Count) 件:" -ForegroundColor Yellow
    $warnings | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
}

# 結果を読めるように、Enterキーが押されるまで画面を閉じない
Write-Host ""
Read-Host "Enterキーを押すと閉じます"
