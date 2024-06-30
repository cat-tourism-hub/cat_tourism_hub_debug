import 'package:flutter/material.dart';

class SubmenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<SubmenuItem> children;

  const SubmenuItem({
    super.key,
    required this.title,
    required this.icon,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      children: children.map((item) {
        return ListTile(
          leading: Icon(item.icon),
          title: Text(item.title),
          onTap: () {
            // Handle submenu item tap
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }
}
