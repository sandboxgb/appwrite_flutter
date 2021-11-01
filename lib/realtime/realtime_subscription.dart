library appwrite_flutter;

import 'package:appwrite_flutter/appwrite.dart';
import 'package:appwrite/appwrite.dart' as aw;
import 'package:logging_lite/logging.dart';

class RTSubscription {
  final AppWrite _appWrite;
  final String channelId;
  final Function(aw.RealtimeMessage) onMessage;
  late final subscription;

  RTSubscription(this._appWrite,
      {required this.channelId, required this.onMessage}) {
    var channelIds = ['collections.$channelId.documents'];
    subscription = _appWrite.realTime.subscribe(channelIds);
    subscription.stream.listen(_onMessage);
    logInfo("Realtime subscription for channels $channelId created");
  }

  void close() {
    subscription.close();
  }

  void _onMessage(aw.RealtimeMessage message) {
    logInfo("subscription.onMessage() => $message");
    onMessage.call(message);
  }
}
