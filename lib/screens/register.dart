import 'package:cloudbook/components/custom_button.dart';
import 'package:cloudbook/components/custom_textfield.dart';
import 'package:cloudbook/helper/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTap;

  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();

  // controladores de texto
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // nós de foco
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r"^[^@]+@[^@]+\.[^@]+$");
    return emailRegExp.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    // Exemplo de requisitos mínimos: pelo menos 6 caracteres, deve conter letras e números
    final passwordRegExp = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,}$');
    return passwordRegExp.hasMatch(password);
  }

  bool arePasswordsMatching(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailFocusNode.requestFocus(); // Foca no campo de email após o build
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    setState(() {
      // Atualiza o estado quando a página muda
    });
  }

  void registerUser() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (passwordController.text != confirmPasswordController.text) {
      if (mounted) {
        Navigator.pop(context);
      }
      displayMessageToUser("As senhas não coincidem", context);
    } else {
      try {
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (mounted) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          Navigator.pop(context);
          displayMessageToUser(e.code, context);
        }
      }
    }
  }

  void nextPage() {
    if (_pageController.page == 0) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      registerUser();
    }
  }

  void previousPage() {
    if (_pageController.page == 0) {
      widget.onTap
          ?.call(); // Chama a função de login se estiver na primeira página
    } else {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _focusOnCurrentPage() {
    final pageIndex = _pageController.page?.toInt() ?? 0;
    switch (pageIndex) {
      case 0:
        FocusScope.of(context).requestFocus(emailFocusNode);
        break;
      case 1:
        FocusScope.of(context).requestFocus(passwordFocusNode);
        break;
    }
  }

  bool isNextButtonEnabled() {
    if (!_pageController.hasClients) {
      return false; // Evita acessar antes de estar inicializado
    }

    final pageIndex = _pageController.page?.toInt() ?? 0;

    switch (pageIndex) {
      case 0:
        return isEmailValid(emailController.text);
      case 1:
        return isPasswordValid(passwordController.text) &&
            isPasswordValid(confirmPasswordController.text) &&
            arePasswordsMatching(
                passwordController.text, confirmPasswordController.text);
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
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
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Desabilita a rolagem
          children: [
            buildPage(
              context: context,
              title: "Qual é o seu email?",
              controller: emailController,
              hintText: "exemplo@email.com",
              buttonText: "Próximo",
              focusNode: emailFocusNode,
              showBackButton: true,
            ),
            buildPasswordPage(
              context: context,
              title: "Crie uma Senha",
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              buttonText: "Criar",
              passwordFocusNode: passwordFocusNode,
              confirmPasswordFocusNode: confirmPasswordFocusNode,
              showBackButton: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPage({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required String hintText,
    required String buttonText,
    required FocusNode focusNode,
    bool obscureText = false,
    required bool showBackButton,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          CustomTextField(
            hintText: hintText,
            obscureText: obscureText,
            controller: controller,
            focusNode: focusNode,
            onChanged: (value) {
              setState(() {}); // Atualiza o estado quando o valor mudar
            },
          ),
          const SizedBox(height: 25),
          const Spacer(),
          CustomButton(
            text: buttonText,
            onTap: nextPage,
            isEnabled: isNextButtonEnabled(), // Habilita ou desabilita o botão
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Já tem uma conta?",
                style: TextStyle(
                  color: Theme.of(context).textTheme.displayLarge!.color,
                ),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: const Text(
                  " Entrar",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget buildPasswordPage({
    required BuildContext context,
    required String title,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required String buttonText,
    required FocusNode passwordFocusNode,
    required FocusNode confirmPasswordFocusNode,
    required bool showBackButton,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Senha",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: "••••••••••••",
            obscureText: true,
            controller: passwordController,
            focusNode: passwordFocusNode,
            onChanged: (value) {
              setState(() {}); // Atualiza o estado quando o valor mudar
            },
          ),
          const SizedBox(height: 12),
          const Text(
            "Confirmar Senha",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: "••••••••••••",
            obscureText: true,
            controller: confirmPasswordController,
            focusNode: confirmPasswordFocusNode,
            onChanged: (value) {
              setState(() {}); // Atualiza o estado quando o valor mudar
            },
          ),
          const SizedBox(height: 25),
          CustomButton(
            text: buttonText,
            onTap: nextPage,
            isEnabled: isNextButtonEnabled(), // Habilita ou desabilita o botão
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Já tem uma conta?",
                style: TextStyle(
                  color: Theme.of(context).textTheme.displayLarge!.color,
                ),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: const Text(
                  " Entrar",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
