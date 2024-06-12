import 'package:flutter/material.dart';

class ChatTextFormField extends StatelessWidget {
  const ChatTextFormField({
    super.key,
    this.focusNode,
    this.controller,
    this.isReadOnly = false,
    required this.onfieldSubmitted,
  });
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool isReadOnly;
  final void Function(String)? onfieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      autocorrect: false,
      focusNode: focusNode,
      controller: controller,
      // readOnly: isReadOnly,
      onFieldSubmitted: onfieldSubmitted,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        hintText: 'Enter your prompt',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some prompt';
        }
        return null;
      },
    );
  }
}
