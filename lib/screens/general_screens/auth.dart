// NEED TO FIX
// PREPEI NA FTIAXW TA IFs na einai 1 if, giati exw balei kapou 3, otan eftiaxna to userType form.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:offers_app/models/user_type.dart';
import 'package:offers_app/theme/other_colors.dart';

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

  var _isBusiness = true;

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredName = '';

  UserType _selectedUserType = UserType.business;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final achievementData = {
          'entertainmentRedemptions': 0,
          'fitnessRedemptions': 0,
          'coffeeAndFoodRedemptions': 0,
          'healthRedemptions': 0,
          'technologyRedemptions': 0,
          'learningRedemptions': 0,
          'beautyRedemptions': 0,
          'petsRedemptions': 0,
          'servicesRedemptions': 0,
          'clothesShoesRedemptions': 0,
        };
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'email': _enteredEmail,
          if (_selectedUserType == UserType.regular) 'username': _enteredName,
          if (_selectedUserType == UserType.business)
            'business_name': _enteredName,
          'userType':
              _selectedUserType == UserType.business ? 'business' : 'regular',
          if (_selectedUserType == UserType.regular) 'points': 0,
          if (_selectedUserType == UserType.business) 'points': -1,
          if (_selectedUserType == UserType.regular) 'totalCodesUsed': 0,
          if (_selectedUserType == UserType.business) 'totalCodesGiven': 0,
          if (_selectedUserType == UserType.regular) ...achievementData,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(116, 102, 109, 128),
            content: Text(
              error.message ?? 'Authentication Failed',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isLogin ? 'Please Log in! 👋' : 'Create an Account! 👋',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(color: textBlackB12),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Join now to discover exclusive offers and discounts tailored just for you.',
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ////////////////////////////////////////
                          if (!_isLogin)
                            Text(
                              'Username or Business name',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: textBlackB12),
                            ),
                          if (!_isLogin) const SizedBox(height: 8),
                          if (!_isLogin)
                            SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Enter your name',
                                ),
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter a valid name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredName = value!;
                                },
                              ),
                            ),
                          if (!_isLogin) const SizedBox(height: 16),
                          //////////////////////////////////////////
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
                              decoration: const InputDecoration(
                                labelText: 'Enter your email',
                              ),
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
                              decoration: const InputDecoration(
                                labelText: 'Enter your password',
                              ),
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
                          if (!_isLogin) const SizedBox(height: 16),
                          if (!_isLogin)
                            Row(
                              children: [
                                SizedBox(
                                  width: 165,
                                  height: 48,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: _isBusiness
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : const Color(0xFFDFE1E7),
                                      ),
                                      foregroundColor: _isBusiness
                                          ? textBlackB12
                                          : textGrayB98,
                                      textStyle: _isBusiness
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                          : Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400),
                                      backgroundColor: _isBusiness
                                          ? Theme.of(context)
                                              .colorScheme
                                              .surface
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isBusiness = true;
                                        _selectedUserType = UserType.business;
                                        print('Business: $_isBusiness');
                                      });
                                    },
                                    child: const Text('Business'),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 165,
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isBusiness = false;
                                        _selectedUserType = UserType.regular;
                                        print('Business: $_isBusiness');
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: !_isBusiness
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : const Color(0xFFDFE1E7),
                                      ),
                                      foregroundColor: !_isBusiness
                                          ? textBlackB12
                                          : textGrayB98,
                                      textStyle: !_isBusiness
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                          : Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400),
                                      backgroundColor: !_isBusiness
                                          ? Theme.of(context)
                                              .colorScheme
                                              .surface
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text('Regular'),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(),
              child: Text(
                _isLogin ? 'Sign in' : 'Sign up',
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
                  : 'Log in with an existing account'),
            ),
          ],
        ),
      ),
    );
  }
}
