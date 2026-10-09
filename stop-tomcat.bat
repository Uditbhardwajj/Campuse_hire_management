@echo off
echo ==========================================================
echo  Stopping Apache Tomcat...
echo ==========================================================

set "JAVA_HOME=C:\Users\VIRENDRA SINGH\Downloads\jdk-25_windows-x64_bin\jdk-25.0.2"
set "CATALINA_HOME=C:\apache-tomcat-10.1.60"

call "%CATALINA_HOME%\bin\shutdown.bat"

echo Tomcat stopped.
pause
