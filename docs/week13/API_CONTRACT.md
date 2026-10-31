# API Contract - Internship Application Monitor (Week 13)

## Base URL
`
http://localhost:8000/api
`

## Automation Endpoints

### 1. GET /automation/reminders
Retrieves milestone reminders for upcoming deadlines.

**Request:**
- Method: GET
- Headers: Content-Type: application/json
- Auth: Not required (Week 13 scope)
- Query Params: None

**Response (200 OK):**
`json
[
  {
    \"id\": 1,
    \"student_name\": \"John Doe\",
    \"student_id\": \"STU-2024-001\",
    \"reminder_type\": \"document_submission\",
    \"message\": \"Resume Submission: Submit updated resume\",
    \"due_date\": \"2024-10-15\",
    \"is_completed\": false,
    \"priority\": \"high\"
  }
]
`

**Status Codes:**
- 200 OK - Success
- 500 Internal Server Error - Database/query failure

---

### 2. GET /automation/incomplete-records
Retrieves alerts for incomplete application records.

**Request:**
- Method: GET
- Headers: Content-Type: application/json

**Response (200 OK):**
`json
[
  {
    \"id\": 1,
    \"student_name\": \"Jane Smith\",
    \"student_id\": \"STU-2024-002\",
    \"missing_field\": \"endorsement_letter\",
    \"record_type\": \"application\",
    \"severity\": \"critical\",
    \"days_incomplete\": 7,
    \"last_updated\": \"2024-10-08\"
  }
]
`

**Status Codes:**
- 200 OK - Success
- 500 Internal Server Error - Database/query failure

---

### 3. GET /automation/escalations
Retrieves stalled application escalations requiring action.

**Request:**
- Method: GET
- Headers: Content-Type: application/json

**Response (200 OK):**
`json
[
  {
    \"id\": 1,
    \"student_name\": \"Mike Johnson\",
    \"student_id\": \"STU-2024-003\",
    \"application_id\": 10,
    \"escalation_reason\": \"No response from partner for 14 days\",
    \"escalation_level\": 3,
    \"status\": \"open\",
    \"assigned_to\": \"Coordinator Sarah\",
    \"days_stalled\": 14,
    \"escalated_at\": \"2024-09-27\"
  }
]
`

**Status Codes:**
- 200 OK - Success
- 500 Internal Server Error - Database/query failure

---

### 4. GET /automation/weekly-summary
Retrieves weekly placement statistics.

**Request:**
- Method: GET
- Headers: Content-Type: application/json

**Response (200 OK):**
`json
[
  {
    \"id\": 1,
    \"week_label\": \"Week 42 - Oct 2024\",
    \"week_start\": \"2024-10-14\",
    \"week_end\": \"2024-10-20\",
    \"total_applications\": 45,
    \"applications_submitted\": 38,
    \"applications_reviewed\": 35,
    \"interviews_scheduled\": 22,
    \"offers_received\": 15,
    \"placements_confirmed\": 12,
    \"rejected\": 8,
    \"pending_review\": 10,
    \"placement_rate\": 26.67
  }
]
`

**Status Codes:**
- 200 OK - Success
- 500 Internal Server Error - Database/query failure

## Error Response Format
`json
{
  \"error\": \"Failed to fetch reminders\"
}
`

## Notes
- All timestamps are in ISO 8601 format (Y-m-d)
- Automation endpoints are read-only in Week 13 scope
- Business logic calculations performed server-side
- Client must handle all response states
