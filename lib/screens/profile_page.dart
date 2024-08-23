import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/profile-background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Botão de voltar
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Ionicons.chevron_back),
                              color: Theme.of(context).iconTheme.color,
                              iconSize: 17,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          // Botão de menu
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Ionicons.ellipsis_horizontal),
                              color: Theme.of(context).iconTheme.color,
                              iconSize: 17,
                              onPressed: () {
                                // Implement your second button logic here
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile-dark.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Lucas Borges',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Professor',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
