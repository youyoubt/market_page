import 'package:flutter/material.dart';

/// search Widget
class SearchWidget extends StatefulWidget {
  final Function(String value)? onSearch;

  const SearchWidget({
    super.key,
    this.onSearch,
  });

  @override
  State<StatefulWidget> createState() => SearchWidgetState();
}

class SearchWidgetState extends _SearchWidgetState {
  void clearText() {
    _controller.text = '';
  }
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      widget.onSearch?.call(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xffF3F3F3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE7E7E7),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        textAlign: TextAlign.start,
        controller: _controller,
        autofocus: false,
        cursorColor: Colors.black87,
        textInputAction: TextInputAction.search,
        onSubmitted: (String value) {},
        onTapOutside: (event) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        decoration: const InputDecoration(
          isDense: true,
          hintText: 'Search',
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0x66000000),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
