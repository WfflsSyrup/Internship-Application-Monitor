# Internship Application Monitor - Setup & Run Instructions

## Prerequisites
- [XAMPP](https://www.apachefriends.org/) with PHP 8.x, MySQL, Apache
- [Composer](https://getcomposer.org/)
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.9+)
- [Git](https://git-scm.com/)

## Project Structure
`
internship_monitor/
├── backend/        # Laravel API (XAMPP)
├── frontend/       # Flutter Web
└── docs/           # Documentation
`

## 1. Backend Setup (Laravel + XAMPP)

### Step 1: Start XAMPP
1. Open XAMPP Control Panel
2. Start **Apache** and **MySQL**

### Step 2: Create Database
1. Open phpMyAdmin: http://localhost/phpmyadmin
2. Create a new database named: internship_monitor
3. Collation: utf8mb4_unicode_ci

### Step 3: Configure Laravel
`ash
# Navigate to backend
cd backend

# Install dependencies
composer install

# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate
`

### Step 4: Update .env
Edit ackend/.env:
`env
APP_NAME="Internship Monitor"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=internship_monitor
DB_USERNAME=root
DB_PASSWORD=
`

### Step 5: Run Migrations
`ash
php artisan migrate
`

### Step 6: Start Laravel Server
`ash
php artisan serve --host=127.0.0.1 --port=8000
`

Backend will run at: http://localhost:8000

Test API: http://localhost:8000/api/automation/reminders

## 2. Frontend Setup (Flutter Web)

### Step 1: Install Dependencies
`ash
# Navigate to frontend
cd frontend

# Get packages
flutter pub get
`

### Step 2: Configure API URL
Check rontend/lib/core/constants/api_constants.dart:
`dart
static const String baseUrl = 'http://localhost:8000/api';
`

Should already point to localhost:8000.

### Step 3: Run on Chrome
`ash
flutter run -d chrome
`

Or build for web:
`ash
flutter build web
# Serve from build/web/
`

## 3. Quick Start (Both Services)

### Terminal 1 - Backend
`ash
cd backend
php artisan serve --host=127.0.0.1 --port=8000
`

### Terminal 2 - Frontend
`ash
cd frontend
flutter run -d chrome
`

## Troubleshooting

### Backend Issues
- **Migration fails**: Ensure MySQL is running and database exists
- **Port 8000 in use**: Use php artisan serve --port=8001 and update Flutter API URL
- **Composer errors**: Run composer update or check PHP version

### Frontend Issues
- **CORS errors**: Laravel should handle CORS for API routes. Check config/cors.php
- **Connection refused**: Ensure backend is running on correct port
- **Build errors**: Run lutter clean && flutter pub get

### XAMPP Issues
- **Apache/MySQL won't start**: Check port conflicts (80, 443, 3306)
- **Access denied**: Default MySQL user is root with no password

## Testing Week 13 Features

1. Start both backend and frontend
2. Navigate to Automation Dashboard in Flutter app
3. Test all four sections:
   - Milestone Reminders
   - Incomplete Record Alerts
   - Stalled Application Escalations
   - Weekly Placement Summary
4. Test retry logic by stopping backend briefly

## API Endpoints
| Endpoint | Method | Description |
|----------|--------|-------------|
| /api/automation/reminders | GET | Milestone reminders |
| /api/automation/incomplete-records | GET | Incomplete record alerts |
| /api/automation/escalations | GET | Stalled escalations |
| /api/automation/weekly-summary | GET | Weekly placement summary |
