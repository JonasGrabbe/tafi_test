@echo off
cd /d "%~dp0"
Rscript run_level_selection.R
if errorlevel 1 (
  echo.
  echo The analysis failed. Review the error message above.
  pause
  exit /b 1
)
echo.
echo Analysis completed.
pause
