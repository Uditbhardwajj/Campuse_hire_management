@echo off
echo ==========================================================
echo  Starting Apache Tomcat for Campus Placement System...
echo ==========================================================

set "JAVA_HOME=C:\Users\VIRENDRA SINGH\Downloads\jdk-25_windows-x64_bin\jdk-25.0.2"
set "CATALINA_HOME=C:\apache-tomcat-10.1.60"

call "%CATALINA_HOME%\bin\startup.bat"

echo.
echo Tomcat is starting in a background window!
echo Once started, open your browser at:
echo   http://localhost:8080/placement/
echo.
pause
