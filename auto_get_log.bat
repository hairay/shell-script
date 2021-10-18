:start

SET Y=%date:~0,4%
SET M=%date:~5,2%
SET D=%date:~8,2%
SET Hour=%time:~0,2%
SET Min=%time:~3,2%
SET IP=%1%

ECHO "netlog_%Y%%M%%D%_%Hour%%Min%.txt"
rem START /B nc64 -w 6000 %IP% 5547 > "netlog_%Y%%M%%D%_%Hour%%Min%.txt"
nc64 -w 6000 %IP% 5547 > "netlog_%Y%%M%%D%_%Hour%%Min%.txt"

rem timeout /t 7200 /nobreak
rem taskkill /f /im nc64.exe
rem taskkill /f /im nc64.exe
rem taskkill /f /im nc64.exe
rem taskkill /f /im nc64.exe
goto start


