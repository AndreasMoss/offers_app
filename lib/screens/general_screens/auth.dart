// NEED TO FIX
// PREPEI NA FTIAXW TA IFs na einai 1 if, giati exw balei kapou 3, otan eftiaxna to userType form.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:offers_app/models/user_type.dart';
import 'package:offers_app/theme/colors_for_text.dart';

//setting the firebase instance object
final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;

  var _enteredEmail = '';
  var _enteredPassword = '';
  UserType _selectedUserType = UserType.regular;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'email': _enteredEmail,
          'userType':
              _selectedUserType == UserType.business ? 'business' : 'regular',
        });
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication Failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isLogin ? 'Please Log in! 👋' : 'Create an Account! 👋',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: textBlackB12),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                    'Join now to discover exclusive offers and discounts tailored just for you.'),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: textBlackB12),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Email Address'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Password',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: textBlackB12),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters long.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _enteredPassword = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!_isLogin)
                    Row(
                      children: [
                        SizedBox(
                          width: 155.5,
                          height: 48,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    _selectedUserType = UserType.business;
                                    //de mporei na einai null kathws exw kanei arxikopoiisi tou _selectedUserType
                                    print(_selectedUserType);
                                  },
                                );
                              },
                              child: const Text('Business')),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 155.5,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(
                                () {
                                  _selectedUserType = UserType.regular;
                                  //de mporei na einai null kathws exw kanei arxikopoiisi tou _selectedUserType
                                  print(_selectedUserType);
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Regular'),
                          ),
                        ),
                      ],
                    ),
                  // if (!_isLogin)
                  //   DropdownButtonFormField(
                  //     value: UserType.regular,
                  //     items: const [
                  //       DropdownMenuItem(
                  //         //value sto menuItem einai to value poy tha parei en telei stin epilogi.
                  //         value: UserType.regular,
                  //         child: Text(
                  //           'Regular User',
                  //           style: TextStyle(fontWeight: FontWeight.normal),
                  //         ),
                  //       ),
                  //       DropdownMenuItem(
                  //         value: UserType.business,
                  //         child: Text(
                  //           'Business',
                  //           style: TextStyle(fontWeight: FontWeight.normal),
                  //         ),
                  //       ),
                  //     ],
                  //     onChanged: (value) {
                  //       setState(
                  //         () {
                  //           _selectedUserType = value!;
                  //           //de mporei na einai null kathws exw kanei arxikopoiisi tou _selectedUserType
                  //           print(_selectedUserType);
                  //         },
                  //       );
                  //     },
                  //   ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      child: Text(_isLogin ? 'Log in' : 'Sign up'),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create an account'
                          : 'Log in with an existing account'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
