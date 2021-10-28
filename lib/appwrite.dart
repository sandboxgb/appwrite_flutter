library appwrite_flutter;

import 'package:logging_lite/logging.dart';
import 'package:appwrite/appwrite.dart';
import 'package:global_configuration/global_configuration.dart';

const APPWRITE_ENDPOINT = "api_endpoint";
const APPWRITE_PROJECT_ID = "project_id";

abstract class IAppWrite {
  Account get accounts;
  Database get database;
}

class AppWrite implements IAppWrite {
  Client? _client;
  final ENDPOINT = GlobalConfiguration().getValue(APPWRITE_ENDPOINT);
  final PROJECT_ID = GlobalConfiguration().getValue(APPWRITE_PROJECT_ID);

  Client get client {
    if (_client == null) {
      _client = Client(endPoint: ENDPOINT);
      _client!.setProject(PROJECT_ID);
      logInfo(
          'Appwrite client created for ${ENDPOINT}?projectId=${PROJECT_ID}');
    }
    return _client!;
  }

  Account get accounts => Account(client);

  Database get database => Database(client);
}

extension ResponseExtensions on Response {
  bool get hasData => data['sum'] > 0;
  List<dynamic> get documents => data['documents'];
}

List<String> userPermission(String userId) => ['user:$userId'];
