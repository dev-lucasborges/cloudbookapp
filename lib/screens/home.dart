import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final List<String> notifications = [
    "Bem-vindo ao CloudBook!",
    "Não esqueça de completar seu perfil.",
    "Novos recursos disponíveis em breve!"
  ];

  String userName = "Professor";
  bool isProfileIncomplete = false;
  bool isExpanded = false; // Estado para controlar expansão
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        String? fullName = userData['fullName'];

        setState(() {
          if (fullName == null || fullName.isEmpty) {
            isProfileIncomplete = true;
            notifications.insert(0,
                "Seu perfil está incompleto. Complete seu nome para acessar todas as funcionalidades.");
          } else {
            userName = userData['displayName'];
            isProfileIncomplete = false;
          }
        });
      }
    }
  }

  // logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Método para limpar a preferência e deslogar
  Future<void> clearPreference(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferências e sessão limpas com sucesso.'),
      ),
    );
  }

  // Verificar e redirecionar para completar perfil
  void checkProfileCompletion(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        String? fullName = userData['fullName'];
        String? schoolId = userData['schoolsUID'];
        // Este campo armazena o docId da escola
        List<dynamic>? classes = userData['classes'];

        if (fullName == null ||
            schoolId == null ||
            classes == null ||
            classes.isEmpty) {
          Navigator.pushNamed(context, '/complete_profile');
        }
      } else {
        Navigator.pushNamed(context, '/complete_profile');
      }
    }
  }

  void navigateToProfile(BuildContext context) {
    if (isProfileIncomplete) {
      Navigator.pushNamed(context, '/complete_profile');
    } else {
      Navigator.pushNamed(context, '/profile');
    }
  }

  void navigateToTurmas(BuildContext context) {
    if (isProfileIncomplete) {
      Navigator.pushNamed(context, '/complete_profile');
    } else {
      Navigator.pushNamed(context, '/turmas');
    }
  }

  void getDataList(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      print(userData.data());
      if (userData.exists) {
        String? fullName = userData['fullName'];
        String? schoolId = userData['schoolsUID'];
        List<dynamic>? classes = userData['classes'];

        if (fullName != null &&
            schoolId != null &&
            classes != null &&
            classes.isNotEmpty) {
          // buscar informações da escola usando o UID (docId)
          DocumentSnapshot schoolData = await FirebaseFirestore.instance
              .collection('schools')
              .doc(schoolId)
              .get();

          if (schoolData.exists) {
            String? schoolName = schoolData['schoolName'];
            String? createdBy = schoolData['createdBy'];
            Timestamp? createdAt = schoolData['createdAt'];

            print("UID da escola: " + schoolId);
            print("Nome da Escola: $schoolName");
            print("Criado por: $createdBy");
            print("Criado em: ${createdAt?.toDate()}");
          } else {
            print('Escola não encontrada');
          }
        } else {
          print("Perfil incompleto. Verifique o nome, escola e turmas.");
        }
      } else {
        print('Usuário não encontrado');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifique se o tema atual é escuro
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Carregue a imagem apropriada com base no tema
    String imagePath =
        isDarkTheme ? 'assets/profile-dark.png' : 'assets/profile-light.png';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 1,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      bottom: 30,
                      top: 15,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CE LUIZ REID',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Olá, ',
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                        ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: userName,
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .copyWith(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                navigateToProfile(context);
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Image.asset(
                                  imagePath,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            // Primeira linha de ícones
                            SizedBox(
                              height: 104,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildModule(
                                    context,
                                    icon: Ionicons.text_outline,
                                    label: 'Notas',
                                    onTap: () {
                                      checkProfileCompletion(context);
                                    },
                                  ),
                                  _buildModule(
                                    context,
                                    icon: Ionicons.document_text_outline,
                                    label: 'Resumo',
                                    onTap: () {
                                      getDataList(context);
                                    },
                                  ),
                                  _buildModule(
                                    context,
                                    icon: Ionicons.arrow_forward_circle_outline,
                                    label: 'Chamada',
                                    onTap: () {
                                      checkProfileCompletion(context);
                                    },
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    iconColor: Colors.white,
                                    textColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            // Segunda linha de ícones (se expandido)
                            ClipRect(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                height: isExpanded ? 114 : 0,
                                curve: Curves.easeInOut,
                                child: SingleChildScrollView(
                                  // Aqui
                                  child: Column(
                                    children: [
                                      if (isExpanded) ...[
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildModule(
                                              context,
                                              icon: Ionicons.people_outline,
                                              label: 'Turmas',
                                              onTap: () {
                                                navigateToTurmas(context);
                                              },
                                            ),
                                            _buildModule(
                                              context,
                                              icon: Ionicons.calendar_outline,
                                              label: 'Calendário',
                                              onTap: () {},
                                            ),
                                            _buildModule(
                                              context,
                                              icon: Ionicons.settings_outline,
                                              label: 'Configurações',
                                              onTap: () {},
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: Container(
                            // dropdown box
                            width: 110,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Icon(
                                isExpanded
                                    ? Ionicons.chevron_up
                                    : Ionicons.chevron_down,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            currentPage = page;
                          });
                        },
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Ionicons.notifications_outline,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 40,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    notifications[index],
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(notifications.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? Theme.of(context).colorScheme.onSecondary
                                : Theme.of(context).colorScheme.tertiary,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModule(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      Color? backgroundColor,
      Color? iconColor,
      Color? textColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 94,
        height: 94,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor ?? Theme.of(context).iconTheme.color,
              size: 50,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    textColor ?? Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
