import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/turma_model.dart';

class TurmaService {
  final CollectionReference turmasCollection =
      FirebaseFirestore.instance.collection('turmas');

  // Criar uma nova turma
  Future<void> createTurma(String nome) async {
    await turmasCollection.add({
      'nome': nome,
    });
  }

  // Obter a lista de turmas
  Stream<List<Turma>> getTurmas() {
    return turmasCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Turma.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Atualizar uma turma existente
  Future<void> updateTurma(String id, String nome) async {
    await turmasCollection.doc(id).update({
      'nome': nome,
    });
  }

  // Remover uma turma
  Future<void> deleteTurma(String id) async {
    await turmasCollection.doc(id).delete();
  }
}
