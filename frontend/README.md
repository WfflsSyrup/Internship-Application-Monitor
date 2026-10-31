# Internship Monitor

A Flutter Web prototype for demonstrating a bounded internship application and placement workflow.

## Run the prototype

Use the Flutter SDK with web support enabled:

```sh
flutter pub get
flutter run -d chrome
```

## Demonstration workflow

The sample path runs from student application through requirements, coordinator verification, adviser endorsement, partner submission, interview status, and placement confirmation. Use the role menu in the top bar to switch among Student, Coordinator, Adviser, and Partner reviewer. The same sample application remains visible as roles hand off work.

The application form blocks empty required fields. Approval actions are limited by role and sequence. Use **Demo controls → Service unavailable** to show a failed update, restore the service, and retry it. Prototype state is held in memory for the current session.

## Scope and data

- This is a browser-based Flutter prototype with sample data; it does not connect to a backend, send email, upload real documents, or contact internship partners.
- Document checkboxes represent fictional uploaded items for demonstrating requirement verification.
- Do not enter real student information or production credentials.
- The role selector demonstrates workflow authorization in the interface only. A deployed system must enforce identity, permissions, persistence, validation, and audit history on a trusted backend.
- Optional features should not replace evidence for the normal workflow or the invalid, unauthorized, unavailable-service, and recovery paths.
