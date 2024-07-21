import 'package:flutter/material.dart';

import '../../../values/strings.dart';

class IconField extends StatelessWidget {
  final IconData? selectedIcon;
  final String labelText;
  final TextEditingController textController;
  final VoidCallback onIconPicker;

  const IconField({
    super.key,
    required this.selectedIcon,
    required this.labelText,
    required this.textController,
    required this.onIconPicker,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Card(
          elevation: 2,
          child: IconButton(
            padding: const EdgeInsets.all(3),
            tooltip: 'Select Icon, default icon is check.',
            icon: Icon(selectedIcon ?? Icons.add),
            onPressed: onIconPicker,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: textController,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            style: labelText == AppStrings.headingText
                ? Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.bold)
                : Theme.of(context).textTheme.bodySmall,
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
