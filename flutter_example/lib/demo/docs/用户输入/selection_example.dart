import 'package:flutter/material.dart';

/// 选择框相关

class SelectionExample extends StatefulWidget {
  const SelectionExample({super.key});

  @override
  State<SelectionExample> createState() => _SelectionExampleState();
}

class _SelectionExampleState extends State<SelectionExample> {
  final List<String> _selectedItems = ['Item 1', 'Item 2', 'Item 3'];
  String _selectedItem = '';
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedItem = _selectedItems.first;
  }

  void onSelectionChange(String item) {
    setState(() {
      _selectedItem = item;
    });
  }

  /// 分段按钮
  SegmentedButton buildSegmentedButton() {
    return SegmentedButton(
      segments: _selectedItems
          .map(
            (item) => ButtonSegment(
              value: item,
              label: Text(item),
              icon: Icon(Icons.toc),
            ),
          )
          .toList(),
      selected: {_selectedItem},
      onSelectionChanged: (value) => onSelectionChange(value.first),
    );
  }

  /// Chip
  List<Chip> buildChip() {
    final chipList = _selectedItems
        .map(
          (item) => Chip(
            label: Text(item),
            avatar: CircleAvatar(backgroundColor: Colors.blue),
          ),
        )
        .toList();
    return chipList;
  }

  /// DropDownMenu
  DropdownMenu buildDropdownMenu() {
    return DropdownMenu(
      initialSelection: _selectedItem,
      onSelected: (value) => onSelectionChange(value),
      dropdownMenuEntries: _selectedItems
          .map((item) => DropdownMenuEntry(value: item, label: item))
          .toList(),
    );
  }

  /// Slider
  Slider buildSlider() {
    return Slider(
      value: _sliderValue,
      max: 100,
      divisions: 10,
      label: _sliderValue.toString(),
      onChanged: (value) => setState(() => _sliderValue = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('SegmentedButton  分段按钮'),
          SizedBox(height: 10),
          buildSegmentedButton(),
          Text('Chip  标签'),
          SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: buildChip(),
          ),
          Text('DropDownMenu  下拉菜单'),
          SizedBox(height: 10),
          buildDropdownMenu(),
          Text('Slider  滑块'),
          SizedBox(height: 10),
          buildSlider(),
        ],
      ),
    );
  }
}
