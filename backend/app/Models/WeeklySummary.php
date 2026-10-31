<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class WeeklySummary extends Model
{
    use HasFactory;

    protected $fillable = [
        'week_label',
        'week_start',
        'week_end',
        'total_applications',
        'applications_submitted',
        'applications_reviewed',
        'interviews_scheduled',
        'offers_received',
        'placements_confirmed',
        'rejected',
        'pending_review',
        'placement_rate',
    ];

    protected $casts = [
        'week_start' => 'date',
        'week_end' => 'date',
        'placement_rate' => 'decimal:2',
    ];
}
