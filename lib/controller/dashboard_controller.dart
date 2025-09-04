
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_prac_getx/controller/bash_controller.dart';
import 'package:demo_prac_getx/screen/customer/customer_registration_screen.dart';
import 'package:demo_prac_getx/screen/item_screen.dart';
import 'package:demo_prac_getx/screen/setting/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/constant.dart';
import '../model/model.dart';
import '../screen/screen.dart';
import '../screen/setting/widgets/widgets.dart';
import '../utils/shared_preferences_helper.dart';
import '../widgets/widgets.dart';
import 'controller.dart';

// class DashboardController extends BaseController {
//   // Observable variables
//   var totalInvoices = 0.obs;
//   var paidInvoices = 0.obs;
//   var unpaidInvoices = 0.obs;
//   var overdueInvoices = 0.obs;
//   var draftInvoices = 0.obs;
//   var totalRevenue = 0.0.obs;
//   var pendingAmount = 0.0.obs;
//   var overdueAmount = 0.0.obs;
//
//   // Recent invoices list
//   var recentInvoices = <Invoice>[].obs;
//
//   // Chart data
//   var monthlyRevenue = <double>[].obs;
//   var invoiceStatusData = <ChartData>[].obs;
//
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadDashboardData();
//   }
//
//   void loadDashboardData() async {
//     try {
//       isLoading.value = true;
//
//       // Simulate API call
//       await Future.delayed(Duration(seconds: 1));
//
//       // Load dashboard statistics
//       totalInvoices.value = 156;
//       paidInvoices.value = 89;
//       unpaidInvoices.value = 45;
//       overdueInvoices.value = 12;
//       draftInvoices.value = 10;
//       totalRevenue.value = 125430.50;
//       pendingAmount.value = 34560.75;
//       overdueAmount.value = 8945.25;
//
//       // Load recent invoices
//       recentInvoices.value = [
//         Invoice(
//           invoiceId: 'INV-001',
//           customerName: 'John Doe',
//           price: 1500.0,
//           itemId: '', qty: 11,
//           mobile: '', itemName: '',
//           //status: 'Paid',
//           //date: DateTime.now().subtract(Duration(days: 1)),
//         ),
//         Invoice(
//           invoiceId: 'INV-002',
//           customerName: 'Johnaaa Doe',
//           price: 160.0,
//           itemId: '', qty: 1,
//           mobile: '', itemName: '',
//
//         ),
//       ];
//
//       // Load chart data
//       monthlyRevenue.value = [15000, 18500, 22000, 19500, 25000, 28000];
//       invoiceStatusData.value = [
//         ChartData('Paid', paidInvoices.value.toDouble(), Colors.green),
//         ChartData('Pending', unpaidInvoices.value.toDouble(), Colors.orange),
//         ChartData('Overdue', overdueInvoices.value.toDouble(), Colors.red),
//         ChartData('Draft', draftInvoices.value.toDouble(), Colors.grey),
//       ];
//
//     } catch (error) {
//       Get.snackbar(
//         'Error',
//         'Failed to load dashboard data: ${error.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   void refreshDashboard() {
//     loadDashboardData();
//   }
//
//   void navigateToCreateInvoice() {
//     Get.toNamed(ItemScreen.pageId);
//   }
//
//   void navigateToInvoiceList() {
//     Get.toNamed(ItemScreen.pageId);
//   }
//
//   void navigateToCustomers() {
//     Get.toNamed(CustomerRegistrationScreen.pageId);
//   }
//
//   void navigateToReports() {
//     Get.toNamed(ItemScreen.pageId);
//   }
//
//   void navigateToSettings() {
//     Get.to(
//           () => TemplatePreviewScreen(templateId: 2),
//       transition: Transition.rightToLeft,
//       duration: Duration(milliseconds: 300),
//     );
//     //Get.toNamed(SettingsScreen.pageId);
//   }
//
//   void viewInvoiceDetails(String invoiceId) {
//     Get.toNamed('/invoice-details/$invoiceId');
//   }
// }
//
// class ChartData {
//   final String label;
//   final double value;
//   final Color color;
//
//   ChartData(this.label, this.value, this.color);
// }

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
  // Add customer count observable
  var customerCount = 0.obs;

  // Recent invoices list
  var recentInvoices = <Invoice>[].obs;

  // Chart data
  var monthlyRevenue = <double>[].obs;
  var invoiceStatusData = <ChartData>[].obs;

  // Company data
  var currentCompany = Rxn<Map<String, dynamic>>();
  var companyId = ''.obs;
  var allUserCompanies = <Map<String, dynamic>>[].obs; // Store all companies
  var hasMultipleCompanies = false.obs; // Track if user has multiple companies


  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _loadCompanyData();
    loadDashboardData();
  }

  // Load all companies and set current company
  Future<void> _loadAllCompaniesAndSetCurrent() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Load all user companies
      final companiesSnapshot = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .where('isActive', isEqualTo: true)
          .get();

      allUserCompanies.clear();
      for (var doc in companiesSnapshot.docs) {
        final companyData = doc.data();
        companyData['id'] = doc.id;
        allUserCompanies.add(companyData);
      }

      hasMultipleCompanies.value = allUserCompanies.length > 1;

      // Try to get current company from SharedPreferences
      String savedCompanyId = await sharedPreferencesHelper.getPrefData("CompanyId").toString();

      if (savedCompanyId.isNotEmpty) {
        // Find saved company in the list
        final savedCompany = allUserCompanies.firstWhereOrNull(
                (company) => company['id'] == savedCompanyId
        );

        if (savedCompany != null) {
          _setCurrentCompany(savedCompany);
        } else if (allUserCompanies.isNotEmpty) {
          // Saved company not found, use first available
          _setCurrentCompany(allUserCompanies.first);
        }
      } else if (allUserCompanies.isNotEmpty) {
        // No saved company, use first available
        _setCurrentCompany(allUserCompanies.first);
      }

      // Load dashboard data after setting company
      if (companyId.value.isNotEmpty) {
        loadDashboardData();
      }

    } catch (e) {
      print("Error loading companies: $e");
    }
  }

  // Set current company and save to preferences
  void _setCurrentCompany(Map<String, dynamic> company) {
    currentCompany.value = company;
    companyId.value = company['id'];

    // Save to SharedPreferences
    sharedPreferencesHelper.storePrefData("CompanyId" , company['id']);

    print("Current company set: ${company['companyName']} (${company['id']})");
  }


  // Load current company data for navigation purposes
  Future<void> _loadCompanyData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final companyDocs = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (companyDocs.docs.isNotEmpty) {
        currentCompany.value = companyDocs.docs.first.data();
        currentCompany.value!['id'] = companyDocs.docs.first.id;
        companyId.value = companyDocs.docs.first.id;
      }
    } catch (e) {
      print("Error loading company data: $e");
    }
  }

  // Switch to a different company
  Future<void> switchCompany(Map<String, dynamic> newCompany) async {
    try {
      isLoading.value = true;

      // Set new current company
      _setCurrentCompany(newCompany);

      // Reload dashboard data for new company
       loadDashboardData();


      showCustomSnackbar(
        title: "Company Switched",
        message: "Switched to ${newCompany['companyName']}",
        baseColor: AppColors.greenColor2,
        icon: Icons.business,
      );

    } catch (e) {
      print("Error switching company: $e");
      showCustomSnackbar(
        title: "Error",
        message: "Failed to switch company",
        baseColor: AppColors.errorColor,
        icon: Icons.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Show company selection dialog
  void showCompanySwitcher() {
    if (!hasMultipleCompanies.value) {
      showCustomSnackbar(
        title: "Info",
        message: "You only have one company registered",
        baseColor: AppColors.appColor,
        icon: Icons.info,
      );
      return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.swap_horiz, color: Colors.blue.shade700, size: 24),
                  SizedBox(width: 12),
                  Text(
                    "Switch Company",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Company list
              Container(
                constraints: BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children: allUserCompanies.map((company) {
                      final isCurrentCompany = company['id'] == companyId.value;

                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: isCurrentCompany ? null : () {
                            Get.back();
                            switchCompany(company);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isCurrentCompany
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCurrentCompany
                                    ? Colors.blue.shade300
                                    : Colors.grey.shade300,
                                width: isCurrentCompany ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isCurrentCompany
                                        ? Colors.blue.shade700
                                        : Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.business,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company['companyName'] ?? 'Unknown Company',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isCurrentCompany
                                              ? Colors.blue.shade700
                                              : Colors.black87,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        company['companyCode'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isCurrentCompany)
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade700,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Add new company button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.back();
                    Get.toNamed(CompanyRegistrationScreen.pageId);
                  },
                  icon: Icon(Icons.add_business),
                  label: Text("Add New Company"),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: Colors.blue.shade700,
                    side: BorderSide(color: Colors.blue.shade700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void loadDashboardData() async {
    try {
      isLoading.value = true;

      // Load dashboard statistics and customer count
      await Future.wait([
        _loadDashboardStatistics(),
        loadCustomerCount(), // Add this line
      ]);

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

  // Load actual dashboard statistics from Firebase
  Future<void> _loadDashboardStatistics() async {
    try {
      final user = _auth.currentUser;
      if (user == null || companyId.value.isEmpty) {
        // Use mock data if no company
        _loadMockData();
        return;
      }

      // Load actual invoices from Firebase
      final invoicesSnapshot = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .doc(companyId.value)
          .collection("invoices")
          .get();

      // Calculate statistics from actual data
      int totalCount = invoicesSnapshot.docs.length;
      int paidCount = 0;
      int unpaidCount = 0;
      int overdueCount = 0;
      int draftCount = 0;
      double totalRev = 0.0;
      double pendingAmt = 0.0;
      double overdueAmt = 0.0;

      List<Invoice> recentInvoicesList = [];

      for (var doc in invoicesSnapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? 'draft';
        final amount = (data['totalAmount'] ?? 0.0).toDouble();

        switch (status.toLowerCase()) {
          case 'paid':
            paidCount++;
            totalRev += amount;
            break;
          case 'pending':
          case 'unpaid':
            unpaidCount++;
            pendingAmt += amount;
            break;
          case 'overdue':
            overdueCount++;
            overdueAmt += amount;
            break;
          case 'draft':
            draftCount++;
            break;
        }

        // Add to recent invoices (limit to 10)
        if (recentInvoicesList.length < 10) {
          recentInvoicesList.add(Invoice(
            invoiceId: data['invoiceId'] ?? doc.id,
            customerName: data['customerName'] ?? 'Unknown',
            price: amount,
            itemId: data['itemId'] ?? '',
            qty: data['qty'] ?? 1,
            mobile: data['customerMobile'] ?? '',
            itemName: data['itemName'] ?? '',
          ));
        }
      }

      // Update observable variables
      totalInvoices.value = totalCount;
      paidInvoices.value = paidCount;
      unpaidInvoices.value = unpaidCount;
      overdueInvoices.value = overdueCount;
      draftInvoices.value = draftCount;
      totalRevenue.value = totalRev;
      pendingAmount.value = pendingAmt;
      overdueAmount.value = overdueAmt;
      recentInvoices.value = recentInvoicesList;

      // Update chart data
      invoiceStatusData.value = [
        ChartData('Paid', paidCount.toDouble(), Colors.green),
        ChartData('Pending', unpaidCount.toDouble(), Colors.orange),
        ChartData('Overdue', overdueCount.toDouble(), Colors.red),
        ChartData('Draft', draftCount.toDouble(), Colors.grey),
      ];

      // Mock monthly revenue for now (you can implement actual monthly calculation)
      monthlyRevenue.value = [15000, 18500, 22000, 19500, 25000, totalRev];

    } catch (e) {
      print("Error loading dashboard statistics: $e");
      _loadMockData(); // Fallback to mock data
    }
  }

  // Fallback mock data
  void _loadMockData() {
    totalInvoices.value = 156;
    paidInvoices.value = 89;
    unpaidInvoices.value = 45;
    overdueInvoices.value = 12;
    draftInvoices.value = 10;
    totalRevenue.value = 125430.50;
    pendingAmount.value = 34560.75;
    overdueAmount.value = 8945.25;

    recentInvoices.value = [
      Invoice(
        invoiceId: 'INV-001',
        customerName: 'John Doe',
        price: 1500.0,
        itemId: '',
        qty: 11,
        mobile: '',
        itemName: '',
      ),
      Invoice(
        invoiceId: 'INV-002',
        customerName: 'Jane Smith',
        price: 160.0,
        itemId: '',
        qty: 1,
        mobile: '',
        itemName: '',
      ),
    ];

    monthlyRevenue.value = [15000, 18500, 22000, 19500, 25000, 28000];
    invoiceStatusData.value = [
      ChartData('Paid', paidInvoices.value.toDouble(), Colors.green),
      ChartData('Pending', unpaidInvoices.value.toDouble(), Colors.orange),
      ChartData('Overdue', overdueInvoices.value.toDouble(), Colors.red),
      ChartData('Draft', draftInvoices.value.toDouble(), Colors.grey),
    ];
  }

  void refreshDashboard() {
    _loadCompanyData();
    loadDashboardData();
  }

  void navigateToCreateInvoice() {
    print("Compny--------:${companyId.value}");
    if (companyId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please register a company first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.toNamed(CompanyRegistrationScreen.pageId);
      return;
    }
    Get.lazyPut<NewInvoiceController>(() => NewInvoiceController());

    Get.to(() => NewInvoiceScreen());
    //Get.toNamed(NewInvoiceScreen.pageId);
  }

  void navigateToInvoiceList() {
    Get.toNamed(ItemScreen.pageId);
  }

  // Updated method to navigate to customer registration with company selection
  void navigateToCustomers() {
    // Always show company selection screen
    Get.toNamed(CompanySelectionScreen.pageId);
  }

  /// New method specifically for adding a new customer
  // void navigateToAddNewCustomer() {
  //   // Always show company selection first
  //   Get.toNamed(CompanySelectionScreen.pageId);
  // }

  // Updated method for adding new customer
  void navigateToAddNewCustomer() {
    if (companyId.value.isEmpty) {
      Get.snackbar(
        'Company Required',
        'Please register a company first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      Get.toNamed(CompanyRegistrationScreen.pageId);
      return;
    }

    // Navigate directly to company selection or customer registration
    Get.toNamed(CompanySelectionScreen.pageId);
  }

  // Updated method to get customer count and load it in dashboard
  Future<void> loadCustomerCount() async {
    try {
      final user = _auth.currentUser;
      if (user == null || companyId.value.isEmpty) {
        customerCount.value = 0;
        return;
      }

      final customersSnapshot = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .doc(companyId.value)
          .collection("customers")
          .where('isActive', isEqualTo: true)
          .get();

      customerCount.value = customersSnapshot.docs.length;
    } catch (e) {
      print("Error getting customer count: $e");
      customerCount.value = 0;
    }
  }


  // Method to navigate to customer list (if you have one)
  // Updated method to navigate to customer list

  void navigateToCustomerList() {
    if (companyId.value.isEmpty) {
      print("companyId.value: ${companyId.value}");
      Get.snackbar(
        'Company Required',
        'Please register a company first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      Get.toNamed(CompanyRegistrationScreen.pageId);
      return;
    }

    print("Navigating to Customer List Screen");

    // Try direct navigation first
    try {
      // Make sure the controller is initialized
      if (!Get.isRegistered<CustomerListController>()) {
        Get.put(CustomerListController());
      }

      // Navigate to the screen
      Get.to(() => const CustomerListScreen());
    } catch (e) {
      print("Error navigating to customer list: $e");
      // Fallback - show a simple dialog with customer count
      _showSimpleCustomerDialog();
    }
  }

  // 3. Add this fallback method to your DashboardController:
  void _showSimpleCustomerDialog() async {
    // Load customer count first
    await loadCustomerCount();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.people, color: Colors.orange.shade700, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Customer Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Customer Count Display
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade100, Colors.orange.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.people,
                      size: 40,
                      color: Colors.orange.shade700,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Total Customers',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Obx(() => Text(
                      '${customerCount.value}',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    )),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Add New Customer Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back(); // Close dialog
                    navigateToAddNewCustomer();
                  },
                  icon: Icon(Icons.person_add),
                  label: Text('Add New Customer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12),

              // View All Customers Button (if you want to try navigation again)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.back(); // Close dialog
                    // Try to navigate to full customer list
                    Get.to(() => const CustomerListScreen());
                  },
                  icon: Icon(Icons.list),
                  label: Text('View All Customers'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange.shade700,
                    side: BorderSide(color: Colors.orange.shade700),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
  }

  void viewInvoiceDetails(String invoiceId) {
    Get.toNamed('/invoice-details/$invoiceId');
  }

  // Method to get customer count for dashboard display
  Future<int> getCustomerCount() async {
    try {
      final user = _auth.currentUser;
      if (user == null || companyId.value.isEmpty) return 0;

      final customersSnapshot = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .doc(companyId.value)
          .collection("customers")
          .where('isActive', isEqualTo: true)
          .get();

      return customersSnapshot.docs.length;
    } catch (e) {
      print("Error getting customer count: $e");
      return 0;
    }
  }

  // Method to check if company is registered
  bool get isCompanyRegistered => companyId.value.isNotEmpty;

  // Method to get company name for display
  String get companyName => currentCompany.value?['companyName'] ?? 'No Company';

  Future<void> logout() async {
    try {
      // Clear Firebase Auth
      await FirebaseAuth.instance.signOut();

      // Clear local storage
      await sharedPreferencesHelper.clearPrefData();

      // Navigate to Auth/Login screen
      Get.offAllNamed(AuthScreen.pageId);

      print("✅ User logged out successfully");
    } catch (e) {
      print("❌ Logout Error: $e");
      Get.snackbar("Error", "Logout failed, try again");
    }
  }


}

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}