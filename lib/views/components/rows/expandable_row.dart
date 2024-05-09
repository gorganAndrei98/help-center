import 'package:flutter/material.dart';

//I'm making it specific to the question types for the sake of the exercise
class ExpandableRow extends StatefulWidget {
  final double radius;
  final String? informationAsString;
  final IconData? iconData;
  final List<String> choices;
  final Function(String) onChoiceSelected;
  final String? initialChoice;

  const ExpandableRow({
    Key? key,
    this.informationAsString,
    this.iconData,
    this.radius = 13.0,
    required this.choices,
    required this.onChoiceSelected,
    this.initialChoice
  }) : super(key: key);

  @override
  State<ExpandableRow> createState() => _ExpandableRowState();
}

class _ExpandableRowState extends State<ExpandableRow> {
  bool _isExpanded = false;
  String? _currentChoice;

  @override
  Widget build(BuildContext context) {
    if (widget.informationAsString == null) return SizedBox.shrink();
    bool allowExpansion = widget.choices.isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (allowExpansion) {
          setState(() => _isExpanded = !_isExpanded);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child:
                        Text(
                          _currentChoice ?? widget.informationAsString!,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.iconData != null) Icon(widget.iconData),
                      if (allowExpansion) Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                    ],
                  ),
                ),
              ],
            ),
            if (_isExpanded && allowExpansion) Divider(height: 1),
            if (_isExpanded && allowExpansion)
              ...widget.choices.map((choice) {
                return GestureDetector(
                  onTap: () {
                    widget.onChoiceSelected(choice);
                    setState(() {
                      _currentChoice = choice;
                      _isExpanded = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                    alignment: Alignment.centerLeft,
                    child: Text(choice),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
