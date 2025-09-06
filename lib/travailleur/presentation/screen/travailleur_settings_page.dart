// lib/presentation/travailleur/pages/travailleur_settings_page.dart (FIXED)
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/top_navbar.dart';
import '../../../demandeur/presentation/controllers/sidebar_controller.dart';
import '../../../demandeur/presentation/widget/universal_sidebar.dart';


class TravailleurSettingsPage extends StatefulWidget {
  const TravailleurSettingsPage({super.key});

  @override
  State<TravailleurSettingsPage> createState() => _TravailleurSettingsPageState();
}

class _TravailleurSettingsPageState extends State<TravailleurSettingsPage> {
  bool _instantBooking = false;
  bool _weekendAvailable = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _pushNotifications = true;
  String _hourlyRate = '2500';
  String _availability = 'Temps plein';
  List<String> _skills = ['Plomberie', 'Électricité', 'Réparation générale'];
  
  final List<String> _availabilityOptions = [
    'Temps plein',
    'Temps partiel',
    'Week-ends seulement',
    'Sur rendez-vous',
  ];

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
    
    // Use the safe update method that always defers the update
    Get.find<SidebarController>().updateCurrentRouteSafe(AppRoutes.travailleurSettings);
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
            userType: 'travailleur',
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paramètres travailleur',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Configurez votre profil professionnel et vos préférences',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Professional Profile
                  _buildSettingsCard(
                    title: 'Profil professionnel',
                    icon: Icons.work,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryGreen,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: const Text('Jean Dupont'),
                        subtitle: const Text('Technicien certifié - Note: 4.8/5'),
                        trailing: TextButton(
                          onPressed: () {
                            _showEditProfileDialog();
                          },
                          child: const Text('Modifier'),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.attach_money, color: AppTheme.accentYellow),
                        title: const Text('Tarif horaire'),
                        subtitle: Text('$_hourlyRate FCFA/heure'),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          _showRateDialog();
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Skills & Services
                  _buildSettingsCard(
                    title: 'Compétences et services',
                    icon: Icons.build,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mes compétences',
                                  style: theme.textTheme.titleMedium,
                                ),
                                TextButton.icon(
                                  onPressed: _addSkill,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Ajouter'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _skills.map((skill) => Chip(
                                label: Text(skill),
                                backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () {
                                  setState(() {
                                    _skills.remove(skill);
                                  });
                                },
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Availability Settings
                  _buildSettingsCard(
                    title: 'Disponibilité',
                    icon: Icons.schedule,
                    children: [
                      ListTile(
                        leading: Icon(Icons.access_time, color: AppTheme.primaryGreen),
                        title: const Text('Type de disponibilité'),
                        subtitle: Text(_availability),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          _showAvailabilityDialog();
                        },
                      ),
                      _buildSwitchTile(
                        title: 'Disponible le week-end',
                        subtitle: 'Recevoir des missions le samedi et dimanche',
                        value: _weekendAvailable,
                        onChanged: (value) {
                          setState(() {
                            _weekendAvailable = value;
                          });
                        },
                      ),
                      _buildSwitchTile(
                        title: 'Réservation instantanée',
                        subtitle: 'Les clients peuvent réserver directement sans validation',
                        value: _instantBooking,
                        onChanged: (value) {
                          setState(() {
                            _instantBooking = value;
                          });
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Notifications
                  _buildSettingsCard(
                    title: 'Notifications',
                    icon: Icons.notifications,
                    children: [
                      _buildSwitchTile(
                        title: 'Notifications email',
                        subtitle: 'Nouveaux clients, confirmations',
                        value: _emailNotifications,
                        onChanged: (value) {
                          setState(() {
                            _emailNotifications = value;
                          });
                        },
                      ),
                      _buildSwitchTile(
                        title: 'Notifications SMS',
                        subtitle: 'Missions urgentes uniquement',
                        value: _smsNotifications,
                        onChanged: (value) {
                          setState(() {
                            _smsNotifications = value;
                          });
                        },
                      ),
                      _buildSwitchTile(
                        title: 'Notifications push',
                        subtitle: 'Alertes en temps réel',
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
                  
                  // Payment & Billing
                  _buildSettingsCard(
                    title: 'Paiement et facturation',
                    icon: Icons.payment,
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_balance, color: AppTheme.primaryGreen),
                        title: const Text('Informations bancaires'),
                        subtitle: const Text('**** **** **** 1234'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to payment settings
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.receipt, color: AppTheme.accentYellow),
                        title: const Text('Historique des paiements'),
                        subtitle: const Text('Voir tous les paiements'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to payment history
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
                        subtitle: const Text('Mot de passe, authentification 2FA'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to security settings
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.help, color: AppTheme.mutedText),
                        title: const Text('Aide et support'),
                        subtitle: const Text('FAQ, contact support'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to help
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout, color: AppTheme.errorColor),
                        title: const Text('Se déconnecter'),
                        onTap: () {
                          _showLogoutDialog();
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
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
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

  void _showRateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le tarif'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Tarif horaire (FCFA)',
            suffixText: 'FCFA/heure',
          ),
          controller: TextEditingController(text: _hourlyRate),
          onChanged: (value) => _hourlyRate = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _showAvailabilityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Type de disponibilité'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _availabilityOptions.map((option) => RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _availability,
            onChanged: (value) {
              setState(() {
                _availability = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _addSkill() {
    showDialog(
      context: context,
      builder: (context) {
        String newSkill = '';
        return AlertDialog(
          title: const Text('Ajouter une compétence'),
          content: TextField(
            onChanged: (value) => newSkill = value,
            decoration: const InputDecoration(
              labelText: 'Nouvelle compétence',
              hintText: 'Ex: Menuiserie',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newSkill.isNotEmpty && !_skills.contains(newSkill)) {
                  setState(() {
                    _skills.add(newSkill);
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
              Get.offAllNamed('/signin');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}