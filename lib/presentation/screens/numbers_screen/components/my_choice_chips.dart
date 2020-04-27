import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/data/models/category.dart';

class MyChoiceChips extends StatelessWidget with PreferredSizeWidget {
  final String value;
  final List<Category> options;
  final Function onChanged;
  MyChoiceChips({
    @required this.value,
    @required this.options,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ChipsChoice<String>.single(
      itemConfig:
          ChipsChoiceItemConfig(selectedColor: Theme.of(context).accentColor),
      value: value,
      options: ChipsChoiceOption.listFrom<String, Category>(
        source: options,
        value: (index, item) => item.id,
        label: (index, item) => item.name,
      ),
      onChanged: onChanged,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
