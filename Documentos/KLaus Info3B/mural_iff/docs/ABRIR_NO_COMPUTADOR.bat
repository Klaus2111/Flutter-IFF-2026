@echo off
cd /d "%~dp0"
if not exist "web_compilado\index.html" (
  echo Extraia todo o ZIP antes de abrir este arquivo.
  pause
  exit /b 1
)
echo MURAL IFF
echo Mantenha esta janela aberta e acesse http://localhost:8765 no navegador.
echo Para encerrar, pressione Ctrl+C.
echo.
where py >nul 2>&1
if not errorlevel 1 (
  py -m http.server 8765 --bind 127.0.0.1 --directory web_compilado
  goto fim
)
where python >nul 2>&1
if not errorlevel 1 (
  python -m http.server 8765 --bind 127.0.0.1 --directory web_compilado
  goto fim
)
echo Python nao encontrado. Consulte LEIA_PRIMEIRO.txt para usar Flutter
echo ou instale o APK em um celular Android.
:fim
pause
