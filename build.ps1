# ==========================================================
# CampusHire Build & Deployment Script for Apache Tomcat
# ==========================================================

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Building College Placement System (CampusHire) " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Detect JDK
$jdkPath = $null
$possibleJdks = @(
    "C:\Users\VIRENDRA SINGH\Downloads\jdk-25_windows-x64_bin\jdk-25.0.2",
    $env:JAVA_HOME,
    "C:\Program Files\Java\jdk-21",
    "C:\Program Files\Java\jdk-17"
)

foreach ($p in $possibleJdks) {
    if ($p -and (Test-Path "$p\bin\javac.exe")) {
        $jdkPath = $p
        break
    }
}

if (-not $jdkPath) {
    $whereJavac = where.exe javac 2>$null
    if ($whereJavac) {
        $jdkPath = Split-Path (Split-Path $whereJavac[0] -Parent) -Parent
    }
}

if (-not $jdkPath) {
    Write-Error "JDK not found! Please specify JDK path."
    exit 1
}

$javac = "$jdkPath\bin\javac.exe"
$jar = "$jdkPath\bin\jar.exe"
Write-Host "[+] Using JDK from: $jdkPath" -ForegroundColor Green

# 2. Detect Tomcat
$tomcatPath = $null
$possibleTomcats = @(
    "C:\apache-tomcat-10.1.60",
    $env:CATALINA_HOME
)

foreach ($t in $possibleTomcats) {
    if ($t -and (Test-Path "$t\lib\servlet-api.jar")) {
        $tomcatPath = $t
        break
    }
}

if (-not $tomcatPath) {
    Write-Error "Tomcat 10 not found! Please check Tomcat installation."
    exit 1
}

$servletJar = "$tomcatPath\lib\servlet-api.jar"
$jspJar = "$tomcatPath\lib\jsp-api.jar"
Write-Host "[+] Using Tomcat from: $tomcatPath" -ForegroundColor Green

# 3. Locate MySQL Connector JAR
$mysqlJar = "src\main\webapp\WEB-INF\lib\mysql-connector-j.jar"
if (-not (Test-Path $mysqlJar)) {
    $srcMysql = "C:\Users\VIRENDRA SINGH\Downloads\mysql-connector-j-26.7.0\mysql-connector-j-26.7.0\mysql-connector-j-26.7.0.jar"
    if (Test-Path $srcMysql) {
        Copy-Item $srcMysql -Destination $mysqlJar -Force
    }
}

# 4. Prepare Build Directories
$targetDir = "target"
$classesDir = "src\main\webapp\WEB-INF\classes"
if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir | Out-Null }
if (-not (Test-Path $classesDir)) { New-Item -ItemType Directory -Path $classesDir -Force | Out-Null }

# Copy resources (db.properties) into classes directory
Copy-Item "src\main\resources\*" -Destination $classesDir -Recurse -Force
Write-Host "[+] Copied resources (db.properties) into classes directory" -ForegroundColor Green

# 5. Compile Java Source Files
$javaFiles = Get-ChildItem -Path "src\main\java" -Filter "*.java" -Recurse | ForEach-Object { "`"$($_.FullName.Replace('\', '/'))`"" }

Write-Host "[+] Compiling $($javaFiles.Count) Java source files..." -ForegroundColor Yellow
$javaSourcesFile = "$targetDir/sources.txt"
$javaFiles | Out-File -FilePath $javaSourcesFile -Encoding ASCII

& $javac -cp "$servletJar;$jspJar;$mysqlJar" -d $classesDir "@$javaSourcesFile"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Compilation failed!"
    exit 1
}
Write-Host "[+] Java sources compiled successfully into $classesDir" -ForegroundColor Green

# 6. Package WAR File
$warFilePath = Join-Path (Get-Location).Path "target\placement.war"
if (Test-Path $warFilePath) { Remove-Item $warFilePath -Force }

Write-Host "[+] Packaging WAR file to $warFilePath..." -ForegroundColor Yellow
Push-Location "src\main\webapp"
try {
    & $jar -cvf "$warFilePath" * | Out-Null
} finally {
    Pop-Location
}

if (Test-Path $warFilePath) {
    $warSize = (Get-Item $warFilePath).Length / 1MB
    Write-Host "[+] WAR created successfully: $warFilePath ($([math]::Round($warSize, 2)) MB)" -ForegroundColor Green
}

# 7. Deploy to Apache Tomcat webapps
$deployTarget = "$tomcatPath\webapps\placement.war"
Copy-Item $warFilePath -Destination $deployTarget -Force
Write-Host "[+] Deployed directly to Apache Tomcat: $deployTarget" -ForegroundColor Green

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host " BUILD & LOCAL DEPLOYMENT SUCCESSFUL! " -ForegroundColor Green
Write-Host " Application URL: http://localhost:8080/placement/ " -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan
