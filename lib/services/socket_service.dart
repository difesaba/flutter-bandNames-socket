
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  late IO.Socket _socket;
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  //void get emit => _socket;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    debugPrint(_serverStatus.name);
    // Dart client
    _socket = IO.io('http://localhost:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    _socket.onConnect((_) {
      debugPrint('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      debugPrint('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /*
     socket.on('nuevo-mensaje', (payload){
      debugPrint('Nuevo Mensaje :');
      debugPrint('nombre : '+payload['nombre']);
      debugPrint('nombre : '+payload['mensaje']);
          debugPrint(payload.containsKey('mensaje2') ? payload['mensaje2']:'No hay');
     } );*/
  }
}
