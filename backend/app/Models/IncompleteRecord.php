<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class IncompleteRecord extends Model
{
    use HasFactory;

    protected $fillable = [
        'application_id',
        'student_id',
        'missing_field',
        'record_type',
        'severity',
        'days_incomplete',
        'resolved',
        'resolved_at',
    ];

    protected $casts = [
        'resolved' => 'boolean',
        'resolved_at' => 'datetime',
    ];

    public function application()
    {
        return $this->belongsTo(Application::class);
    }

    public function student()
    {
        return $this->belongsTo(User::class, 'student_id');
    }
}
