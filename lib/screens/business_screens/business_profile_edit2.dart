import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offers_app/functions.dart/current_location.dart';
import 'package:offers_app/models/for_maps.dart';
import 'package:offers_app/providers/user_provider.dart';
import 'package:offers_app/screens/business_screens/choose_location_map.dart';
import 'package:offers_app/theme/colors_for_text.dart';

class BusinessProfileEditScreen2 extends ConsumerStatefulWidget {
  const BusinessProfileEditScreen2({super.key});

  @override
  ConsumerState<BusinessProfileEditScreen2> createState() =>
      _BusinessProfileEditScreenState();
}

class _BusinessProfileEditScreenState
    extends ConsumerState<BusinessProfileEditScreen2> {
  final _editBusinessNameForm = GlobalKey<FormState>();
  final TextEditingController _businessNameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    // Απελευθέρωση του Controller όταν η οθόνη καταστρέφεται
    _businessNameController.dispose();
    super.dispose();
  }

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

  void _submitBusinessNameForm(String userId) async {
    if (_isLoading) return;
    final isValid = _editBusinessNameForm.currentState!.validate();

    if (!isValid) {
      return;
    }
    _editBusinessNameForm.currentState!.save();

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'business_name': _enteredBusinessName,
      });
    } catch (error) {
      print(
          "ERROR ON UPDATING THE USER FILE IN FIRESTORE WHILE EDITING BUSINESS NAME");
    }
    _businessNameController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 120, 120, 120),
          content: Text(
            'Succesfuly changed Business name!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      FocusScope.of(context).unfocus();
    }
  }

  void _submitProfilePicture(String userId) async {
    String? imageUrl = await _uploadImage(userId);
    if (imageUrl == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profile_image': imageUrl,
      });
    } catch (error) {
      print("ERROR ON UPDATING BUSINESS IMAGE PROFILE");
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 120, 120, 120),
          content: Text(
            'Succesfuly changed Profile Image!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      FocusScope.of(context).unfocus();
    }
  }

  void _submitLocation(String userId) async {
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
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'location':
            GeoPoint(_pickedLocation!.latitude, _pickedLocation!.longtitude),
        'address': _pickedLocation!.address,
      });
    } catch (error) {
      print("ERROR ON UPDATING THE USER LOCATION");
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 120, 120, 120),
          content: Text(
            'Succesfuly edited Business Location!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userIdProvided = ref.read(userIdProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Name Section',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Form(
              key: _editBusinessNameForm,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus: false,
                      controller: _businessNameController,
                      decoration: const InputDecoration(
                          labelText: 'Edit your Business Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a valid business Name';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _enteredBusinessName = value!.trim();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (userIdProvided != null) {
                          _submitBusinessNameForm(userIdProvided);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(20, 40)),
                      child: const Text('Save')),
                ],
              ),
            ),
            const SizedBox(height: 52),
            Text(
              'Profile Image Section',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_selectedImage != null)
                  Container(
                    width: 115,
                    height: 108,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                else
                  const Text(
                    'No image selected',
                    style: TextStyle(color: Colors.grey),
                  ),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo),
                      label: const Text('Select'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: textGrayB98,
                          minimumSize: const Size(130, 40)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (userIdProvided != null) {
                          _submitProfilePicture(userIdProvided);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 40)),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 52),
            Text(
              'Business Location Section',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      final fetchedLocation = await getCurrentLocation();
                      setState(() {
                        _pickedLocation = fetchedLocation;
                        _isLoading = false;
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: textGrayB98),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                        : const Text(
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: textGrayB98),
                    child: const Text(
                      'Choose on Map',
                      textAlign: TextAlign.center,
                    )),
              ),
            ]),
            const SizedBox(height: 15),
            if (_pickedLocation != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Picked address:',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      )),
                  const SizedBox(height: 4),
                  Text(
                    _pickedLocation!.address,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textGrayB98,
                    ),
                  ),
                ],
              )
            else
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'No Address selected',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  onPressed: () {
                    if (userIdProvided != null) {
                      _submitLocation(userIdProvided);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(130, 40)),
                  child: const Text('Save')),
            )
          ],
        ),
      ),
    );
  }
}
