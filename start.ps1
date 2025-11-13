# MyScheme App - Quick Start Script
# This script starts the backend and Flutter app

Write-Host "=" -ForegroundColor Cyan -NoNewline
Write-Host ("="*59) -ForegroundColor Cyan
Write-Host "MyScheme App - Quick Start" -ForegroundColor Cyan
Write-Host "=" -ForegroundColor Cyan -NoNewline
Write-Host ("="*59) -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Python
Write-Host "[1] Checking Python..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "   [OK] $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "   [ERROR] Python not found. Please install Python 3.7+" -ForegroundColor Red
    exit 1
}

# Step 2: Check Flutter
Write-Host "`n[2] Checking Flutter..." -ForegroundColor Yellow
$flutterVersion = flutter --version 2>&1 | Select-Object -First 1
if ($LASTEXITCODE -eq 0) {
    Write-Host "   [OK] $flutterVersion" -ForegroundColor Green
} else {
    Write-Host "   [ERROR] Flutter not found. Please install Flutter SDK" -ForegroundColor Red
    exit 1
}

# Step 3: Install Python dependencies
Write-Host "`n[3] Installing Python dependencies..." -ForegroundColor Yellow
Set-Location backend
$pipInstall = pip install -r requirements.txt 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "   [OK] Dependencies installed" -ForegroundColor Green
} else {
    Write-Host "   [WARN] Some dependencies may have failed. Continuing..." -ForegroundColor Yellow
}
Set-Location ..

# Step 4: Start Backend Server
Write-Host "`n[4] Starting Python backend server..." -ForegroundColor Yellow
Write-Host "   Backend will run at http://localhost:5000" -ForegroundColor Cyan

# Start backend in new window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\backend'; python server.py"
Write-Host "   [OK] Backend started in new window" -ForegroundColor Green

# Wait for backend to start
Write-Host "`nWaiting for backend to initialize (5 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Step 5: Test Backend
Write-Host "`n[5] Testing backend health..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000/health" -TimeoutSec 5 -ErrorAction Stop
    $data = $response.Content | ConvertFrom-Json
    Write-Host "   [OK] $($data.message)" -ForegroundColor Green
} catch {
    Write-Host "   [WARN] Backend may still be starting. Check the backend window." -ForegroundColor Yellow
}

# Step 6: Ask user how to run Flutter
Write-Host "`n[6] Choose Flutter run option:" -ForegroundColor Yellow
Write-Host "   1. Chrome (Web)" -ForegroundColor Cyan
Write-Host "   2. Windows (Desktop)" -ForegroundColor Cyan
Write-Host "   3. Skip (Run manually later)" -ForegroundColor Cyan
Write-Host ""
$choice = Read-Host "   Enter choice (1-3)"

switch ($choice) {
    "1" {
        Write-Host "`nStarting Flutter app in Chrome..." -ForegroundColor Yellow
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; flutter run -d chrome"
        Write-Host "   [OK] Flutter app started in new window" -ForegroundColor Green
    }
    "2" {
        Write-Host "`nStarting Flutter app on Windows..." -ForegroundColor Yellow
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; flutter run -d windows"
        Write-Host "   [OK] Flutter app started in new window" -ForegroundColor Green
    }
    "3" {
        Write-Host "`nSkipped. Run manually:" -ForegroundColor Yellow
        Write-Host "   flutter run -d chrome" -ForegroundColor Cyan
    }
    default {
        Write-Host "`n[WARN] Invalid choice. Run manually:" -ForegroundColor Yellow
        Write-Host "   flutter run -d chrome" -ForegroundColor Cyan
    }
}

# Final Instructions
Write-Host "`n" -NoNewline
Write-Host "=" -ForegroundColor Cyan -NoNewline
Write-Host ("="*59) -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "=" -ForegroundColor Cyan -NoNewline
Write-Host ("="*59) -ForegroundColor Cyan
Write-Host ""
Write-Host "What's Running:" -ForegroundColor Yellow
Write-Host "   - Backend: http://localhost:5000" -ForegroundColor Cyan
Write-Host "   - Flutter: Check the new window(s)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Test Backend:" -ForegroundColor Yellow
Write-Host "   python backend/test_backend.py" -ForegroundColor Cyan
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Yellow
Write-Host "   - CORS_SOLUTION_SUMMARY.md - Quick overview" -ForegroundColor Cyan
Write-Host "   - BACKEND_SETUP.md - Detailed setup guide" -ForegroundColor Cyan
Write-Host "   - WHY_PYTHON_WORKS_DART_FAILS.md - Full explanation" -ForegroundColor Cyan
Write-Host ""
Write-Host "To Stop:" -ForegroundColor Yellow
Write-Host "   Close the backend and Flutter windows" -ForegroundColor Cyan
Write-Host "=" -ForegroundColor Cyan -NoNewline
Write-Host ("="*59) -ForegroundColor Cyan
Write-Host ""
