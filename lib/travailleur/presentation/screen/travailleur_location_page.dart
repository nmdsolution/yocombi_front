// lib/presentation/travailleur/pages/travailleur_location_page.dart (FIXED)
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/top_navbar.dart';
import '../../../demandeur/presentation/controllers/sidebar_controller.dart';
import '../../../demandeur/presentation/widget/universal_sidebar.dart';

class TravailleurLocationPage extends StatefulWidget {
  const TravailleurLocationPage({super.key});

  @override
  State<TravailleurLocationPage> createState() => _TravailleurLocationPageState();
}

class _TravailleurLocationPageState extends State<TravailleurLocationPage> {
  bool _isOnline = true;
  bool _autoUpdateLocation = true;
  String _currentLocation = 'Douala, Bonanjo';
  String _workRadius = '10 km';
  List<String> _serviceAreas = ['Douala', 'Yaoundé', 'Bafoussam'];

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
    Get.find<SidebarController>().updateCurrentRouteSafe(AppRoutes.travailleurLocation);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: PageHeader(
        title: 'Localisation',
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
                    'Gestion de localisation',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mettez à jour votre position pour recevoir des missions près de vous',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _isOnline ? AppTheme.successColor : AppTheme.mutedText,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _isOnline ? 'En ligne' : 'Hors ligne',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: _isOnline ? AppTheme.successColor : AppTheme.mutedText,
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                value: _isOnline,
                                onChanged: (value) {
                                  setState(() {
                                    _isOnline = value;
                                  });
                                  _updateOnlineStatus(value);
                                },
                                activeColor: AppTheme.successColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isOnline 
                                ? 'Vous êtes visible aux clients et pouvez recevoir des missions'
                                : 'Vous n\'êtes pas visible aux clients',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Current Location
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppTheme.primaryGreen,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Position actuelle',
                                style: theme.textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.my_location,
                                  color: AppTheme.primaryGreen,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _currentLocation,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.verified,
                                  color: AppTheme.successColor,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: _autoUpdateLocation,
                                onChanged: (value) {
                                  setState(() {
                                    _autoUpdateLocation = value!;
                                  });
                                },
                                activeColor: AppTheme.primaryGreen,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Mise à jour automatique de la position',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    _updateCurrentLocation();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Actualiser position'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showLocationPicker();
                                  },
                                  icon: const Icon(Icons.edit_location),
                                  label: const Text('Modifier manuellement'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Work Radius
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.radar,
                                color: AppTheme.accentYellow,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Rayon de travail',
                                style: theme.textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Distance maximale pour recevoir des missions: $_workRadius',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.mutedText,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildRadiusSelector(),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Service Areas
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.map,
                                    color: AppTheme.mutedText,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Zones de service',
                                    style: theme.textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              TextButton.icon(
                                onPressed: _addServiceArea,
                                icon: const Icon(Icons.add),
                                label: const Text('Ajouter'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ..._serviceAreas.map((area) => _buildServiceAreaTile(area)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusSelector() {
    final radii = ['2 km', '5 km', '10 km', '15 km', '25 km', '50 km'];
    
    return Wrap(
      spacing: 8,
      children: radii.map((radius) => ChoiceChip(
        label: Text(radius),
        selected: _workRadius == radius,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _workRadius = radius;
            });
          }
        },
        selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
        labelStyle: TextStyle(
          color: _workRadius == radius ? AppTheme.primaryGreen : AppTheme.mutedText,
        ),
      )).toList(),
    );
  }

  Widget _buildServiceAreaTile(String area) {
    return ListTile(
      leading: Icon(
        Icons.location_city,
        color: AppTheme.primaryGreen,
      ),
      title: Text(area),
      trailing: IconButton(
        onPressed: () {
          setState(() {
            _serviceAreas.remove(area);
          });
        },
        icon: Icon(
          Icons.remove_circle,
          color: AppTheme.errorColor,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _updateOnlineStatus(bool isOnline) {
    Get.snackbar(
      isOnline ? 'En ligne' : 'Hors ligne',
      isOnline 
          ? 'Vous êtes maintenant visible aux clients'
          : 'Vous n\'êtes plus visible aux clients',
      backgroundColor: isOnline ? AppTheme.successColor : AppTheme.mutedText,
      colorText: Colors.white,
    );
  }

  void _updateCurrentLocation() async {
    // Simulate location update
    setState(() {
      _currentLocation = 'Douala, Akwa - Position mise à jour';
    });
    
    Get.snackbar(
      'Position actualisée',
      'Votre localisation a été mise à jour',
      backgroundColor: AppTheme.successColor,
      colorText: Colors.white,
    );
  }

  void _showLocationPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la position'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Nouvelle adresse',
            hintText: 'Entrez votre adresse...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateCurrentLocation();
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _addServiceArea() {
    showDialog(
      context: context,
      builder: (context) {
        String newArea = '';
        return AlertDialog(
          title: const Text('Ajouter une zone'),
          content: TextField(
            onChanged: (value) => newArea = value,
            decoration: const InputDecoration(
              labelText: 'Nom de la ville/zone',
              hintText: 'Ex: Bafoussam',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newArea.isNotEmpty && !_serviceAreas.contains(newArea)) {
                  setState(() {
                    _serviceAreas.add(newArea);
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
}