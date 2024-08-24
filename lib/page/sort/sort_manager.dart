import 'package:market_page/model/market_model.dart';

/// sort by market base
abstract class SortBase {
  static const basePriority = ['BTC', 'ETH', 'WOO'];
  static const quotePriority = ['USDT', 'USDC', 'PERP'];
  int sortTimes = 0; // sort times,can click 3 times

  final SortColumnType _columnType = SortColumnType.symbol;

  SortColumnType get columnType => _columnType;

  /// do sort after click header
  SortResult doSort(List<MarketModel> marketList) {
    if (marketList.isEmpty) return SortResult(marketList, SortType.none);
    sortTimes++;
    SortType sortType = SortType.getByTimes(sortTimes);
    // default sort
    if (sortType == SortType.none) return SortResult(marketList, SortType.none);
    // make a new list
    List<MarketModel> sortedList = List.from(marketList);
    // do list sort,implement by child
    sortList(sortedList, sortType);
    return SortResult(sortedList, sortType);
  }

  /// do default sort
  void sortDefault(List<MarketModel> marketList) {
    marketList.sort((a, b) {
      //1.BTC, ETH, WOO of ${base} are displayed in the highest priority
      int baseComparison =
          basePriority.indexOf(a.base).compareTo(basePriority.indexOf(b.base));
      if (baseComparison != 0) {
        return baseComparison;
      }
      // 2.In the same ${base}, the display order is fixed as USDT > USDC > PERP
      int quoteComparison = quotePriority
          .indexOf(a.quote)
          .compareTo(quotePriority.indexOf(b.quote));
      if (quoteComparison != 0) {
        return quoteComparison;
      }
      // implementation by child
      return sortDefaultItem(a, b);
    });
  }

  void sortList(List<MarketModel> list, SortType sortType);

  int sortDefaultItem(MarketModel a, MarketModel b) {
    return 0;
  }
}

///Symbol implementation
final class SortBySymbol extends SortBase {
  @override
  SortColumnType columnType = SortColumnType.symbol;

  @override
  void sortList(List<MarketModel> list, SortType sortType) {
    //Symbol: First time click, the data should be sorted by {base} + {quote} + {type} Ascending
    //  Second time click, he data should be sorted by {base} + {quote} + {type} Descending
    //  Third time click should reset to default sort.
    list.sort((a, b) {
      String aKey = '${a.base}${a.quote}${a.type}';
      String bKey = '${b.base}${b.quote}${b.type}';
      if (sortType == SortType.ascending) {
        return aKey.compareTo(bKey);
      }
      return bKey.compareTo(aKey);
    });
  }
}

/// Last Price implementation
final class SortByLastPrice extends SortBase {
  @override
  SortColumnType columnType = SortColumnType.lastPrice;

  @override
  void sortList(List<MarketModel> list, SortType sortType) {
    //Last Price: First time click, the data should be sorted by ${lastPrice} Ascending
    //  Second time click, he data should be sorted by ${lastPrice} Descending
    //  Third time click should reset to default sort.
    list.sort((a, b) {
      if (sortType == SortType.ascending) {
        return a.lastPrice.compareTo(b.lastPrice);
      }
      return b.lastPrice.compareTo(a.lastPrice);
    });
  }
}

/// Volume implementation
final class SortByVolume extends SortBase {
  @override
  SortColumnType columnType = SortColumnType.volume;

  @override
  void sortList(List<MarketModel> list, SortType sortType) {
    // Volume: First time click, the data should be sorted by ${volume} Ascending
    // 	Second time click, he data should be sorted by ${volume} Descending
    // 	Third time click should reset to default sort.
    list.sort((a, b) {
      if (sortType == SortType.ascending) {
        return a.volume.compareTo(b.volume);
      }
      return b.volume.compareTo(a.volume);
    });
  }
}

///  Tab All default sort
final class SortDefaultAll extends SortBase {
  @override
  void sortList(List<MarketModel> list, SortType sortType) {
    throw Exception("Not Supported");
  }

  @override
  int sortDefaultItem(MarketModel a, MarketModel b) {
    return a.getSymbolDisplay().compareTo(b.getSymbolDisplay());
  }
}

/// TAB SPOT \ FUTURES default sort
final class SortDefaultOther extends SortBase {
  @override
  void sortList(List<MarketModel> list, SortType sortType) {
    throw Exception("Not Supported");
  }

  @override
  int sortDefaultItem(MarketModel a, MarketModel b) {
    return b.volume.compareTo(a.volume);
  }
}

/// the manager of sort
class SortManager {
  static SortBase? getSortByType(SortColumnType type) {
    switch (type) {
      case SortColumnType.symbol:
        return SortBySymbol();
      case SortColumnType.lastPrice:
        return SortByLastPrice();
      case SortColumnType.volume:
        return SortByVolume();
      default:
        return null;
    }
  }

  ///  All Tab default sort
  static void sortDefaultAll(List<MarketModel> list) {
    SortDefaultAll().sortDefault(list);
  }

  /// Other Tab default sort
  static void sortDefaultOther(List<MarketModel> list) {
    SortDefaultOther().sortDefault(list);
  }
}

/// sort type
enum SortType {
  ascending,
  descending,
  none;

  static SortType getByTimes(int times) {
    switch (times % 3) {
      case 1:
        return SortType.ascending;
      case 2:
        return SortType.descending;
      default:
        return SortType.none;
    }
  }
}

/// type of the column
enum SortColumnType {
  symbol('Symbol'),
  lastPrice('Last Price'),
  volume('Volume');

  final String value;

  const SortColumnType(this.value);
}

///  sort result
class SortResult {
  List<MarketModel> list;
  SortType sortType;

  SortResult(this.list, this.sortType);
}
