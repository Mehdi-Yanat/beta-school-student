import 'package:flutter/material.dart';

class ToggleIconBtnsFb1 extends StatefulWidget {
  final List<Icon> icons;
  final List<bool> whichSelected;
  final Function(int) selected;
  final Color selectedColor;
  final bool multipleSelectionsAllowed;
  final bool stateContained;
  final bool canUnToggle;
  ToggleIconBtnsFb1(
      {required this.icons,
      required this.selected,
      this.whichSelected = const [],
      this.selectedColor = const Color(0xFF6200EE),
      this.stateContained = true,
      this.canUnToggle = false,
      this.multipleSelectionsAllowed = false,
      Key? key});

  @override
  _ToggleIconBtnsFb1State createState() => _ToggleIconBtnsFb1State();
}

class _ToggleIconBtnsFb1State extends State<ToggleIconBtnsFb1> {
  late List<bool> isSelected = [];
  @override
  void initState() {
    if (widget.whichSelected.length == 0) {
      widget.icons.forEach((e) => isSelected.add(false));
    } else {
      widget.whichSelected.forEach((e) => isSelected.add(e));
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToggleButtons(
            color: Colors.black.withOpacity(0.60),
            selectedColor: widget.selectedColor,
            selectedBorderColor: widget.selectedColor,
            fillColor: widget.selectedColor.withOpacity(0.08),
            splashColor: widget.selectedColor.withOpacity(0.12),
            hoverColor: widget.selectedColor.withOpacity(0.04),
            borderRadius: BorderRadius.circular(4.0),
            isSelected: isSelected,
            highlightColor: Colors.transparent,
            onPressed: (index) {
              // send callback
              widget.selected(index);
              // if you wish to have state:
              if (widget.stateContained) {
                if (!widget.multipleSelectionsAllowed) {
                  final selectedIndex = isSelected[index];
                  isSelected = isSelected.map((e) => e = false).toList();
                  if (widget.canUnToggle) {
                    isSelected[index] = selectedIndex;
                  }
                }
                setState(() {
                  isSelected[index] = !isSelected[index];
                });
              }
            },
            children: widget.icons,
          ),
        ],
      ),
    );
  }
}
