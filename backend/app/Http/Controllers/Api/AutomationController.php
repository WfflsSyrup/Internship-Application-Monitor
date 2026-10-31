<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Milestone;
use App\Models\IncompleteRecord;
use App\Models\Escalation;
use App\Models\WeeklySummary;
use Illuminate\Http\JsonResponse;
use Carbon\Carbon;

class AutomationController extends Controller
{
    /**
     * Get milestone reminders for students
     */
    public function getReminders(): JsonResponse
    {
        try {
            $reminders = Milestone::with(['application.student'])
                ->where('is_completed', false)
                ->whereDate('due_date', '>=', Carbon::today())
                ->orderBy('due_date', 'asc')
                ->orderBy('priority', 'desc')
                ->get()
                ->map(function ($milestone) {
                    return [
                        'id' => $milestone->id,
                        'student_name' => $milestone->application->student->name ?? 'N/A',
                        'student_id' => $milestone->application->student->student_id ?? 'N/A',
                        'reminder_type' => $milestone->type,
                        'message' => $milestone->title . ': ' . $milestone->description,
                        'due_date' => $milestone->due_date->format('Y-m-d'),
                        'is_completed' => $milestone->is_completed,
                        'priority' => $milestone->priority,
                    ];
                });

            return response()->json($reminders);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch reminders'], 500);
        }
    }

    /**
     * Get incomplete records alerts
     */
    public function getIncompleteRecords(): JsonResponse
    {
        try {
            $records = IncompleteRecord::with(['student', 'application'])
                ->where('resolved', false)
                ->orderBy('severity', 'desc')
                ->orderBy('days_incomplete', 'desc')
                ->get()
                ->map(function ($record) {
                    // Update days incomplete
                    $record->days_incomplete = Carbon::parse($record->created_at)->diffInDays(Carbon::now());
                    $record->save();

                    return [
                        'id' => $record->id,
                        'student_name' => $record->student->name ?? 'N/A',
                        'student_id' => $record->student->student_id ?? 'N/A',
                        'missing_field' => $record->missing_field,
                        'record_type' => $record->record_type,
                        'severity' => $record->severity,
                        'days_incomplete' => $record->days_incomplete,
                        'last_updated' => $record->updated_at->format('Y-m-d'),
                    ];
                });

            return response()->json($records);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch incomplete records'], 500);
        }
    }

    /**
     * Get stalled application escalations
     */
    public function getEscalations(): JsonResponse
    {
        try {
            $escalations = Escalation::with(['student', 'application', 'assignee'])
                ->whereIn('status', ['open', 'in_progress'])
                ->orderBy('escalation_level', 'desc')
                ->orderBy('days_stalled', 'desc')
                ->get()
                ->map(function ($escalation) {
                    // Update days stalled
                    $escalation->days_stalled = Carbon::parse($escalation->escalated_at)->diffInDays(Carbon::now());
                    $escalation->save();

                    return [
                        'id' => $escalation->id,
                        'student_name' => $escalation->student->name ?? 'N/A',
                        'student_id' => $escalation->student->student_id ?? 'N/A',
                        'application_id' => $escalation->application_id,
                        'escalation_reason' => $escalation->escalation_reason,
                        'escalation_level' => $escalation->escalation_level,
                        'status' => $escalation->status,
                        'assigned_to' => $escalation->assignee->name ?? 'Unassigned',
                        'days_stalled' => $escalation->days_stalled,
                        'escalated_at' => $escalation->escalated_at->format('Y-m-d'),
                    ];
                });

            return response()->json($escalations);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch escalations'], 500);
        }
    }

    /**
     * Get weekly placement summaries
     */
    public function getWeeklySummary(): JsonResponse
    {
        try {
            $summaries = WeeklySummary::orderBy('week_start', 'desc')
                ->limit(4)
                ->get()
                ->map(function ($summary) {
                    // Calculate placement rate
                    if ($summary->total_applications > 0) {
                        $summary->placement_rate = round(
                            ($summary->placements_confirmed / $summary->total_applications) * 100,
                            2
                        );
                        $summary->save();
                    }

                    return [
                        'id' => $summary->id,
                        'week_label' => $summary->week_label,
                        'week_start' => $summary->week_start->format('Y-m-d'),
                        'week_end' => $summary->week_end->format('Y-m-d'),
                        'total_applications' => $summary->total_applications,
                        'applications_submitted' => $summary->applications_submitted,
                        'applications_reviewed' => $summary->applications_reviewed,
                        'interviews_scheduled' => $summary->interviews_scheduled,
                        'offers_received' => $summary->offers_received,
                        'placements_confirmed' => $summary->placements_confirmed,
                        'rejected' => $summary->rejected,
                        'pending_review' => $summary->pending_review,
                        'placement_rate' => $summary->placement_rate,
                    ];
                });

            return response()->json($summaries);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch weekly summary'], 500);
        }
    }
}
