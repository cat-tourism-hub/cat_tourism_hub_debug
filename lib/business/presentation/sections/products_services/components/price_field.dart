import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.onChanged,
    this.initialAmount = '',
    this.initialCustomDuration = '',
  });

  final Function(double, String)? onChanged;
  final String initialAmount;
  final String initialCustomDuration;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String _duration = 'none';
  late TextEditingController _amountController;
  late TextEditingController _customDurationController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.initialAmount);
    if (widget.initialCustomDuration.isNotEmpty &&
        widget.initialCustomDuration != 'none') {
      _duration = 'custom';
    }
    _customDurationController =
        TextEditingController(text: widget.initialCustomDuration);

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
    double amount = double.tryParse(_amountController.text) ?? 0;
    String duration =
        _duration == 'custom' ? _customDurationController.text : _duration;
    if (widget.onChanged != null) {
      widget.onChanged!(amount, duration);
    }
  }

  Widget _mobileView() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      // Peso Icon and TextField
      TextFormField(
        controller: _amountController,
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter a price' : null,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: true),
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
      const Gap(10),
      // Dropdown for duration
      DropdownButtonFormField<String>(
        value: _duration,
        onChanged: (String? newValue) {
          setState(() {
            _duration = newValue!;
            _onValueChanged();
          });
        },
        items: <String>['none', 'per night', 'per day', 'per serving', 'custom']
            .map<DropdownMenuItem<String>>((String value) {
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
      if (_duration == 'custom')
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: _customDurationController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: AppStrings.customData,
            ),
          ),
        ),
    ]);
  }

  Widget _desktopView() {
    return Row(children: [
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
      const Gap(10),
      // Divider
      Container(
        height: 40,
        width: 1,
        color: Colors.grey,
      ),
      const Gap(10),
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
      const Gap(10),
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.sizeOf(context).width < 600;
    return LayoutBuilder(builder: (context, constraints) {
      if (isMobile) {
        return _mobileView();
      }
      return _desktopView();
    });
  }
}
