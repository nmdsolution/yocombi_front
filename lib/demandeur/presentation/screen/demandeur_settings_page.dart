// lib/presentation/demandeur/pages/demandeur_settings_page.dart (Updated)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/top_navbar.dart';
import '../../../core/routes/routes.dart';
import '../controllers/sidebar_controller.dart';
import '../widget/universal_sidebar.dart';

class DemandeurSettingsPage extends StatefulWidget {
  const DemandeurSettingsPage({super.key});

  @override
  State<DemandeurSettingsPage> createState() => _DemandeurSettingsPageState();
}

class _DemandeurSettingsPageState extends State<DemandeurSettingsPage> {
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _pushNotifications = true;
  bool _locationSharing = true;
  bool _autoAcceptOffers = false;
  String _preferredLanguage = 'Français';
  String _currency = 'FCFA';

  final List<String> _languages = ['Français', 'English', 'Español'];
  final List<String> _currencies = ['FCFA', 'EUR', 'USD'];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    // Initialize sidebar controller if not already done
    if (!Get.isRegistered<SidebarController>()) {
      Get.put(SidebarController());
    }
    
    // Update current route
    Get.find<SidebarController>().updateCurrentRoute(AppRoutes.demandeurSettings);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: PageHeader(
        title: 'Paramètres',
        showBackButton: true,
        showUserProfile: true,
        backgroundColor: Colors.white,
        titleColor: AppTheme.primaryText,
        backButtonColor: AppTheme.primaryGreen,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          // Universal Sidebar
          const UniversalSidebar(
            userType: 'demandeur',
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paramètres du compte',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gérez vos préférences et paramètres de compte',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Profile Settings
                  _buildSettingsCard(
                    title: 'Profil',
                    icon: Icons.person,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryGreen,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: const Text('Jean Dupont'),
                        subtitle: const Text('jean.dupont@email.com'),
                        trailing: TextButton(
                          onPressed: () {
                            _showEditProfileDialog();
                          },
                          child: const Text('Modifier'),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Notifications Settings
                  _buildSettingsCard(
                    title: 'Notifications',
                    icon: Icons.notifications,
                    children: [
                      _buildSwitchTile(
                        title: 'Notifications par email',
                        subtitle: 'Recevoir les mises à jour par email',
                        value: _emailNotifications,
                        onChanged: (value) {
                          setState(() {
                            _emailNotifications = value;
                          });
                        },
                      ),
                      _buildSwitchTile(
                        title: 'Notifications SMS',
                        subtitle: 'Recevoir les alertes par SMS',
                        value: _smsNotifications,
                        onChanged: (value) {
                          setState(() {
                            _smsNotifications = value;
                          });
                        },
                      ),
                      _buildSwitchTile(
                        title: 'Notifications push',
                        subtitle: 'Notifications dans l\'application',
                        value: _pushNotifications,
                        onChanged: (value) {
                          setState(() {
                            _pushNotifications = value;
                          });
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Privacy Settings
                  _buildSettingsCard(
                    title: 'Confidentialité',
                    icon: Icons.privacy_tip,
                    children: [
                      _buildSwitchTile(
                        title: 'Partage de localisation',
                        subtitle: 'Permettre aux travailleurs de voir votre position',
                        value: _locationSharing,
                        onChanged: (value) {
                          setState(() {
                            _locationSharing = value;
                          });
                        },
                      ),
                      _buildSwitchTile(
                        title: 'Acceptation automatique',
                        subtitle: 'Accepter automatiquement les offres correspondantes',
                        value: _autoAcceptOffers,
                        onChanged: (value) {
                          setState(() {
                            _autoAcceptOffers = value;
                          });
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Preferences
                  _buildSettingsCard(
                    title: 'Préférences',
                    icon: Icons.tune,
                    children: [
                      ListTile(
                        leading: Icon(Icons.language, color: AppTheme.primaryGreen),
                        title: const Text('Langue'),
                        subtitle: Text(_preferredLanguage),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          _showLanguageDialog();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.money, color: AppTheme.accentYellow),
                        title: const Text('Devise'),
                        subtitle: Text(_currency),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          _showCurrencyDialog();
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Account Management
                  _buildSettingsCard(
                    title: 'Gestion du compte',
                    icon: Icons.manage_accounts,
                    children: [
                      ListTile(
                        leading: Icon(Icons.security, color: AppTheme.primaryGreen),
                        title: const Text('Sécurité'),
                        subtitle: const Text('Changer le mot de passe, 2FA'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to security settings
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.download, color: AppTheme.mutedText),
                        title: const Text('Télécharger mes données'),
                        subtitle: const Text('Exporter vos informations'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          _showDataExportDialog();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete, color: AppTheme.errorColor),
                        title: const Text('Supprimer le compte'),
                        subtitle: const Text('Action irréversible'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          _showDeleteAccountDialog();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.primaryGreen),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le profil'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nom complet'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Téléphone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((lang) => RadioListTile<String>(
            title: Text(lang),
            value: lang,
            groupValue: _preferredLanguage,
            onChanged: (value) {
              setState(() {
                _preferredLanguage = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la devise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _currencies.map((currency) => RadioListTile<String>(
            title: Text(currency),
            value: currency,
            groupValue: _currency,
            onChanged: (value) {
              setState(() {
                _currency = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showDataExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exporter les données'),
        content: const Text(
          'Vos données seront préparées et envoyées par email dans un délai de 48h.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar(
                'Demande envoyée',
                'Vous recevrez vos données par email',
                backgroundColor: AppTheme.successColor,
                colorText: Colors.white,
              );
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Cette action est irréversible. Toutes vos données seront supprimées définitivement.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
