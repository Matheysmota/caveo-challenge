/// Network configuration contract.
library;

abstract class NetworkConfigProvider {
  String get baseUrl;
  Duration get connectTimeout;
  Duration get receiveTimeout;
  Duration get sendTimeout;
}
