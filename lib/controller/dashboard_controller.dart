
import 'package:demo_prac_getx/controller/bash_controller.dart';
import 'package:demo_prac_getx/screen/customer/customer_registration_screen.dart';
import 'package:demo_prac_getx/screen/item_screen.dart';
import 'package:demo_prac_getx/screen/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/model.dart';
import '../screen/setting/widgets/widgets.dart';

class DashboardController extends BaseController {
  // Observable variables
  var totalInvoices = 0.obs;
  var paidInvoices = 0.obs;
  var unpaidInvoices = 0.obs;
  var overdueInvoices = 0.obs;
  var draftInvoices = 0.obs;
  var totalRevenue = 0.0.obs;
  var pendingAmount = 0.0.obs;
  var overdueAmount = 0.0.obs;

  // Recent invoices list
  var recentInvoices = <Invoice>[].obs;

  // Chart data
  var monthlyRevenue = <double>[].obs;
  var invoiceStatusData = <ChartData>[].obs;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void loadDashboardData() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Load dashboard statistics
      totalInvoices.value = 156;
      paidInvoices.value = 89;
      unpaidInvoices.value = 45;
      overdueInvoices.value = 12;
      draftInvoices.value = 10;
      totalRevenue.value = 125430.50;
      pendingAmount.value = 34560.75;
      overdueAmount.value = 8945.25;

      // Load recent invoices
      recentInvoices.value = [
        Invoice(
          invoiceId: 'INV-001',
          customerName: 'John Doe',
          price: 1500.0,
          itemId: '', qty: 11,
          mobile: '', itemName: '',
          //status: 'Paid',
          //date: DateTime.now().subtract(Duration(days: 1)),
        ),
        Invoice(
          invoiceId: 'INV-002',
          customerName: 'Johnaaa Doe',
          price: 160.0,
          itemId: '', qty: 1,
          mobile: '', itemName: '',

        ),
      ];

      // Load chart data
      monthlyRevenue.value = [15000, 18500, 22000, 19500, 25000, 28000];
      invoiceStatusData.value = [
        ChartData('Paid', paidInvoices.value.toDouble(), Colors.green),
        ChartData('Pending', unpaidInvoices.value.toDouble(), Colors.orange),
        ChartData('Overdue', overdueInvoices.value.toDouble(), Colors.red),
        ChartData('Draft', draftInvoices.value.toDouble(), Colors.grey),
      ];

    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  
  void refreshDashboard() {
    loadDashboardData();
  }

  void navigateToCreateInvoice() {
    Get.toNamed(ItemScreen.pageId);
  }

  void navigateToInvoiceList() {
    Get.toNamed(ItemScreen.pageId);
  }

  void navigateToCustomers() {
    Get.toNamed(CustomerRegistrationScreen.pageId);
  }

  void navigateToReports() {
    Get.toNamed(ItemScreen.pageId);
  }

  void navigateToSettings() {
    Get.to(
          () => TemplatePreviewScreen(templateId: 2),
      transition: Transition.rightToLeft,
      duration: Duration(milliseconds: 300),
    );
    //Get.toNamed(SettingsScreen.pageId);
  }

  void viewInvoiceDetails(String invoiceId) {
    Get.toNamed('/invoice-details/$invoiceId');
  }
}

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}