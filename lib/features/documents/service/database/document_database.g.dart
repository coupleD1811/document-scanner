// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_database.dart';

// ignore_for_file: type=lint
class $StoredDocumentsTable extends StoredDocuments
    with TableInfo<$StoredDocumentsTable, StoredDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pdfPathMeta = const VerificationMeta(
    'pdfPath',
  );
  @override
  late final GeneratedColumn<String> pdfPath = GeneratedColumn<String>(
    'pdf_path',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeInBytesMeta = const VerificationMeta(
    'sizeInBytes',
  );
  @override
  late final GeneratedColumn<int> sizeInBytes = GeneratedColumn<int>(
    'size_in_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ocrStatusMeta = const VerificationMeta(
    'ocrStatus',
  );
  @override
  late final GeneratedColumn<String> ocrStatus = GeneratedColumn<String>(
    'ocr_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    pdfPath,
    thumbnailPath,
    pageCount,
    sizeInBytes,
    createdAt,
    updatedAt,
    ocrStatus,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredDocument> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('pdf_path')) {
      context.handle(
        _pdfPathMeta,
        pdfPath.isAcceptableOrUnknown(data['pdf_path']!, _pdfPathMeta),
      );
    } else if (isInserting) {
      context.missing(_pdfPathMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_thumbnailPathMeta);
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    } else if (isInserting) {
      context.missing(_pageCountMeta);
    }
    if (data.containsKey('size_in_bytes')) {
      context.handle(
        _sizeInBytesMeta,
        sizeInBytes.isAcceptableOrUnknown(
          data['size_in_bytes']!,
          _sizeInBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sizeInBytesMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('ocr_status')) {
      context.handle(
        _ocrStatusMeta,
        ocrStatus.isAcceptableOrUnknown(data['ocr_status']!, _ocrStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_ocrStatusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredDocument(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      pdfPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_path'],
      )!,
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      )!,
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      )!,
      sizeInBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_in_bytes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      ocrStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ocr_status'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $StoredDocumentsTable createAlias(String alias) {
    return $StoredDocumentsTable(attachedDatabase, alias);
  }
}

class StoredDocument extends DataClass implements Insertable<StoredDocument> {
  final String id;
  final String name;
  final String pdfPath;
  final String thumbnailPath;
  final int pageCount;
  final int sizeInBytes;
  final int createdAt;
  final int updatedAt;
  final String ocrStatus;
  final String syncStatus;
  const StoredDocument({
    required this.id,
    required this.name,
    required this.pdfPath,
    required this.thumbnailPath,
    required this.pageCount,
    required this.sizeInBytes,
    required this.createdAt,
    required this.updatedAt,
    required this.ocrStatus,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['pdf_path'] = Variable<String>(pdfPath);
    map['thumbnail_path'] = Variable<String>(thumbnailPath);
    map['page_count'] = Variable<int>(pageCount);
    map['size_in_bytes'] = Variable<int>(sizeInBytes);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['ocr_status'] = Variable<String>(ocrStatus);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  StoredDocumentsCompanion toCompanion(bool nullToAbsent) {
    return StoredDocumentsCompanion(
      id: Value(id),
      name: Value(name),
      pdfPath: Value(pdfPath),
      thumbnailPath: Value(thumbnailPath),
      pageCount: Value(pageCount),
      sizeInBytes: Value(sizeInBytes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      ocrStatus: Value(ocrStatus),
      syncStatus: Value(syncStatus),
    );
  }

  factory StoredDocument.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredDocument(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pdfPath: serializer.fromJson<String>(json['pdfPath']),
      thumbnailPath: serializer.fromJson<String>(json['thumbnailPath']),
      pageCount: serializer.fromJson<int>(json['pageCount']),
      sizeInBytes: serializer.fromJson<int>(json['sizeInBytes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      ocrStatus: serializer.fromJson<String>(json['ocrStatus']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'pdfPath': serializer.toJson<String>(pdfPath),
      'thumbnailPath': serializer.toJson<String>(thumbnailPath),
      'pageCount': serializer.toJson<int>(pageCount),
      'sizeInBytes': serializer.toJson<int>(sizeInBytes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'ocrStatus': serializer.toJson<String>(ocrStatus),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  StoredDocument copyWith({
    String? id,
    String? name,
    String? pdfPath,
    String? thumbnailPath,
    int? pageCount,
    int? sizeInBytes,
    int? createdAt,
    int? updatedAt,
    String? ocrStatus,
    String? syncStatus,
  }) => StoredDocument(
    id: id ?? this.id,
    name: name ?? this.name,
    pdfPath: pdfPath ?? this.pdfPath,
    thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    pageCount: pageCount ?? this.pageCount,
    sizeInBytes: sizeInBytes ?? this.sizeInBytes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    ocrStatus: ocrStatus ?? this.ocrStatus,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  StoredDocument copyWithCompanion(StoredDocumentsCompanion data) {
    return StoredDocument(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pdfPath: data.pdfPath.present ? data.pdfPath.value : this.pdfPath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      sizeInBytes: data.sizeInBytes.present
          ? data.sizeInBytes.value
          : this.sizeInBytes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      ocrStatus: data.ocrStatus.present ? data.ocrStatus.value : this.ocrStatus,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredDocument(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pdfPath: $pdfPath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('pageCount: $pageCount, ')
          ..write('sizeInBytes: $sizeInBytes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('ocrStatus: $ocrStatus, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    pdfPath,
    thumbnailPath,
    pageCount,
    sizeInBytes,
    createdAt,
    updatedAt,
    ocrStatus,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredDocument &&
          other.id == this.id &&
          other.name == this.name &&
          other.pdfPath == this.pdfPath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.pageCount == this.pageCount &&
          other.sizeInBytes == this.sizeInBytes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.ocrStatus == this.ocrStatus &&
          other.syncStatus == this.syncStatus);
}

class StoredDocumentsCompanion extends UpdateCompanion<StoredDocument> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> pdfPath;
  final Value<String> thumbnailPath;
  final Value<int> pageCount;
  final Value<int> sizeInBytes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> ocrStatus;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const StoredDocumentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pdfPath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.sizeInBytes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.ocrStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredDocumentsCompanion.insert({
    required String id,
    required String name,
    required String pdfPath,
    required String thumbnailPath,
    required int pageCount,
    required int sizeInBytes,
    required int createdAt,
    required int updatedAt,
    required String ocrStatus,
    required String syncStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       pdfPath = Value(pdfPath),
       thumbnailPath = Value(thumbnailPath),
       pageCount = Value(pageCount),
       sizeInBytes = Value(sizeInBytes),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       ocrStatus = Value(ocrStatus),
       syncStatus = Value(syncStatus);
  static Insertable<StoredDocument> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? pdfPath,
    Expression<String>? thumbnailPath,
    Expression<int>? pageCount,
    Expression<int>? sizeInBytes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? ocrStatus,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pdfPath != null) 'pdf_path': pdfPath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (pageCount != null) 'page_count': pageCount,
      if (sizeInBytes != null) 'size_in_bytes': sizeInBytes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (ocrStatus != null) 'ocr_status': ocrStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredDocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? pdfPath,
    Value<String>? thumbnailPath,
    Value<int>? pageCount,
    Value<int>? sizeInBytes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? ocrStatus,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return StoredDocumentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pdfPath: pdfPath ?? this.pdfPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      pageCount: pageCount ?? this.pageCount,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ocrStatus: ocrStatus ?? this.ocrStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (pdfPath.present) {
      map['pdf_path'] = Variable<String>(pdfPath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (sizeInBytes.present) {
      map['size_in_bytes'] = Variable<int>(sizeInBytes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (ocrStatus.present) {
      map['ocr_status'] = Variable<String>(ocrStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pdfPath: $pdfPath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('pageCount: $pageCount, ')
          ..write('sizeInBytes: $sizeInBytes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('ocrStatus: $ocrStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoredDocumentPagesTable extends StoredDocumentPages
    with TableInfo<$StoredDocumentPagesTable, StoredDocumentPage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredDocumentPagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_documents (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pageIndexMeta = const VerificationMeta(
    'pageIndex',
  );
  @override
  late final GeneratedColumn<int> pageIndex = GeneratedColumn<int>(
    'page_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalImagePathMeta = const VerificationMeta(
    'originalImagePath',
  );
  @override
  late final GeneratedColumn<String> originalImagePath =
      GeneratedColumn<String>(
        'original_image_path',
        aliasedName,
        false,
        additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _normalizedImagePathMeta =
      const VerificationMeta('normalizedImagePath');
  @override
  late final GeneratedColumn<String> normalizedImagePath =
      GeneratedColumn<String>(
        'normalized_image_path',
        aliasedName,
        false,
        additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _processedImagePathMeta =
      const VerificationMeta('processedImagePath');
  @override
  late final GeneratedColumn<String> processedImagePath =
      GeneratedColumn<String>(
        'processed_image_path',
        aliasedName,
        false,
        additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _originalPixelWidthMeta =
      const VerificationMeta('originalPixelWidth');
  @override
  late final GeneratedColumn<int> originalPixelWidth = GeneratedColumn<int>(
    'original_pixel_width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalPixelHeightMeta =
      const VerificationMeta('originalPixelHeight');
  @override
  late final GeneratedColumn<int> originalPixelHeight = GeneratedColumn<int>(
    'original_pixel_height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processedPixelWidthMeta =
      const VerificationMeta('processedPixelWidth');
  @override
  late final GeneratedColumn<int> processedPixelWidth = GeneratedColumn<int>(
    'processed_pixel_width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processedPixelHeightMeta =
      const VerificationMeta('processedPixelHeight');
  @override
  late final GeneratedColumn<int> processedPixelHeight = GeneratedColumn<int>(
    'processed_pixel_height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topLeftXMeta = const VerificationMeta(
    'topLeftX',
  );
  @override
  late final GeneratedColumn<double> topLeftX = GeneratedColumn<double>(
    'top_left_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topLeftYMeta = const VerificationMeta(
    'topLeftY',
  );
  @override
  late final GeneratedColumn<double> topLeftY = GeneratedColumn<double>(
    'top_left_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topRightXMeta = const VerificationMeta(
    'topRightX',
  );
  @override
  late final GeneratedColumn<double> topRightX = GeneratedColumn<double>(
    'top_right_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topRightYMeta = const VerificationMeta(
    'topRightY',
  );
  @override
  late final GeneratedColumn<double> topRightY = GeneratedColumn<double>(
    'top_right_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bottomRightXMeta = const VerificationMeta(
    'bottomRightX',
  );
  @override
  late final GeneratedColumn<double> bottomRightX = GeneratedColumn<double>(
    'bottom_right_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bottomRightYMeta = const VerificationMeta(
    'bottomRightY',
  );
  @override
  late final GeneratedColumn<double> bottomRightY = GeneratedColumn<double>(
    'bottom_right_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bottomLeftXMeta = const VerificationMeta(
    'bottomLeftX',
  );
  @override
  late final GeneratedColumn<double> bottomLeftX = GeneratedColumn<double>(
    'bottom_left_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bottomLeftYMeta = const VerificationMeta(
    'bottomLeftY',
  );
  @override
  late final GeneratedColumn<double> bottomLeftY = GeneratedColumn<double>(
    'bottom_left_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cornersSourceMeta = const VerificationMeta(
    'cornersSource',
  );
  @override
  late final GeneratedColumn<String> cornersSource = GeneratedColumn<String>(
    'corners_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cornersConfidenceMeta = const VerificationMeta(
    'cornersConfidence',
  );
  @override
  late final GeneratedColumn<double> cornersConfidence =
      GeneratedColumn<double>(
        'corners_confidence',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _rotationMeta = const VerificationMeta(
    'rotation',
  );
  @override
  late final GeneratedColumn<int> rotation = GeneratedColumn<int>(
    'rotation',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filterMeta = const VerificationMeta('filter');
  @override
  late final GeneratedColumn<String> filter = GeneratedColumn<String>(
    'filter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brightnessMeta = const VerificationMeta(
    'brightness',
  );
  @override
  late final GeneratedColumn<int> brightness = GeneratedColumn<int>(
    'brightness',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contrastMeta = const VerificationMeta(
    'contrast',
  );
  @override
  late final GeneratedColumn<int> contrast = GeneratedColumn<int>(
    'contrast',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentId,
    pageIndex,
    originalImagePath,
    normalizedImagePath,
    processedImagePath,
    originalPixelWidth,
    originalPixelHeight,
    processedPixelWidth,
    processedPixelHeight,
    topLeftX,
    topLeftY,
    topRightX,
    topRightY,
    bottomRightX,
    bottomRightY,
    bottomLeftX,
    bottomLeftY,
    cornersSource,
    cornersConfidence,
    rotation,
    filter,
    brightness,
    contrast,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_document_pages';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredDocumentPage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('page_index')) {
      context.handle(
        _pageIndexMeta,
        pageIndex.isAcceptableOrUnknown(data['page_index']!, _pageIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_pageIndexMeta);
    }
    if (data.containsKey('original_image_path')) {
      context.handle(
        _originalImagePathMeta,
        originalImagePath.isAcceptableOrUnknown(
          data['original_image_path']!,
          _originalImagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalImagePathMeta);
    }
    if (data.containsKey('normalized_image_path')) {
      context.handle(
        _normalizedImagePathMeta,
        normalizedImagePath.isAcceptableOrUnknown(
          data['normalized_image_path']!,
          _normalizedImagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedImagePathMeta);
    }
    if (data.containsKey('processed_image_path')) {
      context.handle(
        _processedImagePathMeta,
        processedImagePath.isAcceptableOrUnknown(
          data['processed_image_path']!,
          _processedImagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processedImagePathMeta);
    }
    if (data.containsKey('original_pixel_width')) {
      context.handle(
        _originalPixelWidthMeta,
        originalPixelWidth.isAcceptableOrUnknown(
          data['original_pixel_width']!,
          _originalPixelWidthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalPixelWidthMeta);
    }
    if (data.containsKey('original_pixel_height')) {
      context.handle(
        _originalPixelHeightMeta,
        originalPixelHeight.isAcceptableOrUnknown(
          data['original_pixel_height']!,
          _originalPixelHeightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalPixelHeightMeta);
    }
    if (data.containsKey('processed_pixel_width')) {
      context.handle(
        _processedPixelWidthMeta,
        processedPixelWidth.isAcceptableOrUnknown(
          data['processed_pixel_width']!,
          _processedPixelWidthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processedPixelWidthMeta);
    }
    if (data.containsKey('processed_pixel_height')) {
      context.handle(
        _processedPixelHeightMeta,
        processedPixelHeight.isAcceptableOrUnknown(
          data['processed_pixel_height']!,
          _processedPixelHeightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processedPixelHeightMeta);
    }
    if (data.containsKey('top_left_x')) {
      context.handle(
        _topLeftXMeta,
        topLeftX.isAcceptableOrUnknown(data['top_left_x']!, _topLeftXMeta),
      );
    } else if (isInserting) {
      context.missing(_topLeftXMeta);
    }
    if (data.containsKey('top_left_y')) {
      context.handle(
        _topLeftYMeta,
        topLeftY.isAcceptableOrUnknown(data['top_left_y']!, _topLeftYMeta),
      );
    } else if (isInserting) {
      context.missing(_topLeftYMeta);
    }
    if (data.containsKey('top_right_x')) {
      context.handle(
        _topRightXMeta,
        topRightX.isAcceptableOrUnknown(data['top_right_x']!, _topRightXMeta),
      );
    } else if (isInserting) {
      context.missing(_topRightXMeta);
    }
    if (data.containsKey('top_right_y')) {
      context.handle(
        _topRightYMeta,
        topRightY.isAcceptableOrUnknown(data['top_right_y']!, _topRightYMeta),
      );
    } else if (isInserting) {
      context.missing(_topRightYMeta);
    }
    if (data.containsKey('bottom_right_x')) {
      context.handle(
        _bottomRightXMeta,
        bottomRightX.isAcceptableOrUnknown(
          data['bottom_right_x']!,
          _bottomRightXMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bottomRightXMeta);
    }
    if (data.containsKey('bottom_right_y')) {
      context.handle(
        _bottomRightYMeta,
        bottomRightY.isAcceptableOrUnknown(
          data['bottom_right_y']!,
          _bottomRightYMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bottomRightYMeta);
    }
    if (data.containsKey('bottom_left_x')) {
      context.handle(
        _bottomLeftXMeta,
        bottomLeftX.isAcceptableOrUnknown(
          data['bottom_left_x']!,
          _bottomLeftXMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bottomLeftXMeta);
    }
    if (data.containsKey('bottom_left_y')) {
      context.handle(
        _bottomLeftYMeta,
        bottomLeftY.isAcceptableOrUnknown(
          data['bottom_left_y']!,
          _bottomLeftYMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bottomLeftYMeta);
    }
    if (data.containsKey('corners_source')) {
      context.handle(
        _cornersSourceMeta,
        cornersSource.isAcceptableOrUnknown(
          data['corners_source']!,
          _cornersSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cornersSourceMeta);
    }
    if (data.containsKey('corners_confidence')) {
      context.handle(
        _cornersConfidenceMeta,
        cornersConfidence.isAcceptableOrUnknown(
          data['corners_confidence']!,
          _cornersConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('rotation')) {
      context.handle(
        _rotationMeta,
        rotation.isAcceptableOrUnknown(data['rotation']!, _rotationMeta),
      );
    } else if (isInserting) {
      context.missing(_rotationMeta);
    }
    if (data.containsKey('filter')) {
      context.handle(
        _filterMeta,
        filter.isAcceptableOrUnknown(data['filter']!, _filterMeta),
      );
    } else if (isInserting) {
      context.missing(_filterMeta);
    }
    if (data.containsKey('brightness')) {
      context.handle(
        _brightnessMeta,
        brightness.isAcceptableOrUnknown(data['brightness']!, _brightnessMeta),
      );
    } else if (isInserting) {
      context.missing(_brightnessMeta);
    }
    if (data.containsKey('contrast')) {
      context.handle(
        _contrastMeta,
        contrast.isAcceptableOrUnknown(data['contrast']!, _contrastMeta),
      );
    } else if (isInserting) {
      context.missing(_contrastMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {documentId, pageIndex},
  ];
  @override
  StoredDocumentPage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredDocumentPage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      pageIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_index'],
      )!,
      originalImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_image_path'],
      )!,
      normalizedImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_image_path'],
      )!,
      processedImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}processed_image_path'],
      )!,
      originalPixelWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_pixel_width'],
      )!,
      originalPixelHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_pixel_height'],
      )!,
      processedPixelWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}processed_pixel_width'],
      )!,
      processedPixelHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}processed_pixel_height'],
      )!,
      topLeftX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}top_left_x'],
      )!,
      topLeftY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}top_left_y'],
      )!,
      topRightX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}top_right_x'],
      )!,
      topRightY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}top_right_y'],
      )!,
      bottomRightX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bottom_right_x'],
      )!,
      bottomRightY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bottom_right_y'],
      )!,
      bottomLeftX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bottom_left_x'],
      )!,
      bottomLeftY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bottom_left_y'],
      )!,
      cornersSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}corners_source'],
      )!,
      cornersConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}corners_confidence'],
      ),
      rotation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rotation'],
      )!,
      filter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filter'],
      )!,
      brightness: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brightness'],
      )!,
      contrast: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contrast'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StoredDocumentPagesTable createAlias(String alias) {
    return $StoredDocumentPagesTable(attachedDatabase, alias);
  }
}

class StoredDocumentPage extends DataClass
    implements Insertable<StoredDocumentPage> {
  final String id;
  final String documentId;
  final int pageIndex;
  final String originalImagePath;
  final String normalizedImagePath;
  final String processedImagePath;
  final int originalPixelWidth;
  final int originalPixelHeight;
  final int processedPixelWidth;
  final int processedPixelHeight;
  final double topLeftX;
  final double topLeftY;
  final double topRightX;
  final double topRightY;
  final double bottomRightX;
  final double bottomRightY;
  final double bottomLeftX;
  final double bottomLeftY;
  final String cornersSource;
  final double? cornersConfidence;
  final int rotation;
  final String filter;
  final int brightness;
  final int contrast;
  final int createdAt;
  final int updatedAt;
  const StoredDocumentPage({
    required this.id,
    required this.documentId,
    required this.pageIndex,
    required this.originalImagePath,
    required this.normalizedImagePath,
    required this.processedImagePath,
    required this.originalPixelWidth,
    required this.originalPixelHeight,
    required this.processedPixelWidth,
    required this.processedPixelHeight,
    required this.topLeftX,
    required this.topLeftY,
    required this.topRightX,
    required this.topRightY,
    required this.bottomRightX,
    required this.bottomRightY,
    required this.bottomLeftX,
    required this.bottomLeftY,
    required this.cornersSource,
    this.cornersConfidence,
    required this.rotation,
    required this.filter,
    required this.brightness,
    required this.contrast,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['document_id'] = Variable<String>(documentId);
    map['page_index'] = Variable<int>(pageIndex);
    map['original_image_path'] = Variable<String>(originalImagePath);
    map['normalized_image_path'] = Variable<String>(normalizedImagePath);
    map['processed_image_path'] = Variable<String>(processedImagePath);
    map['original_pixel_width'] = Variable<int>(originalPixelWidth);
    map['original_pixel_height'] = Variable<int>(originalPixelHeight);
    map['processed_pixel_width'] = Variable<int>(processedPixelWidth);
    map['processed_pixel_height'] = Variable<int>(processedPixelHeight);
    map['top_left_x'] = Variable<double>(topLeftX);
    map['top_left_y'] = Variable<double>(topLeftY);
    map['top_right_x'] = Variable<double>(topRightX);
    map['top_right_y'] = Variable<double>(topRightY);
    map['bottom_right_x'] = Variable<double>(bottomRightX);
    map['bottom_right_y'] = Variable<double>(bottomRightY);
    map['bottom_left_x'] = Variable<double>(bottomLeftX);
    map['bottom_left_y'] = Variable<double>(bottomLeftY);
    map['corners_source'] = Variable<String>(cornersSource);
    if (!nullToAbsent || cornersConfidence != null) {
      map['corners_confidence'] = Variable<double>(cornersConfidence);
    }
    map['rotation'] = Variable<int>(rotation);
    map['filter'] = Variable<String>(filter);
    map['brightness'] = Variable<int>(brightness);
    map['contrast'] = Variable<int>(contrast);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  StoredDocumentPagesCompanion toCompanion(bool nullToAbsent) {
    return StoredDocumentPagesCompanion(
      id: Value(id),
      documentId: Value(documentId),
      pageIndex: Value(pageIndex),
      originalImagePath: Value(originalImagePath),
      normalizedImagePath: Value(normalizedImagePath),
      processedImagePath: Value(processedImagePath),
      originalPixelWidth: Value(originalPixelWidth),
      originalPixelHeight: Value(originalPixelHeight),
      processedPixelWidth: Value(processedPixelWidth),
      processedPixelHeight: Value(processedPixelHeight),
      topLeftX: Value(topLeftX),
      topLeftY: Value(topLeftY),
      topRightX: Value(topRightX),
      topRightY: Value(topRightY),
      bottomRightX: Value(bottomRightX),
      bottomRightY: Value(bottomRightY),
      bottomLeftX: Value(bottomLeftX),
      bottomLeftY: Value(bottomLeftY),
      cornersSource: Value(cornersSource),
      cornersConfidence: cornersConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(cornersConfidence),
      rotation: Value(rotation),
      filter: Value(filter),
      brightness: Value(brightness),
      contrast: Value(contrast),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StoredDocumentPage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredDocumentPage(
      id: serializer.fromJson<String>(json['id']),
      documentId: serializer.fromJson<String>(json['documentId']),
      pageIndex: serializer.fromJson<int>(json['pageIndex']),
      originalImagePath: serializer.fromJson<String>(json['originalImagePath']),
      normalizedImagePath: serializer.fromJson<String>(
        json['normalizedImagePath'],
      ),
      processedImagePath: serializer.fromJson<String>(
        json['processedImagePath'],
      ),
      originalPixelWidth: serializer.fromJson<int>(json['originalPixelWidth']),
      originalPixelHeight: serializer.fromJson<int>(
        json['originalPixelHeight'],
      ),
      processedPixelWidth: serializer.fromJson<int>(
        json['processedPixelWidth'],
      ),
      processedPixelHeight: serializer.fromJson<int>(
        json['processedPixelHeight'],
      ),
      topLeftX: serializer.fromJson<double>(json['topLeftX']),
      topLeftY: serializer.fromJson<double>(json['topLeftY']),
      topRightX: serializer.fromJson<double>(json['topRightX']),
      topRightY: serializer.fromJson<double>(json['topRightY']),
      bottomRightX: serializer.fromJson<double>(json['bottomRightX']),
      bottomRightY: serializer.fromJson<double>(json['bottomRightY']),
      bottomLeftX: serializer.fromJson<double>(json['bottomLeftX']),
      bottomLeftY: serializer.fromJson<double>(json['bottomLeftY']),
      cornersSource: serializer.fromJson<String>(json['cornersSource']),
      cornersConfidence: serializer.fromJson<double?>(
        json['cornersConfidence'],
      ),
      rotation: serializer.fromJson<int>(json['rotation']),
      filter: serializer.fromJson<String>(json['filter']),
      brightness: serializer.fromJson<int>(json['brightness']),
      contrast: serializer.fromJson<int>(json['contrast']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'documentId': serializer.toJson<String>(documentId),
      'pageIndex': serializer.toJson<int>(pageIndex),
      'originalImagePath': serializer.toJson<String>(originalImagePath),
      'normalizedImagePath': serializer.toJson<String>(normalizedImagePath),
      'processedImagePath': serializer.toJson<String>(processedImagePath),
      'originalPixelWidth': serializer.toJson<int>(originalPixelWidth),
      'originalPixelHeight': serializer.toJson<int>(originalPixelHeight),
      'processedPixelWidth': serializer.toJson<int>(processedPixelWidth),
      'processedPixelHeight': serializer.toJson<int>(processedPixelHeight),
      'topLeftX': serializer.toJson<double>(topLeftX),
      'topLeftY': serializer.toJson<double>(topLeftY),
      'topRightX': serializer.toJson<double>(topRightX),
      'topRightY': serializer.toJson<double>(topRightY),
      'bottomRightX': serializer.toJson<double>(bottomRightX),
      'bottomRightY': serializer.toJson<double>(bottomRightY),
      'bottomLeftX': serializer.toJson<double>(bottomLeftX),
      'bottomLeftY': serializer.toJson<double>(bottomLeftY),
      'cornersSource': serializer.toJson<String>(cornersSource),
      'cornersConfidence': serializer.toJson<double?>(cornersConfidence),
      'rotation': serializer.toJson<int>(rotation),
      'filter': serializer.toJson<String>(filter),
      'brightness': serializer.toJson<int>(brightness),
      'contrast': serializer.toJson<int>(contrast),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  StoredDocumentPage copyWith({
    String? id,
    String? documentId,
    int? pageIndex,
    String? originalImagePath,
    String? normalizedImagePath,
    String? processedImagePath,
    int? originalPixelWidth,
    int? originalPixelHeight,
    int? processedPixelWidth,
    int? processedPixelHeight,
    double? topLeftX,
    double? topLeftY,
    double? topRightX,
    double? topRightY,
    double? bottomRightX,
    double? bottomRightY,
    double? bottomLeftX,
    double? bottomLeftY,
    String? cornersSource,
    Value<double?> cornersConfidence = const Value.absent(),
    int? rotation,
    String? filter,
    int? brightness,
    int? contrast,
    int? createdAt,
    int? updatedAt,
  }) => StoredDocumentPage(
    id: id ?? this.id,
    documentId: documentId ?? this.documentId,
    pageIndex: pageIndex ?? this.pageIndex,
    originalImagePath: originalImagePath ?? this.originalImagePath,
    normalizedImagePath: normalizedImagePath ?? this.normalizedImagePath,
    processedImagePath: processedImagePath ?? this.processedImagePath,
    originalPixelWidth: originalPixelWidth ?? this.originalPixelWidth,
    originalPixelHeight: originalPixelHeight ?? this.originalPixelHeight,
    processedPixelWidth: processedPixelWidth ?? this.processedPixelWidth,
    processedPixelHeight: processedPixelHeight ?? this.processedPixelHeight,
    topLeftX: topLeftX ?? this.topLeftX,
    topLeftY: topLeftY ?? this.topLeftY,
    topRightX: topRightX ?? this.topRightX,
    topRightY: topRightY ?? this.topRightY,
    bottomRightX: bottomRightX ?? this.bottomRightX,
    bottomRightY: bottomRightY ?? this.bottomRightY,
    bottomLeftX: bottomLeftX ?? this.bottomLeftX,
    bottomLeftY: bottomLeftY ?? this.bottomLeftY,
    cornersSource: cornersSource ?? this.cornersSource,
    cornersConfidence: cornersConfidence.present
        ? cornersConfidence.value
        : this.cornersConfidence,
    rotation: rotation ?? this.rotation,
    filter: filter ?? this.filter,
    brightness: brightness ?? this.brightness,
    contrast: contrast ?? this.contrast,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StoredDocumentPage copyWithCompanion(StoredDocumentPagesCompanion data) {
    return StoredDocumentPage(
      id: data.id.present ? data.id.value : this.id,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      pageIndex: data.pageIndex.present ? data.pageIndex.value : this.pageIndex,
      originalImagePath: data.originalImagePath.present
          ? data.originalImagePath.value
          : this.originalImagePath,
      normalizedImagePath: data.normalizedImagePath.present
          ? data.normalizedImagePath.value
          : this.normalizedImagePath,
      processedImagePath: data.processedImagePath.present
          ? data.processedImagePath.value
          : this.processedImagePath,
      originalPixelWidth: data.originalPixelWidth.present
          ? data.originalPixelWidth.value
          : this.originalPixelWidth,
      originalPixelHeight: data.originalPixelHeight.present
          ? data.originalPixelHeight.value
          : this.originalPixelHeight,
      processedPixelWidth: data.processedPixelWidth.present
          ? data.processedPixelWidth.value
          : this.processedPixelWidth,
      processedPixelHeight: data.processedPixelHeight.present
          ? data.processedPixelHeight.value
          : this.processedPixelHeight,
      topLeftX: data.topLeftX.present ? data.topLeftX.value : this.topLeftX,
      topLeftY: data.topLeftY.present ? data.topLeftY.value : this.topLeftY,
      topRightX: data.topRightX.present ? data.topRightX.value : this.topRightX,
      topRightY: data.topRightY.present ? data.topRightY.value : this.topRightY,
      bottomRightX: data.bottomRightX.present
          ? data.bottomRightX.value
          : this.bottomRightX,
      bottomRightY: data.bottomRightY.present
          ? data.bottomRightY.value
          : this.bottomRightY,
      bottomLeftX: data.bottomLeftX.present
          ? data.bottomLeftX.value
          : this.bottomLeftX,
      bottomLeftY: data.bottomLeftY.present
          ? data.bottomLeftY.value
          : this.bottomLeftY,
      cornersSource: data.cornersSource.present
          ? data.cornersSource.value
          : this.cornersSource,
      cornersConfidence: data.cornersConfidence.present
          ? data.cornersConfidence.value
          : this.cornersConfidence,
      rotation: data.rotation.present ? data.rotation.value : this.rotation,
      filter: data.filter.present ? data.filter.value : this.filter,
      brightness: data.brightness.present
          ? data.brightness.value
          : this.brightness,
      contrast: data.contrast.present ? data.contrast.value : this.contrast,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredDocumentPage(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('pageIndex: $pageIndex, ')
          ..write('originalImagePath: $originalImagePath, ')
          ..write('normalizedImagePath: $normalizedImagePath, ')
          ..write('processedImagePath: $processedImagePath, ')
          ..write('originalPixelWidth: $originalPixelWidth, ')
          ..write('originalPixelHeight: $originalPixelHeight, ')
          ..write('processedPixelWidth: $processedPixelWidth, ')
          ..write('processedPixelHeight: $processedPixelHeight, ')
          ..write('topLeftX: $topLeftX, ')
          ..write('topLeftY: $topLeftY, ')
          ..write('topRightX: $topRightX, ')
          ..write('topRightY: $topRightY, ')
          ..write('bottomRightX: $bottomRightX, ')
          ..write('bottomRightY: $bottomRightY, ')
          ..write('bottomLeftX: $bottomLeftX, ')
          ..write('bottomLeftY: $bottomLeftY, ')
          ..write('cornersSource: $cornersSource, ')
          ..write('cornersConfidence: $cornersConfidence, ')
          ..write('rotation: $rotation, ')
          ..write('filter: $filter, ')
          ..write('brightness: $brightness, ')
          ..write('contrast: $contrast, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    documentId,
    pageIndex,
    originalImagePath,
    normalizedImagePath,
    processedImagePath,
    originalPixelWidth,
    originalPixelHeight,
    processedPixelWidth,
    processedPixelHeight,
    topLeftX,
    topLeftY,
    topRightX,
    topRightY,
    bottomRightX,
    bottomRightY,
    bottomLeftX,
    bottomLeftY,
    cornersSource,
    cornersConfidence,
    rotation,
    filter,
    brightness,
    contrast,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredDocumentPage &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.pageIndex == this.pageIndex &&
          other.originalImagePath == this.originalImagePath &&
          other.normalizedImagePath == this.normalizedImagePath &&
          other.processedImagePath == this.processedImagePath &&
          other.originalPixelWidth == this.originalPixelWidth &&
          other.originalPixelHeight == this.originalPixelHeight &&
          other.processedPixelWidth == this.processedPixelWidth &&
          other.processedPixelHeight == this.processedPixelHeight &&
          other.topLeftX == this.topLeftX &&
          other.topLeftY == this.topLeftY &&
          other.topRightX == this.topRightX &&
          other.topRightY == this.topRightY &&
          other.bottomRightX == this.bottomRightX &&
          other.bottomRightY == this.bottomRightY &&
          other.bottomLeftX == this.bottomLeftX &&
          other.bottomLeftY == this.bottomLeftY &&
          other.cornersSource == this.cornersSource &&
          other.cornersConfidence == this.cornersConfidence &&
          other.rotation == this.rotation &&
          other.filter == this.filter &&
          other.brightness == this.brightness &&
          other.contrast == this.contrast &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StoredDocumentPagesCompanion extends UpdateCompanion<StoredDocumentPage> {
  final Value<String> id;
  final Value<String> documentId;
  final Value<int> pageIndex;
  final Value<String> originalImagePath;
  final Value<String> normalizedImagePath;
  final Value<String> processedImagePath;
  final Value<int> originalPixelWidth;
  final Value<int> originalPixelHeight;
  final Value<int> processedPixelWidth;
  final Value<int> processedPixelHeight;
  final Value<double> topLeftX;
  final Value<double> topLeftY;
  final Value<double> topRightX;
  final Value<double> topRightY;
  final Value<double> bottomRightX;
  final Value<double> bottomRightY;
  final Value<double> bottomLeftX;
  final Value<double> bottomLeftY;
  final Value<String> cornersSource;
  final Value<double?> cornersConfidence;
  final Value<int> rotation;
  final Value<String> filter;
  final Value<int> brightness;
  final Value<int> contrast;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const StoredDocumentPagesCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.pageIndex = const Value.absent(),
    this.originalImagePath = const Value.absent(),
    this.normalizedImagePath = const Value.absent(),
    this.processedImagePath = const Value.absent(),
    this.originalPixelWidth = const Value.absent(),
    this.originalPixelHeight = const Value.absent(),
    this.processedPixelWidth = const Value.absent(),
    this.processedPixelHeight = const Value.absent(),
    this.topLeftX = const Value.absent(),
    this.topLeftY = const Value.absent(),
    this.topRightX = const Value.absent(),
    this.topRightY = const Value.absent(),
    this.bottomRightX = const Value.absent(),
    this.bottomRightY = const Value.absent(),
    this.bottomLeftX = const Value.absent(),
    this.bottomLeftY = const Value.absent(),
    this.cornersSource = const Value.absent(),
    this.cornersConfidence = const Value.absent(),
    this.rotation = const Value.absent(),
    this.filter = const Value.absent(),
    this.brightness = const Value.absent(),
    this.contrast = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredDocumentPagesCompanion.insert({
    required String id,
    required String documentId,
    required int pageIndex,
    required String originalImagePath,
    required String normalizedImagePath,
    required String processedImagePath,
    required int originalPixelWidth,
    required int originalPixelHeight,
    required int processedPixelWidth,
    required int processedPixelHeight,
    required double topLeftX,
    required double topLeftY,
    required double topRightX,
    required double topRightY,
    required double bottomRightX,
    required double bottomRightY,
    required double bottomLeftX,
    required double bottomLeftY,
    required String cornersSource,
    this.cornersConfidence = const Value.absent(),
    required int rotation,
    required String filter,
    required int brightness,
    required int contrast,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       documentId = Value(documentId),
       pageIndex = Value(pageIndex),
       originalImagePath = Value(originalImagePath),
       normalizedImagePath = Value(normalizedImagePath),
       processedImagePath = Value(processedImagePath),
       originalPixelWidth = Value(originalPixelWidth),
       originalPixelHeight = Value(originalPixelHeight),
       processedPixelWidth = Value(processedPixelWidth),
       processedPixelHeight = Value(processedPixelHeight),
       topLeftX = Value(topLeftX),
       topLeftY = Value(topLeftY),
       topRightX = Value(topRightX),
       topRightY = Value(topRightY),
       bottomRightX = Value(bottomRightX),
       bottomRightY = Value(bottomRightY),
       bottomLeftX = Value(bottomLeftX),
       bottomLeftY = Value(bottomLeftY),
       cornersSource = Value(cornersSource),
       rotation = Value(rotation),
       filter = Value(filter),
       brightness = Value(brightness),
       contrast = Value(contrast),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StoredDocumentPage> custom({
    Expression<String>? id,
    Expression<String>? documentId,
    Expression<int>? pageIndex,
    Expression<String>? originalImagePath,
    Expression<String>? normalizedImagePath,
    Expression<String>? processedImagePath,
    Expression<int>? originalPixelWidth,
    Expression<int>? originalPixelHeight,
    Expression<int>? processedPixelWidth,
    Expression<int>? processedPixelHeight,
    Expression<double>? topLeftX,
    Expression<double>? topLeftY,
    Expression<double>? topRightX,
    Expression<double>? topRightY,
    Expression<double>? bottomRightX,
    Expression<double>? bottomRightY,
    Expression<double>? bottomLeftX,
    Expression<double>? bottomLeftY,
    Expression<String>? cornersSource,
    Expression<double>? cornersConfidence,
    Expression<int>? rotation,
    Expression<String>? filter,
    Expression<int>? brightness,
    Expression<int>? contrast,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (pageIndex != null) 'page_index': pageIndex,
      if (originalImagePath != null) 'original_image_path': originalImagePath,
      if (normalizedImagePath != null)
        'normalized_image_path': normalizedImagePath,
      if (processedImagePath != null)
        'processed_image_path': processedImagePath,
      if (originalPixelWidth != null)
        'original_pixel_width': originalPixelWidth,
      if (originalPixelHeight != null)
        'original_pixel_height': originalPixelHeight,
      if (processedPixelWidth != null)
        'processed_pixel_width': processedPixelWidth,
      if (processedPixelHeight != null)
        'processed_pixel_height': processedPixelHeight,
      if (topLeftX != null) 'top_left_x': topLeftX,
      if (topLeftY != null) 'top_left_y': topLeftY,
      if (topRightX != null) 'top_right_x': topRightX,
      if (topRightY != null) 'top_right_y': topRightY,
      if (bottomRightX != null) 'bottom_right_x': bottomRightX,
      if (bottomRightY != null) 'bottom_right_y': bottomRightY,
      if (bottomLeftX != null) 'bottom_left_x': bottomLeftX,
      if (bottomLeftY != null) 'bottom_left_y': bottomLeftY,
      if (cornersSource != null) 'corners_source': cornersSource,
      if (cornersConfidence != null) 'corners_confidence': cornersConfidence,
      if (rotation != null) 'rotation': rotation,
      if (filter != null) 'filter': filter,
      if (brightness != null) 'brightness': brightness,
      if (contrast != null) 'contrast': contrast,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredDocumentPagesCompanion copyWith({
    Value<String>? id,
    Value<String>? documentId,
    Value<int>? pageIndex,
    Value<String>? originalImagePath,
    Value<String>? normalizedImagePath,
    Value<String>? processedImagePath,
    Value<int>? originalPixelWidth,
    Value<int>? originalPixelHeight,
    Value<int>? processedPixelWidth,
    Value<int>? processedPixelHeight,
    Value<double>? topLeftX,
    Value<double>? topLeftY,
    Value<double>? topRightX,
    Value<double>? topRightY,
    Value<double>? bottomRightX,
    Value<double>? bottomRightY,
    Value<double>? bottomLeftX,
    Value<double>? bottomLeftY,
    Value<String>? cornersSource,
    Value<double?>? cornersConfidence,
    Value<int>? rotation,
    Value<String>? filter,
    Value<int>? brightness,
    Value<int>? contrast,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return StoredDocumentPagesCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      pageIndex: pageIndex ?? this.pageIndex,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      normalizedImagePath: normalizedImagePath ?? this.normalizedImagePath,
      processedImagePath: processedImagePath ?? this.processedImagePath,
      originalPixelWidth: originalPixelWidth ?? this.originalPixelWidth,
      originalPixelHeight: originalPixelHeight ?? this.originalPixelHeight,
      processedPixelWidth: processedPixelWidth ?? this.processedPixelWidth,
      processedPixelHeight: processedPixelHeight ?? this.processedPixelHeight,
      topLeftX: topLeftX ?? this.topLeftX,
      topLeftY: topLeftY ?? this.topLeftY,
      topRightX: topRightX ?? this.topRightX,
      topRightY: topRightY ?? this.topRightY,
      bottomRightX: bottomRightX ?? this.bottomRightX,
      bottomRightY: bottomRightY ?? this.bottomRightY,
      bottomLeftX: bottomLeftX ?? this.bottomLeftX,
      bottomLeftY: bottomLeftY ?? this.bottomLeftY,
      cornersSource: cornersSource ?? this.cornersSource,
      cornersConfidence: cornersConfidence ?? this.cornersConfidence,
      rotation: rotation ?? this.rotation,
      filter: filter ?? this.filter,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (pageIndex.present) {
      map['page_index'] = Variable<int>(pageIndex.value);
    }
    if (originalImagePath.present) {
      map['original_image_path'] = Variable<String>(originalImagePath.value);
    }
    if (normalizedImagePath.present) {
      map['normalized_image_path'] = Variable<String>(
        normalizedImagePath.value,
      );
    }
    if (processedImagePath.present) {
      map['processed_image_path'] = Variable<String>(processedImagePath.value);
    }
    if (originalPixelWidth.present) {
      map['original_pixel_width'] = Variable<int>(originalPixelWidth.value);
    }
    if (originalPixelHeight.present) {
      map['original_pixel_height'] = Variable<int>(originalPixelHeight.value);
    }
    if (processedPixelWidth.present) {
      map['processed_pixel_width'] = Variable<int>(processedPixelWidth.value);
    }
    if (processedPixelHeight.present) {
      map['processed_pixel_height'] = Variable<int>(processedPixelHeight.value);
    }
    if (topLeftX.present) {
      map['top_left_x'] = Variable<double>(topLeftX.value);
    }
    if (topLeftY.present) {
      map['top_left_y'] = Variable<double>(topLeftY.value);
    }
    if (topRightX.present) {
      map['top_right_x'] = Variable<double>(topRightX.value);
    }
    if (topRightY.present) {
      map['top_right_y'] = Variable<double>(topRightY.value);
    }
    if (bottomRightX.present) {
      map['bottom_right_x'] = Variable<double>(bottomRightX.value);
    }
    if (bottomRightY.present) {
      map['bottom_right_y'] = Variable<double>(bottomRightY.value);
    }
    if (bottomLeftX.present) {
      map['bottom_left_x'] = Variable<double>(bottomLeftX.value);
    }
    if (bottomLeftY.present) {
      map['bottom_left_y'] = Variable<double>(bottomLeftY.value);
    }
    if (cornersSource.present) {
      map['corners_source'] = Variable<String>(cornersSource.value);
    }
    if (cornersConfidence.present) {
      map['corners_confidence'] = Variable<double>(cornersConfidence.value);
    }
    if (rotation.present) {
      map['rotation'] = Variable<int>(rotation.value);
    }
    if (filter.present) {
      map['filter'] = Variable<String>(filter.value);
    }
    if (brightness.present) {
      map['brightness'] = Variable<int>(brightness.value);
    }
    if (contrast.present) {
      map['contrast'] = Variable<int>(contrast.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredDocumentPagesCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('pageIndex: $pageIndex, ')
          ..write('originalImagePath: $originalImagePath, ')
          ..write('normalizedImagePath: $normalizedImagePath, ')
          ..write('processedImagePath: $processedImagePath, ')
          ..write('originalPixelWidth: $originalPixelWidth, ')
          ..write('originalPixelHeight: $originalPixelHeight, ')
          ..write('processedPixelWidth: $processedPixelWidth, ')
          ..write('processedPixelHeight: $processedPixelHeight, ')
          ..write('topLeftX: $topLeftX, ')
          ..write('topLeftY: $topLeftY, ')
          ..write('topRightX: $topRightX, ')
          ..write('topRightY: $topRightY, ')
          ..write('bottomRightX: $bottomRightX, ')
          ..write('bottomRightY: $bottomRightY, ')
          ..write('bottomLeftX: $bottomLeftX, ')
          ..write('bottomLeftY: $bottomLeftY, ')
          ..write('cornersSource: $cornersSource, ')
          ..write('cornersConfidence: $cornersConfidence, ')
          ..write('rotation: $rotation, ')
          ..write('filter: $filter, ')
          ..write('brightness: $brightness, ')
          ..write('contrast: $contrast, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DocumentDatabase extends GeneratedDatabase {
  _$DocumentDatabase(QueryExecutor e) : super(e);
  $DocumentDatabaseManager get managers => $DocumentDatabaseManager(this);
  late final $StoredDocumentsTable storedDocuments = $StoredDocumentsTable(
    this,
  );
  late final $StoredDocumentPagesTable storedDocumentPages =
      $StoredDocumentPagesTable(this);
  late final Index storedDocumentsUpdatedAt = Index(
    'stored_documents_updated_at',
    'CREATE INDEX stored_documents_updated_at ON stored_documents (updated_at)',
  );
  late final Index storedDocumentPagesDocumentId = Index(
    'stored_document_pages_document_id',
    'CREATE INDEX stored_document_pages_document_id ON stored_document_pages (document_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    storedDocuments,
    storedDocumentPages,
    storedDocumentsUpdatedAt,
    storedDocumentPagesDocumentId,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_documents',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stored_document_pages', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$StoredDocumentsTableCreateCompanionBuilder =
    StoredDocumentsCompanion Function({
      required String id,
      required String name,
      required String pdfPath,
      required String thumbnailPath,
      required int pageCount,
      required int sizeInBytes,
      required int createdAt,
      required int updatedAt,
      required String ocrStatus,
      required String syncStatus,
      Value<int> rowid,
    });
typedef $$StoredDocumentsTableUpdateCompanionBuilder =
    StoredDocumentsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> pdfPath,
      Value<String> thumbnailPath,
      Value<int> pageCount,
      Value<int> sizeInBytes,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String> ocrStatus,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$StoredDocumentsTableReferences
    extends
        BaseReferences<
          _$DocumentDatabase,
          $StoredDocumentsTable,
          StoredDocument
        > {
  $$StoredDocumentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $StoredDocumentPagesTable,
    List<StoredDocumentPage>
  >
  _storedDocumentPagesRefsTable(_$DocumentDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.storedDocumentPages,
        aliasName: 'stored_documents__id__stored_document_pages__document_id',
      );

  $$StoredDocumentPagesTableProcessedTableManager get storedDocumentPagesRefs {
    final manager = $$StoredDocumentPagesTableTableManager(
      $_db,
      $_db.storedDocumentPages,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedDocumentPagesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoredDocumentsTableFilterComposer
    extends Composer<_$DocumentDatabase, $StoredDocumentsTable> {
  $$StoredDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pdfPath => $composableBuilder(
    column: $table.pdfPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeInBytes => $composableBuilder(
    column: $table.sizeInBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ocrStatus => $composableBuilder(
    column: $table.ocrStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> storedDocumentPagesRefs(
    Expression<bool> Function($$StoredDocumentPagesTableFilterComposer f) f,
  ) {
    final $$StoredDocumentPagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedDocumentPages,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredDocumentPagesTableFilterComposer(
            $db: $db,
            $table: $db.storedDocumentPages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoredDocumentsTableOrderingComposer
    extends Composer<_$DocumentDatabase, $StoredDocumentsTable> {
  $$StoredDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pdfPath => $composableBuilder(
    column: $table.pdfPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeInBytes => $composableBuilder(
    column: $table.sizeInBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ocrStatus => $composableBuilder(
    column: $table.ocrStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredDocumentsTableAnnotationComposer
    extends Composer<_$DocumentDatabase, $StoredDocumentsTable> {
  $$StoredDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get pdfPath =>
      $composableBuilder(column: $table.pdfPath, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<int> get sizeInBytes => $composableBuilder(
    column: $table.sizeInBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get ocrStatus =>
      $composableBuilder(column: $table.ocrStatus, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  Expression<T> storedDocumentPagesRefs<T extends Object>(
    Expression<T> Function($$StoredDocumentPagesTableAnnotationComposer a) f,
  ) {
    final $$StoredDocumentPagesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedDocumentPages,
          getReferencedColumn: (t) => t.documentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredDocumentPagesTableAnnotationComposer(
                $db: $db,
                $table: $db.storedDocumentPages,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredDocumentsTableTableManager
    extends
        RootTableManager<
          _$DocumentDatabase,
          $StoredDocumentsTable,
          StoredDocument,
          $$StoredDocumentsTableFilterComposer,
          $$StoredDocumentsTableOrderingComposer,
          $$StoredDocumentsTableAnnotationComposer,
          $$StoredDocumentsTableCreateCompanionBuilder,
          $$StoredDocumentsTableUpdateCompanionBuilder,
          (StoredDocument, $$StoredDocumentsTableReferences),
          StoredDocument,
          PrefetchHooks Function({bool storedDocumentPagesRefs})
        > {
  $$StoredDocumentsTableTableManager(
    _$DocumentDatabase db,
    $StoredDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> pdfPath = const Value.absent(),
                Value<String> thumbnailPath = const Value.absent(),
                Value<int> pageCount = const Value.absent(),
                Value<int> sizeInBytes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> ocrStatus = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredDocumentsCompanion(
                id: id,
                name: name,
                pdfPath: pdfPath,
                thumbnailPath: thumbnailPath,
                pageCount: pageCount,
                sizeInBytes: sizeInBytes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                ocrStatus: ocrStatus,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String pdfPath,
                required String thumbnailPath,
                required int pageCount,
                required int sizeInBytes,
                required int createdAt,
                required int updatedAt,
                required String ocrStatus,
                required String syncStatus,
                Value<int> rowid = const Value.absent(),
              }) => StoredDocumentsCompanion.insert(
                id: id,
                name: name,
                pdfPath: pdfPath,
                thumbnailPath: thumbnailPath,
                pageCount: pageCount,
                sizeInBytes: sizeInBytes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                ocrStatus: ocrStatus,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoredDocumentsTable, StoredDocument>(table),
                  $$StoredDocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({storedDocumentPagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (storedDocumentPagesRefs) db.storedDocumentPages,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (storedDocumentPagesRefs)
                    await $_getPrefetchedData<
                      StoredDocument,
                      $StoredDocumentsTable,
                      StoredDocumentPage
                    >(
                      currentTable: table,
                      referencedTable: $$StoredDocumentsTableReferences
                          ._storedDocumentPagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$StoredDocumentsTableReferences(
                            db,
                            table,
                            p0,
                          ).storedDocumentPagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.documentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StoredDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$DocumentDatabase,
      $StoredDocumentsTable,
      StoredDocument,
      $$StoredDocumentsTableFilterComposer,
      $$StoredDocumentsTableOrderingComposer,
      $$StoredDocumentsTableAnnotationComposer,
      $$StoredDocumentsTableCreateCompanionBuilder,
      $$StoredDocumentsTableUpdateCompanionBuilder,
      (StoredDocument, $$StoredDocumentsTableReferences),
      StoredDocument,
      PrefetchHooks Function({bool storedDocumentPagesRefs})
    >;
typedef $$StoredDocumentPagesTableCreateCompanionBuilder =
    StoredDocumentPagesCompanion Function({
      required String id,
      required String documentId,
      required int pageIndex,
      required String originalImagePath,
      required String normalizedImagePath,
      required String processedImagePath,
      required int originalPixelWidth,
      required int originalPixelHeight,
      required int processedPixelWidth,
      required int processedPixelHeight,
      required double topLeftX,
      required double topLeftY,
      required double topRightX,
      required double topRightY,
      required double bottomRightX,
      required double bottomRightY,
      required double bottomLeftX,
      required double bottomLeftY,
      required String cornersSource,
      Value<double?> cornersConfidence,
      required int rotation,
      required String filter,
      required int brightness,
      required int contrast,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$StoredDocumentPagesTableUpdateCompanionBuilder =
    StoredDocumentPagesCompanion Function({
      Value<String> id,
      Value<String> documentId,
      Value<int> pageIndex,
      Value<String> originalImagePath,
      Value<String> normalizedImagePath,
      Value<String> processedImagePath,
      Value<int> originalPixelWidth,
      Value<int> originalPixelHeight,
      Value<int> processedPixelWidth,
      Value<int> processedPixelHeight,
      Value<double> topLeftX,
      Value<double> topLeftY,
      Value<double> topRightX,
      Value<double> topRightY,
      Value<double> bottomRightX,
      Value<double> bottomRightY,
      Value<double> bottomLeftX,
      Value<double> bottomLeftY,
      Value<String> cornersSource,
      Value<double?> cornersConfidence,
      Value<int> rotation,
      Value<String> filter,
      Value<int> brightness,
      Value<int> contrast,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$StoredDocumentPagesTableReferences
    extends
        BaseReferences<
          _$DocumentDatabase,
          $StoredDocumentPagesTable,
          StoredDocumentPage
        > {
  $$StoredDocumentPagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredDocumentsTable _documentIdTable(_$DocumentDatabase db) => db
      .storedDocuments
      .createAlias('stored_document_pages__document_id__stored_documents__id');

  $$StoredDocumentsTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<String>('document_id')!;

    final manager = $$StoredDocumentsTableTableManager(
      $_db,
      $_db.storedDocuments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoredDocumentPagesTableFilterComposer
    extends Composer<_$DocumentDatabase, $StoredDocumentPagesTable> {
  $$StoredDocumentPagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageIndex => $composableBuilder(
    column: $table.pageIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalImagePath => $composableBuilder(
    column: $table.originalImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedImagePath => $composableBuilder(
    column: $table.normalizedImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processedImagePath => $composableBuilder(
    column: $table.processedImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalPixelWidth => $composableBuilder(
    column: $table.originalPixelWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalPixelHeight => $composableBuilder(
    column: $table.originalPixelHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get processedPixelWidth => $composableBuilder(
    column: $table.processedPixelWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get processedPixelHeight => $composableBuilder(
    column: $table.processedPixelHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get topLeftX => $composableBuilder(
    column: $table.topLeftX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get topLeftY => $composableBuilder(
    column: $table.topLeftY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get topRightX => $composableBuilder(
    column: $table.topRightX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get topRightY => $composableBuilder(
    column: $table.topRightY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bottomRightX => $composableBuilder(
    column: $table.bottomRightX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bottomRightY => $composableBuilder(
    column: $table.bottomRightY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bottomLeftX => $composableBuilder(
    column: $table.bottomLeftX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bottomLeftY => $composableBuilder(
    column: $table.bottomLeftY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cornersSource => $composableBuilder(
    column: $table.cornersSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cornersConfidence => $composableBuilder(
    column: $table.cornersConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filter => $composableBuilder(
    column: $table.filter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contrast => $composableBuilder(
    column: $table.contrast,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredDocumentsTableFilterComposer get documentId {
    final $$StoredDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.storedDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.storedDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredDocumentPagesTableOrderingComposer
    extends Composer<_$DocumentDatabase, $StoredDocumentPagesTable> {
  $$StoredDocumentPagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageIndex => $composableBuilder(
    column: $table.pageIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalImagePath => $composableBuilder(
    column: $table.originalImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedImagePath => $composableBuilder(
    column: $table.normalizedImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processedImagePath => $composableBuilder(
    column: $table.processedImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalPixelWidth => $composableBuilder(
    column: $table.originalPixelWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalPixelHeight => $composableBuilder(
    column: $table.originalPixelHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get processedPixelWidth => $composableBuilder(
    column: $table.processedPixelWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get processedPixelHeight => $composableBuilder(
    column: $table.processedPixelHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get topLeftX => $composableBuilder(
    column: $table.topLeftX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get topLeftY => $composableBuilder(
    column: $table.topLeftY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get topRightX => $composableBuilder(
    column: $table.topRightX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get topRightY => $composableBuilder(
    column: $table.topRightY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bottomRightX => $composableBuilder(
    column: $table.bottomRightX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bottomRightY => $composableBuilder(
    column: $table.bottomRightY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bottomLeftX => $composableBuilder(
    column: $table.bottomLeftX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bottomLeftY => $composableBuilder(
    column: $table.bottomLeftY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cornersSource => $composableBuilder(
    column: $table.cornersSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cornersConfidence => $composableBuilder(
    column: $table.cornersConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filter => $composableBuilder(
    column: $table.filter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contrast => $composableBuilder(
    column: $table.contrast,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredDocumentsTableOrderingComposer get documentId {
    final $$StoredDocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.storedDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredDocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.storedDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredDocumentPagesTableAnnotationComposer
    extends Composer<_$DocumentDatabase, $StoredDocumentPagesTable> {
  $$StoredDocumentPagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get pageIndex =>
      $composableBuilder(column: $table.pageIndex, builder: (column) => column);

  GeneratedColumn<String> get originalImagePath => $composableBuilder(
    column: $table.originalImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalizedImagePath => $composableBuilder(
    column: $table.normalizedImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get processedImagePath => $composableBuilder(
    column: $table.processedImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originalPixelWidth => $composableBuilder(
    column: $table.originalPixelWidth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originalPixelHeight => $composableBuilder(
    column: $table.originalPixelHeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get processedPixelWidth => $composableBuilder(
    column: $table.processedPixelWidth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get processedPixelHeight => $composableBuilder(
    column: $table.processedPixelHeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get topLeftX =>
      $composableBuilder(column: $table.topLeftX, builder: (column) => column);

  GeneratedColumn<double> get topLeftY =>
      $composableBuilder(column: $table.topLeftY, builder: (column) => column);

  GeneratedColumn<double> get topRightX =>
      $composableBuilder(column: $table.topRightX, builder: (column) => column);

  GeneratedColumn<double> get topRightY =>
      $composableBuilder(column: $table.topRightY, builder: (column) => column);

  GeneratedColumn<double> get bottomRightX => $composableBuilder(
    column: $table.bottomRightX,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bottomRightY => $composableBuilder(
    column: $table.bottomRightY,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bottomLeftX => $composableBuilder(
    column: $table.bottomLeftX,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bottomLeftY => $composableBuilder(
    column: $table.bottomLeftY,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cornersSource => $composableBuilder(
    column: $table.cornersSource,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cornersConfidence => $composableBuilder(
    column: $table.cornersConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rotation =>
      $composableBuilder(column: $table.rotation, builder: (column) => column);

  GeneratedColumn<String> get filter =>
      $composableBuilder(column: $table.filter, builder: (column) => column);

  GeneratedColumn<int> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => column,
  );

  GeneratedColumn<int> get contrast =>
      $composableBuilder(column: $table.contrast, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$StoredDocumentsTableAnnotationComposer get documentId {
    final $$StoredDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.storedDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredDocumentPagesTableTableManager
    extends
        RootTableManager<
          _$DocumentDatabase,
          $StoredDocumentPagesTable,
          StoredDocumentPage,
          $$StoredDocumentPagesTableFilterComposer,
          $$StoredDocumentPagesTableOrderingComposer,
          $$StoredDocumentPagesTableAnnotationComposer,
          $$StoredDocumentPagesTableCreateCompanionBuilder,
          $$StoredDocumentPagesTableUpdateCompanionBuilder,
          (StoredDocumentPage, $$StoredDocumentPagesTableReferences),
          StoredDocumentPage,
          PrefetchHooks Function({bool documentId})
        > {
  $$StoredDocumentPagesTableTableManager(
    _$DocumentDatabase db,
    $StoredDocumentPagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredDocumentPagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredDocumentPagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StoredDocumentPagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<int> pageIndex = const Value.absent(),
                Value<String> originalImagePath = const Value.absent(),
                Value<String> normalizedImagePath = const Value.absent(),
                Value<String> processedImagePath = const Value.absent(),
                Value<int> originalPixelWidth = const Value.absent(),
                Value<int> originalPixelHeight = const Value.absent(),
                Value<int> processedPixelWidth = const Value.absent(),
                Value<int> processedPixelHeight = const Value.absent(),
                Value<double> topLeftX = const Value.absent(),
                Value<double> topLeftY = const Value.absent(),
                Value<double> topRightX = const Value.absent(),
                Value<double> topRightY = const Value.absent(),
                Value<double> bottomRightX = const Value.absent(),
                Value<double> bottomRightY = const Value.absent(),
                Value<double> bottomLeftX = const Value.absent(),
                Value<double> bottomLeftY = const Value.absent(),
                Value<String> cornersSource = const Value.absent(),
                Value<double?> cornersConfidence = const Value.absent(),
                Value<int> rotation = const Value.absent(),
                Value<String> filter = const Value.absent(),
                Value<int> brightness = const Value.absent(),
                Value<int> contrast = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredDocumentPagesCompanion(
                id: id,
                documentId: documentId,
                pageIndex: pageIndex,
                originalImagePath: originalImagePath,
                normalizedImagePath: normalizedImagePath,
                processedImagePath: processedImagePath,
                originalPixelWidth: originalPixelWidth,
                originalPixelHeight: originalPixelHeight,
                processedPixelWidth: processedPixelWidth,
                processedPixelHeight: processedPixelHeight,
                topLeftX: topLeftX,
                topLeftY: topLeftY,
                topRightX: topRightX,
                topRightY: topRightY,
                bottomRightX: bottomRightX,
                bottomRightY: bottomRightY,
                bottomLeftX: bottomLeftX,
                bottomLeftY: bottomLeftY,
                cornersSource: cornersSource,
                cornersConfidence: cornersConfidence,
                rotation: rotation,
                filter: filter,
                brightness: brightness,
                contrast: contrast,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String documentId,
                required int pageIndex,
                required String originalImagePath,
                required String normalizedImagePath,
                required String processedImagePath,
                required int originalPixelWidth,
                required int originalPixelHeight,
                required int processedPixelWidth,
                required int processedPixelHeight,
                required double topLeftX,
                required double topLeftY,
                required double topRightX,
                required double topRightY,
                required double bottomRightX,
                required double bottomRightY,
                required double bottomLeftX,
                required double bottomLeftY,
                required String cornersSource,
                Value<double?> cornersConfidence = const Value.absent(),
                required int rotation,
                required String filter,
                required int brightness,
                required int contrast,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StoredDocumentPagesCompanion.insert(
                id: id,
                documentId: documentId,
                pageIndex: pageIndex,
                originalImagePath: originalImagePath,
                normalizedImagePath: normalizedImagePath,
                processedImagePath: processedImagePath,
                originalPixelWidth: originalPixelWidth,
                originalPixelHeight: originalPixelHeight,
                processedPixelWidth: processedPixelWidth,
                processedPixelHeight: processedPixelHeight,
                topLeftX: topLeftX,
                topLeftY: topLeftY,
                topRightX: topRightX,
                topRightY: topRightY,
                bottomRightX: bottomRightX,
                bottomRightY: bottomRightY,
                bottomLeftX: bottomLeftX,
                bottomLeftY: bottomLeftY,
                cornersSource: cornersSource,
                cornersConfidence: cornersConfidence,
                rotation: rotation,
                filter: filter,
                brightness: brightness,
                contrast: contrast,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoredDocumentPagesTable, StoredDocumentPage>(
                    table,
                  ),
                  $$StoredDocumentPagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({documentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (documentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.documentId,
                                referencedTable:
                                    $$StoredDocumentPagesTableReferences
                                        ._documentIdTable(db),
                                referencedColumn:
                                    $$StoredDocumentPagesTableReferences
                                        ._documentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoredDocumentPagesTableProcessedTableManager =
    ProcessedTableManager<
      _$DocumentDatabase,
      $StoredDocumentPagesTable,
      StoredDocumentPage,
      $$StoredDocumentPagesTableFilterComposer,
      $$StoredDocumentPagesTableOrderingComposer,
      $$StoredDocumentPagesTableAnnotationComposer,
      $$StoredDocumentPagesTableCreateCompanionBuilder,
      $$StoredDocumentPagesTableUpdateCompanionBuilder,
      (StoredDocumentPage, $$StoredDocumentPagesTableReferences),
      StoredDocumentPage,
      PrefetchHooks Function({bool documentId})
    >;

class $DocumentDatabaseManager {
  final _$DocumentDatabase _db;
  $DocumentDatabaseManager(this._db);
  $$StoredDocumentsTableTableManager get storedDocuments =>
      $$StoredDocumentsTableTableManager(_db, _db.storedDocuments);
  $$StoredDocumentPagesTableTableManager get storedDocumentPages =>
      $$StoredDocumentPagesTableTableManager(_db, _db.storedDocumentPages);
}
