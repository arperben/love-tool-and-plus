@echo off
git add .
git commit -m "Mise a jour automatique"
git pull origin main --rebase
git push -u origin main
pause