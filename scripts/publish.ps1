<#
publish.ps1
ブログの公開を、確認からプッシュまで一続きで行う。

  1. コピー用スクリプト（sync-publish.ps1）を実行する
  2. hugo server を別の画面で起動し、ブラウザで開く
  3. 確認が終わったら Enter → hugo server を止める
  4. 変更されたファイルを一覧にし、個人情報・位置情報（GPS）を確かめる
  5. プッシュするか聞き、コミットのコメントを入力してもらう
  6. git add → commit → push

使い方：scripts\publish.cmd をダブルクリックする
個人情報の確認に自分の名前などを足すときは、scripts\private-words.txt に1行1語で書く
（このファイルは .gitignore で除外しているので、GitHub には送られない）
#>
$ErrorActionPreference = 'Stop'
$siteDir = Split-Path -Parent $PSScriptRoot
Set-Location $siteDir

function Stop-Here([string]$message) {
    Write-Host ""
    Write-Host $message -ForegroundColor Yellow
    Read-Host "Enterキーを押すと閉じます"
    exit 1
}

trap {
    Write-Host ""
    Write-Host "エラー: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Enterキーを押すと閉じます"
    exit 1
}

# ---- 1. コピー用スクリプト ----
Write-Host "[1/4] コピー用スクリプトを実行します（09_Publish → content/posts・content直下の固定ページ・static/images）" -ForegroundColor Cyan
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'sync-publish.ps1')
if ($LASTEXITCODE -ne 0) { Stop-Here "コピー用スクリプトでエラーが出たため、ここで止めます。" }

# ---- 2. hugo server ----
Write-Host ""
Write-Host "[2/4] hugo server を別の画面で起動します。ブラウザで http://localhost:1313/ が開きます。" -ForegroundColor Cyan
$hugo = Start-Process hugo -ArgumentList 'server', '--openBrowser' -WorkingDirectory $siteDir -PassThru
Write-Host ""
Write-Host "ブラウザで表示を確かめてください。"
Write-Host "  見るところ：タイトル・日付、見出しと目次、画像、リンク、カテゴリー・タグのページ"
Write-Host ""
Read-Host "確認が終わったら Enter を押してください（hugo server を止めます）"
if (-not $hugo.HasExited) { Stop-Process -Id $hugo.Id -Force -ErrorAction SilentlyContinue }

# ---- 3. 変更の一覧と、プッシュ前の確認 ----
Write-Host ""
Write-Host "[3/4] 変更されたファイルを確かめます" -ForegroundColor Cyan
$status = @(git -c core.quotepath=false status --porcelain --untracked-files=all)
if ($status.Count -eq 0) { Stop-Here "変更はありません。プッシュするものがないので終わります。" }
$status | ForEach-Object { Write-Host "  $_" }

# 確認する対象：消したファイル以外
$files = @($status | Where-Object { $_ -notmatch '^ ?D' } | ForEach-Object {
    $p = $_.Substring(3); if ($p -match ' -> ') { $p = ($p -split ' -> ')[-1] }; $p.Trim('"')
})

# 個人情報の目印（一般的なもの ＋ private-words.txt）
$patterns = @('[A-Za-z]:\\Users\\', 'OneDrive', '[\w.+-]+@[\w-]+\.[\w.]+')
$wordsFile = Join-Path $PSScriptRoot 'private-words.txt'
if (Test-Path $wordsFile) {
    $patterns += [IO.File]::ReadAllLines($wordsFile, [Text.Encoding]::UTF8) |
        Where-Object { $_.Trim() } | ForEach-Object { [regex]::Escape($_.Trim()) }
}
$textExt = '.md', '.toml', '.html', '.txt', '.css', '.js', '.json', '.yml', '.yaml', '.xml', '.cmd', '.ps1'
$imageExt = '.jpg', '.jpeg', '.png', '.tif', '.tiff'
$skipCheck = 'scripts/publish.ps1'   # 目印の書き方そのものが入っているため対象外
Add-Type -AssemblyName System.Drawing

$warnings = New-Object System.Collections.Generic.List[string]
foreach ($f in $files) {
    $full = Join-Path $siteDir $f
    if (-not (Test-Path $full -PathType Leaf)) { continue }
    $ext = [IO.Path]::GetExtension($f).ToLower()
    if ($textExt -contains $ext -and $f -ne $skipCheck) {
        $lines = [IO.File]::ReadAllLines($full, [Text.Encoding]::UTF8)
        for ($i = 0; $i -lt $lines.Count; $i++) {
            foreach ($pat in $patterns) {
                if ($lines[$i] -match $pat) {
                    # 記事にふつうに出てくるメールアドレス風の文字列（例：画像名の @2x）も拾うので、目で判断する
                    $warnings.Add("${f}:$($i + 1)  「$($Matches[0])」")
                }
            }
        }
    }
    elseif ($imageExt -contains $ext) {
        $img = [Drawing.Image]::FromFile($full)
        try { if ($img.PropertyIdList -contains 0x8825) { $warnings.Add("${f}  位置情報（GPS）が残っています") } }
        finally { $img.Dispose() }
    }
}

if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "注意：公開すると困る情報かもしれないものが見つかりました。" -ForegroundColor Yellow
    $warnings | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
    $ans = Read-Host "このままプッシュしてよければ yes と入力してください（それ以外で中止）"
    if ($ans -ne 'yes') { Stop-Here "中止しました。直してから、もう一度実行してください。" }
}
else {
    Write-Host "  個人情報・位置情報（GPS）は見つかりませんでした。" -ForegroundColor Green
}

# ---- 4. コメントを入力して、コミット・プッシュ ----
Write-Host ""
Write-Host "[4/4] プッシュして公開します" -ForegroundColor Cyan
$ans = Read-Host "上の変更をプッシュして公開しますか？ (y/n)"
if ($ans -notin 'y', 'Y') { Stop-Here "プッシュせずに終わります。変更はパソコンの中に残っています。" }

Write-Host "コミットのコメントを入力してください（例：記事を追加：記事のタイトル）。何も入れずに Enter で中止します。"
$message = (Read-Host "コメント").Trim()
if (-not $message) { Stop-Here "コメントが空なので、プッシュせずに終わります。" }

# 日本語のコメントが崩れないよう、ファイル（UTF-8）経由で渡す
$msgFile = [IO.Path]::GetTempFileName()
[IO.File]::WriteAllText($msgFile, $message, (New-Object Text.UTF8Encoding $false))
try {
    git add -A
    if ($LASTEXITCODE -ne 0) { Stop-Here "git add に失敗しました。" }
    git commit -F $msgFile
    if ($LASTEXITCODE -ne 0) { Stop-Here "git commit に失敗しました。" }
}
finally { Remove-Item $msgFile -ErrorAction SilentlyContinue }

git push
if ($LASTEXITCODE -ne 0) {
    Stop-Here "git push に失敗しました。コミットはできているので、原因を直してから git push だけ実行してください。"
}

$repo = (git remote get-url origin) -replace '\.git$', ''
Write-Host ""
Write-Host "プッシュしました。数分後に https://uske2.github.io/ に反映されます。" -ForegroundColor Green
Write-Host "公開の進み具合：$repo/actions （緑のチェックが付けば完了）"
Read-Host "Enterキーを押すと閉じます"
