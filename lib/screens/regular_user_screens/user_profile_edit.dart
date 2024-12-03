import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offers_app/providers/user_provider.dart';

class UserProfileEditScreen extends ConsumerStatefulWidget {
  const UserProfileEditScreen({super.key});

  @override
  ConsumerState<UserProfileEditScreen> createState() =>
      _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends ConsumerState<UserProfileEditScreen> {
  final _editProfileForm = GlobalKey<FormState>();

  var _enteredUsername = '';
  bool _isLoading = false;

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
    //String? imageUrl = await _uploadImage(userIdProvided);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userIdProvided)
          .update({
        'username': _enteredUsername,
        // if (imageUrl != null) 'profile_image': imageUrl,
      });
    } catch (error) {
      print(
          "ERROR ON UPDATING THE USER FILE IN FIRESTORE WHILE EDITING PROFILE AFTER SAVE");
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.of(context).pop();
    }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Username Section',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Edit your Username'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a valid Username';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _enteredUsername = value!.trim();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submitEditProfileForm,
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(20, 40),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary),
                          child: const Text('Save'),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
