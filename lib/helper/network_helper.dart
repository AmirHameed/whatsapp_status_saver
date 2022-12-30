import 'package:connectivity/connectivity.dart';
class NetworkHelper {
  static NetworkHelper instance = NetworkHelper._internal();

  NetworkHelper._internal();

  final _connectivity = Connectivity();

  Future<bool> isNetworkConnected() async =>
      await _connectivity.checkConnectivity() != ConnectivityResult.none;
}
