import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Admin Dashboard', style: AppTextStyles.heading.copyWith(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Swaps'),
            Tab(text: 'Messages'),
            Tab(text: 'Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('User Management (ban, view, etc.)', style: AppTextStyles.body)),
          Center(child: Text('Swap Requests Moderation', style: AppTextStyles.body)),
          Center(child: Text('Send Platform-wide Messages', style: AppTextStyles.body)),
          Center(child: Text('Download/View Reports', style: AppTextStyles.body)),
        ],
      ),
    );
  }
}

