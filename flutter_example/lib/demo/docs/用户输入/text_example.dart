import 'package:flutter/material.dart';

/// 文本相关

class TextExample extends StatefulWidget {
  const TextExample({super.key});

  @override
  State<TextExample> createState() => _TextExampleState();
}

class _TextExampleState extends State<TextExample> {
  static const String _text = 'Hello, World!';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_text),
              const SizedBox(width: 10),
              Text("Text： 普通文本"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectableText(_text),
              const SizedBox(width: 10),
              Text("SelectableText： 可选择文本"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: _text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text("RichText： 富文本"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300, // 给TextField设置固定宽度
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: _text,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text("TextField：   文本输入框"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(hintText: '请输入'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '请输入';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('提交成功')),
                            );
                          }
                        },
                        child: const Text('提交'),
                      ),
                    ),
                  ],
                ),
              ),
              Text('TextFormField： 表单文本输入框'),
            ],
          ),
        ],
      ),
    );
  }
}
