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

    Navigator.of(context).pop();
  }

  _deleteContact(String id) {
    setState(() {
      _contacts.removeWhere((element) => element.id == id);
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
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: ContactsList(
              contacts: _contacts,
              onRemove: _deleteContact,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.person_add_alt_1, size: 50),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(5),
              ),
            ),
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
