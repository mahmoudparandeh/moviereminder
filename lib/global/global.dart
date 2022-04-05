import 'dart:async';


class GlobalState {

  static bool canRefreshWatchList = false;
  static var watchListController = StreamController<bool>.broadcast();
  static Stream<bool> get onChangeWatchList => watchListController.stream;

  static changeWatchList(state) {
    canRefreshWatchList = state;
    watchListController.add(canRefreshWatchList);
  }

  static dispose() {
    watchListController.close();
  }
}
