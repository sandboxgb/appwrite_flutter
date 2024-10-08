library appwrite_flutter;


import 'package:appwrite_flutter/appwrite.dart';
import 'package:dart_appwrite/models.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logging_lite/logging.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as aw_server;

class RealTimeService {
  aw_server.Client? _client;
  final ENDPOINT = GlobalConfiguration().getValue(APPWRITE_ENDPOINT);
  final PROJECT_ID = GlobalConfiguration().getValue(APPWRITE_PROJECT_ID);
  final DATABASE_ID = GlobalConfiguration().getValue(REALTIME_DATABASE_ID);

  aw_server.Client get client {
    if (_client == null) {
      _client = aw_server.Client(endPoint: ENDPOINT);
      _client!.setProject(PROJECT_ID);
      _client!.setKey(
          '92b681437ac1b9b8be32bfedb298fc6c792518ff4646330907b320cbeac03aef6e73cdc043c28d05cb0b08e93a2ac3ac84ff3a485332e05f2444a494719f3878e6fc3c1a339dbda106d4dd625125208753ff6c587a2dd674e0e552c9050145c4988f4d9116f67e162e60b171f89f4036fd703ba47a1084e2de95d49f5dda433a');
      logInfo(
          'dart_appwrite client created for ${ENDPOINT}?projectId=${PROJECT_ID}');
    }
    return _client!;
  }

  aw_server.Databases get database => aw_server.Databases(client);

  String channelName(String name, String userId) => 'rtc_${userId}_$name';

  Future<Collection> _createCollection(
      {
        required String collectionId,
        String? name,
        required List<String> permissions,
        bool? enableDocumentSecurity,
        bool? enabledCollection,
        //List<_Rule> rules
      }) async {
    //final _RuleSerializer serializer = _RuleSerializer();
    return database.createCollection(
      databaseId: DATABASE_ID,
      collectionId: collectionId,
      name: name ?? collectionId,
      permissions: permissions,
      documentSecurity: enableDocumentSecurity,
      enabled: enabledCollection,
    ); //rules: rules.map((e) => serializer.toMap(e)).toList(growable: false)s
  }

  Future<String?> channelExists(
          {required String name, required String userId}) =>
      database
          .listCollections(
            databaseId: DATABASE_ID,
            search: channelName(name, userId))
          .then((response) => response.total > 0 ? response.collections[0].$id : null);

  Future<String> createChannel(
          {required String name, required String userId}) =>
      _createCollection(collectionId: channelName(name, userId), 
          permissions: [
            'read:*', 'write:*'
          ], 
          // rules: [
          //  _Rule(label: "message", key: "message", type: "text", isRequired: true)
          //]
        )
        .then((response) => response.$id);

  Future<String?> createChannelIfNotExists(
          {required String name, required String userId}) =>
      channelExists(name: name, userId: userId).then((channelId) {
        if (channelId == null) {
          logTrace('before create runtime channel');
          return createChannel(name: name, userId: userId);
        } else {
          return channelId;
        }
      });

/*
  Future<dynamic> _getBody(Response response) async {
    logTrace("response=$response");
    if (response.isQueryResult) {
      if (response.hasData) {
        logTrace("response query result=${response.data}");
        return response.collections.first;
      } else {
        return null;
      }
    } else {
      logTrace("response data=${response.data}");
      return response.data;
    }
  }
  */
}

/*
extension _ResponseExtensions on Response {
  bool get isQueryResult => (data as Map).containsKey('sum');
  bool get hasData => data['sum'] > 0;
  List<dynamic> get documents => data['documents'];
  List<dynamic> get collections => data['collections'];
}
*/
/*
class _Rule {
  final String label;
  final String key;
  final String type;
  final String? defaultValue;
  final bool isRequired;
  final bool isArray;

  _Rule(
      {required this.label,
      required this.key,
      required this.type,
      this.defaultValue,
      this.isRequired = false,
      this.isArray = false});
}

class _RuleSerializer extends MapSerializer<_Rule> {
  @override
  _Rule fromMap(map) => _Rule(
      label: map['label'],
      key: map['key'],
      type: map['type'],
      defaultValue: map['default'],
      isRequired: map['required'] == 'true',
      isArray: map['array'] == 'true');

  @override
  Map<String, dynamic> toMap(_Rule entity) => {
        'label': entity.label,
        'key': entity.key,
        'type': entity.type,
        'required': entity.isRequired,
        'array': entity.isArray,
      }.also((map) {
        map.putIfNotNull("default", entity.defaultValue);
      });
}
*/
