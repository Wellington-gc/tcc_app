import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ContactsForm extends StatefulWidget {
  const ContactsForm({Key? key, required this.onSubmit}) : super(key: key);

  final void Function(String, String, String, String) onSubmit;

  @override
  State<ContactsForm> createState() => _ContactsFormState();
}

class _ContactsFormState extends State<ContactsForm> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final relationshipController = TextEditingController();

  MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
    mask: '(0##) # ####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: '(099) 9 9999-9999',
                  labelText: 'Telefone',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [phoneFormatter],
              ),
              TextField(
                controller: relationshipController,
                decoration: const InputDecoration(
                  labelText: 'Parentesco',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text;
                  final email = emailController.text;
                  final phone = phoneController.text;
                  final relationship = relationshipController.text;

                  if (name.isEmpty || email.isEmpty || phone.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Campos vazios!',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  widget.onSubmit(name, email, phone, relationship);
                },
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
