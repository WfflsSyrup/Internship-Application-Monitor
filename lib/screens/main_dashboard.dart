import 'package:flutter/material.dart';

enum _DemoRole { student, coordinator, adviser, partnerReviewer }

extension on _DemoRole {
  String get label => switch (this) {
    _DemoRole.student => 'Student',
    _DemoRole.coordinator => 'Coordinator',
    _DemoRole.adviser => 'Adviser',
    _DemoRole.partnerReviewer => 'Partner reviewer',
  };

  IconData get icon => switch (this) {
    _DemoRole.student => Icons.school_outlined,
    _DemoRole.coordinator => Icons.assignment_ind_outlined,
    _DemoRole.adviser => Icons.support_agent_outlined,
    _DemoRole.partnerReviewer => Icons.business_outlined,
  };
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  static const _ink = Color(0xFF172B4D);
  static const _blue = Color(0xFF3157C8);
  static const _muted = Color(0xFF69778C);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Alex Rivera');
  final _studentIdController = TextEditingController(text: '2026-10482');
  final _programController = TextEditingController(
    text: 'BS Information Technology',
  );
  final _partnerController = TextEditingController(text: 'Northstar Digital');

  _DemoRole _role = _DemoRole.student;
  final Map<String, bool> _documents = {
    'Resume / CV': false,
    'Medical clearance': false,
    'Endorsement form': false,
  };
  bool _applicationSubmitted = false;
  bool _requirementsVerified = false;
  bool _endorsed = false;
  bool _partnerSubmitted = false;
  bool _interviewScheduled = false;
  bool _interviewCompleted = false;
  bool _placementConfirmed = false;
  bool _serviceUnavailable = false;
  bool _recoveryPending = false;
  String _interviewNote = 'Awaiting partner review';
  String _lastAction = '';

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _programController.dispose();
    _partnerController.dispose();
    super.dispose();
  }

  bool get _allDocumentsReady => _documents.values.every((ready) => ready);

  int get _completedStages => [
    _applicationSubmitted,
    _requirementsVerified,
    _endorsed,
    _partnerSubmitted,
    _interviewCompleted,
    _placementConfirmed,
  ].where((done) => done).length;

  String get _currentStage {
    if (!_applicationSubmitted) return 'Application';
    if (!_requirementsVerified) return 'Requirements review';
    if (!_endorsed) return 'Adviser endorsement';
    if (!_partnerSubmitted) return 'Partner submission';
    if (!_interviewCompleted) return 'Interview status';
    if (!_placementConfirmed) return 'Placement confirmation';
    return 'Placement confirmed';
  }

  void _notify(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? const Color(0xFF9F3434) : _ink,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  bool _canActAs(_DemoRole requiredRole) {
    if (_role == requiredRole) return true;
    _notify(
      'This action is for the ${requiredRole.label.toLowerCase()} role. Switch roles in the header to continue.',
      isError: true,
    );
    return false;
  }

  bool _runAction(String action, VoidCallback update) {
    if (_serviceUnavailable) {
      setState(() {
        _lastAction = action;
        _recoveryPending = true;
      });
      _notify(
        'The demo service is unavailable. Your work is still here; restore the service and retry.',
        isError: true,
      );
      return false;
    }
    setState(update);
    _notify(action);
    return true;
  }

  void _retryLastAction() {
    if (_serviceUnavailable) {
      _notify(
        'The service is still unavailable. Turn it back on, then retry.',
        isError: true,
      );
      return;
    }
    switch (_lastAction) {
      case 'Application submitted':
        setState(() {
          _applicationSubmitted = true;
          _recoveryPending = false;
        });
        break;
      case 'Requirements verified':
        setState(() {
          _requirementsVerified = true;
          _recoveryPending = false;
        });
        break;
      case 'Adviser endorsement recorded':
        setState(() {
          _endorsed = true;
          _recoveryPending = false;
        });
        break;
      case 'Partner submission recorded':
        setState(() {
          _partnerSubmitted = true;
          _recoveryPending = false;
        });
        break;
      case 'Interview scheduled':
        setState(() {
          _interviewScheduled = true;
          _interviewNote = 'Interview scheduled';
          _recoveryPending = false;
        });
        break;
      case 'Interview completed':
        setState(() {
          _interviewCompleted = true;
          _interviewNote = 'Interview completed';
          _recoveryPending = false;
        });
        break;
      case 'Placement confirmed':
        setState(() {
          _placementConfirmed = true;
          _recoveryPending = false;
        });
        break;
      default:
        _notify('There is no failed action to retry.', isError: true);
        return;
    }
    _notify('Recovered: $_lastAction. The update is now recorded.');
    setState(() => _lastAction = '');
  }

  void _submitApplication() {
    if (!_canActAs(_DemoRole.student)) return;
    if (!_formKey.currentState!.validate()) {
      _notify('Check the highlighted fields and try again.', isError: true);
      return;
    }
    _runAction('Application submitted', () => _applicationSubmitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final compactHeader = MediaQuery.sizeOf(context).width < 520;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        titleSpacing: compactHeader ? 14 : 24,
        title: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: _blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.route_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Internship Monitor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
                if (!compactHeader)
                  const Text(
                    'Student placement workspace',
                    style: TextStyle(fontSize: 11, color: _muted),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          if (MediaQuery.sizeOf(context).width > 600)
            const Center(
              child: Text(
                'DEMO WORKSPACE',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.1,
                  color: _muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<_DemoRole>(
                value: _role,
                borderRadius: BorderRadius.circular(14),
                items: _DemoRole.values
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(role.icon, size: 18, color: _blue),
                            const SizedBox(width: 8),
                            Text(role.label),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                selectedItemBuilder: (context) => _DemoRole.values
                    .map(
                      (role) => compactHeader
                          ? Center(
                              child: Icon(role.icon, size: 20, color: _blue),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(role.icon, size: 18, color: _blue),
                                const SizedBox(width: 8),
                                Text(role.label),
                              ],
                            ),
                    )
                    .toList(),
                onChanged: (role) {
                  if (role != null) setState(() => _role = role);
                },
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1050;
          final content = _buildContent(wide: wide);
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth < 600 ? 16 : 32,
                  vertical: 28,
                ),
                child: wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: SingleChildScrollView(child: content),
                          ),
                          const SizedBox(width: 24),
                          SizedBox(
                            width: 300,
                            child: SingleChildScrollView(
                              child: _buildSidebar(),
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(child: content),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent({required bool wide}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcome(),
        const SizedBox(height: 20),
        _buildProgressCard(),
        const SizedBox(height: 18),
        if (_recoveryPending) ...[
          _buildRecoveryBanner(),
          const SizedBox(height: 18),
        ],
        if (_serviceUnavailable) ...[
          _buildUnavailableBanner(),
          const SizedBox(height: 18),
        ],
        _buildApplicationCard(),
        const SizedBox(height: 16),
        _buildRequirementsCard(),
        const SizedBox(height: 16),
        _buildApprovalCard(),
        const SizedBox(height: 16),
        _buildPartnerCard(),
        const SizedBox(height: 16),
        _buildPlacementCard(),
        if (!wide) ...[const SizedBox(height: 20), _buildSidebar()],
        const SizedBox(height: 28),
        const Center(
          child: Text(
            'Prototype uses sample data stored in this session. No live partner service is connected.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: _muted),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcome() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Your internship, in one place.',
        style: TextStyle(
          fontSize: 28,
          height: 1.15,
          letterSpacing: -0.7,
          color: _ink,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 7),
      Text(
        'Follow each handoff from application through placement confirmation. Signed in as ${_role.label.toLowerCase()}.',
        style: const TextStyle(fontSize: 14, color: _muted),
      ),
    ],
  );

  Widget _buildProgressCard() {
    final steps = [
      'Application',
      'Requirements',
      'Endorsement',
      'Partner',
      'Interview',
      'Placement',
    ];
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Application progress',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
              _pill('$_completedStages of 6 complete', _blue),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _completedStages / 6,
              minHeight: 7,
              backgroundColor: const Color(0xFFE8ECF4),
              color: _blue,
            ),
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 7,
            runSpacing: 8,
            children: List.generate(steps.length, (index) {
              final done = index < _completedStages;
              final active = index == _completedStages;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: done
                      ? const Color(0xFFE8F5EF)
                      : active
                      ? const Color(0xFFEDF1FF)
                      : const Color(0xFFF3F5F8),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      done
                          ? Icons.check_circle
                          : active
                          ? Icons.radio_button_checked
                          : Icons.circle_outlined,
                      size: 14,
                      color: done
                          ? const Color(0xFF21845A)
                          : active
                          ? _blue
                          : const Color(0xFFABB4C2),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        color: active || done ? _ink : _muted,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            _placementConfirmed
                ? 'All required steps are complete.'
                : 'Current step: $_currentStage',
            style: const TextStyle(fontSize: 12, color: _muted),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard() => _workflowCard(
    number: '01',
    title: 'Application',
    subtitle: 'Start with the student and internship details.',
    icon: Icons.description_outlined,
    done: _applicationSubmitted,
    child: _applicationSubmitted
        ? _summaryRows([
            ('Student', _nameController.text),
            ('Student ID', _studentIdController.text),
            ('Program', _programController.text),
            ('Preferred partner', _partnerController.text),
          ])
        : Form(
            key: _formKey,
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, box) {
                    final stacked = box.maxWidth < 600;
                    final first = _input(
                      _nameController,
                      'Student name',
                      'Enter the student name',
                    );
                    final second = _input(
                      _studentIdController,
                      'Student ID',
                      'Enter the student ID',
                    );
                    return stacked
                        ? Column(
                            children: [
                              first,
                              const SizedBox(height: 12),
                              second,
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: first),
                              const SizedBox(width: 12),
                              Expanded(child: second),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, box) {
                    final stacked = box.maxWidth < 600;
                    final first = _input(
                      _programController,
                      'Program',
                      'Enter the program',
                    );
                    final second = _input(
                      _partnerController,
                      'Preferred partner',
                      'Enter an organization',
                    );
                    return stacked
                        ? Column(
                            children: [
                              first,
                              const SizedBox(height: 12),
                              second,
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: first),
                              const SizedBox(width: 12),
                              Expanded(child: second),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: _actionButton(
                    'Submit application',
                    Icons.arrow_forward_rounded,
                    _submitApplication,
                  ),
                ),
              ],
            ),
          ),
  );

  Widget _input(TextEditingController controller, String label, String error) =>
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          filled: true,
          fillColor: const Color(0xFFF8F9FC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
        validator: (value) =>
            (value == null || value.trim().isEmpty) ? error : null,
      );

  Widget _buildRequirementsCard() => _workflowCard(
    number: '02',
    title: 'Requirements',
    subtitle:
        'Mark each sample document as uploaded, then have the coordinator verify the set.',
    icon: Icons.folder_open_outlined,
    done: _requirementsVerified,
    child: Column(
      children: [
        for (final entry in _documents.entries)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            value: entry.value,
            title: Text(
              entry.key,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: _ink,
              ),
            ),
            subtitle: Text(
              entry.value ? 'Uploaded · sample item' : 'Not uploaded',
              style: const TextStyle(fontSize: 11, color: _muted),
            ),
            activeColor: _blue,
            onChanged:
                _applicationSubmitted &&
                    !_requirementsVerified &&
                    _role == _DemoRole.student
                ? (value) =>
                      setState(() => _documents[entry.key] = value ?? false)
                : null,
          ),
        if (!_applicationSubmitted)
          _hint('Submit the application before adding requirements.'),
        if (_applicationSubmitted && !_requirementsVerified)
          Align(
            alignment: Alignment.centerRight,
            child: _actionButton(
              _allDocumentsReady
                  ? 'Verify requirements'
                  : 'Complete all requirements',
              Icons.fact_check_outlined,
              () {
                if (!_canActAs(_DemoRole.coordinator)) return;
                if (!_allDocumentsReady) {
                  _notify(
                    'Some requirements are missing. Ask the student to complete all three items.',
                    isError: true,
                  );
                  return;
                }
                _runAction(
                  'Requirements verified',
                  () => _requirementsVerified = true,
                );
              },
              enabled: _allDocumentsReady,
            ),
          ),
        if (_requirementsVerified)
          _successLine('All required items verified by the coordinator.'),
      ],
    ),
  );

  Widget _buildApprovalCard() => _workflowCard(
    number: '03',
    title: 'Endorsement',
    subtitle: 'Adviser review records the academic approval for internship.',
    icon: Icons.verified_user_outlined,
    done: _endorsed,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusLine(
          _endorsed
              ? 'Endorsed by adviser'
              : _requirementsVerified
              ? 'Ready for adviser review'
              : 'Waiting for verified requirements',
          _endorsed,
        ),
        if (!_endorsed) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _actionButton('Record endorsement', Icons.draw_outlined, () {
              if (!_canActAs(_DemoRole.adviser)) return;
              if (!_requirementsVerified) {
                _notify(
                  'Requirements must be verified before endorsement.',
                  isError: true,
                );
                return;
              }
              _runAction(
                'Adviser endorsement recorded',
                () => _endorsed = true,
              );
            }, enabled: _requirementsVerified),
          ),
        ],
      ],
    ),
  );

  Widget _buildPartnerCard() => _workflowCard(
    number: '04',
    title: 'Partner review',
    subtitle:
        'The coordinator sends the endorsed application to the preferred partner.',
    icon: Icons.business_center_outlined,
    done: _partnerSubmitted,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _summaryRows([
          ('Partner', _partnerController.text),
          (
            'Submission',
            _partnerSubmitted ? 'Sent for review' : 'Not yet submitted',
          ),
          ('Interview', _interviewNote),
        ]),
        if (!_partnerSubmitted) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _actionButton('Submit to partner', Icons.send_outlined, () {
              if (!_canActAs(_DemoRole.coordinator)) return;
              if (!_endorsed) {
                _notify(
                  'Adviser endorsement is required before partner submission.',
                  isError: true,
                );
                return;
              }
              _runAction(
                'Partner submission recorded',
                () => _partnerSubmitted = true,
              );
            }, enabled: _endorsed),
          ),
        ],
        if (_partnerSubmitted && !_interviewScheduled)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: _actionButton(
                'Schedule interview',
                Icons.event_available_outlined,
                () {
                  if (!_canActAs(_DemoRole.partnerReviewer)) return;
                  _runAction('Interview scheduled', () {
                    _interviewScheduled = true;
                    _interviewNote = 'Interview scheduled';
                  });
                },
              ),
            ),
          ),
        if (_interviewScheduled && !_interviewCompleted)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: _actionButton(
                'Record interview complete',
                Icons.check_circle_outline,
                () {
                  if (!_canActAs(_DemoRole.partnerReviewer)) return;
                  _runAction('Interview completed', () {
                    _interviewCompleted = true;
                    _interviewNote = 'Interview completed';
                  });
                },
              ),
            ),
          ),
        if (_interviewCompleted)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _successLine(
              'Partner interview completed. Student status is up to date.',
            ),
          ),
      ],
    ),
  );

  Widget _buildPlacementCard() => _workflowCard(
    number: '05',
    title: 'Placement confirmation',
    subtitle:
        'The coordinator records the final placement decision after partner review.',
    icon: Icons.emoji_events_outlined,
    done: _placementConfirmed,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusLine(
          _placementConfirmed
              ? 'Placement confirmed'
              : _interviewCompleted
              ? 'Ready for placement confirmation'
              : 'Waiting for completed partner interview',
          _placementConfirmed,
        ),
        if (!_placementConfirmed) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _actionButton('Confirm placement', Icons.task_alt, () {
              if (!_canActAs(_DemoRole.coordinator)) return;
              if (!_interviewCompleted) {
                _notify(
                  'Partner interview must be completed first.',
                  isError: true,
                );
                return;
              }
              _runAction(
                'Placement confirmed',
                () => _placementConfirmed = true,
              );
            }, enabled: _interviewCompleted),
          ),
        ],
      ],
    ),
  );

  Widget _buildSidebar() => Column(
    children: [
      _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: _blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Latest update',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _placementConfirmed
                  ? 'Your placement at ${_partnerController.text} is confirmed.'
                  : _applicationSubmitted
                  ? 'Your application is at: $_currentStage.'
                  : 'Your application has not been submitted yet.',
              style: const TextStyle(fontSize: 13, height: 1.45, color: _muted),
            ),
            const SizedBox(height: 10),
            Text(
              'Updated just now · sample workflow',
              style: TextStyle(
                fontSize: 10,
                color: _muted.withValues(alpha: .8),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workflow roles',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            const SizedBox(height: 12),
            for (final role in _DemoRole.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: Row(
                  children: [
                    Icon(
                      role.icon,
                      size: 17,
                      color: role == _role ? _blue : _muted,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        role.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: role == _role ? _ink : _muted,
                          fontWeight: role == _role
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (role == _role)
                      const Icon(Icons.circle, size: 7, color: _blue),
                  ],
                ),
              ),
            const Divider(height: 20),
            const Text(
              'Select a role from the top menu to perform that role’s actions. Student view remains read-only for approvals.',
              style: TextStyle(fontSize: 11, height: 1.4, color: _muted),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo controls',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Use these controls to demonstrate service failure and recovery.',
              style: TextStyle(fontSize: 11, height: 1.4, color: _muted),
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Service unavailable',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _ink,
                ),
              ),
              subtitle: Text(
                _serviceUnavailable
                    ? 'Writes will fail safely'
                    : 'Demo service is available',
                style: const TextStyle(fontSize: 10, color: _muted),
              ),
              value: _serviceUnavailable,
              activeColor: const Color(0xFFB94A48),
              onChanged: (value) => setState(() => _serviceUnavailable = value),
            ),
            if (_recoveryPending)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _retryLastAction,
                  icon: const Icon(Icons.refresh_rounded, size: 17),
                  label: const Text('Retry failed action'),
                ),
              ),
          ],
        ),
      ),
    ],
  );

  Widget _buildRecoveryBanner() => _banner(
    icon: Icons.history_rounded,
    color: const Color(0xFF98690A),
    title: 'An update is waiting to be retried',
    body:
        '“$_lastAction” was not recorded because the demo service was unavailable. Restore service in Demo controls, then retry.',
  );

  Widget _buildUnavailableBanner() => _banner(
    icon: Icons.cloud_off_outlined,
    color: const Color(0xFF9F3434),
    title: 'Demo service unavailable',
    body:
        'Updates will not be recorded while this switch is on. Existing application information is preserved in this session.',
  );

  Widget _banner({
    required IconData icon,
    required Color color,
    required String title,
    required String body,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .08),
      border: Border.all(color: color.withValues(alpha: .2)),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: TextStyle(color: color, fontSize: 11, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _workflowCard({
    required String number,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool done,
    required Widget child,
  }) => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: done ? const Color(0xFFE8F5EF) : const Color(0xFFEDF1FF),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                done ? Icons.check_rounded : icon,
                size: 19,
                color: done ? const Color(0xFF21845A) : _blue,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$number  ',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: _blue,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _ink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (done) _pill('Complete', const Color(0xFF21845A)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.35,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Divider(height: 1, color: Color(0xFFEEF0F4)),
        ),
        child,
      ],
    ),
  );

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: const Color(0xFFE8ECF2)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0717284D),
          blurRadius: 18,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: child,
  );

  Widget _pill(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .09),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w800),
    ),
  );

  Widget _summaryRows(List<(String, String)> rows) => Column(
    children: [
      for (final row in rows)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 128,
                child: Text(
                  row.$1,
                  style: const TextStyle(fontSize: 11, color: _muted),
                ),
              ),
              Expanded(
                child: Text(
                  row.$2,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _ink,
                  ),
                ),
              ),
            ],
          ),
        ),
    ],
  );

  Widget _statusLine(String text, bool done) => Row(
    children: [
      Icon(
        done ? Icons.check_circle_outline : Icons.schedule_rounded,
        size: 17,
        color: done ? const Color(0xFF21845A) : const Color(0xFF8A95A6),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: _ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );

  Widget _successLine(String text) => Row(
    children: [
      const Icon(Icons.check_circle, size: 17, color: Color(0xFF21845A)),
      const SizedBox(width: 7),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF21845A),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  );

  Widget _hint(String text) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Row(
      children: [
        const Icon(Icons.info_outline, size: 15, color: _muted),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, color: _muted),
          ),
        ),
      ],
    ),
  );

  Widget _actionButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool enabled = true,
  }) => FilledButton.icon(
    onPressed: enabled
        ? onPressed
        : () {
            if (_role == _DemoRole.student) {
              _notify(
                'This step is completed by a coordinator. Switch to the coordinator role in the header.',
                isError: true,
              );
            } else {
              _notify(
                'Complete the required earlier steps first.',
                isError: true,
              );
            }
          },
    icon: Icon(icon, size: 17),
    label: Text(label),
    style: FilledButton.styleFrom(
      backgroundColor: _blue,
      foregroundColor: Colors.white,
      disabledBackgroundColor: const Color(0xFFE9ECF2),
      disabledForegroundColor: _muted,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
    ),
  );
}
