import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class ErrorAlertDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const ErrorAlertDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    final message = request.data as String;
    return AlertDialog.adaptive(
      title: const Text('Error'),
      scrollable: true,
      content: SingleChildScrollView(
        child: Text(message),
      ),
      actions: [
        TextButton(
          onPressed: () {
            completer(
              DialogResponse(confirmed: true),
            );
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
