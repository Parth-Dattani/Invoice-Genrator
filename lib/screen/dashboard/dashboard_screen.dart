import 'package:demo_prac_getx/screen/dashboard/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/controller.dart';

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
    drawer: Drawer(
    child: ListView(
    padding: EdgeInsets.zero,
    children: const [
    DrawerHeader(
    decoration: BoxDecoration(color: Colors.blue),
    child: Text("My Drawer", style: TextStyle(color: Colors.white, fontSize: 20)),
    ),
    ListTile(
    leading: Icon(Icons.home),
    title: Text("Home"),
    ),
    ListTile(
    leading: Icon(Icons.settings),
    title: Text("Settings"),
    ),
    ],
    ))
    );
  }
}
