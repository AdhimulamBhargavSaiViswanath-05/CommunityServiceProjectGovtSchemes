# MyScheme App - Complete Startup Script
# Starts both backend and frontend

Write-Host "🚀 Starting MyScheme App" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

# Check if backend is already running
$backendRunning = Get-Process python -ErrorAction SilentlyContinue | Where-Object {$_.MainWindowTitle -like "*server.py*"}
if ($backendRunning) {
    Write-Host "✅ Backend already running on port 5000" -ForegroundColor Green
} else {
    Write-Host "🐍 Starting Backend Server..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\backend'; python server.py"
    Start-Sleep -Seconds 3
    Write-Host "✅ Backend started on http://localhost:5000" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎯 Select platform to run Flutter app:" -ForegroundColor Cyan
Write-Host "1. Chrome (Web)" -ForegroundColor White
Write-Host "2. Windows (Desktop)" -ForegroundColor White
Write-Host "3. Android Emulator" -ForegroundColor White
Write-Host ""
$choice = Read-Host "Enter choice (1-3)"

Write-Host ""
switch ($choice) {
    "1" { 
        Write-Host "🌐 Starting on Chrome..." -ForegroundColor Yellow
        flutter run -d chrome 
    }
    "2" { 
        Write-Host "🖥️  Starting on Windows..." -ForegroundColor Yellow
        flutter run -d windows 
    }
    "3" { 
        Write-Host "📱 Starting on Android..." -ForegroundColor Yellow
        flutter run 
    }
    default { 
        Write-Host "❌ Invalid choice. Defaulting to Chrome..." -ForegroundColor Red
        flutter run -d chrome 
    }
}
