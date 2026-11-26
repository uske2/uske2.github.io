@echo off
rem ブログの公開：コピー用スクリプト → hugo server で確認 → コメントを入力してプッシュ
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0publish.ps1"
