import 'package:flutter/material.dart';

class ProgressGrid extends StatelessWidget {
  const ProgressGrid({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
  });

  final String label;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: isSelected
            ? [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 40,
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ]
            : [
                Icon(icon),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
      ),
    );
  }
}

enum ProgressStatus {
  open,
  waiting,
  inProgress,
  done,
}
