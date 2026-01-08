import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/article/article_model.dart';

class ArticleLocalDataSource {
  static const String _tableName = 'articles';
  static const String _columnSlug = 'slug';
  static const String _columnJson = 'json';
  static const String _columnUpdatedAt = 'updated_at';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(
      await getDatabasesPath(),
      'ilmalogiya_articles.db',
    );
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            $_columnSlug TEXT PRIMARY KEY,
            $_columnJson TEXT,
            $_columnUpdatedAt INTEGER
          )
        ''');
      },
    );
  }

  Future<List<ArticleModel>> getArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: '$_columnUpdatedAt DESC', // Show newest/recently updated first
    );

    return List.generate(maps.length, (i) {
      return ArticleModel.fromJson(jsonDecode(maps[i][_columnJson]));
    });
  }

  Future<void> saveArticles(List<ArticleModel> articles) async {
    final db = await database;
    final batch = db.batch();

    for (var article in articles) {
      // Use slug as ID. If slug is null, we can't key it properly,
      // but ArticleModel usually has a slug.
      // If slug is missing, maybe skip or use ID as fallback?
      // Based on model, slug is nullable but essential for this strategy.
      // Let's assume slug is present or fallback to id.toString().
      final String key = article.slug ?? article.id.toString();

      batch.insert(_tableName, {
        _columnSlug: key,
        _columnJson: jsonEncode(article.toJson()),
        _columnUpdatedAt: DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future<ArticleModel?> getArticle(String slug) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_columnSlug = ?',
      whereArgs: [slug],
    );

    if (maps.isNotEmpty) {
      return ArticleModel.fromJson(jsonDecode(maps.first[_columnJson]));
    }
    return null;
  }

  Future<void> saveArticle(ArticleModel article) async {
    final db = await database;
    final String key = article.slug ?? article.id.toString();

    await db.insert(_tableName, {
      _columnSlug: key,
      _columnJson: jsonEncode(article.toJson()),
      _columnUpdatedAt: DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
