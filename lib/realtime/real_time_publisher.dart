library appwrite_flutter;

import 'package:appwrite_flutter/appwrite.dart';
import 'package:logging_lite/logging.dart';

class RTPublisher {
  final AppWrite _appWrite;
  final String channelId;
  final String databaseId;
  static const _allUsers = ['*'];

  RTPublisher(this._appWrite, {required this.databaseId, required this.channelId}) {
    logTrace("Realtime publisher for channel $channelId created'");
  }

  Future<void> publish(
          {required String message,
          List<String> permissions = _allUsers,
          }) async =>
      _appWrite.database
          .createDocument(
              databaseId: databaseId,
              collectionId: channelId,
              documentId: 'unique()',
              data: {'message': message},
              permissions: permissions,
          )
          .then((result) {
        logTrace('send Realtime message OK: ${result.data}');
      }).catchError((onError) {
        logTrace('send Realtime message ERROR: ${onError}');
      });
}
