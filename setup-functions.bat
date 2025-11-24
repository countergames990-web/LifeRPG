@echo off
echo Setting up Netlify Functions for LifeRPG...
echo.

cd netlify\functions

echo Installing dependencies...
call npm install

echo.
echo Setup complete!
echo.
echo To test locally:
echo   1. Install Netlify CLI: npm install -g netlify-cli
echo   2. Run: netlify dev
echo.
echo To deploy:
echo   1. Connect your repo to Netlify
echo   2. Push to your Git repository
echo   3. Netlify will automatically deploy
echo.
pause
