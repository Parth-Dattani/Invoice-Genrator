import 'package:demo_prac_getx/screen/dashboard/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/controller.dart';
import '../screen.dart';

class DashboardScreen extends GetView<DashboardController> {
  static const String pageId = '/DashboardScreen';

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          controller.scaffoldKey.currentState?.openDrawer();
        },
            icon: Icon(Icons.menu)),
        title: Text('Invoice Dashboard'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: controller.navigateToSettings,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: controller.refreshDashboard,
          ),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () async => controller.refreshDashboard(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Here\'s your business overview',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Statistics Cards
              DashboardStatsCard(),

              SizedBox(height: 20),

              // Quick Actions
              QuickActionsGrid(),

              SizedBox(height: 20),

              // Charts Section
              Row(
                children: [
                  Expanded(child: RevenueChartCard()),
                  SizedBox(width: 10),
                  Expanded(child: InvoiceStatusChart()),
                ],
              ),

              SizedBox(height: 20),

              // Recent Invoices
              RecentInvoicesCard(),
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToSettings,
        backgroundColor: Colors.blue.shade700,
        child: Icon(Icons.add, color: Colors.white),
      ),
      drawer: buildDrawer(),
    );
  }

  // Add these methods to your Dashboard screen widget

  Widget _buildQuickActionsSection() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.person_add,
                    title: 'Add Customer',
                    subtitle: 'Register new customer',
                    color: Colors.green,
                    onTap: () => controller.navigateToAddNewCustomer(),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.receipt_long,
                    title: 'New Invoice',
                    subtitle: 'Create invoice',
                    color: Colors.blue,
                    onTap: () => controller.navigateToCreateInvoice(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.people,
                    title: 'View Customers',
                    subtitle: 'Manage customers',
                    color: Colors.orange,
                    onTap: () => controller.navigateToCustomerList(),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.analytics,
                    title: 'Reports',
                    subtitle: 'View analytics',
                    color: Colors.purple,
                    onTap: () => controller.navigateToReports(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

// Add this to your floating action button or main action area
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => controller.navigateToAddNewCustomer(),
      backgroundColor: Colors.green,
      icon: Icon(Icons.person_add),
      label: Text('Add Customer'),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header with Company Info
          Obx(() => DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: Icon(
                      Icons.business,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    controller.companyName.isNotEmpty
                        ? controller.companyName
                        : "No Company Selected",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (controller.hasMultipleCompanies.value)
                    GestureDetector(
                      onTap: controller.showCompanySwitcher,
                      child: Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Switch Company",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.swap_horiz,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.dashboard, color: Colors.blue.shade700),
                  title: Text("Dashboard"),
                  onTap: () => Get.back(),
                ),
                ListTile(
                  leading: Icon(Icons.person_add, color: Colors.green),
                  title: Text("Add Customer"),
                  onTap: () {
                    Get.back();
                    controller.navigateToAddNewCustomer();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.receipt_long, color: Colors.blue),
                  title: Text("Create Invoice"),
                  onTap: () {
                    Get.back();
                    controller.navigateToCreateInvoice();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people, color: Colors.orange),
                  title: Text("View Customers"),
                  onTap: () {
                    Get.back();
                    controller.navigateToCustomerList();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.analytics, color: Colors.purple),
                  title: Text("Reports"),
                  onTap: () {
                    Get.back();
                    controller.navigateToReports();
                  },
                ),
                Divider(),

                // Company Management Section
                if (controller.hasMultipleCompanies.value)
                  ListTile(
                    leading: Icon(Icons.swap_horiz, color: Colors.indigo),
                    title: Text("Switch Company"),
                    onTap: () {
                      Get.back();
                      controller.showCompanySwitcher();
                    },
                  ),

                ListTile(
                  leading: Icon(Icons.add_business, color: Colors.teal),
                  title: Text("Add New Company"),
                  onTap: () {
                    Get.back();
                    Get.toNamed(CompanyRegistrationScreen.pageId);
                  },
                ),

                Divider(),

                ListTile(
                  leading: Icon(Icons.settings, color: Colors.grey),
                  title: Text("Settings"),
                  onTap: () {
                    Get.back();
                    controller.navigateToSettings();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Logout"),
                  onTap: () async {
                    ///Get.back();
                    await controller.logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
