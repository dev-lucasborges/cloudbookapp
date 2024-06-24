import 'package:cloudbook/components/custom_button.dart';
import 'package:cloudbook/components/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class RegisterScreen extends StatelessWidget {
  final void Function()? onTap;

  RegisterScreen({super.key, required this.onTap});

  // controladores de texto
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // metodo de registro
  void register() {}

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
                "Criar",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nome Completo",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              CustomTextField(
                hintText: "Fulano de Tal",
                obscureText: false,
                controller: usernameController,
              ),

              const SizedBox(height: 12),

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

              // username textfield

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

              const SizedBox(height: 12),

              // confirm password text
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Confirmar Senha",
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
                controller: confirmPasswordController,
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
                text: "Criar",
                onTap: register,
              ),

              // dont have account
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Já tem uma conta?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      " Entrar",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
