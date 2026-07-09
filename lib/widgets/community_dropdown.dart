import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CommunityDropdown extends StatelessWidget {
  const CommunityDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.mutedText,
          fontFamily: AppTheme.sansFallback,
        ),
      ),
      dropdownColor: AppColors.card,
      borderRadius: BorderRadius.circular(18),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.mutedText),
      style: const TextStyle(
        color: AppColors.text,
        fontFamily: AppTheme.sansFallback,
        fontSize: 16,
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
