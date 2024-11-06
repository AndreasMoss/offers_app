import 'package:flutter/material.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new Offer'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid email address.';
                  }

                  return null;
                },
                onSaved: (value) {
                  // _enteredValue=value
                },
              ),
            ],
          )),
        ));
  }
}
