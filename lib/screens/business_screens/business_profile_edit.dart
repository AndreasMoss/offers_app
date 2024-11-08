import 'package:flutter/material.dart';

class BusinessProfileEditScreen extends StatefulWidget {
  const BusinessProfileEditScreen({super.key});

  @override
  State<BusinessProfileEditScreen> createState() =>
      _BusinessProfileEditScreenState();
}

class _BusinessProfileEditScreenState extends State<BusinessProfileEditScreen> {
  final _editProfileForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _editProfileForm,
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
                    //_enteredVALUE = value!;
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
                    //_enteredVALUE = value!;
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
                    //_enteredCodesVALUE = int.tryParse(value!)!;
                  },
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary),
                  child: const Text('Add Offer'),
                ),
              ],
            )),
      ),
    );
  }
}
