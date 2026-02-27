import 'package:flutter/material.dart';

// ─── DATA MODEL ──────────────────────────────────────────────────────────────

enum RequestStatus { pending, accepted, declined }

class ConnectionRequest {
  final String id;
  final String patientName;
  final int age;
  final String diabetesType;
  final String sentAgo;
  final String avatarInitials;
  RequestStatus status;

  ConnectionRequest({
    required this.id,
    required this.patientName,
    required this.age,
    required this.diabetesType,
    required this.sentAgo,
    required this.avatarInitials,
    this.status = RequestStatus.pending,
  });
}

// ─── SCREEN ──────────────────────────────────────────────────────────────────

class DoctorRequestsScreen extends StatefulWidget {
  const DoctorRequestsScreen({super.key});

  @override
  State<DoctorRequestsScreen> createState() => _DoctorRequestsScreenState();
}

class _DoctorRequestsScreenState extends State<DoctorRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ConnectionRequest> _requests = [
    ConnectionRequest(id: '1', patientName: 'Sara Mahmoud', age: 27, diabetesType: 'Type 1', sentAgo: '10 min ago', avatarInitials: 'SM'),
    ConnectionRequest(id: '2', patientName: 'Ahmed Tarek', age: 34, diabetesType: 'Type 1', sentAgo: '1 hour ago', avatarInitials: 'AT'),
    ConnectionRequest(id: '3', patientName: 'Israa Nabil', age: 19, diabetesType: 'Type 1', sentAgo: '3 hours ago', avatarInitials: 'NH'),
    ConnectionRequest(id: '4', patientName: 'Layla Ibrahim', age: 45, diabetesType: 'Type 1', sentAgo: 'Yesterday', avatarInitials: 'LI', status: RequestStatus.accepted),
    ConnectionRequest(id: '5', patientName: 'Samir Youssef', age: 22, diabetesType: 'Type 1', sentAgo: '2 days ago', avatarInitials: 'YK', status: RequestStatus.declined),
  ];

  List<ConnectionRequest> get _pending   => _requests.where((r) => r.status == RequestStatus.pending).toList();
  List<ConnectionRequest> get _accepted  => _requests.where((r) => r.status == RequestStatus.accepted).toList();
  List<ConnectionRequest> get _declined  => _requests.where((r) => r.status == RequestStatus.declined).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _accept(ConnectionRequest request) {
    setState(() => request.status = RequestStatus.accepted);
    _showSnackbar('${request.patientName} accepted', const Color(0xFF2BB6A3));
  }

  void _decline(ConnectionRequest request) {
    setState(() => request.status = RequestStatus.declined);
    _showSnackbar('${request.patientName} declined', Colors.redAccent);
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isLandscape = orientation == Orientation.landscape;
            return Column(
              children: [
                // ── Header (always visible, never scrolls away) ──
                _buildHeader(isLandscape),
                // ── Tab bar ──
                _buildTabBar(),
                // ── Tab content — each tab is its own scrollable ──
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      _buildRequestList(_pending,  showActions: true,  isLandscape: isLandscape),
                      _buildRequestList(_accepted, showActions: false, isLandscape: isLandscape),
                      _buildRequestList(_declined, showActions: false, isLandscape: isLandscape),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLandscape) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, isLandscape ? 10 : 20, 16, 0),
      child: isLandscape
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Connection Requests',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                        '${_pending.length} pending request${_pending.length == 1 ? '' : 's'}',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Summary chips inline
                Row(
                  children: [
                    _summaryChip('Pending',  _pending.length,  const Color(0xFF2BB6A3)),
                    const SizedBox(width: 8),
                    _summaryChip('Accepted', _accepted.length, Colors.green),
                    const SizedBox(width: 8),
                    _summaryChip('Declined', _declined.length, Colors.redAccent),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Connection Requests',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  '${_pending.length} pending request${_pending.length == 1 ? '' : 's'}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _summaryChip('Pending',  _pending.length,  const Color(0xFF2BB6A3)),
                    const SizedBox(width: 10),
                    _summaryChip('Accepted', _accepted.length, Colors.green),
                    const SizedBox(width: 10),
                    _summaryChip('Declined', _declined.length, Colors.redAccent),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }

  Widget _summaryChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('$count $label', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF1A7A6E),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF2BB6A3),
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Pending'),
                if (_pending.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  _tabBadge(_pending.length, const Color(0xFF2BB6A3)),
                ],
              ],
            ),
          ),
          const Tab(text: 'Accepted'),
          const Tab(text: 'Declined'),
        ],
      ),
    );
  }

  Widget _tabBadge(int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }

  Widget _buildRequestList(
    List<ConnectionRequest> requests, {
    required bool showActions,
    required bool isLandscape,
  }) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(showActions ? Icons.inbox_outlined : Icons.check_circle_outline,
                size: 52, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(showActions ? 'No pending requests' : 'Nothing here yet',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),
          ],
        ),
      );
    }

    // Both orientations: natural-height list.
    // In landscape we add horizontal padding so cards don't stretch full width.
    final hPad = isLandscape ? 60.0 : 16.0;
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 16),
      itemCount: requests.length,
      itemBuilder: (context, index) => _RequestCard(
        request: requests[index],
        showActions: showActions,
        onAccept: () => _accept(requests[index]),
        onDecline: () => _decline(requests[index]),
      ),
    );
  }
}

// ─── REQUEST CARD ─────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final ConnectionRequest request;
  final bool showActions;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _RequestCard({
    required this.request,
    required this.showActions,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF2BB6A3).withValues(alpha: 0.15),
                child: Text(request.avatarInitials,
                    style: const TextStyle(color: Color(0xFF1A7A6E), fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.patientName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 3),
                    Text('Age ${request.age} • ${request.diabetesType} Diabetes',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Text(request.sentAgo, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          if (showActions) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('Decline', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2BB6A3),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('Accept', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: request.status == RequestStatus.accepted
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  request.status == RequestStatus.accepted ? '✓ Accepted' : '✗ Declined',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: request.status == RequestStatus.accepted ? Colors.green : Colors.redAccent,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}