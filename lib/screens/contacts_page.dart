import 'package:flutter/material.dart';
import 'package:tcc_app/components/contacts_form.dart';
import 'package:tcc_app/components/contacts_list.dart';
import 'package:tcc_app/models/contact.dart';
import 'package:uuid/uuid.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final _contacts = <Contact>[];

  _addContact(String name, String email, String phone, String relationship) {
    final newContact = Contact(
      id: const Uuid().v4(),
      name: name,
      email: email,
      phone: phone,
      relationship: relationship,
    );

    setState(() {
      _contacts.add(newContact);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
      ),
      body: Column(
        children: [
          ContactsList(contacts: _contacts),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.person_add_alt_1, size: 50),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return ContactsForm(onSubmit: _addContact);
            },
          );
        },
        elevation: 7,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
