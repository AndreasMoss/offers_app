import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_app/models/offer.dart';
import 'package:offers_app/providers/user_provider.dart';

//PROSEXE NA BALEIS NA MI MPOROUN NA KANOUN ADD OFFER BUSINESSESS POU DEN EXOUN BALEI PEDIO ONOMA BUSINESS
// I NA TO ELEGXEIS. GIATI DEN EXW BALEI GIA OLES AKOMA.

class AddOfferScreen extends ConsumerStatefulWidget {
  const AddOfferScreen({super.key});

  @override
  ConsumerState<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends ConsumerState<AddOfferScreen> {
  final _addForm = GlobalKey<FormState>();

  var _enteredTitle = '';
  var _enteredDescription = '';
  var _enteredCodesNumber = 1;
  var _selectedCategory = OfferCategory.entertainment;

  void _submitAddForm() async {
    final isValid = _addForm.currentState!.validate();

    final userIdProvided = ref.read(userIdProvider);
    final userData = ref.read(userDataProvider).value;
    final businessProfileImageUrl = userData!['profile_image'];
    final businessLocation = userData['location'];
    final businessAddress = userData['address'];
    final businessName = userData['business_name'];

    if (userIdProvided == null) {
      print(
          'ISSUE WITH userIdProvided!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      return;
    }

    if (!isValid) {
      return;
    }

    _addForm.currentState!.save();

    await FirebaseFirestore.instance.collection('offers').add({
      'business_id': userIdProvided,
      'title': _enteredTitle,
      'description': _enteredDescription,
      'codes': _enteredCodesNumber,
      'business_image_url': businessProfileImageUrl,
      'isActive': true,
      'location': businessLocation,
      'address': businessAddress,
      'category': _selectedCategory.toString().split('.').last,
      'businessName': businessName,
    });

    //print("New document ID: ${docRef.id}");

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataAsync = ref.watch(userDataProvider);
    return userDataAsync.when(
      data: (userData) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add new Offer'),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10, right: 10, bottom: 24),
            child: Form(
              key: _addForm,
              child: Column(
                children: [
                  // TextFormField(
                  //   decoration: const InputDecoration(labelText: 'ID'),
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) {
                  //       return 'Please enter a valid ID';
                  //     }

                  //     return null;
                  //   },
                  //   onSaved: (value) {
                  //     _enteredID = value!;
                  //   },
                  // ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid Title';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      //se kathe tetoio elegxoume an einai null ston validator pou kaloume prin to save sto _submitAddForm.
                      //Giauto bazoume !
                      _enteredTitle = value!;
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  TextFormField(
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid Description';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _enteredDescription = value!;
                    },
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Number of Codes'),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                int.tryParse(value) == null) {
                              return 'Please enter a valid number of Codes';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredCodesNumber = int.tryParse(value!)!;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<OfferCategory>(
                          isExpanded: true,
                          decoration:
                              const InputDecoration(labelText: 'Category'),
                          dropdownColor: Colors.white,
                          value: _selectedCategory,
                          items: OfferCategory.values
                              .where(
                                  (category) => category != OfferCategory.all)
                              .map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(categoryDict[category]),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                              // print(
                              //     _selectedCategory.toString().split('.').last);
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _submitAddForm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                    child: const Text('Add Offer'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stack) => Scaffold(
        body: Center(
            child: Text(
                'ErrorINADDOFFERPAGE WITH PROFILE IMAGE ASYNC VALUE: $error')),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
