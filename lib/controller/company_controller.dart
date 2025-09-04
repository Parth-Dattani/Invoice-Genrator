import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_prac_getx/controller/bash_controller.dart';
import 'package:demo_prac_getx/screen/dashboard/dashboard_screen.dart';
import 'package:demo_prac_getx/screen/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/constant.dart';
import '../widgets/custom_snackbar.dart';

class CompanyController extends BaseController {
  // TextEditingControllers
  final companyCodeController = TextEditingController();
  final companyNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();
  final logoController = TextEditingController(); // File/Image path (Optional)
  final businessCategoryController = TextEditingController();
  final gstController = TextEditingController();
  final panController = TextEditingController();
  final bankNameController = TextEditingController();
  final ifscController = TextEditingController();
  final accountNumberController = TextEditingController();
  final authorisedSignatureController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Observable variables
  var isCompanyRegistered = false.obs;
  var currentCompany = Rxn<Map<String, dynamic>>();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
   /// _checkCompanyRegistration();
  }

  // Check if current user has registered a company
  Future<void> _checkCompanyRegistration() async {
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
        isCompanyRegistered.value = true;
        currentCompany.value = companyDocs.docs.first.data();
        currentCompany.value!['id'] = companyDocs.docs.first.id; // Add document ID
        _populateFields(currentCompany.value!);

        // Pass company data to customer registration
        Get.offNamed(
          CustomerRegistrationScreen.pageId,
          arguments: {
            'companyId': companyDocs.docs.first.id,
            'companyData': currentCompany.value,
          },
        );
      }
    } catch (e) {
      print("Error checking company registration: $e");
    }
  }

  // Populate form fields with existing company data
  void _populateFields(Map<String, dynamic> companyData) {
    companyCodeController.text = companyData['companyCode'] ?? '';
    companyNameController.text = companyData['companyName'] ?? '';
    addressController.text = companyData['address'] ?? '';
    cityController.text = companyData['city'] ?? '';
    stateController.text = companyData['state'] ?? '';
    countryController.text = companyData['country'] ?? '';
    pincodeController.text = companyData['pincode'] ?? '';
    logoController.text = companyData['logo'] ?? '';
    businessCategoryController.text = companyData['businessCategory'] ?? '';
    gstController.text = companyData['gst'] ?? '';
    panController.text = companyData['pan'] ?? '';
    bankNameController.text = companyData['bankName'] ?? '';
    ifscController.text = companyData['ifsc'] ?? '';
    accountNumberController.text = companyData['accountNumber'] ?? '';
    authorisedSignatureController.text = companyData['authorisedSignature'] ?? '';
  }

  /// Check if company code already exists
  Future<bool> _isCompanyCodeUnique(String companyCode) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final querySnapshot = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("companies")
        .where('companyCode', isEqualTo: companyCode.trim().toUpperCase())
        .limit(1)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  // Validate required fields
  bool _validateRequiredFields() {
    if (companyCodeController.text.trim().isEmpty) {
      showCustomSnackbar(
        title: "",
        message: "Company Code is required",
        icon: Icons.close,
        baseColor: AppColors.appColor,
      );
      return false;
    }

    if (companyNameController.text.trim().isEmpty) {
      showCustomSnackbar(
        title: "",
        message: "Company Name is required",
        icon: Icons.close,
        baseColor: AppColors.appColor,
      );
      return false;
    }

    if (cityController.text.trim().isEmpty) {
      showCustomSnackbar(
        title: "",
        message: "City is required",
        icon: Icons.close,
        baseColor: AppColors.appColor,
      );
      return false;
    }

    if (stateController.text.trim().isEmpty) {
      showCustomSnackbar(
        title: "",
        message: "State is required",
        icon: Icons.close,
        baseColor: AppColors.appColor,
      );
      return false;
    }

    if (countryController.text.trim().isEmpty) {
      showCustomSnackbar(
        title: "",
        message: "Country is required",
        icon: Icons.close,
        baseColor: AppColors.appColor,
      );
      return false;
    }

    if (pincodeController.text.trim().isEmpty) {
      showCustomSnackbar(
        title: "",
        message: "Pincode is required",
        icon: Icons.close,
        baseColor: AppColors.appColor,
      );
      return false;
    }

    if (businessCategoryController.text.trim().isEmpty) {
      showCustomSnackbar(
        title: "",
        message: "Business Category is required",
        icon: Icons.close,
        baseColor: AppColors.appColor,
      );
      return false;
    }

    if (authorisedSignatureController.text.trim().isEmpty) {
      showCustomSnackbar(
        title: "",
        message: "Authorised Signature is required",
        icon: Icons.close,
        baseColor: AppColors.appColor,
      );
      return false;
    }

    // Validate pincode format
    if (!RegExp(r'^\d{6}$').hasMatch(pincodeController.text.trim())) {
      showCustomSnackbar(
        title: "",
        message: "Please enter a valid 6-digit pincode",
        icon: Icons.close,
        baseColor: AppColors.appColor,
      );
      return false;
    }

    // Validate GST format if provided
    if (gstController.text.trim().isNotEmpty) {
      if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
          .hasMatch(gstController.text.trim())) {
        showCustomSnackbar(
          title: "",
          message: "Please enter a valid GST number",
          icon: Icons.close,
          baseColor: AppColors.appColor,
        );
        return false;
      }
    }

    // Validate PAN format if provided
    if (panController.text.trim().isNotEmpty) {
      if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$')
          .hasMatch(panController.text.trim())) {
        showCustomSnackbar(
          title: "",
          message: "Please enter a valid PAN number",
          icon: Icons.close,
          baseColor: AppColors.appColor,
        );
        return false;
      }
    }

    return true;
  }

  /// Save company details to Firestore
  Future<void> registerCompany() async {
    if (!formKey.currentState!.validate()) return;
    if (!_validateRequiredFields()) return;

    final user = _auth.currentUser;
    if (user == null) {
      showCustomSnackbar(
        title: "Error",
        message: "Please login first!",
        baseColor: AppColors.errorColor,
        icon: Icons.error,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Check if company code is unique
      final isUnique = await _isCompanyCodeUnique(companyCodeController.text);
      if (!isUnique) {
        showCustomSnackbar(
          title: "Error",
          message: "Company code already exists. Please choose a different one.",
          baseColor: AppColors.errorColor,
          icon: Icons.error,
        );
        return;
      }

      final companyRef = _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .doc();

      // Prepare company data
      final companyData = {
        'id': companyRef.id,
        'userId': user.uid,
        'userEmail': user.email,
        'companyCode': companyCodeController.text.trim().toUpperCase(),
        'companyName': companyNameController.text.trim(),
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'state': stateController.text.trim(),
        'country': countryController.text.trim(),
        'pincode': pincodeController.text.trim(),
        'logo': logoController.text.trim(),
        'businessCategory': businessCategoryController.text.trim(),
        'gst': gstController.text.trim().toUpperCase(),
        'pan': panController.text.trim().toUpperCase(),
        'bankName': bankNameController.text.trim(),
        'ifsc': ifscController.text.trim().toUpperCase(),
        'accountNumber': accountNumberController.text.trim(),
        'authorisedSignature': authorisedSignatureController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      };

      await companyRef.set(companyData);

      isCompanyRegistered.value = true;
      currentCompany.value = companyData;

      showCustomSnackbar(
        title: "Success",
        message: "Company registered successfully!",
        icon: Icons.done_all,
        baseColor: AppColors.greenColor2,
      );

      // Navigate to customer registration with company data
      Get.offNamed(
        CustomerRegistrationScreen.pageId,
        arguments: {
          'companyId': companyRef.id,
          'companyData': companyData,
        },
      );

    } catch (e) {
      showCustomSnackbar(
        title: "Error",
        message: "Registration failed: ${e.toString()}",
        icon: Icons.close,
        baseColor: AppColors.appColor,
      );
      print('Company registration error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update existing company
  Future<void> updateCompany() async {
    final user = _auth.currentUser;
    if (user == null || currentCompany.value == null) return;

    try {
      isLoading.value = true;

      final companyId = currentCompany.value!['id'];
      final updateData = {
        'companyName': companyNameController.text.trim(),
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'state': stateController.text.trim(),
        'country': countryController.text.trim(),
        'pincode': pincodeController.text.trim(),
        'logo': logoController.text.trim(),
        'businessCategory': businessCategoryController.text.trim(),
        'gst': gstController.text.trim().toUpperCase(),
        'pan': panController.text.trim().toUpperCase(),
        'bankName': bankNameController.text.trim(),
        'ifsc': ifscController.text.trim().toUpperCase(),
        'accountNumber': accountNumberController.text.trim(),
        'authorisedSignature': authorisedSignatureController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .doc(companyId)
          .update(updateData);

      currentCompany.value = {...currentCompany.value!, ...updateData};

      showCustomSnackbar(
        title: "Success",
        message: "Company updated successfully!",
        baseColor: AppColors.greenColor2,
        icon: Icons.done_all,
      );
    } catch (e) {
      showCustomSnackbar(
        title: "Error",
        message: "Update failed: ${e.toString()}",
        baseColor: AppColors.errorColor,
        icon: Icons.close,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear all form fields
  void clearForm() {
    companyCodeController.clear();
    companyNameController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    pincodeController.clear();
    logoController.clear();
    businessCategoryController.clear();
    gstController.clear();
    panController.clear();
    bankNameController.clear();
    ifscController.clear();
    accountNumberController.clear();
    authorisedSignatureController.clear();
  }

  // Get company data for current user
  Future<Map<String, dynamic>?> getCurrentUserCompany() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final companyQuery = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (companyQuery.docs.isNotEmpty) {
        final companyData = companyQuery.docs.first.data();
        companyData['id'] = companyQuery.docs.first.id;
        return companyData;
      }

      return null;
    } catch (e) {
      print('Error fetching company: $e');
      return null;
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    companyCodeController.dispose();
    companyNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    logoController.dispose();
    businessCategoryController.dispose();
    gstController.dispose();
    panController.dispose();
    bankNameController.dispose();
    ifscController.dispose();
    accountNumberController.dispose();
    authorisedSignatureController.dispose();
    super.dispose();
  }

}