library appwrite_flutter;

import 'package:appwrite_flutter/appwrite.dart';
import 'package:logging_lite/logging.dart';

class RTPublisher {
  final AppWrite _appWrite;
  final String channelId;
  static const _allUsers = ['*'];

  RTPublisher(this._appWrite, {required this.channelId}) {
    logTrace("Realtime publisher for channel $channelId created'");
  }

  Future<void> publish(
          {required String message,
          List<String> readers = _allUsers,
          List<String> writers = _allUsers}) async =>
      _appWrite.database
          .createDocument(
              collectionId: channelId,
              data: {'message': message},
              read: readers,
              write: writers)
          .then((result) {
        logTrace('send Realtime message OK: ${result.data}');
      }).catchError((onError) {
        logTrace('send Realtime message ERROR: ${onError}');
      });
}
