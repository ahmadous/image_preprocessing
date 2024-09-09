import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../image_processing/presentation/providers/image_processor_provider.dart';
import '../../../image_processing/presentation/pages/image_editing_page.dart';
import '../widgets/saved_images_grid.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final imageProcessor =
        Provider.of<ImageProcessorProvider>(context, listen: false);
    imageProcessor.loadSavedImages();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Toggle light/dark theme or apply other theme-related actions
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePageContent(context, imageProcessor),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.teal,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageEditingPage()),
                );
              },
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add_a_photo),
            )
          : null,
    );
  }

  Widget _buildHomePageContent(
      BuildContext context, ImageProcessorProvider imageProcessor) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            _buildActionGrid(context),
            const SizedBox(height: 20),
            _buildSectionTitle('Images modifiées récemment:'),
            const SizedBox(height: 10),
            _buildImageGrid(context, true),
            const SizedBox(height: 20),
            _buildSectionTitle('Images non modifiées:'),
            const SizedBox(height: 10),
            _buildImageGrid(context, false),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      color: Colors.teal,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Bienvenue!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Choisissez une option ci-dessous pour commencer:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildActionCard(
          context,
          icon: Icons.edit,
          label: 'Modifier une Image',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageEditingPage()),
            );
          },
        ),
        _buildActionCard(
          context,
          icon: Icons.person,
          label: 'Profil',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Card(
      color: Colors.teal.shade400,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context, bool isModified) {
    return FutureBuilder(
      future: Provider.of<ImageProcessorProvider>(context, listen: false)
          .loadSavedImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SavedImagesGrid(isModified: isModified);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
