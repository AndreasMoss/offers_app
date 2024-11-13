import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/theme/colors_for_text.dart';

class BusinessProfileEditScreen extends ConsumerStatefulWidget {
  const BusinessProfileEditScreen({super.key});

  @override
  ConsumerState<BusinessProfileEditScreen> createState() =>
      _BusinessProfileEditScreenState();
}

class _BusinessProfileEditScreenState
    extends ConsumerState<BusinessProfileEditScreen> {
  final _editProfileForm = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  var _enteredBusinessName = '';

  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    // i .pickImage tha epistrepsei ena XFile? , to opoio periexei pliforories gia to arxeio pou epilexthike.
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 375,
      maxHeight: 352,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(String userId) async {
    if (_selectedImage == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');

      await storageRef.putFile(_selectedImage!);
      return await storageRef.getDownloadURL();
    } catch (error) {
      print("Error uploading image: $error");
      return null;
    }
  }

  void _submitEditProfileForm() async {
    if (_isLoading) return;
    final isValid = _editProfileForm.currentState!.validate();

    final userIdProvided = ref.read(userIdProvider);
    if (userIdProvided == null) {
      print(
          'ISSUE WITH userIdProvided in edit profile form!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      return;
    }

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _editProfileForm.currentState!.save();

    // anebase tin eikona kai pare to url
    String? imageUrl = await _uploadImage(userIdProvided);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userIdProvided)
          .update({
        'business_name': _enteredBusinessName,
        if (imageUrl != null) 'profile_image': imageUrl,
      });
    } catch (error) {
      print(
          "ERROR ON UPDATING THE USER FILE IN FIRESTORE WHILE EDITING PROFILE AFTER SAVE");
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _editProfileForm,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Enter your Business Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid business Name';
                  }

                  return null;
                },
                onSaved: (value) {
                  _enteredBusinessName = value!;
                },
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: const Text('Select Profile Image'),
                style: ElevatedButton.styleFrom(backgroundColor: textGrayB98),
              ),
              const SizedBox(height: 10),
              if (_selectedImage != null)
                Column(
                  children: [
                    Image.file(
                      _selectedImage!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Selected Image',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )
              else
                const Text(
                  'No image selected',
                  style: TextStyle(color: Colors.grey),
                ),
              const Spacer(),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitEditProfileForm,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      child: const Text('Save'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
