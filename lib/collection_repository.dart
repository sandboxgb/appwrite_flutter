library appwrite_flutter;

import 'package:logging_lite/logging.dart';
import 'package:appwrite/appwrite.dart';
import 'package:logging_lite/run_with_trace.dart';
import 'appwrite.dart';

abstract class MapSerializer<T> {
  Map<String, dynamic> toMap(T entity);
  T fromMap(dynamic map);
}

abstract class CollectionRepository<T> {
  final IAppWrite _appWrite;
  final String collectionId;
  final MapSerializer<T> serializer;

  CollectionRepository(this._appWrite, this.serializer,
      {required this.collectionId});

  Future<T> save(T entity,
          {required List<String> readPermissions,
          required List<String> writePermissions}) async =>
      runWithTraceAsync<T>(
          'save entity $entity',
          () => _appWrite.database
              .createDocument(
                  collectionId: collectionId,
                  data: serializer.toMap(entity),
                  read: readPermissions,
                  write: writePermissions)
              .then((result) => serializer.fromMap(result.data)));

  Future<T?> findOne(List? filters) async => runWithTraceAsync<T?>(
      'findOne',
      () => _appWrite.database
          .listDocuments(collectionId: collectionId, filters: filters)
          .then((response) => _getBody(response)));

  Future<T?> _getBody(Response response) async {
    if (response.hasData) {
      logTrace("response data=${response.data}");
      return response.documents.map((e) => serializer.fromMap(e)).first;
    } else
      return null;
  }

  Future<List<T>> searchAll(String searchText) async =>
      runWithTraceAsync<List<T>>(
          'findAll',
          () => _appWrite.database
              .listDocuments(collectionId: collectionId, search: searchText)
              .then((response) => _getBodyAsList(response)));

  Future<List<T>> findAll(List? filters) async => runWithTraceAsync<List<T>>(
      'findAll',
      () => _appWrite.database
          .listDocuments(collectionId: collectionId, filters: filters)
          .then((response) => _getBodyAsList(response)));

  Future<List<T>> _getBodyAsList(Response response) async {
    if (response.hasData) {
      logTrace("response data=${response.data}");
      return response.documents
          .map((e) => serializer.fromMap(e))
          .toList(growable: true);
    } else
      return [];
  }
}
