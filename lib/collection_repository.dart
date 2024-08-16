library appwrite_flutter;

import 'package:appwrite/models.dart';
import 'package:logging_lite/logging.dart';
import 'package:appwrite/appwrite.dart';
import 'package:logging_lite/run_with_trace.dart';
import 'appwrite.dart';

abstract class MapSerializer<T> {
  Map<String, dynamic> toMap(T entity);
  Document toDocument(T entity);
  T fromMap(dynamic map);
  T fromDocument(Document document);
}

abstract class CollectionRepository<T> {
  final IAppWrite _appWrite;
  final String databaseId;
  final String collectionId;
  final MapSerializer<T> serializer;


  CollectionRepository(this._appWrite, this.serializer,
      {required this.databaseId, required this.collectionId});

  Future<T> save(T entity,
          { 
            String? documentId,
            List<String>? permissions,
          }) async =>
      runWithTraceAsync<T>(
          'save entity $entity',
          () => _appWrite.database
              .createDocument(
                  databaseId: databaseId,
                  collectionId: collectionId,
                  documentId: documentId ??  ID.unique(),
                  data: serializer.toMap(entity),
                  permissions: permissions
              )
              .then((result) => serializer.fromMap(result.data)));

  Future<T?> findOne({List<String>? filters}) async => runWithTraceAsync<T?>(
      'findOne',
      () => _appWrite.database
          .listDocuments(
            databaseId: databaseId,
            collectionId: collectionId, 
            queries: filters, 
          )
          .then((response) => _getBody(response)));

  Future<T?> _getBody(DocumentList response) async {
    if (response.total > 0) {
      logTrace("response data=${response.documents}");
      return response.documents.map((e) => serializer.fromDocument(e)).first;
    } else
      return null;
  }

  Future<List<T>> findAll({List<String>? filters, int? limit}) async =>
      runWithTraceAsync<List<T>>(
          'findAll',
          () => _appWrite.database
              .listDocuments(
                databaseId: databaseId,
                collectionId: collectionId, 
                queries: filters,)
              .then((response) => _getBodyAsList(response)));


  Future<List<T>> _getBodyAsList(DocumentList response) async {
    if (response.total > 0) {
      logTrace("response data=${response.documents}");
      return response.documents
          .map((e) => serializer.fromDocument(e))
          .toList(growable: true);
    } else
      return [];
  }
}
