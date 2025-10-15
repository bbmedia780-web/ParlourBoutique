import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// Controller to monitor network connectivity status
class NetworkController extends GetxController {
  static NetworkController get to => Get.find<NetworkController>();

  // Observable variables
  final RxBool _isConnected = true.obs;
  final RxBool _isLoading = false.obs;
  final RxString _connectionType = 'none'.obs;

  // Connectivity stream subscription
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Getters
  bool get isConnected => _isConnected.value;
  bool get isLoading => _isLoading.value;
  String get connectionType => _connectionType.value;

  // Observable getters for UI
  RxBool get isConnectedObs => _isConnected;
  RxBool get isLoadingObs => _isLoading;
  RxString get connectionTypeObs => _connectionType;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  /// Initialize connectivity monitoring
  void _initializeConnectivity() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen(_updateConnectionStatus);
    
    // Check initial connectivity status
    _checkInitialConnectivity();
  }

  /// Check initial connectivity status
  Future<void> _checkInitialConnectivity() async {
    _isLoading.value = true;
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      _isConnected.value = false;
      _connectionType.value = 'none';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update connection status based on connectivity results
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      _isConnected.value = false;
      _connectionType.value = 'none';
      return;
    }

    // Check if any connection type is available
    final hasConnection = results.any((result) => 
        result != ConnectivityResult.none);

    _isConnected.value = hasConnection;
    
    if (hasConnection) {
      // Determine the primary connection type
      if (results.contains(ConnectivityResult.wifi)) {
        _connectionType.value = 'wifi';
      } else if (results.contains(ConnectivityResult.mobile)) {
        _connectionType.value = 'mobile';
      } else if (results.contains(ConnectivityResult.ethernet)) {
        _connectionType.value = 'ethernet';
      } else {
        _connectionType.value = 'other';
      }
    } else {
      _connectionType.value = 'none';
    }
  }

  /// Manually check connectivity status
  Future<bool> checkConnectivity() async {
    _isLoading.value = true;
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectionStatus(result);
      return _isConnected.value;
    } catch (e) {
      _isConnected.value = false;
      _connectionType.value = 'none';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Retry connection check
  Future<void> retryConnection() async {
    await checkConnectivity();
  }

  /// Check if connection is stable (not just connected but actually working)
  Future<bool> isConnectionStable() async {
    if (!_isConnected.value) return false;
    
    try {
      // You can add a simple ping test here if needed
      // For now, we'll just return the current connection status
      return _isConnected.value;
    } catch (e) {
      return false;
    }
  }

  /// Check if connection is slow (for future enhancement)
  Future<bool> isConnectionSlow() async {
    if (!_isConnected.value) return false;
    
    try {
      // This could be enhanced to measure actual connection speed
      // For now, we'll assume all connections are fast enough
      return false;
    } catch (e) {
      return true; // Assume slow if we can't check
    }
  }

  /// Get user-friendly connection status message
  String getConnectionStatusMessage() {
    if (_isLoading.value) {
      return 'Checking connection...';
    }
    
    if (!_isConnected.value) {
      return 'No internet connection!';
    }
    
    switch (_connectionType.value) {
      case 'wifi':
        return 'Connected via WiFi';
      case 'mobile':
        return 'Connected via Mobile Data';
      case 'ethernet':
        return 'Connected via Ethernet';
      default:
        return 'Connected';
    }
  }
}
