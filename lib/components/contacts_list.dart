import 'package:flutter/material.dart';
import 'package:tcc_app/models/contact.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key, required this.contacts, required this.onRemove})
      : super(key: key);

  final void Function(String) onRemove;

  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: ListView(
        children: contacts.map(
          (contact) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Text(
                    contact.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                title: Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  contact.relationship,
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
                  onPressed: () => onRemove(contact.id),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
