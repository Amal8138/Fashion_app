import 'package:fashion/core/colors/colors.dart';
import 'package:flutter/material.dart';

class ScreenPrivacyAndPolicy extends StatelessWidget {
  const ScreenPrivacyAndPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy and Policy',style: TextStyle(color: Colors.white),),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our e-commerce application. '
              'Please read this privacy policy carefully. If you do not agree with the terms of this privacy policy, please do not access the application.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Information We Collect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We may collect information about you in a variety of ways. The information we may collect via the Application includes:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '1. Personal Data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Personally identifiable information, such as your name, shipping address, email address, and telephone number, and demographic information, '
              'such as your age, gender, hometown, and interests, that you voluntarily give to us when you register with the application.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '2. Payment Data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Financial information, such as data related to your payment method (e.g., valid credit card number, card brand, expiration date) '
              'that we may collect when you purchase, order, return, exchange, or request information about our services.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'How We Use Your Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We use the information we collect in the following ways:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '1. To facilitate account creation and logon process.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '2. To send you marketing and promotional communications.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '3. To fulfill and manage purchases, orders, payments, and other transactions related to the Application.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '4. To respond to product and customer service requests.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'If you have questions or comments about this Privacy Policy, please contact us at:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Email: support@ecommerceapp.com',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
