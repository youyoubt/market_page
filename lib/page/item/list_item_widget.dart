import 'package:flutter/material.dart';
import 'package:market_page/common/const.dart';
import 'package:market_page/model/market_model.dart';

/// market list item
class ListItemWidget extends StatefulWidget {
  final MarketModel data;
  final bool showEndLine;

  const ListItemWidget({
    super.key,
    required this.data,
    this.showEndLine = false,
  });

  @override
  State<StatefulWidget> createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
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
                _buildText(widget.data.getSymbolDisplay(), TextAlign.start),
                buildVerLine(),
                // Last Price
                _buildText(widget.data.getPriceDisplay(), TextAlign.end),
                buildVerLine(),
                // Volume
                _buildText(widget.data.getDisplayVolume(), TextAlign.end),
                buildVerLine(),
              ],
            ),
          ),
          if (widget.showEndLine) buildHorLine(),
        ],
      ),
    );
  }

  Widget _buildText(String name, TextAlign alignment) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          name,
          textAlign: alignment,
          style: listItemStyle,
        ),
      ),
    );
  }
}
