import 'package:cloudbook/components/custom_button.dart';
import 'package:cloudbook/components/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class LoginScreen extends StatelessWidget {
  final void Function()? onTap;

  LoginScreen({super.key, required this.onTap});

  // controladores de texto
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // metodo de login
  void login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // app name
              const Text(
                "Entrar",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              // email textfield
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              CustomTextField(
                hintText: "exemplo@email.com",
                obscureText: false,
                controller: emailController,
              ),

              const SizedBox(height: 17),

              // password text

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Senha",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              CustomTextField(
                hintText: "••••••••••••",
                obscureText: true,
                controller: passwordController,
              ),

              // forgot password

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Esqueceu sua senha?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),

              // sign in button
              const SizedBox(height: 25),

              CustomButton(
                text: "Entrar",
                onTap: login,
              ),

              // dont have account
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Não tem uma conta?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      " Crie uma",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
