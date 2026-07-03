import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'pegadas_na_pista.db';
  static const _databaseVersion = 3;

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trails (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE trail_points (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trail_id INTEGER NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        timestamp TEXT NOT NULL,
        photo_path TEXT,
        FOREIGN KEY (trail_id) REFERENCES trails (id) ON DELETE CASCADE
      )
    ''');
    await _createWildlifeRecordTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createWildlifeRecordTables(db);
    }
    if (oldVersion == 2) {
      await _addSyncColumns(db);
    }
  }

  Future<void> _addSyncColumns(Database db) async {
    await db.execute('''
      ALTER TABLE wildlife_records ADD COLUMN sync_status TEXT NOT NULL DEFAULT 'pending'
    ''');
    await db.execute('ALTER TABLE wildlife_records ADD COLUMN remote_id TEXT');
  }

  Future<void> _createWildlifeRecordTables(Database db) async {
    await db.execute('''
      CREATE TABLE wildlife_records (
        id TEXT PRIMARY KEY,
        tipo_registro TEXT NOT NULL,
        id_especie TEXT,
        nome_especie_informado TEXT,
        data_ocorrencia TEXT NOT NULL,
        hora_ocorrencia TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        precisao_localizacao_m REAL,
        rodovia TEXT,
        km_rodovia REAL,
        municipio TEXT,
        observacoes TEXT,
        status_validacao TEXT NOT NULL DEFAULT 'pendente',
        sync_status TEXT NOT NULL DEFAULT 'pending',
        remote_id TEXT,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE wildlife_record_environmental_data (
        record_id TEXT PRIMARY KEY,
        clima TEXT,
        periodo_dia TEXT,
        temperatura_c REAL,
        umidade_percentual REAL,
        precipitacao_mm REAL,
        condicao_pista TEXT,
        luminosidade TEXT,
        visibilidade TEXT,
        observacao_ambiental TEXT,
        FOREIGN KEY (record_id) REFERENCES wildlife_records (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE wildlife_record_roadkill_details (
        record_id TEXT PRIMARY KEY,
        condicao_carcaca TEXT,
        posicao_animal TEXT,
        sentido_via TEXT,
        faixa_rodovia TEXT,
        FOREIGN KEY (record_id) REFERENCES wildlife_records (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE wildlife_record_sighting_details (
        record_id TEXT PRIMARY KEY,
        quantidade_individuos INTEGER NOT NULL DEFAULT 1,
        comportamento_observado TEXT,
        distancia_aproximada_m REAL,
        animal_vivo INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (record_id) REFERENCES wildlife_records (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE wildlife_record_photos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        record_id TEXT NOT NULL,
        local_path TEXT,
        url_foto TEXT,
        tipo_foto TEXT NOT NULL,
        ordem INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (record_id) REFERENCES wildlife_records (id) ON DELETE CASCADE
      )
    ''');
  }
}
