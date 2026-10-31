# Workflow Boundary Map - Internship Application Monitor (Week 13)

## System Boundaries

### Frontend (Flutter Web)
- **Trust Level**: Untrusted client
- **Responsibilities**:
  - UI rendering and state management
  - Client-side validation (non-authoritative)
  - Retry orchestration with user feedback
  - Error classification and presentation
- **Boundaries**: Only communicates via HTTP to Laravel API

### Backend (Laravel API on XAMPP)
- **Trust Level**: Trusted server (authoritative)
- **Responsibilities**:
  - Business logic enforcement
  - Data validation and authorization
  - State transitions in workflow
  - Automation calculations
  - Audit logging
- **Boundaries**: Authenticates requests, validates business rules

### Database (MySQL)
- **Trust Level**: Trusted data store
- **Responsibilities**:
  - Persistent state
  - Referential integrity
  - Transactional consistency
- **Boundaries**: Only accessed by Laravel ORM/Eloquent

### External Dependencies
- **XAMPP Stack**: Apache + PHP 8.x + MySQL (local development)
- **HTTP Client**: Dart http package
- **State Management**: Flutter Provider
- **None in production scope**: Email/SMS/External APIs not integrated

## Trusted Inputs
| Source | Inputs | Validation |
|--------|--------|------------|
| Authenticated API requests | User tokens, resource IDs | Laravel middleware validation |
| Form submissions | Application data, status updates | Server-side validation rules |
| Automation triggers | Scheduled queries | Internal system calls |

## Untrusted Inputs
| Source | Inputs | Handling |
|--------|--------|----------|
| Flutter client | All request payloads | Re-validated server-side, never trust client state |
| URL parameters | IDs, filters | Sanitized and validated |
| Query strings | Pagination/sorting | Whitelisted parameters only |

## Workflow Boundaries
`
Student (Client) -> Flutter UI -> API Service (Retry) -> Laravel Routes -> Controllers -> Models -> MySQL
                                                                           ↓
                                                                      Automation Logic
                                                                           ↓
                                                                      JSON Response
`

## Security Boundaries
- CORS configured on Laravel (API routes)
- No sensitive data logged in client
- Server-side authorization checks required for mutations
- Business rule violations classified as permanent failures (require human intervention)
