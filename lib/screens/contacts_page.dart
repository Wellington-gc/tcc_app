import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tcc_app/components/contacts_form.dart';
import 'package:tcc_app/models/contact.dart';
import 'package:uuid/uuid.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  _addContact(
      String name, String email, String phone, String relationship) async {
    final newContact = Contact(
      id: const Uuid().v4(),
      name: name,
      email: email,
      phone: phone,
      relationship: relationship,
    );

    Box<Contact> contactsBox = Hive.box<Contact>('contacts');

    contactsBox.add(newContact);

    Navigator.of(context).pop();
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
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Contact>('contacts').listenable(),
              builder: (context, Box<Contact> box, _) {
                if (box.values.isEmpty) {
                  return const SizedBox(
                    height: 550,
                    child: Center(
                      child: Text(
                        'Nenhum contato cadastrado',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 550,
                  child: ListView.builder(
                    itemCount: box.values.length,
                    itemBuilder: (context, index) {
                      Contact? currentContact = box.getAt(index);

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            child: Text(
                              currentContact!.name
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          title: Text(
                            currentContact.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            currentContact.relationship,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 35,
                            ),
                            color: Theme.of(context).errorColor,
                            onPressed: () async {
                              await box.deleteAt(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
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
