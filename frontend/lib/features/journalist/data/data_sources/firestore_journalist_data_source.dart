import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/journalist_article_model.dart';
import '../../domain/entities/journalist_article.dart';

abstract class FirestoreJournalistDataSource {
  Future<List<JournalistArticleModel>> getArticles();
  Future<void> saveArticle(JournalistArticleEntity article);
}

class FirestoreJournalistDataSourceImpl implements FirestoreJournalistDataSource {
  final FirebaseFirestore _firestore;

  FirestoreJournalistDataSourceImpl(this._firestore);

  @override
  Future<List<JournalistArticleModel>> getArticles() async {
    try {
      final snapshot = await _firestore
          .collection('articles')
          .orderBy('metadata.createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        try {
          // parse timestamps back to strings if needed by json
          return JournalistArticleModel.fromJson(data);
        } catch (e) {
          // We allow skipping corrupted documents safely
          return JournalistArticleModel();
        }
      }).where((element) => element.id != null).toList();
    } catch (e) {
      throw Exception('Failed to fetch articles from Firestore: $e');
    }
  }

  @override
  Future<void> saveArticle(JournalistArticleEntity article) async {
    try {
      final model = JournalistArticleModel.fromEntity(article);
      await _firestore.collection('articles').doc(model.id).set(model.toJson());
    } catch (e) {
      throw Exception('Failed to save article to Firestore: $e');
    }
  }
}
