import 'dart:io';
import 'dart:typed_data';
import 'package:fashion/core/constant/snack_bar.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUserWidget extends StatefulWidget {
  final UserSignUpModels user;
  final Function(UserSignUpModels) onUpdate;
  const UpdateUserWidget({super.key, required this.user, required this.onUpdate});

  @override
  State<UpdateUserWidget> createState() => _UpdateUserWidgetState();
}

class _UpdateUserWidgetState extends State<UpdateUserWidget> {
  final TextEditingController inputName = TextEditingController();
  final TextEditingController inputAddress = TextEditingController();
  final TextEditingController inputPhone = TextEditingController();
  final TextEditingController houseName = TextEditingController();
  final TextEditingController houseNum = TextEditingController();
  final TextEditingController locality = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    inputName.text = widget.user.userName;
    inputPhone.text = widget.user.userPhone;
    inputAddress.text = widget.user.userAddress;
    houseName.text = widget.user.houseName;
    houseNum.text = widget.user.houseNumber;
    locality.text = widget.user.locality;
  }

  @override
  void dispose() {
    inputName.dispose();
    inputAddress.dispose();
    inputPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: pickImageFromGallery,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.teal,
                backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : widget.user.userImage.isNotEmpty
                      ? MemoryImage(widget.user.userImage)
                      : null,
                child: _selectedImage == null && widget.user.userImage.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: inputName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: const Text('Name'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    maxLines: 2,
                    controller: inputAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: const Text('Address'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: houseName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: const Text('House Name'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter house name';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: houseNum,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: const Text('House Num'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter House num';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: locality,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: const Text('Locality'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter locality';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: inputPhone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: const Text('Phone'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 15),
                  _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            updateUserDetails();
                          }
                        },
                        child: const Text('Update'),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> updateUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final name = inputName.text.trim();
      final address = inputAddress.text.trim();
      final phone = inputPhone.text.trim();
      final houseNameVal = houseName.text.trim();
      final houseNumVal = houseNum.text.trim();
      final loacalityVal = locality.text.trim();

      if (phone.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid phone number')),
        );
        return;
      }

      Uint8List? userImage = widget.user.userImage;
      if (_selectedImage != null) {
        userImage = await _selectedImage!.readAsBytes();
      }

      final updatedUser = UserSignUpModels(
        userId: widget.user.userId,
        userName: name,
        userPhone: phone,
        userAddress: address,
        userGender: widget.user.userGender,
        userImage: userImage,
        houseName: houseNameVal,
        houseNumber: houseNumVal,
        locality: loacalityVal
      );

      var box = await getUserBox();
      await box.put(widget.user.userId, updatedUser);

     showSnackBar(context, 'Update successfully', Colors.green);

      widget.onUpdate(updatedUser);

      Navigator.pop(context, updatedUser);

    } catch (e) {
      showSnackBar(context, 'Error updating user profile$e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Box<UserSignUpModels>> getUserBox() async {
    if (Hive.isBoxOpen('userBox')) {
      return Hive.box('userBox');
    } else {
      return await Hive.openBox('userBox');
    }
  }
}
