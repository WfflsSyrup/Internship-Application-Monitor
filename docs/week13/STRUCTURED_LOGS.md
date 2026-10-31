# Structured Logs - Week 13 Automation Foundation

## Log Format
All logs use JSON structure with standard fields:
- 	imestamp: ISO 8601 UTC
- level: info|warn|error|critical
- component: frontend|backend|api_service
- event: event identifier
- correlation_id: request trace ID
- context: relevant data
- duration_ms: operation duration

## Example 1: Recovered Transient Failure (Auto-Retry Success)

`json
{
  \"timestamp\": \"2024-10-31T08:39:45.123Z\",
  \"level\": \"warn\",
  \"component\": \"api_service\",
  \"event\": \"transient_network_error_recovered\",
  \"correlation_id\": \"req_9f3a8b2c-4e5d-4a1b-9c7e-123456789abc\",
  \"context\": {
    \"endpoint\": \"/api/automation/reminders\",
    \"method\": \"GET\",
    \"attempt\": 3,
    \"max_retries\": 5,
    \"error_type\": \"TimeoutException\",
    \"error_message\": \"Request timeout\",
    \"backoff_ms\": 4000,
    \"jitter_applied\": true
  },
  \"duration_ms\": 8450,
  \"outcome\": \"success\",
  \"recovery\": {
    \"strategy\": \"exponential_backoff_with_jitter\",
    \"retries_used\": 2,
    \"total_delay_ms\": 7000
  }
}
`

**Explanation:** Request timed out on attempt 1, retried with exponential backoff (1s -> 2s -> 4s with jitter), succeeded on attempt 3. System recovered automatically without human intervention.

## Example 2: Permanent Failure Routed to Human

`json
{
  \"timestamp\": \"2024-10-31T09:12:33.456Z\",
  \"level\": \"error\",
  \"component\": \"api_service\",
  \"event\": \"permanent_business_rule_failure\",
  \"correlation_id\": \"req_7b2e9a1d-6c8f-4b3a-8e2d-987654321fed\",
  \"context\": {
    \"endpoint\": \"/api/automation/escalations\",
    \"method\": \"GET\",
    \"attempt\": 1,
    \"error_type\": \"BusinessRuleException\",
    \"error_code\": \"BUSINESS_VALIDATION_422\",
    \"error_message\": \"Business validation failed\",
    \"details\": \"Application workflow state invalid for escalation query\",
    \"status_code\": 422
  },
  \"duration_ms\": 245,
  \"outcome\": \"failure_routed_to_human\",
  \"human_intervention_required\": true,
  \"routing\": {
    \"target\": \"coordinator_dashboard\",
    \"priority\": \"high\",
    \"intervention_steps\": [
      \"Review validation errors and correct the data\",
      \"Ensure all workflow prerequisites are met\",
      \"Contact the appropriate party for required information\"
    ],
    \"ui_state\": \"business_rule_failure\"
  },
  \"alert\": {
    \"notify\": [\"coordinator\", \"system_admin\"],
    \"escalate\": true
  }
}
`

**Explanation:** Business rule violation (422) detected. Not retryable - classified as permanent failure. Routed to coordinator dashboard with explicit intervention steps. Human action required.
