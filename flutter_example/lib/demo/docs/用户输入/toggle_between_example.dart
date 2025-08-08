import 'package:flutter/material.dart';

class ToggleBetweenExample extends StatefulWidget {
  const ToggleBetweenExample({super.key});

  @override
  State<ToggleBetweenExample> createState() => _ToggleBetweenExampleState();
}

/// 值切换相关
enum Character { musician, chef, firefighter, artist }

class _ToggleBetweenExampleState extends State<ToggleBetweenExample> {
  bool _isSelected = false;
  Character _characters = Character.musician;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  /// Switch
  Switch buildSwitch() {
    return Switch(
      activeColor: Colors.red,
      value: _isSelected,
      onChanged: (value) => {setState(() => _isSelected = value)},
    );
  }

  /// CheckBox
  Checkbox buildCheckbox() {
    return Checkbox(
      activeColor: Colors.red,
      value: _isSelected,
      onChanged: (value) => {setState(() => _isSelected = value!)},
    );
  }

  /// CheckboxListTitle
  CheckboxListTile buildCheckboxListTitle() {
    return CheckboxListTile(
      title: Text('CheckboxListTitle'),
      value: _isSelected,
      onChanged: (value) => {setState(() => _isSelected = value!)},
      activeColor: Colors.red,
      secondary: Icon(Icons.person),
    );
  }

  /// SwitchListTile
  SwitchListTile buildSwitchListTile() {
    return SwitchListTile(
      value: _isSelected,
      onChanged: (value) => {setState(() => _isSelected = value)},
      title: Text('RadioListTile'),
    );
  }

  /// Redio
  Widget buildRadio() {
    return Column(
      children: [
        ListTile(
          title: Text('Musician'),
          leading: Radio(
            value: Character.musician,
            onChanged: (value) => {setState(() => _characters = value!)},
            groupValue: _characters,
            activeColor: Colors.red,
          ),
        ),
        ListTile(
          title: Text('Radio'),
          leading: Radio(
            value: Character.chef,
            onChanged: (value) => {setState(() => _characters = value!)},
            groupValue: _characters,
            activeColor: Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Switch  开关'),
          SizedBox(height: 10),
          buildSwitch(),
          Text('CheckBox  复选框'),
          SizedBox(height: 10),
          buildCheckbox(),
          Text('Radio  单选框'),
          SizedBox(height: 10),
          buildRadio(),
          Text('CheckboxListTitle  复选框列表'),
          SizedBox(height: 10),
          buildCheckboxListTitle(),
          Text('RadioListTitle  单选框列表'),
          SizedBox(height: 10),
          buildSwitchListTile(),
        ],
      ),
    );
  }
}
