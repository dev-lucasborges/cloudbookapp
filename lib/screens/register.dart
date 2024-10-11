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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  String passwordErrorText = '';
  String confirmPasswordErrorText = '';
  bool isPasswordCriteriaMet = false;
  bool isPasswordMatching = false;

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r"^[^@]+@[^@]+\.[^@]+$");
    return emailRegExp.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    final hasMinLength = password.length >= 6;
    final hasLetter = password.contains(RegExp(r'[a-zA-Z]'));

    setState(() {
      isPasswordCriteriaMet = hasMinLength && hasLetter;
      if (!hasMinLength && !hasLetter) {
        passwordErrorText =
            "A senha deve conter pelo menos 6 dígitos e uma letra";
      } else if (!hasMinLength) {
        passwordErrorText = "A senha deve conter pelo menos 6 dígitos";
      } else if (!hasLetter) {
        passwordErrorText = "A senha deve conter pelo menos uma letra";
      } else {
        passwordErrorText = "";
      }
    });

    return hasMinLength && hasLetter;
  }

  bool arePasswordsMatching(String password, String confirmPassword) {
    setState(() {
      isPasswordMatching = password == confirmPassword;
      confirmPasswordErrorText =
          isPasswordMatching ? "" : "As senhas não coincidem";
    });
    return isPasswordMatching;
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailFocusNode.requestFocus();
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
      final pageIndex = _pageController.page?.toInt() ?? 0;
      if (pageIndex == 1) {
        FocusScope.of(context).requestFocus(passwordFocusNode);
      }
    });
  }

  void registerUser() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (!arePasswordsMatching(
        passwordController.text, confirmPasswordController.text)) {
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
      widget.onTap?.call();
    } else {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  bool isNextButtonEnabled() {
    if (!_pageController.hasClients) {
      return false;
    }

    final pageIndex = _pageController.page?.toInt() ?? 0;

    switch (pageIndex) {
      case 0:
        return isEmailValid(emailController.text);
      case 1:
        return isPasswordCriteriaMet && isPasswordMatching;
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
            onPressed: () {},
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
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildPage(
              context: context,
              title: "Qual é o seu email?",
              controller: emailController,
              hintText: "exemplo@email.com",
              buttonText: "Próximo",
              focusNode: emailFocusNode,
              keyboardType: TextInputType.emailAddress,
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
    required TextInputType keyboardType,
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
            keyboardType: keyboardType,
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 25),
          const Spacer(),
          CustomButton(
            text: buttonText,
            onTap: nextPage,
            isEnabled: isNextButtonEnabled(),
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
              isPasswordValid(value);
              setState(() {});
            },
          ),
          if (passwordErrorText.isNotEmpty) const SizedBox(height: 5),
          if (passwordErrorText.isNotEmpty)
            Text(
              passwordErrorText,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          if (!passwordErrorText.isNotEmpty) const SizedBox(height: 12),
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
              arePasswordsMatching(passwordController.text, value);
              setState(() {});
            },
          ),
          if (confirmPasswordErrorText.isNotEmpty)
            Text(
              confirmPasswordErrorText,
              style: const TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 15),
          CustomButton(
            text: buttonText,
            onTap: nextPage,
            isEnabled: isNextButtonEnabled(),
          ),
          const SizedBox(height: 10),
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
        ],
      ),
    );
  }
}
