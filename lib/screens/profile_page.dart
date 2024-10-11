import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>?> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  void _showMoreInfo(BuildContext context, Map<String, dynamic> userData) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow("Nome completo", userData['fullName']),
              _buildInfoRow("Nome de exibição", userData['displayName']),
              _buildInfoRow(
                  "É independente", userData['isIndependent'] ? "Sim" : "Não"),
              _buildInfoRow("ID da escola", userData['schoolsUID']),
              _buildInfoRow("Turmas", userData['classes'].join(', ')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(
              child: Text("Erro ao carregar os dados do usuário"));
        }

        final userData = snapshot.data!;
        final userName = userData['fullName'] ?? 'Usuário';

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage('assets/profile-background.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildIconButton(
                                    context,
                                    Ionicons.chevron_back,
                                    () => Navigator.pop(context),
                                  ),
                                  _buildIconButton(
                                    context,
                                    Ionicons.ellipsis_horizontal,
                                    () => _showMoreInfo(context, userData),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                                border:
                                    Border.all(color: Colors.white, width: 2.0),
                              ),
                            ),
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/profile-dark.png'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 55),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoIcon(
                          context, Ionicons.location_outline, 'RJ, Macaé'),
                      const SizedBox(width: 15),
                      _buildInfoIcon(context, Ionicons.gift_outline, '18 anos'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Analytics'),
                  const SizedBox(height: 10),
                  _buildAnalyticsCard(context),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Histórico'),
                  const SizedBox(height: 10),
                  _buildHistoryScroll(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 17),
        color: Theme.of(context).iconTheme.color,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildInfoIcon(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnalyticsItem("32", "Chamadas", Colors.grey),
          const SizedBox(width: 20),
          const SizedBox(
            width: 20,
            height: 105,
            child: VerticalDivider(color: Colors.grey),
          ),
          const SizedBox(width: 20),
          _buildAnalyticsItem("128", "Economizados", Colors.green,
              subtitle: "minutos"),
        ],
      ),
    );
  }

  Widget _buildAnalyticsItem(String value, String label, Color labelColor,
      {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w500),
            ),
            if (subtitle != null) ...[
              const SizedBox(width: 5),
              Text(
                subtitle,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
        Text(
          label,
          style: TextStyle(color: labelColor, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildHistoryScroll() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _buildHistoryCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(15),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Ionicons.document_text_outline,
            size: 60,
          ),
          SizedBox(height: 5),
          Text(
            "Chamada",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            "07:21 • 12/09/2021",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
