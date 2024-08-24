import 'package:flutter/material.dart';
import 'package:market_page/common/const.dart';
import 'package:market_page/page/market_list_page.dart';
import 'package:market_page/provider/market_provider.dart';
import 'package:market_page/provider/tab_changed_provider.dart';
import 'package:provider/provider.dart';

/// market main page
class MarketMainPage extends StatefulWidget {
  const MarketMainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MarketMainPageState();
}

class _MarketMainPageState extends State<MarketMainPage>
    with TickerProviderStateMixin {
  MarketProvider get read => context.read<MarketProvider>();

  MarketProvider get watch => context.watch<MarketProvider>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      int index = _tabController.index;
      context.read<TabChangedProvider>().tabIndex = index;
    });
    // load data
    read.loadAllMarketData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          systemOverlayStyle: systemUiWhiteStyle,
          title: const Text(
            'Market Page',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelStyle: tabSelectedStyle,
            unselectedLabelStyle: tabStyle,
            indicatorColor: Colors.blueAccent,
            dividerColor: Colors.transparent,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.0, color: Colors.blueAccent),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            tabs: const [
              Tab(text: 'ALL', height: 22),
              Tab(text: 'SPOTS', height: 22),
              Tab(text: 'FUTURES', height: 22),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            MarketListPage(pageIndex: 0, list: watch.allList),
            MarketListPage(pageIndex: 1, list: watch.spotList),
            MarketListPage(pageIndex: 2, list: watch.futureList),
          ],
        ),
      ),
    );
  }
}
