import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          _buildHeader(),
          SizedBox(height: 20),
          _buildSettings(context),
          SizedBox(height: 20),
          _buildHelpAndSupport(context),
          SizedBox(height: 20),
          _buildRecentActivities(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.teal,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                AssetImage('assets/profile.png'), // Image de profil
          ),
          SizedBox(height: 10),
          Text(
            'Nom d\'utilisateur',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'email@example.com',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.edit, color: Colors.teal),
            title: Text('Modifier le profil'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Logique pour modifier le profil
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.teal),
            title: Text('Paramètres'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Logique pour accéder aux paramètres
            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.teal),
            title: Text('Changer le mot de passe'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Logique pour changer le mot de passe
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpAndSupport(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.teal),
            title: Text('Centre d\'aide'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Logique pour accéder au centre d'aide
            },
          ),
          ListTile(
            leading: Icon(Icons.email, color: Colors.teal),
            title: Text('Contactez-nous'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Logique pour contacter le support
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            title: Text('Historique des modifications récentes',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          _buildActivityItem('Modification d\'image',
              'assets/modified_images.png', '02 Février 2024'),
          _buildActivityItem('Modification d\'image',
              'assets/modified_images.png', '30 Janvier 2024'),
          // Ajouter plus d'éléments ici
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      String activityName, String imagePath, String date) {
    return ListTile(
      leading: Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(activityName),
      subtitle: Text(date),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Logique pour afficher les détails de l'activité
      },
    );
  }
}
