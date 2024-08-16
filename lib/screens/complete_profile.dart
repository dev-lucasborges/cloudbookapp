import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudbook/components/custom_textfield.dart';
import 'package:cloudbook/components/custom_button.dart';
import 'package:ionicons/ionicons.dart';

class CompleteProfileScreen extends StatefulWidget {
  final void Function()? onTap;

  const CompleteProfileScreen({super.key, this.onTap});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<double> _progressNotifier = ValueNotifier<double>(0.33);

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final List<String> classList = [];
  final TextEditingController classController = TextEditingController();

  String? associatedSchoolId;

  bool isFullNameValid(String name) {
    return name.contains(' ');
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    _progressNotifier.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final pageIndex = _pageController.page ?? 0;
    _progressNotifier.value = (pageIndex + 1) / 3;
  }

  void addClass() {
    setState(() {
      classList.add(classController.text);
      classController.clear();
    });
  }

  void previousPage() {
    if (_pageController.page == 0) {
      _showExitDialog();
    } else {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  Future<void> createUserProfile(String fullName) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      List<String> nameParts = fullName.split(' ');
      String displayName = '';
      if (nameParts.length > 1) {
        displayName = '${nameParts.first} ${nameParts.last}';
      } else {
        displayName = nameParts.first;
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': fullName,
        'displayName': displayName,
        'isIndependent': associatedSchoolId == null,
        'schoolsUID': associatedSchoolId,
        'classes': classList,
      });

      _showSuccessDialog("Perfil criado com sucesso!");
    }
  }

  Future<void> createSchoolAndProceed() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('schools')
        .where('name', isEqualTo: schoolController.text)
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      // Cria a escola no banco de dados e captura o UID
      final DocumentReference schoolRef =
          await FirebaseFirestore.instance.collection('schools').add({
        'createdBy': fullNameController.text,
        'schoolName': schoolController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Armazena o UID da escola criada
      associatedSchoolId = schoolRef.id;
    } else {
      // Se a escola já existe, usar o UID existente
      associatedSchoolId = result.docs.first.id;
    }

    _pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar saída"),
        content: const Text(
            "Tem certeza que não quer completar o perfil agora? Para ter acesso às funcionalidades do CloudBook, é necessário completar o perfil."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Volta para a tela inicial
            },
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sucesso"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Volta para a tela inicial
            },
            child: const Text("Voltar para a tela inicial"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Ionicons.chevron_back),
          onPressed: previousPage,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Ação para "Ajuda"
            },
            child: Text(
              'Ajuda',
              style: TextStyle(
                color: Theme.of(context).textTheme.displayLarge!.color,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder<double>(
              valueListenable: _progressNotifier,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey[900],
                  color: Theme.of(context).colorScheme.primary,
                );
              },
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  buildNamePage(context),
                  buildSchoolPage(context),
                  buildClassPage(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNamePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Qual é o seu nome completo?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'Seu nome completo',
            controller: fullNameController,
            focusNode: FocusNode(),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 10),
          if (!isFullNameValid(fullNameController.text))
            const Text(
              'Nome inválido',
              style: TextStyle(color: Colors.red),
            ),
          const Spacer(),
          CustomButton(
            text: "Próximo",
            onTap: () {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            },
            isEnabled: isFullNameValid(fullNameController.text),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildSchoolPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Qual é a sua escola?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'Nome da escola',
            controller: schoolController,
            focusNode: FocusNode(),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const Spacer(),
          CustomButton(
            text: "Próximo",
            onTap: createSchoolAndProceed,
            isEnabled: schoolController.text.isNotEmpty,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildClassPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Crie suas turmas',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'Nome da turma',
            controller: classController,
            focusNode: FocusNode(),
          ),
          ElevatedButton(
            onPressed: addClass,
            child: const Text('Adicionar Turma'),
          ),
          ...classList.map((className) => ListTile(
                title: Text(className),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      classList.remove(className);
                    });
                  },
                ),
              )),
          const Spacer(),
          CustomButton(
            text: "Salvar Perfil",
            onTap: () {
              createUserProfile(fullNameController.text);
            },
          ),
          TextButton(
            onPressed: () {
              _showSuccessDialog("Perfil salvo com sucesso!");
            },
            child: const Text('Fazer depois'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
