import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../services/swap_service.dart';
import '../../services/auth_service.dart';
import '../../models/swap_request_model.dart';

class SwapRequestsScreen extends StatefulWidget {
  const SwapRequestsScreen({Key? key}) : super(key: key);

  @override
  State<SwapRequestsScreen> createState() => _SwapRequestsScreenState();
}

class _SwapRequestsScreenState extends State<SwapRequestsScreen> {
  String _statusFilter = 'Pending';
  String _searchQuery = '';
  int _currentPage = 1;
  final int _requestsPerPage = 2;

  final List<Map<String, dynamic>> demoRequests = [
    {
      'name': 'Marc Demo',
      'profilePhoto': null,
      'skillsOffered': ['Python'],
      'skillsWanted': ['Photoshop'],
      'rating': 3.8,
      'status': 'Pending',
    },
  ];

  int get totalPages => (demoRequests.length / _requestsPerPage).ceil().clamp(1, 999);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final swapService = SwapService();
    final currentUser = authService.currentUser;
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text('Skill Swap Platform', style: AppTextStyles.heading.copyWith(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Home', style: AppTextStyles.body.copyWith(color: Colors.white, decoration: TextDecoration.underline)),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: currentUser == null
          ? Center(child: Text('Please log in to view your swap requests.', style: AppTextStyles.body))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DropdownButton<String>(
                      value: _statusFilter,
                      items: const [
                        DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                        DropdownMenuItem(value: 'All', child: Text('All')),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _statusFilter = val ?? 'Pending';
                          _currentPage = 1;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'search',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                            _currentPage = 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: demoRequests.length,
                    itemBuilder: (context, idx) {
                      final req = demoRequests[idx];
                      return Card(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white24)),
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person, color: AppColors.primary, size: 32),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(req['name'], style: AppTextStyles.heading.copyWith(color: Colors.white)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text('Skills Offered => ', style: AppTextStyles.body.copyWith(color: Colors.greenAccent, fontSize: 12)),
                                        ...req['skillsOffered'].map<Widget>((s) => Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 2),
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white10,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.greenAccent),
                                          ),
                                          child: Text(s, style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 12)),
                                        )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Skill wanted => ', style: AppTextStyles.body.copyWith(color: Colors.cyanAccent, fontSize: 12)),
                                        ...req['skillsWanted'].map<Widget>((s) => Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 2),
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white10,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.cyanAccent),
                                          ),
                                          child: Text(s, style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 12)),
                                        )),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text('rating: ${req['rating']}/5', style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Status', style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 14)),
                                  Text(req['status'], style: AppTextStyles.body.copyWith(
                                    color: req['status'] == 'Pending' ? Colors.amber : req['status'] == 'Rejected' ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                                  if (req['status'] == 'Pending') ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              demoRequests.removeAt(idx);
                                            });
                                          },
                                          child: Text('Accept', style: AppTextStyles.body.copyWith(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                                        ),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              demoRequests.removeAt(idx);
                                            });
                                          },
                                          child: Text('Reject', style: AppTextStyles.body.copyWith(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (totalPages > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(totalPages, (index) {
                        final page = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _currentPage == page ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Text(
                              '$page',
                              style: AppTextStyles.body.copyWith(
                                color: _currentPage == page ? Colors.white : AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
    );
  }
} 