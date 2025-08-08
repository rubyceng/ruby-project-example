import 'package:flutter/material.dart';

/// 用户输入框
class TextInputExample extends StatefulWidget {
  const TextInputExample({super.key});

  @override
  State<TextInputExample> createState() => _TextInputExample();
}

class _TextInputExample extends State<TextInputExample> {
  final myController = TextEditingController();
  late FocusNode myFocusNode;

  _printText() {
    final text = myController.text;
    print('Current text: $text');
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myController.addListener(_printText);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retrieve Text Input')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('TextField Widget'),
            TextField(
              controller: myController,
              onChanged: (e) {
                print('Text changed: $e');
              },
              autofocus: true,
            ),
            SizedBox(height: 20),
            TextFormField(controller: myController, focusNode: myFocusNode),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myFocusNode.requestFocus();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text(myController.text));
            },
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
