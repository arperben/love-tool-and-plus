@echo off
git add .
git commit -m "Mise a jour automatique"
git push -u origin main -f
git push -u origin main
pause