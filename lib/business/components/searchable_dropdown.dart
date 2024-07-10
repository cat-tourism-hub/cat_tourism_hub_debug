import 'package:flutter/material.dart';

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
                          final iconLabel = entry.value;
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
                                Text(iconLabel,
                                    style: const TextStyle(fontSize: 12)),
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
            const SizedBox(width: 5),
            if (_selectedIcon == null) const Text('Icon'),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
