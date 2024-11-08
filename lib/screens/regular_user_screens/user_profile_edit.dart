//THELEI FTIAKSIMO TO IF EINAI USER I BUSINESS
// DEN EXEI TELEIWSEI OPOTE PAW NA BALW MONO GIA TA BUSINESSES TORA TO EDIT PROFILE

// MI TELEIWMENO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/providers/usertype_provider.dart';

class UserProfileEditScreen extends ConsumerStatefulWidget {
  const UserProfileEditScreen({super.key});

  @override
  ConsumerState<UserProfileEditScreen> createState() =>
      _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends ConsumerState<UserProfileEditScreen> {
  final _editProfileForm = GlobalKey<FormState>();

  var _enteredUsername = '';

  void _submitEditProfileForm() async {
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

    _editProfileForm.currentState!.save();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userIdProvided)
          .update({
        'username': _enteredUsername,
      });
    } catch (error) {
      print(
          "ERROR ON UPDATING THE USER FILE IN FIRESTORE WHILE EDITING PROFILE AFTER SAVE");
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
            key: _editProfileForm,
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Enter your Username'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid Username';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _enteredUsername = value!;
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                ElevatedButton(
                  onPressed: _submitEditProfileForm,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary),
                  child: const Text('Save'),
                ),
              ],
            )),
      ),
    );
  }
}
