import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_page/model/market_model.dart';
import 'package:market_page/page/sort/sort_manager.dart';

/// market provider
class MarketProvider extends ChangeNotifier {
  final List<MarketModel> _allList = []; //all list
  final List<MarketModel> _spotList = []; //spot list
  final List<MarketModel> _futureList = []; //future list

  List<MarketModel> get allList => _allList;

  List<MarketModel> get spotList => _spotList;

  List<MarketModel> get futureList => _futureList;

  /// load market data
  Future<void> loadAllMarketData() async {
    try {
      /// load data from assets
      String json = await rootBundle.loadString('assets/data/data.json');
      List<dynamic> list = jsonDecode(json);
      List<MarketModel> datas =
          list.map((e) => MarketModel.fromJson(e)).toList();

      // all list
      _allList.clear();
      _allList.addAll(datas);
      // sort list
      SortManager.sortDefaultAll(_allList);

      // sportList
      _spotList.clear();
      _spotList.addAll(_filterData('SPOT'));
      SortManager.sortDefaultOther(_spotList);

      // futureList
      _futureList.clear();
      _futureList.addAll(_filterData('FUTURES'));
      SortManager.sortDefaultOther(_futureList);

      notifyListeners();
    } catch (e) {
      print('_loadAllMarketData err:$e');
    }
  }

  List<MarketModel> _filterData(String type) {
    return _allList.where((e) => e.type == type).toList();
  }
}
