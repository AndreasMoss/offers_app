import 'package:flutter/material.dart';

import 'package:offers_app/dummy_data_for_test/dummy_offers.dart';
import 'package:offers_app/models/offer.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final _addForm = GlobalKey<FormState>();

  var _enteredID = '';
  var _enteredTitle = '';
  var _enteredDescription = '';
  var _enteredCodesNumber = 1;

  void _submitAddForm() {
    final isValid = _addForm.currentState!.validate();

    if (!isValid) {
      return;
    }

    _addForm.currentState!.save();

    dummyOffers.add(
      Offer(
          id: _enteredID,
          title: _enteredTitle,
          description: _enteredDescription,
          codes: _enteredCodesNumber),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new Offer'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _addForm,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'ID'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid ID';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _enteredID = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'title'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid title';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      //se kathe tetoio elegxoume an einai null ston validator pou kaloume prin to save sto _submitAddForm.
                      //Giauto bazoume !
                      _enteredTitle = value!;
                    },
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
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Number of Codes'),
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
                  ElevatedButton(
                    onPressed: _submitAddForm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                    child: const Text('Add Offer'),
                  ),
                ],
              )),
        ));
  }
}
