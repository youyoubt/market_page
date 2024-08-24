import 'package:flutter/material.dart';
import 'package:market_page/model/market_model.dart';
import 'package:market_page/page/item/list_item_header.dart';
import 'package:market_page/page/item/list_item_widget.dart';
import 'package:market_page/page/search/search_widget.dart';
import 'package:market_page/page/sort/sort_manager.dart';
import 'package:market_page/provider/tab_changed_provider.dart';
import 'package:provider/provider.dart';

/// common page list
class MarketListPage extends StatefulWidget {
  final List<MarketModel> list;
  final SortType sortType;
  final int pageIndex;

  const MarketListPage({
    super.key,
    required this.pageIndex,
    this.list = const [],
    this.sortType = SortType.none,
  });

  @override
  State<StatefulWidget> createState() => _MarketListPageState();
}

class _MarketListPageState extends State<MarketListPage>
    with AutomaticKeepAliveClientMixin<MarketListPage> {
  // sort list
  SortResult? sortResult;
  SortBase? currentSort;
  String _searchValue = '';
  GlobalKey<SearchWidgetState> searchKey = GlobalKey();

  List<MarketModel> get list {
    List<MarketModel> list;
    if (sortResult != null &&
        sortResult?.list != null &&
        sortResult?.sortType != SortType.none) {
      list = sortResult!.list;
    } else {
      list = widget.list;
    }
    if (_searchValue.isNotEmpty) {
      /// search filter
      list = list
          .where(
              (m) => m.base.toLowerCase().contains(_searchValue.toLowerCase()))
          .toList();
    }
    return list;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    currentSort = null;
    sortResult = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// when tab changed clear search text
    int currentIndex = context.watch<TabChangedProvider>().tabIndex;
    if (widget.pageIndex != currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        if (mounted) searchKey.currentState?.clearText();
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          SearchWidget(
            key: searchKey,
            onSearch: _onSearch,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: ListItemHeader(
              sortType: sortResult?.sortType ?? SortType.none,
              columnType: currentSort?.columnType,
              onPressed: _onSortPressed,
            ),
          ),
          Expanded(child: _buildListWidget()),
        ],
      ),
    );
  }

  Widget _buildListWidget() {
    if (list.isEmpty && _searchValue.isNotEmpty) {
      return const Center(child: Text('No results found'));
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListItemWidget(
          data: list[index],
          showEndLine: index == list.length - 1,
        );
      },
    );
  }

  /// header click to sort list
  void _onSortPressed(SortColumnType type) {
    //1.Symbol: First time click, the data should be sorted by {base} + {quote} + {type} Ascending
    //  Second time click, he data should be sorted by {base} + {quote} + {type} Descending
    //  Third time click should reset to default sort.
    //2.Last Price: First time click, the data should be sorted by ${lastPrice} Ascending
    //  Second time click, he data should be sorted by ${lastPrice} Descending
    //  Third time click should reset to default sort.
    //3.Volume: First time click, the data should be sorted by ${volume} Ascending
    // 	Second time click, he data should be sorted by ${volume} Descending
    // 	Third time click should reset to default sort.
    SortBase? sort = SortManager.getSortByType(type);
    if (sort?.columnType != currentSort?.columnType) {
      currentSort = sort;
      sortResult = null;
    }
    SortResult? result = currentSort?.doSort(widget.list);

    setState(() {
      sortResult = result;
    });
  }

  void _onSearch(String value) {
    if (_searchValue != value) {
      _searchValue = value;
      setState(() {});
    }
  }
}
