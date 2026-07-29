@echo off
setlocal
set "FLUTTER_EXE=C:\Users\james\Downloads\flutter\bin\flutter.bat"
if not exist "%FLUTTER_EXE%" (
  echo Flutter SDK not found at "%FLUTTER_EXE%".
  exit /b 1
)
call "%FLUTTER_EXE%" %*
