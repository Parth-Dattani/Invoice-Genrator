import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/controller.dart';
import '../../widgets/widgets.dart';





class CompanyRegistrationScreen extends GetView<CompanyController> {
  static const pageId = "/CompanyRegistrationScreen";

  const CompanyRegistrationScreen({super.key});

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Company Registration"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal, Colors.tealAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Company Info Section ---
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _sectionTitle("Company Info", Icons.business),
                      CustomTextFormField(
                        controller: controller.companyCodeController,
                        label: "Company Code *",
                        prefixIcon: Icons.qr_code,
                        isRequired: true,
                      ),
                      CustomTextFormField(
                        controller: controller.companyNameController,
                        label: "Company Name *",
                        prefixIcon: Icons.apartment,
                        isRequired: true,
                      ),
                      CustomTextFormField(
                        controller: controller.addressController,
                        label: "Address",
                        prefixIcon: Icons.location_on,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: controller.cityController,
                              label: "City *",
                              prefixIcon: Icons.location_city,
                              isRequired: true,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextFormField(
                              controller: controller.stateController,
                              label: "State *",
                              prefixIcon: Icons.map,
                              isRequired: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: controller.countryController,
                              label: "Country *",
                              prefixIcon: Icons.flag,
                              isRequired: true,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextFormField(
                              controller: controller.pincodeController,
                              label: "Pincode *",
                              prefixIcon: Icons.pin,
                              keyboardType: TextInputType.number,
                              isRequired: true,
                            ),
                          ),
                        ],
                      ),
                      CustomTextFormField(
                        controller: controller.logoController,
                        label: "Logo",
                        prefixIcon: Icons.image,
                        hintText: "Upload company logo",
                      ),
                    ],
                  ),
                ),
              ),

              // --- Business Info Section ---
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _sectionTitle("Business Info", Icons.pie_chart),
                      CustomTextFormField(
                        controller: controller.businessCategoryController,
                        label: "Business Category *",
                        prefixIcon: Icons.category,
                        isRequired: true,
                      ),
                      CustomTextFormField(
                        controller: controller.gstController,
                        label: "G.S.T. Number",
                        prefixIcon: Icons.confirmation_number,
                      ),
                      CustomTextFormField(
                        controller: controller.panController,
                        label: "PAN No",
                        prefixIcon: Icons.credit_card,
                      ),
                    ],
                  ),
                ),
              ),

              // --- Bank Info Section ---
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _sectionTitle("Bank Info", Icons.account_balance),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: controller.bankNameController,
                              label: "Bank Name",
                              prefixIcon: Icons.account_balance_wallet,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextFormField(
                              controller: controller.ifscController,
                              label: "IFSC Code",
                              prefixIcon: Icons.code,
                            ),
                          ),
                        ],
                      ),
                      CustomTextFormField(
                        controller: controller.accountNumberController,
                        label: "Account Number",
                        prefixIcon: Icons.numbers,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),

              // --- Authorisation Section ---
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _sectionTitle("Authorisation", Icons.edit_document),
                      CustomTextFormField(
                        controller: controller.authorisedSignatureController,
                        label: "Authorised Signature *",
                        prefixIcon: Icons.person,
                        isRequired: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // --- Register Button ---
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    "Register Company",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => controller.registerCompany(),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}


