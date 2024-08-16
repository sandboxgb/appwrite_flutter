library appwrite_flutter;

import 'package:dart_appwrite/dart_appwrite.dart' as aw_server;
import 'package:logging_lite/logging.dart';
import 'package:appwrite/appwrite.dart' as aw_client;
import 'package:global_configuration/global_configuration.dart';

const APPWRITE_ENDPOINT = "api_endpoint";
const APPWRITE_PROJECT_ID = "project_id";
const REALTIME_DATABASE_ID = "REALTIME_DATABASE_ID";

abstract class IAppWrite {
  aw_client.Account get accounts;
  aw_server.Users get users;
  aw_client.Databases get database;
}

class AppWrite implements IAppWrite {
  aw_client.Client? _client;
  aw_server.Client? _serverClient;
  final ENDPOINT = GlobalConfiguration().getValue(APPWRITE_ENDPOINT);
  final PROJECT_ID = GlobalConfiguration().getValue(APPWRITE_PROJECT_ID);

  aw_client.Client get client {
    if (_client == null) {
      _client = aw_client.Client(endPoint: ENDPOINT);
      _client!.setProject(PROJECT_ID);
      logInfo(
          'Appwrite client created for ${ENDPOINT}?projectId=${PROJECT_ID}');
    }
    return _client!;
  }

  aw_server.Client get serverClient {
    if (_serverClient == null) {
      _serverClient = aw_server.Client(endPoint: ENDPOINT);
      _serverClient!.setProject(PROJECT_ID);
      logInfo(
          'Appwrite backend created for ${ENDPOINT}?projectId=${PROJECT_ID}');
    }
    return _serverClient!;
  }

  aw_client.Account get accounts => aw_client.Account(client);

  aw_client.Databases get database => aw_client.Databases(client);

  aw_client.Realtime get realTime => aw_client.Realtime(client);

  aw_server.Users get users => aw_server.Users(serverClient); 
}


List<String> userPermission(String userId) => ['user:$userId'];
