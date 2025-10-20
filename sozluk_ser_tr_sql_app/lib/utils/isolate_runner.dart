// 📃 utils/isolate_runner.dart
//
// Tek seferlik küçük işler için: computeWrapper  ➜ (Bu sürüm, callback 'i
// doğrudan aynı izolede çalıştırır. compute() kullanmaz.)
// İlerlemeli ağır işler için: runWithProgress<TOut>(entryPoint: ...)
//   - entryPoint mutlaka top-level olmalı.
//   - sqflite gibi platform kanalı kullanan paketleri izole içinde kullanma!

import 'dart:async';
import 'dart:isolate';

/// Basit/tek seferlik işler: aynı izolede çalıştır.
/// (Not: compute() yalnızca top-level callback kabul ettiğinden burada
/// bilinmeyen fonksiyonları güvenli şekilde doğrudan çağırıyoruz.)
Future<R> computeWrapper<T, R>(R Function(T) fn, T message) async {
  return fn(message);
}

/// İlerleme gerektiren işler için izole başlatır.
/// [entryPoint] mutlaka top-level bir fonksiyon olmalı.
/// entryPoint signature:
///   void entryPoint(SendPort sp, dynamic initialMessage)
///
/// İzole ana izoleye şu mesajları göndermeli:
/// - {'type':'progress','value':double}
/// - {'type':'data','value': TOut}
/// - {'type':'error','error': '...'}
/// - {'type':'done'}
Future<({Stream<double> progress, Future<TOut> result})> runWithProgress<TOut>({
  required void Function(SendPort sendPort, dynamic initialMessage) entryPoint,
  dynamic initialMessage,
}) async {
  final receivePort = ReceivePort();
  final progressCtrl = StreamController<double>.broadcast();
  final resultCompleter = Completer<TOut>();

  await Isolate.spawn(
    _isolateBootstrap,
    _IsolateBootstrapMessage(
      mainSendPort: receivePort.sendPort,
      entryPoint: entryPoint,
      initialMessage: initialMessage,
    ),
    debugName: 'progress_isolate',
  );

  StreamSubscription? sub;
  sub = receivePort.listen((msg) {
    if (msg is Map && msg['type'] == 'ready' && msg['sendPort'] is SendPort) {
      final sp = msg['sendPort'] as SendPort;
      sp.send({'type': 'start', 'payload': initialMessage});
    } else if (msg is Map && msg['type'] == 'progress') {
      final p = (msg['value'] as num).toDouble().clamp(0.0, 1.0);
      progressCtrl.add(p);
    } else if (msg is Map && msg['type'] == 'data') {
      if (!resultCompleter.isCompleted) {
        resultCompleter.complete(msg['value'] as TOut);
      }
    } else if (msg is Map && msg['type'] == 'error') {
      if (!resultCompleter.isCompleted) {
        resultCompleter.completeError(msg['error'] ?? 'Isolate error');
      }
    } else if (msg is Map && msg['type'] == 'done') {
      sub?.cancel();
      progressCtrl.close();
      receivePort.close();
    }
  });

  return (progress: progressCtrl.stream, result: resultCompleter.future);
}

class _IsolateBootstrapMessage {
  final SendPort mainSendPort;
  final void Function(SendPort, dynamic) entryPoint;
  final dynamic initialMessage;
  _IsolateBootstrapMessage({
    required this.mainSendPort,
    required this.entryPoint,
    required this.initialMessage,
  });
}

void _isolateBootstrap(_IsolateBootstrapMessage msg) async {
  final internalPort = ReceivePort();
  msg.mainSendPort.send({'type': 'ready', 'sendPort': internalPort.sendPort});

  await for (final message in internalPort) {
    if (message is Map && message['type'] == 'start') {
      try {
        msg.entryPoint(msg.mainSendPort, message['payload']);
      } catch (e) {
        msg.mainSendPort.send({'type': 'error', 'error': e.toString()});
        msg.mainSendPort.send({'type': 'done'});
      }
    }
  }
}
