import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offers_app/functions.dart/current_location.dart';
import 'package:offers_app/models/for_maps.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/screens/business_screens/choose_location_map.dart';
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
  PlaceLocation? _pickedLocation;

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

    if (_pickedLocation == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please pick your Business Location before saving',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black87,
          duration: Duration(seconds: 2), // Προσαρμογή διάρκειας.
        ),
      );
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
        'location':
            GeoPoint(_pickedLocation!.latitude, _pickedLocation!.longtitude),
        'address': _pickedLocation!.address,
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
      resizeToAvoidBottomInset: false,
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
              const SizedBox(
                height: 40,
              ),
              Text(
                'Put your Business Location',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        final fetchedLocation = await getCurrentLocation();
                        setState(() {
                          _pickedLocation = fetchedLocation;
                        });
                      },
                      child: const Text(
                        'Get current Location',
                        textAlign: TextAlign.center,
                      )),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        final markedLocation =
                            await Navigator.of(context).push<LatLng>(
                          MaterialPageRoute(
                            builder: (ctx) {
                              return const ChooseLocationMap();
                            },
                          ),
                        );

                        if (markedLocation == null) {
                          return;
                        }

                        final address = await locationToAddress(
                            latitude: markedLocation.latitude,
                            longtitude: markedLocation.longitude);
                        setState(() {
                          _pickedLocation = PlaceLocation(
                              latitude: markedLocation.latitude,
                              longtitude: markedLocation.longitude,
                              address: address);
                        });
                      },
                      child: const Text(
                        'Choose on Map',
                        textAlign: TextAlign.center,
                      )),
                ),
              ]),
              if (_pickedLocation != null)
                Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text('Picked address:'),
                    Text(_pickedLocation!.address),
                  ],
                ),
              // if (_pickedLocation != null)
              //   Text(_pickedLocation!.latitude.toString()),
              // if (_pickedLocation != null)
              //   Text(_pickedLocation!.longtitude.toString()),
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
