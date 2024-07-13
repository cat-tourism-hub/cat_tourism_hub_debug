import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({super.key, required this.onChanged});
  final Function(String, String) onChanged;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String _duration = 'none';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _customDurationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onValueChanged);
    _customDurationController.addListener(_onValueChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onValueChanged);
    _customDurationController.removeListener(_onValueChanged);
    _amountController.dispose();
    _customDurationController.dispose();
    super.dispose();
  }

  void _onValueChanged() {
    String amount = _amountController.text;
    String duration =
        _duration == 'custom' ? _customDurationController.text : _duration;
    widget.onChanged(amount, duration);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Peso Icon and TextField
        Expanded(
          child: TextFormField(
            controller: _amountController,
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a price' : null,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'assets/images/philippines-peso.svg',
                  height: 20,
                  width: 20,
                ),
              ),
              border: const OutlineInputBorder(),
              label: const Text('${AppStrings.price}*'),
              labelStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Divider
        Container(
          height: 40,
          width: 1,
          color: Colors.grey,
        ),
        const SizedBox(width: 10),
        // Dropdown for duration
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _duration,
            onChanged: (String? newValue) {
              setState(() {
                _duration = newValue!;
                _onValueChanged();
              });
            },
            items: <String>[
              'none',
              'per night',
              'per day',
              'per serving',
              'custom'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              );
            }).toList(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        if (_duration == 'custom')
          Expanded(
            child: TextFormField(
              controller: _customDurationController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: AppStrings.customData,
              ),
            ),
          ),
      ],
    );
  }
}
