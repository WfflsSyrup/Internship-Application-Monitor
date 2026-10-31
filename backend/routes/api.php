<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AutomationController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Automation endpoints
Route::prefix('automation')->group(function () {
    Route::get('/reminders', [AutomationController::class, 'getReminders']);
    Route::get('/incomplete-records', [AutomationController::class, 'getIncompleteRecords']);
    Route::get('/escalations', [AutomationController::class, 'getEscalations']);
    Route::get('/weekly-summary', [AutomationController::class, 'getWeeklySummary']);
});
