import 'package:cat_tourism_hub/business/components/dynamic_fields/dynamic_sub_field.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/icon_picker.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/icon_textfield.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';

import '../../components/dynamic_fields/dynamic_field.dart';

class Policies extends StatefulWidget {
  const Policies({super.key});

  @override
  State<Policies> createState() => _PoliciesState();
}

class _PoliciesState extends State<Policies> {
  final List<DynamicField> _dynamicFields = [];

  void _addNewField() {
    setState(() {
      _dynamicFields.add(
        DynamicField(
          textController: TextEditingController(),
          subFields: [SubField(textController: TextEditingController())],
        ),
      );
    });
  }

  List<Widget> _buildFields() {
    return _dynamicFields.map((field) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconField(
            labelText: AppStrings.headingText,
            selectedIcon: field.selectedIcon,
            textController: field.textController,
            onIconPicker: () async {
              IconData icon = await pickIcon(context);
              setState(() {
                field.selectedIcon = icon;
              });
            },
          ),
          const SizedBox(height: 10),
          ...field.subFields.map((subField) {
            return Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: TextFormField(
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 5,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter policy'
                      : null,
                ));
          }),
          const SizedBox(height: 10),
          const Divider(),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        ..._buildFields(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _addNewField,
          child: const Text('Add Field'),
        ),
        const SizedBox(height: 20),
        if (_dynamicFields.isNotEmpty)
          ElevatedButton(
            onPressed: () async {
              // await _saveData(value.user!.uid, value2, value.token!);
            },
            child: const Text(AppStrings.save),
          ),
      ]),
    );
  }
}
