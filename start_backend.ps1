#!/usr/bin/env pwsh
# Start the MyScheme Backend Server

Write-Host "Starting MyScheme Backend Server..." -ForegroundColor Green

# Check if Python is installed
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ Python found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Python not found. Please install Python." -ForegroundColor Red
    exit 1
}

# Check if required packages are installed
Write-Host "`nChecking Python packages..." -ForegroundColor Cyan
$packagesCheck = python -c "import flask; import flask_cors; import requests; print('OK')" 2>&1

if ($packagesCheck -ne "OK") {
    Write-Host "✗ Required packages not found. Installing..." -ForegroundColor Yellow
    pip install -r backend/requirements.txt
} else {
    Write-Host "✓ All packages installed" -ForegroundColor Green
}

# Start the backend server
Write-Host "`nStarting backend server on http://localhost:5000..." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server`n" -ForegroundColor Yellow

python backend/server.py
