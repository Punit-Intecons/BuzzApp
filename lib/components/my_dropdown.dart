import 'package:flutter/material.dart';
class MyDropdown extends StatefulWidget {
  final String selectedCountryCode;
  final List<DropdownMenuItem<String>> list;
  final Function(String) onValueChanged;
  final EdgeInsets margin;

  const MyDropdown({
    Key? key,
    required this.selectedCountryCode, required this.list,required this.onValueChanged, required this.margin,
  }) : super(key: key);

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.selectedCountryCode;
  }

  @override
  Widget build(BuildContext context) {
      // Set the desired width factor (adjust as needed)
        return Container(
          margin: widget.margin,
          width: 80, // Set the desired width for the dropdown
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
                widget.onValueChanged(dropdownValue);
              });
            },
            isExpanded: true,
            items: widget.list,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              border: InputBorder.none,
            ),
          ),
        );
  }
}
