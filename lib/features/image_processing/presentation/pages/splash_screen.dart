import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildPage(
            title: 'Modifier une Image',
            description:
                'Importez ou capturez une image, puis appliquez des filtres, ajustez la luminosité, le contraste, etc.',
            image: 'assets/image_edit.jpeg',
          ),
          _buildPage(
            title: 'Profil',
            description:
                'Gérez votre profil utilisateur, accédez aux paramètres personnels, et visualisez vos statistiques d\'édition.',
            image: 'assets/profile.png',
          ),
          _buildPage(
            title: 'Images Modifiées',
            description:
                'Affichez toutes les images modifiées et enregistrées dans l\'application.',
            image: 'assets/modified_images.png',
          ),
          _buildPage(
            title: 'Images Non Modifiées',
            description:
                'Consultez toutes les images importées mais non encore modifiées.',
            image: 'assets/modified_images.png',
            isLastPage: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required String image,
    bool isLastPage = false,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(image, height: 250),
              const SizedBox(height: 40),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              if (isLastPage) const SizedBox(height: 40),
              if (isLastPage)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Commencer'),
                ),
            ],
          ),
        ),
        if (!isLastPage)
          Positioned(
            top: 30,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Passer', style: TextStyle(fontSize: 16)),
            ),
          ),
      ],
    );
  }
}
