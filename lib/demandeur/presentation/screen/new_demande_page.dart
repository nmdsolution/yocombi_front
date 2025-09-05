// lib/presentation/demandeur/pages/new_demande_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/top_navbar.dart';
import '../../../core/routes/routes.dart';
import '../../../job-offers/domain/entities/job_offer_request.dart';
import '../../../job-offers/providers/job_offer_provider.dart';
import '../../../service-categories/providers/service_category_provider.dart';
import '../controllers/sidebar_controller.dart';
import '../widget/universal_sidebar.dart';

class NewmDemandePage extends StatefulWidget {
  const NewmDemandePage({super.key});

  @override
  State<NewmDemandePage> createState() => _NewmDemandePageState();
}

class _NewmDemandePageState extends State<NewmDemandePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _estimatedPriceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  // Selected values for dropdowns
  String? _selectedCategoryId;
  String _selectedCurrency = 'XAF'; // Default currency
  String _selectedUrgency = 'medium'; // Default urgency
  DateTime? _selectedDeadline;

  // Placeholder for photos (for simplicity, we'll just store paths)
  final List<String> _photos = [];

  // Loading state for categories
  bool _categoriesLoaded = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadCategories();
  }

  void _initControllers() {
    if (!Get.isRegistered<SidebarController>()) {
      Get.put(SidebarController());
    }
    Get.find<SidebarController>().updateCurrentRoute(AppRoutes.newmDemande);
  }

  Future<void> _loadCategories() async {
    final categoryProvider = Provider.of<ServiceCategoryProvider>(context, listen: false);
    
    // Load active categories only if not already loaded
    if (!categoryProvider.hasActiveCategories || categoryProvider.hasError) {
      await categoryProvider.getActiveServiceCategories();
    }
    
    if (mounted) {
      setState(() {
        _categoriesLoaded = true;
      });
    }
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // 5 years from now
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryGreen, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: AppTheme.primaryGreen, // Body text color (changed from white)
              surface: AppTheme.cardBackground, // Calendar background
            ),
            dialogBackgroundColor: AppTheme.cardBackground, // Dialog background
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryGreen, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDeadline) {
      setState(() {
        _selectedDeadline = picked;
        _deadlineController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _addPhoto() {
    // In a real application, this would open an image picker
    // For now, we'll just add a placeholder string
    setState(() {
      _photos.add('path/to/photo_${_photos.length + 1}.jpg');
      Get.snackbar(
        'Photo ajoutée',
        'Une photo a été ajoutée (placeholder)',
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final jobOfferProvider = Provider.of<JobOfferProvider>(context, listen: false);

      // Basic validation for deadline and price
      if (_selectedDeadline == null || _selectedDeadline!.isBefore(DateTime.now())) {
        Get.snackbar(
          'Erreur de validation',
          'La date limite doit être dans le futur.',
          backgroundColor: AppTheme.errorColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final estimatedPrice = double.tryParse(_estimatedPriceController.text);
      if (estimatedPrice == null || estimatedPrice <= 0) {
        Get.snackbar(
          'Erreur de validation',
          'Le budget estimé doit être un nombre positif.',
          backgroundColor: AppTheme.errorColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final request = JobOfferRequest(
        categoryId: _selectedCategoryId!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        estimatedPrice: estimatedPrice,
        currency: _selectedCurrency,
        latitude: 0.0, // Placeholder, would come from a map picker
        longitude: 0.0, // Placeholder
        location: _locationController.text.trim(),
        photos: _photos,
        deadline: _selectedDeadline!,
        urgency: _selectedUrgency,
        status: 'draft', // Always create as draft initially
      );

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final success = await jobOfferProvider.createJobOffer(request);

      // Dismiss loading indicator
      Get.back();

      if (success) {
        Get.snackbar(
          'Succès',
          'Votre demande a été créée avec succès en tant que brouillon.',
          backgroundColor: AppTheme.successColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offNamed(AppRoutes.mesDemande); // Navigate back to my requests
      } else {
        Get.snackbar(
          'Erreur',
          jobOfferProvider.errorMessage.isNotEmpty
              ? jobOfferProvider.errorMessage
              : 'Échec de la création de la demande. Veuillez réessayer.',
          backgroundColor: AppTheme.errorColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMediumScreen = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: PageHeader(
        title: 'Nouvelle Demande',
        showBackButton: true,
        showUserProfile: true,
        backgroundColor: Colors.white,
        titleColor: Colors.white,
        backButtonColor: AppTheme.primaryGreen,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isMediumScreen ? null : const UniversalSidebar(userType: 'demandeur'),
      body: Row(
        children: [
          if (isMediumScreen)
            const UniversalSidebar(userType: 'demandeur'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMediumScreen ? 32 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Créer une Nouvelle Demande',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: isMediumScreen ? null : 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section: Détails de la Demande
                        _buildFormSection(
                          context,
                          title: 'Détails de la Demande',
                          children: [
                            Consumer<ServiceCategoryProvider>(
                              builder: (context, categoryProvider, child) {
                                // Show loading indicator if categories are being fetched
                                if (!_categoriesLoaded && categoryProvider.isLoading) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                // Show error message if failed to load categories
                                if (categoryProvider.hasError) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Catégorie de service',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppTheme.errorColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppTheme.errorColor),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.error, color: AppTheme.errorColor),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Erreur de chargement',
                                                    style: TextStyle(
                                                      color: AppTheme.errorColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    categoryProvider.errorMessage,
                                                    style: TextStyle(color: AppTheme.errorColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: _loadCategories,
                                              child: Text(
                                                'Réessayer',
                                                style: TextStyle(color: AppTheme.errorColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                // Build dropdown with loaded categories
                                final categories = categoryProvider.activeServiceCategories;
                                
                                if (categories.isEmpty) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Catégorie de service',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppTheme.accentYellow.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppTheme.accentYellow),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.info, color: AppTheme.accentYellow),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Aucune catégorie disponible pour le moment.',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: _loadCategories,
                                              child: Text(
                                                'Actualiser',
                                                style: TextStyle(color: AppTheme.accentYellow),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                return _buildDropdownField<String>(
                                  label: 'Catégorie de service',
                                  value: _selectedCategoryId,
                                  items: categories.map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category.id,
                                      child: Text(category.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategoryId = value;
                                    });
                                  },
                                  validator: (value) => value == null ? 'Veuillez sélectionner une catégorie' : null,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _titleController,
                              label: 'Titre de la demande',
                              hintText: 'Ex: Réparation de fuite d\'eau',
                              validator: (value) => value!.isEmpty ? 'Le titre est requis' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _descriptionController,
                              label: 'Description détaillée',
                              hintText: 'Décrivez le problème ou le service dont vous avez besoin...',
                              maxLines: 5,
                              validator: (value) => value!.isEmpty ? 'La description est requise' : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section: Budget et Localisation
                        _buildFormSection(
                          context,
                          title: 'Budget et Localisation',
                          children: [
                            Flex(
                              direction: isMediumScreen ? Axis.horizontal : Axis.vertical,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _estimatedPriceController,
                                    label: 'Budget estimé',
                                    hintText: 'Ex: 25000',
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) return 'Le budget est requis';
                                      if (double.tryParse(value) == null) return 'Veuillez entrer un nombre valide';
                                      if (double.parse(value) <= 0) return 'Le budget doit être supérieur à 0';
                                      return null;
                                    },
                                  ),
                                ),
                                if (isMediumScreen) const SizedBox(width: 16) else const SizedBox(height: 16),
                                Expanded(
                                  child: _buildDropdownField(
                                    label: 'Devise',
                                    value: _selectedCurrency,
                                    items: const [
                                      DropdownMenuItem(value: 'XAF', child: Text('XAF (FCFA)')),
                                      DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                                      DropdownMenuItem(value: 'EUR', child: Text('EUR (€)')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCurrency = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _locationController,
                              label: 'Localisation',
                              hintText: 'Ex: Quartier Petit Marché, Garoua',
                              validator: (value) => value!.isEmpty ? 'La localisation est requise' : null,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.map, color: AppTheme.primaryGreen),
                                onPressed: () {
                                  // TODO: Implement map picker
                                  Get.snackbar(
                                    'Fonctionnalité à venir',
                                    'La sélection de localisation sur carte sera bientôt disponible.',
                                    backgroundColor: AppTheme.accentYellow, // Use a warning/info color
                                    colorText: AppTheme.darkGreen,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section: Calendrier et Urgence
                        _buildFormSection(
                          context,
                          title: 'Calendrier et Urgence',
                          children: [
                            _buildTextField(
                              controller: _deadlineController,
                              label: 'Date limite',
                              hintText: 'Sélectionnez une date',
                              readOnly: true,
                              onTap: () => _selectDeadline(context),
                              validator: (value) {
                                if (value!.isEmpty) return 'La date limite est requise';
                                if (_selectedDeadline != null && _selectedDeadline!.isBefore(DateTime.now())) {
                                  return 'La date limite doit être dans le futur';
                                }
                                return null;
                              },
                              suffixIcon: Icon(Icons.calendar_today, color: AppTheme.primaryGreen),
                            ),
                            const SizedBox(height: 16),
                            _buildDropdownField(
                              label: 'Urgence',
                              value: _selectedUrgency,
                              items: const [
                                DropdownMenuItem(value: 'low', child: Text('Faible')),
                                DropdownMenuItem(value: 'medium', child: Text('Moyenne')),
                                DropdownMenuItem(value: 'high', child: Text('Haute')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedUrgency = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section: Photos
                        _buildFormSection(
                          context,
                          title: 'Photos (Optionnel)',
                          children: [
                            Text(
                              'Ajoutez des photos pour aider les travailleurs à mieux comprendre votre demande.',
                              style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.mutedText),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                ..._photos.map((photoPath) => _buildPhotoChip(photoPath)),
                                _buildAddPhotoButton(),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _submitForm,
                            icon: const Icon(Icons.send),
                            label: const Text('Créer la Demande'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentYellow,
                              foregroundColor: AppTheme.darkGreen,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              textStyle: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkGreen,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              ),
                              elevation: 4,
                              shadowColor: AppTheme.accentYellow.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildFormSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero, // Remove default card margin
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryGreen),
            ),
            const Divider(height: 24, thickness: 1, color: AppTheme.borderColor),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            // Apply theme's input decoration
            border: Theme.of(context).inputDecorationTheme.border,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
            focusedErrorBorder: Theme.of(context).inputDecorationTheme.focusedErrorBorder,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface, // Use surface color for input background
            suffixIcon: suffixIcon,
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
            contentPadding: Theme.of(context).inputDecorationTheme.contentPadding,
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white,),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T? value, // Make value nullable for initial state
    required List<DropdownMenuItem<T>> items,
    required void Function(T?)? onChanged,
    String? Function(T?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white,),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            // Apply theme's input decoration
            border: Theme.of(context).inputDecorationTheme.border,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
            focusedErrorBorder: Theme.of(context).inputDecorationTheme.focusedErrorBorder,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface, // Use surface color for input background
            contentPadding: Theme.of(context).inputDecorationTheme.contentPadding,
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white,),
          icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryGreen),
          dropdownColor: Theme.of(context).colorScheme.surface, // Dropdown menu background
        ),
      ],
    );
  }

  Widget _buildPhotoChip(String photoPath) {
    return Chip(
      avatar: const Icon(Icons.image, color: Colors.white, size: 18),
      label: Text(
        photoPath.split('/').last,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: AppTheme.primaryGreen,
      deleteIcon: const Icon(Icons.close, color: Colors.white, size: 18),
      onDeleted: () {
        setState(() {
          _photos.remove(photoPath);
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildAddPhotoButton() {
    return ActionChip(
      avatar: Icon(Icons.add_a_photo, color: AppTheme.primaryGreen),
      label: Text(
        'Ajouter une photo',
        style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w500),
      ),
      onPressed: _addPhoto,
      backgroundColor: AppTheme.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppTheme.primaryGreen.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedPriceController.dispose();
    _locationController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }
}