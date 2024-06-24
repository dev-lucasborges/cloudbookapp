import 'package:flutter/material.dart';
import '../utils/app_colors.dart'; // Importa o arquivo de cores
import 'package:shared_preferences/shared_preferences.dart';

class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  late PageController _pageController;

  _markAsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenGetStarted', false);
  }

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    _markAsSeen();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Pular',
                      style: TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.w400)),
                ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                  itemCount: demoData.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnboardContent(
                        image: demoData[index].image,
                        title: demoData[index].title,
                        description: demoData[index].description,
                      )),
            ),
            Row(
              children: [
                ...List.generate(
                  demoData.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: DotIndicator(
                      isActive: index == _pageIndex,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_pageIndex < demoData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _markAsSeen();
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    child: _pageIndex < demoData.length - 1
                        ? Icon(Icons.arrow_forward_ios_rounded,
                            size: 16, color: Colors.white)
                        : const Icon(Icons.check,
                            size: 16, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 8,
      width: isActive ? 23 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.amberAccent,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class Onboard {
  final String image, title, description;

  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> demoData = [
  Onboard(
    image: 'assets/menino.jpg',
    title: 'Faça chamadas em segundos',
    description:
        'Com o CloudBook, você economiza até 10 vezes mais tempo ao fazer chamadas graças à nossa tecnologia.',
  ),
  Onboard(
    image: 'assets/download.jpg',
    title: 'Planeje Suas Aulas com Facilidade',
    description:
        'Acesse calendários de provas, eventos e atividades escolares diretamente no app.',
  ),
  Onboard(
    image: 'assets/download.jpg',
    title: 'Onde estiver, como quiser, a qualquer momento',
    description:
        'Acesse e atualize informações dos alunos mesmo offline, com sincronização automática quando voltar online.',
  ),
];

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          image,
          height: 250,
        ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Text(
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 14,
          ),
          description,
          textAlign: TextAlign.start,
        ),
        const Spacer(),
      ],
    );
  }
}
