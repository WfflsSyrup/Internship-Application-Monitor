# Week 13 - Full-Stack Automation Foundation

## Overview
Complete full-stack implementation for Internship Application Monitor with Flutter Web frontend and Laravel API backend on XAMPP/MySQL.

## Technology Stack
- **Frontend**: Flutter Web (Dart 3.9+)
- **Backend**: Laravel (PHP 8.x)
- **Database**: MySQL (via XAMPP/phpMyAdmin)
- **Server**: Apache (XAMPP)

## Database Schema

### Tables
1. **users** - All system users (students, coordinators, advisers, partner reviewers)
2. **applications** - Core applications with workflow tracking
3. **milestones** - Deadline/reminder tracking
4. **incomplete_records** - Missing documentation alerts
5. **escalations** - Stalled application escalations
6. **weekly_summaries** - Placement statistics

See migrations in `laravel_backend/database/migrations/`

## Laravel API Setup (XAMPP)

### Installation
```bash
cd laravel_backend
composer install
cp .env.example .env
php artisan key:generate
```

### Database Configuration (.env)
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=internship_monitor
DB_USERNAME=root
DB_PASSWORD=
```

### Run Migrations
```bash
php artisan migrate
```

### Start Server
```bash
php artisan serve --host=127.0.0.1 --port=8000
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/automation/reminders` | Get milestone reminders |
| GET | `/api/automation/incomplete-records` | Get incomplete record alerts |
| GET | `/api/automation/escalations` | Get stalled application escalations |
| GET | `/api/automation/weekly-summary` | Get weekly placement summaries |

## Flutter Configuration
Update `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

## Features Implemented

### Flutter UI
- Clean, minimalist responsive design
- Workflow visualization (6 stages)
- Automation dashboards for reminders, alerts, escalations, summaries
- All UI states: loading, success, empty, transient errors, business failures
- Bounded retry API service

### Laravel Backend
- RESTful API controllers
- Eloquent models with relationships
- Automated calculations (days incomplete, days stalled, placement rate)
- Proper error handling
- MySQL schema via migrations

## Testing
1. Start XAMPP (Apache + MySQL)
2. Create database `internship_monitor` in phpMyAdmin
3. Run Laravel migrations
4. Start Laravel server
5. Run Flutter app: `flutter run -d chrome`

## Week 13 Deliverables
- [x] Flutter Web UI with workflow flows
- [x] MySQL schema/migrations
- [x] Laravel API controllers and routes
- [x] API service with bounded retries
- [x] All UI states implemented
- [x] Automation features integrated
