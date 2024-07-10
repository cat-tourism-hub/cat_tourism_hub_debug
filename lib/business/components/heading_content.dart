import 'package:cat_tourism_hub/business/components/searchable_dropdown.dart';
import 'package:flutter/material.dart';

class HeadingContent extends StatelessWidget {
  const HeadingContent({
    super.key,
    required this.iconMap,
    required this.selectedIcon,
    required this.onIconSelected,
    required this.textController,
    required this.subTextController,
    required this.subSelectedIcon,
    required this.onSubIconSelected,
  });

  final Map<IconData, String> iconMap;
  final IconData? selectedIcon;
  final IconData? subSelectedIcon;
  final ValueChanged<IconData> onIconSelected;
  final ValueChanged<IconData> onSubIconSelected;
  final TextEditingController textController;
  final TextEditingController subTextController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          child: SearchableDropdown(
            iconMap: iconMap,
            selectedIcon: selectedIcon,
            onIconSelected: onIconSelected,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TextFormField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Enter text',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
