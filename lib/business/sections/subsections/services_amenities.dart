import 'package:flutter/material.dart';

class ServicesAndAmenities extends StatefulWidget {
  const ServicesAndAmenities({super.key});

  @override
  State<ServicesAndAmenities> createState() => _ServicesAndAmenitiesState();
}

class _ServicesAndAmenitiesState extends State<ServicesAndAmenities> {
  final _formKey = GlobalKey<FormState>();
  final _textControllers = {
    'field1': TextEditingController(),
    'field2': TextEditingController(),
  };
  final Map _selectedIcons = {
    'field1': null,
    'field2': null,
  };

  final Map<IconData, String> _iconMap = {
    Icons.home: 'House',
    Icons.star: 'Star',
    Icons.favorite: 'Favorite',
    Icons.settings: 'Settings',
    Icons.search: 'Search',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Selector App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconField(
                title: 'Field 1',
                iconMap: _iconMap,
                selectedIcon: _selectedIcons['field1'],
                onIconSelected: (icon) {
                  setState(() {
                    _selectedIcons['field1'] = icon;
                  });
                },
                textController: _textControllers['field1']!,
              ),
              const SizedBox(height: 20),
              IconField(
                title: 'Field 2',
                iconMap: _iconMap,
                selectedIcon: _selectedIcons['field2'],
                onIconSelected: (icon) {
                  setState(() {
                    _selectedIcons['field2'] = icon;
                  });
                },
                textController: _textControllers['field2']!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Process data
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconField extends StatelessWidget {
  final String title;
  final Map<IconData, String> iconMap;
  final IconData? selectedIcon;
  final ValueChanged<IconData> onIconSelected;
  final TextEditingController textController;

  const IconField({
    super.key,
    required this.title,
    required this.iconMap,
    required this.selectedIcon,
    required this.onIconSelected,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Text(
        //   title,
        //   style: const TextStyle(fontSize: 16),
        // ),
        const SizedBox(height: 10),
        Flexible(
          child: SizedBox(
            width: 100,
            child: SearchableDropdown(
              iconMap: iconMap,
              selectedIcon: selectedIcon,
              onIconSelected: onIconSelected,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
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

class SearchableDropdown extends StatefulWidget {
  final Map<IconData, String> iconMap;
  final IconData? selectedIcon;
  final ValueChanged<IconData> onIconSelected;

  const SearchableDropdown({
    super.key,
    required this.iconMap,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  IconData? _selectedIcon;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIcon;
  }

  void _openIconSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredIcons = widget.iconMap.entries.where((entry) {
              final query = _searchController.text.toLowerCase();
              return entry.value.toLowerCase().contains(query);
            }).toList();

            return AlertDialog(
              title: const Text('Select an Icon'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search icons',
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10,
                        children: filteredIcons.map((entry) {
                          final icon = entry.key;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIcon = icon;
                              });
                              widget.onIconSelected(icon);
                              Navigator.of(context).pop();
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _selectedIcon == icon
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    icon,
                                    color: _selectedIcon == icon
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openIconSelector(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _selectedIcon != null ? Icon(_selectedIcon) : Container(),
            const SizedBox(width: 10),
            if (_selectedIcon == null) const Text('Icon'),
            const Spacer(),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
