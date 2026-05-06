import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nura_app/app/data/api_constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<dynamic> _streamController =
      StreamController.broadcast();

  Stream<dynamic> get stream => _streamController.stream;

  bool _isConnected = false;

  // CONNECT
  void connect() {
    String url = ApiConstants.socketUrl;
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _isConnected = true;
      debugPrint('🔌 WebSocket Connected: $url');

      _channel!.stream.listen(
        (message) {
          final decoded = jsonDecode(message);
          _streamController.add(decoded);
        },
        onError: (error) {
          _isConnected = false;
          debugPrint('❌ WebSocket Error: $error');
          _reconnect(url);
        },
        onDone: () {
          _isConnected = false;
          debugPrint('🔌 WebSocket Disconnected');
          _reconnect(url);
        },
      );
    } catch (e) {
      _isConnected = false;
      debugPrint('❌ WebSocket Connection Error: $e');
      _reconnect(url);
    }
  }

  // SEND MESSAGE
  void send(dynamic data) {
    if (_isConnected && _channel != null) {
      if (data is String) {
        _channel!.sink.add(data); // ✅ send raw string
        debugPrint('📤 WebSocket Message Sent: $data');
      } else {
        _channel!.sink.add(jsonEncode(data)); // ✅ encode only maps/objects
        debugPrint('📤 WebSocket Message Sent: ${jsonEncode(data)}');
      }
    } else {
      debugPrint('⚠️ WebSocket not connected. Cannot send message.');
    }
  }

  // DISCONNECT
  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
    debugPrint('🔌 WebSocket Manually Disconnected');
  }

  // AUTO RECONNECT
  void _reconnect(String url) {
    debugPrint('⏳ WebSocket Attempting to reconnect in 5 seconds...');
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isConnected) {
        connect();
      }
    });
  }

  void dispose() {
    _streamController.close();
    disconnect();
  }
}
