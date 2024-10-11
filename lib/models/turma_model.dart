class Turma {
  String id;
  String nome;

  Turma({required this.id, required this.nome});

  factory Turma.fromMap(String id, Map<String, dynamic> data) {
    return Turma(
      id: id,
      nome: data['nome'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
    };
  }
}
