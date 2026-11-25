// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    displayName,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  /// `guest` or the account JWT subject.
  final String id;

  /// `guest` or `account`.
  final String kind;

  /// Public display name, `null` for the guest profile.
  final String? displayName;

  /// Whether this profile is currently active on the device.
  final bool isActive;

  /// Creation timestamp in UTC milliseconds.
  final int createdAt;
  const ProfileRow({
    required this.id,
    required this.kind,
    this.displayName,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      kind: Value(kind),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'displayName': serializer.toJson<String?>(displayName),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ProfileRow copyWith({
    String? id,
    String? kind,
    Value<String?> displayName = const Value.absent(),
    bool? isActive,
    int? createdAt,
  }) => ProfileRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    displayName: displayName.present ? displayName.value : this.displayName,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('displayName: $displayName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, displayName, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.displayName == this.displayName &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String?> displayName;
  final Value<bool> isActive;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.displayName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    required String kind,
    this.displayName = const Value.absent(),
    this.isActive = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       createdAt = Value(createdAt);
  static Insertable<ProfileRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? displayName,
    Expression<bool>? isActive,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (displayName != null) 'display_name': displayName,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String?>? displayName,
    Value<bool>? isActive,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      displayName: displayName ?? this.displayName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('displayName: $displayName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LevelResultsTable extends LevelResults
    with TableInfo<$LevelResultsTable, LevelResultRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topologyMeta = const VerificationMeta(
    'topology',
  );
  @override
  late final GeneratedColumn<String> topology = GeneratedColumn<String>(
    'topology',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelIdMeta = const VerificationMeta(
    'levelId',
  );
  @override
  late final GeneratedColumn<String> levelId = GeneratedColumn<String>(
    'level_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
    'stars',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeMsMeta = const VerificationMeta('timeMs');
  @override
  late final GeneratedColumn<int> timeMs = GeneratedColumn<int>(
    'time_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _movesMeta = const VerificationMeta('moves');
  @override
  late final GeneratedColumn<int> moves = GeneratedColumn<int>(
    'moves',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<int> achievedAt = GeneratedColumn<int>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pendingMeta = const VerificationMeta(
    'pending',
  );
  @override
  late final GeneratedColumn<bool> pending = GeneratedColumn<bool>(
    'pending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    gameId,
    topology,
    levelId,
    stars,
    timeMs,
    moves,
    score,
    achievedAt,
    pending,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelResultRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('topology')) {
      context.handle(
        _topologyMeta,
        topology.isAcceptableOrUnknown(data['topology']!, _topologyMeta),
      );
    } else if (isInserting) {
      context.missing(_topologyMeta);
    }
    if (data.containsKey('level_id')) {
      context.handle(
        _levelIdMeta,
        levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('stars')) {
      context.handle(
        _starsMeta,
        stars.isAcceptableOrUnknown(data['stars']!, _starsMeta),
      );
    }
    if (data.containsKey('time_ms')) {
      context.handle(
        _timeMsMeta,
        timeMs.isAcceptableOrUnknown(data['time_ms']!, _timeMsMeta),
      );
    }
    if (data.containsKey('moves')) {
      context.handle(
        _movesMeta,
        moves.isAcceptableOrUnknown(data['moves']!, _movesMeta),
      );
    } else if (isInserting) {
      context.missing(_movesMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    if (data.containsKey('pending')) {
      context.handle(
        _pendingMeta,
        pending.isAcceptableOrUnknown(data['pending']!, _pendingMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    profileId,
    gameId,
    topology,
    levelId,
  };
  @override
  LevelResultRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelResultRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      topology: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topology'],
      )!,
      levelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level_id'],
      )!,
      stars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars'],
      ),
      timeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_ms'],
      ),
      moves: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moves'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}achieved_at'],
      )!,
      pending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  $LevelResultsTable createAlias(String alias) {
    return $LevelResultsTable(attachedDatabase, alias);
  }
}

class LevelResultRow extends DataClass implements Insertable<LevelResultRow> {
  /// Owner profile identifier.
  final String profileId;

  /// Variant identifier from the contract.
  final String gameId;

  /// Topology identifier.
  final String topology;

  /// Level identifier (`D-47`).
  final String levelId;

  /// Earned stars (1 to 3), if applicable.
  final int? stars;

  /// Active completion time in milliseconds, if applicable.
  final int? timeMs;

  /// Moves taken to complete the level.
  final int moves;

  /// Score reached in the level, if applicable.
  final int? score;

  /// Timestamp in UTC milliseconds when this attempt was achieved.
  final int achievedAt;

  /// Whether this result has pending changes to sync (D-49).
  final bool pending;

  /// Monotonically incremented local revision counter (D-49).
  final int revision;
  const LevelResultRow({
    required this.profileId,
    required this.gameId,
    required this.topology,
    required this.levelId,
    this.stars,
    this.timeMs,
    required this.moves,
    this.score,
    required this.achievedAt,
    required this.pending,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['game_id'] = Variable<String>(gameId);
    map['topology'] = Variable<String>(topology);
    map['level_id'] = Variable<String>(levelId);
    if (!nullToAbsent || stars != null) {
      map['stars'] = Variable<int>(stars);
    }
    if (!nullToAbsent || timeMs != null) {
      map['time_ms'] = Variable<int>(timeMs);
    }
    map['moves'] = Variable<int>(moves);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    map['achieved_at'] = Variable<int>(achievedAt);
    map['pending'] = Variable<bool>(pending);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  LevelResultsCompanion toCompanion(bool nullToAbsent) {
    return LevelResultsCompanion(
      profileId: Value(profileId),
      gameId: Value(gameId),
      topology: Value(topology),
      levelId: Value(levelId),
      stars: stars == null && nullToAbsent
          ? const Value.absent()
          : Value(stars),
      timeMs: timeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(timeMs),
      moves: Value(moves),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      achievedAt: Value(achievedAt),
      pending: Value(pending),
      revision: Value(revision),
    );
  }

  factory LevelResultRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelResultRow(
      profileId: serializer.fromJson<String>(json['profileId']),
      gameId: serializer.fromJson<String>(json['gameId']),
      topology: serializer.fromJson<String>(json['topology']),
      levelId: serializer.fromJson<String>(json['levelId']),
      stars: serializer.fromJson<int?>(json['stars']),
      timeMs: serializer.fromJson<int?>(json['timeMs']),
      moves: serializer.fromJson<int>(json['moves']),
      score: serializer.fromJson<int?>(json['score']),
      achievedAt: serializer.fromJson<int>(json['achievedAt']),
      pending: serializer.fromJson<bool>(json['pending']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'gameId': serializer.toJson<String>(gameId),
      'topology': serializer.toJson<String>(topology),
      'levelId': serializer.toJson<String>(levelId),
      'stars': serializer.toJson<int?>(stars),
      'timeMs': serializer.toJson<int?>(timeMs),
      'moves': serializer.toJson<int>(moves),
      'score': serializer.toJson<int?>(score),
      'achievedAt': serializer.toJson<int>(achievedAt),
      'pending': serializer.toJson<bool>(pending),
      'revision': serializer.toJson<int>(revision),
    };
  }

  LevelResultRow copyWith({
    String? profileId,
    String? gameId,
    String? topology,
    String? levelId,
    Value<int?> stars = const Value.absent(),
    Value<int?> timeMs = const Value.absent(),
    int? moves,
    Value<int?> score = const Value.absent(),
    int? achievedAt,
    bool? pending,
    int? revision,
  }) => LevelResultRow(
    profileId: profileId ?? this.profileId,
    gameId: gameId ?? this.gameId,
    topology: topology ?? this.topology,
    levelId: levelId ?? this.levelId,
    stars: stars.present ? stars.value : this.stars,
    timeMs: timeMs.present ? timeMs.value : this.timeMs,
    moves: moves ?? this.moves,
    score: score.present ? score.value : this.score,
    achievedAt: achievedAt ?? this.achievedAt,
    pending: pending ?? this.pending,
    revision: revision ?? this.revision,
  );
  LevelResultRow copyWithCompanion(LevelResultsCompanion data) {
    return LevelResultRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      topology: data.topology.present ? data.topology.value : this.topology,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      stars: data.stars.present ? data.stars.value : this.stars,
      timeMs: data.timeMs.present ? data.timeMs.value : this.timeMs,
      moves: data.moves.present ? data.moves.value : this.moves,
      score: data.score.present ? data.score.value : this.score,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
      pending: data.pending.present ? data.pending.value : this.pending,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelResultRow(')
          ..write('profileId: $profileId, ')
          ..write('gameId: $gameId, ')
          ..write('topology: $topology, ')
          ..write('levelId: $levelId, ')
          ..write('stars: $stars, ')
          ..write('timeMs: $timeMs, ')
          ..write('moves: $moves, ')
          ..write('score: $score, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('pending: $pending, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    gameId,
    topology,
    levelId,
    stars,
    timeMs,
    moves,
    score,
    achievedAt,
    pending,
    revision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelResultRow &&
          other.profileId == this.profileId &&
          other.gameId == this.gameId &&
          other.topology == this.topology &&
          other.levelId == this.levelId &&
          other.stars == this.stars &&
          other.timeMs == this.timeMs &&
          other.moves == this.moves &&
          other.score == this.score &&
          other.achievedAt == this.achievedAt &&
          other.pending == this.pending &&
          other.revision == this.revision);
}

class LevelResultsCompanion extends UpdateCompanion<LevelResultRow> {
  final Value<String> profileId;
  final Value<String> gameId;
  final Value<String> topology;
  final Value<String> levelId;
  final Value<int?> stars;
  final Value<int?> timeMs;
  final Value<int> moves;
  final Value<int?> score;
  final Value<int> achievedAt;
  final Value<bool> pending;
  final Value<int> revision;
  final Value<int> rowid;
  const LevelResultsCompanion({
    this.profileId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.topology = const Value.absent(),
    this.levelId = const Value.absent(),
    this.stars = const Value.absent(),
    this.timeMs = const Value.absent(),
    this.moves = const Value.absent(),
    this.score = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.pending = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LevelResultsCompanion.insert({
    required String profileId,
    required String gameId,
    required String topology,
    required String levelId,
    this.stars = const Value.absent(),
    this.timeMs = const Value.absent(),
    required int moves,
    this.score = const Value.absent(),
    required int achievedAt,
    this.pending = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       gameId = Value(gameId),
       topology = Value(topology),
       levelId = Value(levelId),
       moves = Value(moves),
       achievedAt = Value(achievedAt);
  static Insertable<LevelResultRow> custom({
    Expression<String>? profileId,
    Expression<String>? gameId,
    Expression<String>? topology,
    Expression<String>? levelId,
    Expression<int>? stars,
    Expression<int>? timeMs,
    Expression<int>? moves,
    Expression<int>? score,
    Expression<int>? achievedAt,
    Expression<bool>? pending,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (gameId != null) 'game_id': gameId,
      if (topology != null) 'topology': topology,
      if (levelId != null) 'level_id': levelId,
      if (stars != null) 'stars': stars,
      if (timeMs != null) 'time_ms': timeMs,
      if (moves != null) 'moves': moves,
      if (score != null) 'score': score,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (pending != null) 'pending': pending,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LevelResultsCompanion copyWith({
    Value<String>? profileId,
    Value<String>? gameId,
    Value<String>? topology,
    Value<String>? levelId,
    Value<int?>? stars,
    Value<int?>? timeMs,
    Value<int>? moves,
    Value<int?>? score,
    Value<int>? achievedAt,
    Value<bool>? pending,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return LevelResultsCompanion(
      profileId: profileId ?? this.profileId,
      gameId: gameId ?? this.gameId,
      topology: topology ?? this.topology,
      levelId: levelId ?? this.levelId,
      stars: stars ?? this.stars,
      timeMs: timeMs ?? this.timeMs,
      moves: moves ?? this.moves,
      score: score ?? this.score,
      achievedAt: achievedAt ?? this.achievedAt,
      pending: pending ?? this.pending,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (topology.present) {
      map['topology'] = Variable<String>(topology.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<String>(levelId.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (timeMs.present) {
      map['time_ms'] = Variable<int>(timeMs.value);
    }
    if (moves.present) {
      map['moves'] = Variable<int>(moves.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<int>(achievedAt.value);
    }
    if (pending.present) {
      map['pending'] = Variable<bool>(pending.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelResultsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('gameId: $gameId, ')
          ..write('topology: $topology, ')
          ..write('levelId: $levelId, ')
          ..write('stars: $stars, ')
          ..write('timeMs: $timeMs, ')
          ..write('moves: $moves, ')
          ..write('score: $score, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('pending: $pending, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecordsTable extends Records with TableInfo<$RecordsTable, RecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topologyMeta = const VerificationMeta(
    'topology',
  );
  @override
  late final GeneratedColumn<String> topology = GeneratedColumn<String>(
    'topology',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<int> achievedAt = GeneratedColumn<int>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pendingMeta = const VerificationMeta(
    'pending',
  );
  @override
  late final GeneratedColumn<bool> pending = GeneratedColumn<bool>(
    'pending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    gameId,
    topology,
    score,
    achievedAt,
    pending,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'records';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('topology')) {
      context.handle(
        _topologyMeta,
        topology.isAcceptableOrUnknown(data['topology']!, _topologyMeta),
      );
    } else if (isInserting) {
      context.missing(_topologyMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    if (data.containsKey('pending')) {
      context.handle(
        _pendingMeta,
        pending.isAcceptableOrUnknown(data['pending']!, _pendingMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, gameId, topology};
  @override
  RecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      topology: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topology'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}achieved_at'],
      )!,
      pending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  $RecordsTable createAlias(String alias) {
    return $RecordsTable(attachedDatabase, alias);
  }
}

class RecordRow extends DataClass implements Insertable<RecordRow> {
  /// Owner profile identifier.
  final String profileId;

  /// Variant identifier from the contract.
  final String gameId;

  /// Topology identifier.
  final String topology;

  /// Best score achieved.
  final int score;

  /// Timestamp in UTC milliseconds when the record was achieved.
  final int achievedAt;

  /// Whether this record has pending changes to sync (D-49).
  final bool pending;

  /// Monotonically incremented local revision counter (D-49).
  final int revision;
  const RecordRow({
    required this.profileId,
    required this.gameId,
    required this.topology,
    required this.score,
    required this.achievedAt,
    required this.pending,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['game_id'] = Variable<String>(gameId);
    map['topology'] = Variable<String>(topology);
    map['score'] = Variable<int>(score);
    map['achieved_at'] = Variable<int>(achievedAt);
    map['pending'] = Variable<bool>(pending);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  RecordsCompanion toCompanion(bool nullToAbsent) {
    return RecordsCompanion(
      profileId: Value(profileId),
      gameId: Value(gameId),
      topology: Value(topology),
      score: Value(score),
      achievedAt: Value(achievedAt),
      pending: Value(pending),
      revision: Value(revision),
    );
  }

  factory RecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordRow(
      profileId: serializer.fromJson<String>(json['profileId']),
      gameId: serializer.fromJson<String>(json['gameId']),
      topology: serializer.fromJson<String>(json['topology']),
      score: serializer.fromJson<int>(json['score']),
      achievedAt: serializer.fromJson<int>(json['achievedAt']),
      pending: serializer.fromJson<bool>(json['pending']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'gameId': serializer.toJson<String>(gameId),
      'topology': serializer.toJson<String>(topology),
      'score': serializer.toJson<int>(score),
      'achievedAt': serializer.toJson<int>(achievedAt),
      'pending': serializer.toJson<bool>(pending),
      'revision': serializer.toJson<int>(revision),
    };
  }

  RecordRow copyWith({
    String? profileId,
    String? gameId,
    String? topology,
    int? score,
    int? achievedAt,
    bool? pending,
    int? revision,
  }) => RecordRow(
    profileId: profileId ?? this.profileId,
    gameId: gameId ?? this.gameId,
    topology: topology ?? this.topology,
    score: score ?? this.score,
    achievedAt: achievedAt ?? this.achievedAt,
    pending: pending ?? this.pending,
    revision: revision ?? this.revision,
  );
  RecordRow copyWithCompanion(RecordsCompanion data) {
    return RecordRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      topology: data.topology.present ? data.topology.value : this.topology,
      score: data.score.present ? data.score.value : this.score,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
      pending: data.pending.present ? data.pending.value : this.pending,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordRow(')
          ..write('profileId: $profileId, ')
          ..write('gameId: $gameId, ')
          ..write('topology: $topology, ')
          ..write('score: $score, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('pending: $pending, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    gameId,
    topology,
    score,
    achievedAt,
    pending,
    revision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordRow &&
          other.profileId == this.profileId &&
          other.gameId == this.gameId &&
          other.topology == this.topology &&
          other.score == this.score &&
          other.achievedAt == this.achievedAt &&
          other.pending == this.pending &&
          other.revision == this.revision);
}

class RecordsCompanion extends UpdateCompanion<RecordRow> {
  final Value<String> profileId;
  final Value<String> gameId;
  final Value<String> topology;
  final Value<int> score;
  final Value<int> achievedAt;
  final Value<bool> pending;
  final Value<int> revision;
  final Value<int> rowid;
  const RecordsCompanion({
    this.profileId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.topology = const Value.absent(),
    this.score = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.pending = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordsCompanion.insert({
    required String profileId,
    required String gameId,
    required String topology,
    required int score,
    required int achievedAt,
    this.pending = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       gameId = Value(gameId),
       topology = Value(topology),
       score = Value(score),
       achievedAt = Value(achievedAt);
  static Insertable<RecordRow> custom({
    Expression<String>? profileId,
    Expression<String>? gameId,
    Expression<String>? topology,
    Expression<int>? score,
    Expression<int>? achievedAt,
    Expression<bool>? pending,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (gameId != null) 'game_id': gameId,
      if (topology != null) 'topology': topology,
      if (score != null) 'score': score,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (pending != null) 'pending': pending,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordsCompanion copyWith({
    Value<String>? profileId,
    Value<String>? gameId,
    Value<String>? topology,
    Value<int>? score,
    Value<int>? achievedAt,
    Value<bool>? pending,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return RecordsCompanion(
      profileId: profileId ?? this.profileId,
      gameId: gameId ?? this.gameId,
      topology: topology ?? this.topology,
      score: score ?? this.score,
      achievedAt: achievedAt ?? this.achievedAt,
      pending: pending ?? this.pending,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (topology.present) {
      map['topology'] = Variable<String>(topology.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<int>(achievedAt.value);
    }
    if (pending.present) {
      map['pending'] = Variable<bool>(pending.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('gameId: $gameId, ')
          ..write('topology: $topology, ')
          ..write('score: $score, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('pending: $pending, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedGamesTable extends SavedGames
    with TableInfo<$SavedGamesTable, SavedGameRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedGamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topologyMeta = const VerificationMeta(
    'topology',
  );
  @override
  late final GeneratedColumn<String> topology = GeneratedColumn<String>(
    'topology',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateJsonMeta = const VerificationMeta(
    'stateJson',
  );
  @override
  late final GeneratedColumn<String> stateJson = GeneratedColumn<String>(
    'state_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codecVersionMeta = const VerificationMeta(
    'codecVersion',
  );
  @override
  late final GeneratedColumn<int> codecVersion = GeneratedColumn<int>(
    'codec_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<int> savedAt = GeneratedColumn<int>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    gameId,
    topology,
    stateJson,
    codecVersion,
    savedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_games';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedGameRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('topology')) {
      context.handle(
        _topologyMeta,
        topology.isAcceptableOrUnknown(data['topology']!, _topologyMeta),
      );
    } else if (isInserting) {
      context.missing(_topologyMeta);
    }
    if (data.containsKey('state_json')) {
      context.handle(
        _stateJsonMeta,
        stateJson.isAcceptableOrUnknown(data['state_json']!, _stateJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_stateJsonMeta);
    }
    if (data.containsKey('codec_version')) {
      context.handle(
        _codecVersionMeta,
        codecVersion.isAcceptableOrUnknown(
          data['codec_version']!,
          _codecVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_codecVersionMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, gameId, topology};
  @override
  SavedGameRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedGameRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      topology: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topology'],
      )!,
      stateJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_json'],
      )!,
      codecVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}codec_version'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $SavedGamesTable createAlias(String alias) {
    return $SavedGamesTable(attachedDatabase, alias);
  }
}

class SavedGameRow extends DataClass implements Insertable<SavedGameRow> {
  /// Owner profile identifier.
  final String profileId;

  /// Variant identifier from the contract.
  final String gameId;

  /// Topology identifier.
  final String topology;

  /// Serialized state, generator, undo history and active time (`D-37`).
  final String stateJson;

  /// Codec version used to encode [stateJson].
  final int codecVersion;

  /// Timestamp in UTC milliseconds when the snapshot was written.
  final int savedAt;
  const SavedGameRow({
    required this.profileId,
    required this.gameId,
    required this.topology,
    required this.stateJson,
    required this.codecVersion,
    required this.savedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['game_id'] = Variable<String>(gameId);
    map['topology'] = Variable<String>(topology);
    map['state_json'] = Variable<String>(stateJson);
    map['codec_version'] = Variable<int>(codecVersion);
    map['saved_at'] = Variable<int>(savedAt);
    return map;
  }

  SavedGamesCompanion toCompanion(bool nullToAbsent) {
    return SavedGamesCompanion(
      profileId: Value(profileId),
      gameId: Value(gameId),
      topology: Value(topology),
      stateJson: Value(stateJson),
      codecVersion: Value(codecVersion),
      savedAt: Value(savedAt),
    );
  }

  factory SavedGameRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedGameRow(
      profileId: serializer.fromJson<String>(json['profileId']),
      gameId: serializer.fromJson<String>(json['gameId']),
      topology: serializer.fromJson<String>(json['topology']),
      stateJson: serializer.fromJson<String>(json['stateJson']),
      codecVersion: serializer.fromJson<int>(json['codecVersion']),
      savedAt: serializer.fromJson<int>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'gameId': serializer.toJson<String>(gameId),
      'topology': serializer.toJson<String>(topology),
      'stateJson': serializer.toJson<String>(stateJson),
      'codecVersion': serializer.toJson<int>(codecVersion),
      'savedAt': serializer.toJson<int>(savedAt),
    };
  }

  SavedGameRow copyWith({
    String? profileId,
    String? gameId,
    String? topology,
    String? stateJson,
    int? codecVersion,
    int? savedAt,
  }) => SavedGameRow(
    profileId: profileId ?? this.profileId,
    gameId: gameId ?? this.gameId,
    topology: topology ?? this.topology,
    stateJson: stateJson ?? this.stateJson,
    codecVersion: codecVersion ?? this.codecVersion,
    savedAt: savedAt ?? this.savedAt,
  );
  SavedGameRow copyWithCompanion(SavedGamesCompanion data) {
    return SavedGameRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      topology: data.topology.present ? data.topology.value : this.topology,
      stateJson: data.stateJson.present ? data.stateJson.value : this.stateJson,
      codecVersion: data.codecVersion.present
          ? data.codecVersion.value
          : this.codecVersion,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedGameRow(')
          ..write('profileId: $profileId, ')
          ..write('gameId: $gameId, ')
          ..write('topology: $topology, ')
          ..write('stateJson: $stateJson, ')
          ..write('codecVersion: $codecVersion, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    gameId,
    topology,
    stateJson,
    codecVersion,
    savedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedGameRow &&
          other.profileId == this.profileId &&
          other.gameId == this.gameId &&
          other.topology == this.topology &&
          other.stateJson == this.stateJson &&
          other.codecVersion == this.codecVersion &&
          other.savedAt == this.savedAt);
}

class SavedGamesCompanion extends UpdateCompanion<SavedGameRow> {
  final Value<String> profileId;
  final Value<String> gameId;
  final Value<String> topology;
  final Value<String> stateJson;
  final Value<int> codecVersion;
  final Value<int> savedAt;
  final Value<int> rowid;
  const SavedGamesCompanion({
    this.profileId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.topology = const Value.absent(),
    this.stateJson = const Value.absent(),
    this.codecVersion = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedGamesCompanion.insert({
    required String profileId,
    required String gameId,
    required String topology,
    required String stateJson,
    required int codecVersion,
    required int savedAt,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       gameId = Value(gameId),
       topology = Value(topology),
       stateJson = Value(stateJson),
       codecVersion = Value(codecVersion),
       savedAt = Value(savedAt);
  static Insertable<SavedGameRow> custom({
    Expression<String>? profileId,
    Expression<String>? gameId,
    Expression<String>? topology,
    Expression<String>? stateJson,
    Expression<int>? codecVersion,
    Expression<int>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (gameId != null) 'game_id': gameId,
      if (topology != null) 'topology': topology,
      if (stateJson != null) 'state_json': stateJson,
      if (codecVersion != null) 'codec_version': codecVersion,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedGamesCompanion copyWith({
    Value<String>? profileId,
    Value<String>? gameId,
    Value<String>? topology,
    Value<String>? stateJson,
    Value<int>? codecVersion,
    Value<int>? savedAt,
    Value<int>? rowid,
  }) {
    return SavedGamesCompanion(
      profileId: profileId ?? this.profileId,
      gameId: gameId ?? this.gameId,
      topology: topology ?? this.topology,
      stateJson: stateJson ?? this.stateJson,
      codecVersion: codecVersion ?? this.codecVersion,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (topology.present) {
      map['topology'] = Variable<String>(topology.value);
    }
    if (stateJson.present) {
      map['state_json'] = Variable<String>(stateJson.value);
    }
    if (codecVersion.present) {
      map['codec_version'] = Variable<int>(codecVersion.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<int>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedGamesCompanion(')
          ..write('profileId: $profileId, ')
          ..write('gameId: $gameId, ')
          ..write('topology: $topology, ')
          ..write('stateJson: $stateJson, ')
          ..write('codecVersion: $codecVersion, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadedLevelsTable extends DownloadedLevels
    with TableInfo<$DownloadedLevelsTable, DownloadedLevelRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topologyMeta = const VerificationMeta(
    'topology',
  );
  @override
  late final GeneratedColumn<String> topology = GeneratedColumn<String>(
    'topology',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<int> downloadedAt = GeneratedColumn<int>(
    'downloaded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    topology,
    order,
    version,
    json,
    downloadedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_levels';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadedLevelRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('topology')) {
      context.handle(
        _topologyMeta,
        topology.isAcceptableOrUnknown(data['topology']!, _topologyMeta),
      );
    } else if (isInserting) {
      context.missing(_topologyMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
        _downloadedAtMeta,
        downloadedAt.isAcceptableOrUnknown(
          data['downloaded_at']!,
          _downloadedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadedLevelRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadedLevelRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      topology: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topology'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      downloadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downloaded_at'],
      )!,
    );
  }

  @override
  $DownloadedLevelsTable createAlias(String alias) {
    return $DownloadedLevelsTable(attachedDatabase, alias);
  }
}

class DownloadedLevelRow extends DataClass
    implements Insertable<DownloadedLevelRow> {
  /// Level identifier (`D-47`).
  final String id;

  /// Variant identifier from the contract.
  final String gameId;

  /// Topology identifier or `any`.
  final String topology;

  /// Display order within the level list.
  final int order;

  /// Level definition version.
  final int version;

  /// Complete validated level JSON.
  final String json;

  /// Timestamp in UTC milliseconds when the level was cached.
  final int downloadedAt;
  const DownloadedLevelRow({
    required this.id,
    required this.gameId,
    required this.topology,
    required this.order,
    required this.version,
    required this.json,
    required this.downloadedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['topology'] = Variable<String>(topology);
    map['order'] = Variable<int>(order);
    map['version'] = Variable<int>(version);
    map['json'] = Variable<String>(json);
    map['downloaded_at'] = Variable<int>(downloadedAt);
    return map;
  }

  DownloadedLevelsCompanion toCompanion(bool nullToAbsent) {
    return DownloadedLevelsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      topology: Value(topology),
      order: Value(order),
      version: Value(version),
      json: Value(json),
      downloadedAt: Value(downloadedAt),
    );
  }

  factory DownloadedLevelRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadedLevelRow(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      topology: serializer.fromJson<String>(json['topology']),
      order: serializer.fromJson<int>(json['order']),
      version: serializer.fromJson<int>(json['version']),
      json: serializer.fromJson<String>(json['json']),
      downloadedAt: serializer.fromJson<int>(json['downloadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'topology': serializer.toJson<String>(topology),
      'order': serializer.toJson<int>(order),
      'version': serializer.toJson<int>(version),
      'json': serializer.toJson<String>(json),
      'downloadedAt': serializer.toJson<int>(downloadedAt),
    };
  }

  DownloadedLevelRow copyWith({
    String? id,
    String? gameId,
    String? topology,
    int? order,
    int? version,
    String? json,
    int? downloadedAt,
  }) => DownloadedLevelRow(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    topology: topology ?? this.topology,
    order: order ?? this.order,
    version: version ?? this.version,
    json: json ?? this.json,
    downloadedAt: downloadedAt ?? this.downloadedAt,
  );
  DownloadedLevelRow copyWithCompanion(DownloadedLevelsCompanion data) {
    return DownloadedLevelRow(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      topology: data.topology.present ? data.topology.value : this.topology,
      order: data.order.present ? data.order.value : this.order,
      version: data.version.present ? data.version.value : this.version,
      json: data.json.present ? data.json.value : this.json,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedLevelRow(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('topology: $topology, ')
          ..write('order: $order, ')
          ..write('version: $version, ')
          ..write('json: $json, ')
          ..write('downloadedAt: $downloadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gameId, topology, order, version, json, downloadedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedLevelRow &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.topology == this.topology &&
          other.order == this.order &&
          other.version == this.version &&
          other.json == this.json &&
          other.downloadedAt == this.downloadedAt);
}

class DownloadedLevelsCompanion extends UpdateCompanion<DownloadedLevelRow> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<String> topology;
  final Value<int> order;
  final Value<int> version;
  final Value<String> json;
  final Value<int> downloadedAt;
  final Value<int> rowid;
  const DownloadedLevelsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.topology = const Value.absent(),
    this.order = const Value.absent(),
    this.version = const Value.absent(),
    this.json = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadedLevelsCompanion.insert({
    required String id,
    required String gameId,
    required String topology,
    required int order,
    required int version,
    required String json,
    required int downloadedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       topology = Value(topology),
       order = Value(order),
       version = Value(version),
       json = Value(json),
       downloadedAt = Value(downloadedAt);
  static Insertable<DownloadedLevelRow> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<String>? topology,
    Expression<int>? order,
    Expression<int>? version,
    Expression<String>? json,
    Expression<int>? downloadedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (topology != null) 'topology': topology,
      if (order != null) 'order': order,
      if (version != null) 'version': version,
      if (json != null) 'json': json,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadedLevelsCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<String>? topology,
    Value<int>? order,
    Value<int>? version,
    Value<String>? json,
    Value<int>? downloadedAt,
    Value<int>? rowid,
  }) {
    return DownloadedLevelsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      topology: topology ?? this.topology,
      order: order ?? this.order,
      version: version ?? this.version,
      json: json ?? this.json,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (topology.present) {
      map['topology'] = Variable<String>(topology.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<int>(downloadedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedLevelsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('topology: $topology, ')
          ..write('order: $order, ')
          ..write('version: $version, ')
          ..write('json: $json, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LevelSyncCursorsTable extends LevelSyncCursors
    with TableInfo<$LevelSyncCursorsTable, LevelSyncCursorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelSyncCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topologyMeta = const VerificationMeta(
    'topology',
  );
  @override
  late final GeneratedColumn<String> topology = GeneratedColumn<String>(
    'topology',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<String> cursor = GeneratedColumn<String>(
    'cursor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [gameId, topology, cursor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelSyncCursorRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('topology')) {
      context.handle(
        _topologyMeta,
        topology.isAcceptableOrUnknown(data['topology']!, _topologyMeta),
      );
    } else if (isInserting) {
      context.missing(_topologyMeta);
    }
    if (data.containsKey('cursor')) {
      context.handle(
        _cursorMeta,
        cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta),
      );
    } else if (isInserting) {
      context.missing(_cursorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gameId, topology};
  @override
  LevelSyncCursorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelSyncCursorRow(
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      topology: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topology'],
      )!,
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cursor'],
      )!,
    );
  }

  @override
  $LevelSyncCursorsTable createAlias(String alias) {
    return $LevelSyncCursorsTable(attachedDatabase, alias);
  }
}

class LevelSyncCursorRow extends DataClass
    implements Insertable<LevelSyncCursorRow> {
  /// Variant identifier from the contract.
  final String gameId;

  /// Topology identifier.
  final String topology;

  /// `nextCursor` returned by the API.
  final String cursor;
  const LevelSyncCursorRow({
    required this.gameId,
    required this.topology,
    required this.cursor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_id'] = Variable<String>(gameId);
    map['topology'] = Variable<String>(topology);
    map['cursor'] = Variable<String>(cursor);
    return map;
  }

  LevelSyncCursorsCompanion toCompanion(bool nullToAbsent) {
    return LevelSyncCursorsCompanion(
      gameId: Value(gameId),
      topology: Value(topology),
      cursor: Value(cursor),
    );
  }

  factory LevelSyncCursorRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelSyncCursorRow(
      gameId: serializer.fromJson<String>(json['gameId']),
      topology: serializer.fromJson<String>(json['topology']),
      cursor: serializer.fromJson<String>(json['cursor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameId': serializer.toJson<String>(gameId),
      'topology': serializer.toJson<String>(topology),
      'cursor': serializer.toJson<String>(cursor),
    };
  }

  LevelSyncCursorRow copyWith({
    String? gameId,
    String? topology,
    String? cursor,
  }) => LevelSyncCursorRow(
    gameId: gameId ?? this.gameId,
    topology: topology ?? this.topology,
    cursor: cursor ?? this.cursor,
  );
  LevelSyncCursorRow copyWithCompanion(LevelSyncCursorsCompanion data) {
    return LevelSyncCursorRow(
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      topology: data.topology.present ? data.topology.value : this.topology,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelSyncCursorRow(')
          ..write('gameId: $gameId, ')
          ..write('topology: $topology, ')
          ..write('cursor: $cursor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gameId, topology, cursor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelSyncCursorRow &&
          other.gameId == this.gameId &&
          other.topology == this.topology &&
          other.cursor == this.cursor);
}

class LevelSyncCursorsCompanion extends UpdateCompanion<LevelSyncCursorRow> {
  final Value<String> gameId;
  final Value<String> topology;
  final Value<String> cursor;
  final Value<int> rowid;
  const LevelSyncCursorsCompanion({
    this.gameId = const Value.absent(),
    this.topology = const Value.absent(),
    this.cursor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LevelSyncCursorsCompanion.insert({
    required String gameId,
    required String topology,
    required String cursor,
    this.rowid = const Value.absent(),
  }) : gameId = Value(gameId),
       topology = Value(topology),
       cursor = Value(cursor);
  static Insertable<LevelSyncCursorRow> custom({
    Expression<String>? gameId,
    Expression<String>? topology,
    Expression<String>? cursor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gameId != null) 'game_id': gameId,
      if (topology != null) 'topology': topology,
      if (cursor != null) 'cursor': cursor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LevelSyncCursorsCompanion copyWith({
    Value<String>? gameId,
    Value<String>? topology,
    Value<String>? cursor,
    Value<int>? rowid,
  }) {
    return LevelSyncCursorsCompanion(
      gameId: gameId ?? this.gameId,
      topology: topology ?? this.topology,
      cursor: cursor ?? this.cursor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (topology.present) {
      map['topology'] = Variable<String>(topology.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<String>(cursor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelSyncCursorsCompanion(')
          ..write('gameId: $gameId, ')
          ..write('topology: $topology, ')
          ..write('cursor: $cursor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $LevelResultsTable levelResults = $LevelResultsTable(this);
  late final $RecordsTable records = $RecordsTable(this);
  late final $SavedGamesTable savedGames = $SavedGamesTable(this);
  late final $DownloadedLevelsTable downloadedLevels = $DownloadedLevelsTable(
    this,
  );
  late final $LevelSyncCursorsTable levelSyncCursors = $LevelSyncCursorsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    levelResults,
    records,
    savedGames,
    downloadedLevels,
    levelSyncCursors,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('level_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('records', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('saved_games', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String id,
  required String kind,
  Value<String?> displayName,
  Value<bool> isActive,
  required int createdAt,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<String> kind,
  Value<String?> displayName,
  Value<bool> isActive,
  Value<int> createdAt,
  Value<int> rowid,
});

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LevelResultsTable, List<LevelResultRow>>
  _levelResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.levelResults,
    aliasName: 'profiles__id__level_results__profile_id',
  );

  $$LevelResultsTableProcessedTableManager get levelResultsRefs {
    final manager = $$LevelResultsTableTableManager(
      $_db,
      $_db.levelResults,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_levelResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecordsTable, List<RecordRow>> _recordsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.records,
    aliasName: 'profiles__id__records__profile_id',
  );

  $$RecordsTableProcessedTableManager get recordsRefs {
    final manager = $$RecordsTableTableManager(
      $_db,
      $_db.records,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SavedGamesTable, List<SavedGameRow>>
  _savedGamesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.savedGames,
    aliasName: 'profiles__id__saved_games__profile_id',
  );

  $$SavedGamesTableProcessedTableManager get savedGamesRefs {
    final manager = $$SavedGamesTableTableManager(
      $_db,
      $_db.savedGames,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_savedGamesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> levelResultsRefs(
    Expression<bool> Function($$LevelResultsTableFilterComposer f) f,
  ) {
    final $$LevelResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.levelResults,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelResultsTableFilterComposer(
            $db: $db,
            $table: $db.levelResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recordsRefs(
    Expression<bool> Function($$RecordsTableFilterComposer f) f,
  ) {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> savedGamesRefs(
    Expression<bool> Function($$SavedGamesTableFilterComposer f) f,
  ) {
    final $$SavedGamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savedGames,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedGamesTableFilterComposer(
            $db: $db,
            $table: $db.savedGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> levelResultsRefs<T extends Object>(
    Expression<T> Function($$LevelResultsTableAnnotationComposer a) f,
  ) {
    final $$LevelResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.levelResults,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.levelResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recordsRefs<T extends Object>(
    Expression<T> Function($$RecordsTableAnnotationComposer a) f,
  ) {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> savedGamesRefs<T extends Object>(
    Expression<T> Function($$SavedGamesTableAnnotationComposer a) f,
  ) {
    final $$SavedGamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savedGames,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedGamesTableAnnotationComposer(
            $db: $db,
            $table: $db.savedGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (ProfileRow, $$ProfilesTableReferences),
          ProfileRow,
          PrefetchHooks Function({
            bool levelResultsRefs,
            bool recordsRefs,
            bool savedGamesRefs,
          })
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                kind: kind,
                displayName: displayName,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                Value<String?> displayName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                kind: kind,
                displayName: displayName,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, ProfileRow>(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                levelResultsRefs = false,
                recordsRefs = false,
                savedGamesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (levelResultsRefs) db.levelResults,
                    if (recordsRefs) db.records,
                    if (savedGamesRefs) db.savedGames,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (levelResultsRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          LevelResultRow,
                          $LevelResultsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._levelResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).levelResultsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (recordsRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          RecordRow,
                          $RecordsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._recordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).recordsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (savedGamesRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          SavedGameRow,
                          $SavedGamesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._savedGamesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).savedGamesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, $$ProfilesTableReferences),
      ProfileRow,
      PrefetchHooks Function({
        bool levelResultsRefs,
        bool recordsRefs,
        bool savedGamesRefs,
      })
    >;
typedef $$LevelResultsTableCreateCompanionBuilder =
    LevelResultsCompanion Function({
      required String profileId,
      required String gameId,
      required String topology,
      required String levelId,
      Value<int?> stars,
      Value<int?> timeMs,
      required int moves,
      Value<int?> score,
      required int achievedAt,
      Value<bool> pending,
      Value<int> revision,
      Value<int> rowid,
    });
typedef $$LevelResultsTableUpdateCompanionBuilder =
    LevelResultsCompanion Function({
      Value<String> profileId,
      Value<String> gameId,
      Value<String> topology,
      Value<String> levelId,
      Value<int?> stars,
      Value<int?> timeMs,
      Value<int> moves,
      Value<int?> score,
      Value<int> achievedAt,
      Value<bool> pending,
      Value<int> revision,
      Value<int> rowid,
    });

final class $$LevelResultsTableReferences
    extends BaseReferences<_$AppDatabase, $LevelResultsTable, LevelResultRow> {
  $$LevelResultsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('level_results__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LevelResultsTableFilterComposer
    extends Composer<_$AppDatabase, $LevelResultsTable> {
  $$LevelResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topology => $composableBuilder(
    column: $table.topology,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeMs => $composableBuilder(
    column: $table.timeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moves => $composableBuilder(
    column: $table.moves,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pending => $composableBuilder(
    column: $table.pending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LevelResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelResultsTable> {
  $$LevelResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topology => $composableBuilder(
    column: $table.topology,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeMs => $composableBuilder(
    column: $table.timeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moves => $composableBuilder(
    column: $table.moves,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pending => $composableBuilder(
    column: $table.pending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LevelResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelResultsTable> {
  $$LevelResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get topology =>
      $composableBuilder(column: $table.topology, builder: (column) => column);

  GeneratedColumn<String> get levelId =>
      $composableBuilder(column: $table.levelId, builder: (column) => column);

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<int> get timeMs =>
      $composableBuilder(column: $table.timeMs, builder: (column) => column);

  GeneratedColumn<int> get moves =>
      $composableBuilder(column: $table.moves, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pending =>
      $composableBuilder(column: $table.pending, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LevelResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelResultsTable,
          LevelResultRow,
          $$LevelResultsTableFilterComposer,
          $$LevelResultsTableOrderingComposer,
          $$LevelResultsTableAnnotationComposer,
          $$LevelResultsTableCreateCompanionBuilder,
          $$LevelResultsTableUpdateCompanionBuilder,
          (LevelResultRow, $$LevelResultsTableReferences),
          LevelResultRow,
          PrefetchHooks Function({bool profileId})
        > {
  $$LevelResultsTableTableManager(_$AppDatabase db, $LevelResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> topology = const Value.absent(),
                Value<String> levelId = const Value.absent(),
                Value<int?> stars = const Value.absent(),
                Value<int?> timeMs = const Value.absent(),
                Value<int> moves = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int> achievedAt = const Value.absent(),
                Value<bool> pending = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelResultsCompanion(
                profileId: profileId,
                gameId: gameId,
                topology: topology,
                levelId: levelId,
                stars: stars,
                timeMs: timeMs,
                moves: moves,
                score: score,
                achievedAt: achievedAt,
                pending: pending,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String gameId,
                required String topology,
                required String levelId,
                Value<int?> stars = const Value.absent(),
                Value<int?> timeMs = const Value.absent(),
                required int moves,
                Value<int?> score = const Value.absent(),
                required int achievedAt,
                Value<bool> pending = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelResultsCompanion.insert(
                profileId: profileId,
                gameId: gameId,
                topology: topology,
                levelId: levelId,
                stars: stars,
                timeMs: timeMs,
                moves: moves,
                score: score,
                achievedAt: achievedAt,
                pending: pending,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LevelResultsTable, LevelResultRow>(table),
                  $$LevelResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
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
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$LevelResultsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$LevelResultsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
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

typedef $$LevelResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelResultsTable,
      LevelResultRow,
      $$LevelResultsTableFilterComposer,
      $$LevelResultsTableOrderingComposer,
      $$LevelResultsTableAnnotationComposer,
      $$LevelResultsTableCreateCompanionBuilder,
      $$LevelResultsTableUpdateCompanionBuilder,
      (LevelResultRow, $$LevelResultsTableReferences),
      LevelResultRow,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$RecordsTableCreateCompanionBuilder = RecordsCompanion Function({
  required String profileId,
  required String gameId,
  required String topology,
  required int score,
  required int achievedAt,
  Value<bool> pending,
  Value<int> revision,
  Value<int> rowid,
});
typedef $$RecordsTableUpdateCompanionBuilder = RecordsCompanion Function({
  Value<String> profileId,
  Value<String> gameId,
  Value<String> topology,
  Value<int> score,
  Value<int> achievedAt,
  Value<bool> pending,
  Value<int> revision,
  Value<int> rowid,
});

final class $$RecordsTableReferences
    extends BaseReferences<_$AppDatabase, $RecordsTable, RecordRow> {
  $$RecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('records__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecordsTableFilterComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topology => $composableBuilder(
    column: $table.topology,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pending => $composableBuilder(
    column: $table.pending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topology => $composableBuilder(
    column: $table.topology,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pending => $composableBuilder(
    column: $table.pending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get topology =>
      $composableBuilder(column: $table.topology, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pending =>
      $composableBuilder(column: $table.pending, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordsTable,
          RecordRow,
          $$RecordsTableFilterComposer,
          $$RecordsTableOrderingComposer,
          $$RecordsTableAnnotationComposer,
          $$RecordsTableCreateCompanionBuilder,
          $$RecordsTableUpdateCompanionBuilder,
          (RecordRow, $$RecordsTableReferences),
          RecordRow,
          PrefetchHooks Function({bool profileId})
        > {
  $$RecordsTableTableManager(_$AppDatabase db, $RecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> topology = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> achievedAt = const Value.absent(),
                Value<bool> pending = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordsCompanion(
                profileId: profileId,
                gameId: gameId,
                topology: topology,
                score: score,
                achievedAt: achievedAt,
                pending: pending,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String gameId,
                required String topology,
                required int score,
                required int achievedAt,
                Value<bool> pending = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordsCompanion.insert(
                profileId: profileId,
                gameId: gameId,
                topology: topology,
                score: score,
                achievedAt: achievedAt,
                pending: pending,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecordsTable, RecordRow>(table),
                  $$RecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
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
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$RecordsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$RecordsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
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

typedef $$RecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordsTable,
      RecordRow,
      $$RecordsTableFilterComposer,
      $$RecordsTableOrderingComposer,
      $$RecordsTableAnnotationComposer,
      $$RecordsTableCreateCompanionBuilder,
      $$RecordsTableUpdateCompanionBuilder,
      (RecordRow, $$RecordsTableReferences),
      RecordRow,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$SavedGamesTableCreateCompanionBuilder = SavedGamesCompanion Function({
  required String profileId,
  required String gameId,
  required String topology,
  required String stateJson,
  required int codecVersion,
  required int savedAt,
  Value<int> rowid,
});
typedef $$SavedGamesTableUpdateCompanionBuilder = SavedGamesCompanion Function({
  Value<String> profileId,
  Value<String> gameId,
  Value<String> topology,
  Value<String> stateJson,
  Value<int> codecVersion,
  Value<int> savedAt,
  Value<int> rowid,
});

final class $$SavedGamesTableReferences
    extends BaseReferences<_$AppDatabase, $SavedGamesTable, SavedGameRow> {
  $$SavedGamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('saved_games__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SavedGamesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedGamesTable> {
  $$SavedGamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topology => $composableBuilder(
    column: $table.topology,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateJson => $composableBuilder(
    column: $table.stateJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get codecVersion => $composableBuilder(
    column: $table.codecVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedGamesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedGamesTable> {
  $$SavedGamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topology => $composableBuilder(
    column: $table.topology,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateJson => $composableBuilder(
    column: $table.stateJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get codecVersion => $composableBuilder(
    column: $table.codecVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedGamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedGamesTable> {
  $$SavedGamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get topology =>
      $composableBuilder(column: $table.topology, builder: (column) => column);

  GeneratedColumn<String> get stateJson =>
      $composableBuilder(column: $table.stateJson, builder: (column) => column);

  GeneratedColumn<int> get codecVersion => $composableBuilder(
    column: $table.codecVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedGamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedGamesTable,
          SavedGameRow,
          $$SavedGamesTableFilterComposer,
          $$SavedGamesTableOrderingComposer,
          $$SavedGamesTableAnnotationComposer,
          $$SavedGamesTableCreateCompanionBuilder,
          $$SavedGamesTableUpdateCompanionBuilder,
          (SavedGameRow, $$SavedGamesTableReferences),
          SavedGameRow,
          PrefetchHooks Function({bool profileId})
        > {
  $$SavedGamesTableTableManager(_$AppDatabase db, $SavedGamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedGamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedGamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedGamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> topology = const Value.absent(),
                Value<String> stateJson = const Value.absent(),
                Value<int> codecVersion = const Value.absent(),
                Value<int> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedGamesCompanion(
                profileId: profileId,
                gameId: gameId,
                topology: topology,
                stateJson: stateJson,
                codecVersion: codecVersion,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String gameId,
                required String topology,
                required String stateJson,
                required int codecVersion,
                required int savedAt,
                Value<int> rowid = const Value.absent(),
              }) => SavedGamesCompanion.insert(
                profileId: profileId,
                gameId: gameId,
                topology: topology,
                stateJson: stateJson,
                codecVersion: codecVersion,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavedGamesTable, SavedGameRow>(table),
                  $$SavedGamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
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
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$SavedGamesTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$SavedGamesTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
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

typedef $$SavedGamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedGamesTable,
      SavedGameRow,
      $$SavedGamesTableFilterComposer,
      $$SavedGamesTableOrderingComposer,
      $$SavedGamesTableAnnotationComposer,
      $$SavedGamesTableCreateCompanionBuilder,
      $$SavedGamesTableUpdateCompanionBuilder,
      (SavedGameRow, $$SavedGamesTableReferences),
      SavedGameRow,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$DownloadedLevelsTableCreateCompanionBuilder =
    DownloadedLevelsCompanion Function({
      required String id,
      required String gameId,
      required String topology,
      required int order,
      required int version,
      required String json,
      required int downloadedAt,
      Value<int> rowid,
    });
typedef $$DownloadedLevelsTableUpdateCompanionBuilder =
    DownloadedLevelsCompanion Function({
      Value<String> id,
      Value<String> gameId,
      Value<String> topology,
      Value<int> order,
      Value<int> version,
      Value<String> json,
      Value<int> downloadedAt,
      Value<int> rowid,
    });

class $$DownloadedLevelsTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadedLevelsTable> {
  $$DownloadedLevelsTableFilterComposer({
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

  ColumnFilters<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topology => $composableBuilder(
    column: $table.topology,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DownloadedLevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadedLevelsTable> {
  $$DownloadedLevelsTableOrderingComposer({
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

  ColumnOrderings<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topology => $composableBuilder(
    column: $table.topology,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DownloadedLevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadedLevelsTable> {
  $$DownloadedLevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get topology =>
      $composableBuilder(column: $table.topology, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );
}

class $$DownloadedLevelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadedLevelsTable,
          DownloadedLevelRow,
          $$DownloadedLevelsTableFilterComposer,
          $$DownloadedLevelsTableOrderingComposer,
          $$DownloadedLevelsTableAnnotationComposer,
          $$DownloadedLevelsTableCreateCompanionBuilder,
          $$DownloadedLevelsTableUpdateCompanionBuilder,
          (
            DownloadedLevelRow,
            BaseReferences<
              _$AppDatabase,
              $DownloadedLevelsTable,
              DownloadedLevelRow
            >,
          ),
          DownloadedLevelRow,
          PrefetchHooks Function()
        > {
  $$DownloadedLevelsTableTableManager(
    _$AppDatabase db,
    $DownloadedLevelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadedLevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadedLevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadedLevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> topology = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> downloadedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DownloadedLevelsCompanion(
                id: id,
                gameId: gameId,
                topology: topology,
                order: order,
                version: version,
                json: json,
                downloadedAt: downloadedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                required String topology,
                required int order,
                required int version,
                required String json,
                required int downloadedAt,
                Value<int> rowid = const Value.absent(),
              }) => DownloadedLevelsCompanion.insert(
                id: id,
                gameId: gameId,
                topology: topology,
                order: order,
                version: version,
                json: json,
                downloadedAt: downloadedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DownloadedLevelsTable, DownloadedLevelRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DownloadedLevelsTable,
                    DownloadedLevelRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DownloadedLevelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadedLevelsTable,
      DownloadedLevelRow,
      $$DownloadedLevelsTableFilterComposer,
      $$DownloadedLevelsTableOrderingComposer,
      $$DownloadedLevelsTableAnnotationComposer,
      $$DownloadedLevelsTableCreateCompanionBuilder,
      $$DownloadedLevelsTableUpdateCompanionBuilder,
      (
        DownloadedLevelRow,
        BaseReferences<
          _$AppDatabase,
          $DownloadedLevelsTable,
          DownloadedLevelRow
        >,
      ),
      DownloadedLevelRow,
      PrefetchHooks Function()
    >;
typedef $$LevelSyncCursorsTableCreateCompanionBuilder =
    LevelSyncCursorsCompanion Function({
      required String gameId,
      required String topology,
      required String cursor,
      Value<int> rowid,
    });
typedef $$LevelSyncCursorsTableUpdateCompanionBuilder =
    LevelSyncCursorsCompanion Function({
      Value<String> gameId,
      Value<String> topology,
      Value<String> cursor,
      Value<int> rowid,
    });

class $$LevelSyncCursorsTableFilterComposer
    extends Composer<_$AppDatabase, $LevelSyncCursorsTable> {
  $$LevelSyncCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topology => $composableBuilder(
    column: $table.topology,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LevelSyncCursorsTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelSyncCursorsTable> {
  $$LevelSyncCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topology => $composableBuilder(
    column: $table.topology,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LevelSyncCursorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelSyncCursorsTable> {
  $$LevelSyncCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get topology =>
      $composableBuilder(column: $table.topology, builder: (column) => column);

  GeneratedColumn<String> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);
}

class $$LevelSyncCursorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelSyncCursorsTable,
          LevelSyncCursorRow,
          $$LevelSyncCursorsTableFilterComposer,
          $$LevelSyncCursorsTableOrderingComposer,
          $$LevelSyncCursorsTableAnnotationComposer,
          $$LevelSyncCursorsTableCreateCompanionBuilder,
          $$LevelSyncCursorsTableUpdateCompanionBuilder,
          (
            LevelSyncCursorRow,
            BaseReferences<
              _$AppDatabase,
              $LevelSyncCursorsTable,
              LevelSyncCursorRow
            >,
          ),
          LevelSyncCursorRow,
          PrefetchHooks Function()
        > {
  $$LevelSyncCursorsTableTableManager(
    _$AppDatabase db,
    $LevelSyncCursorsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelSyncCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelSyncCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelSyncCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gameId = const Value.absent(),
                Value<String> topology = const Value.absent(),
                Value<String> cursor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelSyncCursorsCompanion(
                gameId: gameId,
                topology: topology,
                cursor: cursor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gameId,
                required String topology,
                required String cursor,
                Value<int> rowid = const Value.absent(),
              }) => LevelSyncCursorsCompanion.insert(
                gameId: gameId,
                topology: topology,
                cursor: cursor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LevelSyncCursorsTable, LevelSyncCursorRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $LevelSyncCursorsTable,
                    LevelSyncCursorRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LevelSyncCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelSyncCursorsTable,
      LevelSyncCursorRow,
      $$LevelSyncCursorsTableFilterComposer,
      $$LevelSyncCursorsTableOrderingComposer,
      $$LevelSyncCursorsTableAnnotationComposer,
      $$LevelSyncCursorsTableCreateCompanionBuilder,
      $$LevelSyncCursorsTableUpdateCompanionBuilder,
      (
        LevelSyncCursorRow,
        BaseReferences<
          _$AppDatabase,
          $LevelSyncCursorsTable,
          LevelSyncCursorRow
        >,
      ),
      LevelSyncCursorRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$LevelResultsTableTableManager get levelResults =>
      $$LevelResultsTableTableManager(_db, _db.levelResults);
  $$RecordsTableTableManager get records =>
      $$RecordsTableTableManager(_db, _db.records);
  $$SavedGamesTableTableManager get savedGames =>
      $$SavedGamesTableTableManager(_db, _db.savedGames);
  $$DownloadedLevelsTableTableManager get downloadedLevels =>
      $$DownloadedLevelsTableTableManager(_db, _db.downloadedLevels);
  $$LevelSyncCursorsTableTableManager get levelSyncCursors =>
      $$LevelSyncCursorsTableTableManager(_db, _db.levelSyncCursors);
}
