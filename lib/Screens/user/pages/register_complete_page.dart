import 'dart:io';
import 'package:fashion/Screens/user/Widgets/bottom_navigation.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/core/constant/const_size.dart';
import 'package:fashion/core/constant/snack_bar.dart';
import 'package:fashion/core/constant/text_form_field.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenRegisterNext extends StatefulWidget {
  final String userId;
  final String userName;
  const ScreenRegisterNext({super.key, required this.userId, required this.userName});

  @override
  State<ScreenRegisterNext> createState() => _ScreenRegisterNextState();
}

class _ScreenRegisterNextState extends State<ScreenRegisterNext> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _houseName = TextEditingController();
  final TextEditingController _houseNum = TextEditingController();
  final TextEditingController _locality = TextEditingController();
  File? _selectedImage;
  Uint8List? _pickedImageBytes;
  String? _selectedGender;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                sizedHeight(35),
                const Text(
                  'Complete Your Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "Don't worry, only you can see your personal \n data. No one else will be able to see it.",
                  style: TextStyle(color: Colors.grey),
                ),
                sizedHeight(30),
                InkWell(
                  onTap: () {
                    pickImage();
                  },
                  child: CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 60,
                    child: _selectedImage != null
                        ? ClipOval(
                          child: kIsWeb && _pickedImageBytes != null ? Image.memory(
                            _pickedImageBytes!,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ) : Image.file(
                            _selectedImage!,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          )
                        ) : const Icon(Icons.person,
                        size: 100,
                        color: Colors.black,
                        )
                  ),
                ),
                sizedHeight(20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textFormField(
                        label: 'Phone No',
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Mobile Number';
                          }
                          if (value.length != 10) {
                            return 'Invalid Mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12,),
                      textFormField(
                        label: 'House Number',
                        keyboardType: TextInputType.streetAddress,
                        controller: _houseNum,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter House Number';
                          }
                          return null;
                        },
                      ),
                      sizedHeight(12),
                      textFormField(
                        label: 'House Name',
                        keyboardType: TextInputType.streetAddress,
                        controller: _houseName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter House Name';
                          }
                          return null;
                        },
                      ),
                      sizedHeight(12),
                      textFormField(
                        label: 'Locality',
                        keyboardType: TextInputType.streetAddress,
                        controller: _locality,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter locality';
                          }
                          return null;
                        },
                      ),
                      sizedHeight(12),
                      textFormField(
                        label: 'address',
                        keyboardType: TextInputType.streetAddress,
                        controller: _addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter House Name';
                          }
                          return null;
                        },
                      ),
                      sizedHeight(12),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          label: const Text('Gender'),
                        ),
                        value: _selectedGender,
                        items: _genderOptions.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue;
                          });
                        },
                      ),
                      sizedHeight(20),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveUserDetails();
                            }
                          },
                          child: const Text('Sign Up'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Future<void> pickImage() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: false,
  );

  if (result != null && result.files.isNotEmpty) {
    final file = result.files.single;
    
    if (kIsWeb) {
      if (file.bytes != null) {
        setState(() {
          _pickedImageBytes = file.bytes;
          _selectedImage = null; 
        });
      } else {
        showSnackBar(context, 'Failed to pick image', Colors.red);
      }
    } else {
      if (file.path != null) {
        setState(() {
          _pickedImageBytes = null; 
          _selectedImage = File(file.path!);
        });
      } else {
        showSnackBar(context, 'Failed to pick image', Colors.red);
      }
    }
  } else {
    showSnackBar(context, 'No file selected', Colors.red);
  }
}


  Future<void> _saveUserDetails() async {
    try {
      final address = _addressController.text.trim();
      final phone = _phoneController.text.trim();
      final gender = _selectedGender;
      final houeName = _houseName.text.trim();
      final houeNum = _houseNum.text.trim();
      final locality = _locality.text.trim();
      if (_selectedImage != null) {
        _pickedImageBytes = await _selectedImage!.readAsBytes();
      }
      await saveUSerDetails(
        widget.userId, 
        widget.userName, 
        address, 
        gender!, 
        phone, 
        _pickedImageBytes!,
        houeName,
        houeNum,
        locality
      );

      showSnackBar(context, 'Register Successfully', Colors.green);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const ScreenBottomNavigationBar()), 
        (Route<dynamic> route) => false
      );

      final sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.setBool(USER_KEY_VALUE, true);

    } on FirebaseAuthException catch (e) {
      showSnackBar(context, 'User already exist$e', Colors.red);
    } catch (e) {
      showSnackBar(context, 'Error$e', Colors.red);
    }
  }
}