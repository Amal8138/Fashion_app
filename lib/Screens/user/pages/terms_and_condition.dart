import 'package:fashion/core/colors/colors.dart';
import 'package:flutter/material.dart';

class ScreenTermsAndConditions extends StatelessWidget {
  const ScreenTermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms And Conditions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body:const SingleChildScrollView(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Introduction',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'These terms and conditions govern your use of our application. By using this app, you accept these terms and conditions in full. If you disagree with any part of these terms and conditions, you must not use this app.',
            ),
            SizedBox(height: 16.0),
            Text(
              '2. License to Use the App',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Unless otherwise stated, we and/or our licensors own the intellectual property rights in the app and material on the app. Subject to the license below, all these intellectual property rights are reserved.',
            ),
            SizedBox(height: 16.0),
            Text(
              '3. Acceptable Use',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'You must not use this app in any way that causes, or may cause, damage to the app or impairment of the availability or accessibility of the app; or in any way which is unlawful, illegal, fraudulent, or harmful.',
            ),
            SizedBox(height: 16.0),
            Text(
              '4. User Accounts',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'If you create an account in our app, you are responsible for maintaining the confidentiality of your account and password and for restricting access to your device. You agree to accept responsibility for all activities that occur under your account or password.',
            ),
            SizedBox(height: 16.0),
            Text(
              '5. Products or Services',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Certain products or services may be available exclusively online through the app. These products or services may have limited quantities and are subject to return or exchange only according to our Return Policy.',
            ),
            SizedBox(height: 16.0),
            Text(
              '6. Limitation of Liability',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'In no event will we, or our suppliers or licensors, be liable with respect to any subject matter of this agreement under any contract, negligence, strict liability, or other legal or equitable theory for any special, incidental, or consequential damages.',
            ),
            SizedBox(height: 16.0),
            Text(
              '7. Governing Law',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'These terms and conditions are governed by and construed in accordance with the laws of [Your Country/State], and you irrevocably submit to the exclusive jurisdiction of the courts in that State or location.',
            ),
            SizedBox(height: 16.0),
            Text(
              '8. Changes to Terms',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'We reserve the right, at our sole discretion, to update, change or replace any part of these Terms and Conditions by posting updates and changes to our app. It is your responsibility to check our app periodically for changes.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact Information',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Questions about the Terms and Conditions should be sent to us at [Your Contact Email].',
            ),
          ],
        ),
      ),
    );
  }
}
