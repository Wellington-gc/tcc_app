import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tcc_app/models/contact.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key, required this.contacts}) : super(key: key);

  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: ListView(
        children: contacts.map(
          (contact) {
            return Card(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 40,
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          contact.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.name.length > 30
                                ? contact.name.substring(0, 28) + '...'
                                : contact.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            contact.relationship.length > 30
                                ? contact.relationship.substring(0, 28) + '...'
                                : contact.relationship,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
