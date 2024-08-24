import 'package:flutter/material.dart';
import 'package:market_page/common/const.dart';
import 'package:market_page/page/sort/sort_manager.dart';

/// list item title widget
class ListItemHeader extends StatefulWidget {
  final SortType sortType;
  final SortColumnType? columnType;
  final Function(SortColumnType)? onPressed;

  const ListItemHeader({
    super.key,
    this.sortType = SortType.none,
    this.columnType,
    this.onPressed,
  });

  @override
  State<StatefulWidget> createState() => _ListItemHeaderState();
}

class _ListItemHeaderState extends State<ListItemHeader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Column(
        children: [
          buildHorLine(),
          Expanded(
            child: Row(
              children: [
                buildVerLine(),
                // Symbol
                _buildTitleText(SortColumnType.symbol, Alignment.centerLeft),
                buildVerLine(),
                // Last Price
                _buildTitleText(
                    SortColumnType.lastPrice, Alignment.centerRight),
                buildVerLine(),
                // Volume
                _buildTitleText(SortColumnType.volume, Alignment.centerRight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleText(SortColumnType type, Alignment textAlign) {
    // Highlight the column header of the sorting column
    bool isInSort =
        type == widget.columnType && widget.sortType != SortType.none;
    Color bgColor = isInSort ? listTitleHighLightBgColor : listTitleBgColor;
    TextStyle titleStyle = isInSort ? listTitleHighStyle : listTitleStyle;

    String title = '${type.value}${getSortTitleEnding(type)}';

    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onPressed?.call(type);
        },
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          color: bgColor,
          child: Align(
            alignment: textAlign,
            child: Text(
              title,
              style: titleStyle,
            ),
          ),
        ),
      ),
    );
  }

  String getSortTitleEnding(SortColumnType type) {
    bool isInSort =
        type == widget.columnType && widget.sortType != SortType.none;
    if (!isInSort) return '';
    if (widget.sortType == SortType.ascending) return '(↑)';
    return '(↓)';
  }
}
