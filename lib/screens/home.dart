import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  int currentPage = 0;

  // logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Método para limpar a preferência
  Future<void> clearPreference(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('seenGetStarted');
    await prefs.remove('fullName');
    await prefs.remove('schoolName');
    await prefs.remove('hasClass');
    await FirebaseAuth.instance.signOut();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences cleared successfully.'),
      ),
    );
  }

  // Verificar e redirecionar para completar perfil
  void checkProfileCompletion(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString('fullName');
    String? schoolName = prefs.getString('schoolName');
    bool hasClass = prefs.getBool('hasClass') ?? false;

    if (fullName == null || schoolName == null || !hasClass) {
      Navigator.pushNamed(context, '/complete_profile');
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
                    borderRadius: BorderRadius.vertical(
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
                                    text: 'Olá,',
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                        ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' Professor',
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
                            Align(
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                imagePath,
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 104,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  checkProfileCompletion(context);
                                },
                                child: SizedBox(
                                  width: 94,
                                  height: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Ionicons.text_outline,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        size: 50,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Notas',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  checkProfileCompletion(context);
                                },
                                child: SizedBox(
                                  width: 94,
                                  height: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Ionicons.document_text_outline,
                                        size: 50,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Resumo',
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  checkProfileCompletion(context);
                                },
                                child: Container(
                                  width: 94,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(23),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Ionicons.arrow_forward_circle_outline,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Chamada',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: Container(
                            width: 110,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: TextButton(
                              onPressed: () {
                                clearPreference(context);
                              },
                              child: Icon(
                                Ionicons.chevron_down,
                                color: Colors.white,
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
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSecondary,
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
}
