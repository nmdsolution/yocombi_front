// lib/presentation/demandeur/pages/edit_demande_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/top_navbar.dart';
import '../../../core/routes/routes.dart';
import '../../../job-offers/domain/entities/job_offer.dart';
import '../../../job-offers/domain/entities/job_offer_request.dart';
import '../../../job-offers/providers/job_offer_provider.dart';
import '../../../service-categories/providers/service_category_provider.dart';
import '../controllers/sidebar_controller.dart';
import '../widget/universal_sidebar.dart';

class EditDemandePage extends StatefulWidget {
  final String jobOfferId;
  
  const EditDemandePage({
    super.key,
    required this.jobOfferId,
  });

  @override
  State<EditDemandePage> createState() => _EditDemandePageState();
}

class _EditDemandePageState extends State<EditDemandePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _estimatedPriceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  // Selected values for dropdowns
  String? _selectedCategoryId;
  String _selectedCurrency = 'XAF';
  String _selectedUrgency = 'medium';
  DateTime? _selectedDeadline;

  // Photos
  List<String> _photos = [];

  // Loading and data states
  bool _isLoading = true;
  bool _categoriesLoaded = false;
  JobOffer? _currentJobOffer;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadInitialData();
  }

  void _initControllers() {
    if (!Get.isRegistered<SidebarController>()) {
      Get.put(SidebarController());
    }
    // Update with appropriate route for edit
    Get.find<SidebarController>().updateCurrentRoute(AppRoutes.mesDemande);
  }

  Future<void> _loadInitialData() async {
    // Load both job offer data and categories in parallel
    await Future.wait([
      _loadJobOffer(),
      _loadCategories(),
    ]);
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadJobOffer() async {
    final provider = Provider.of<JobOfferProvider>(context, listen: false);
    
    // Try to get from cached data first
    _currentJobOffer = provider.getJobOfferById(widget.jobOfferId);
    
    // If not found in cache, fetch from API
    if (_currentJobOffer == null) {
      await provider.getJobOffer(widget.jobOfferId);
      if (provider.selectedJobOffer != null) {
        _currentJobOffer = provider.selectedJobOffer;
      }
    }

    if (_currentJobOffer != null) {
      _populateFormWithJobOfferData(_currentJobOffer!);
    } else if (mounted) {
      // Show error if job offer not found
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données de la demande.',
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back(); // Go back to previous page
    }
  }

  void _populateFormWithJobOfferData(JobOffer jobOffer) {
    _titleController.text = jobOffer.title;
    _descriptionController.text = jobOffer.description;
    _estimatedPriceController.text = jobOffer.estimatedPrice.toString();
    _locationController.text = jobOffer.location;
    _deadlineController.text = DateFormat('dd/MM/yyyy').format(jobOffer.deadline);
    
    _selectedCategoryId = jobOffer.categoryId;
    _selectedCurrency = jobOffer.currency;
    _selectedUrgency = jobOffer.urgency;
    _selectedDeadline = jobOffer.deadline;
    _photos = List.from(jobOffer.photos);
  }

  Future<void> _loadCategories() async {
    final categoryProvider = Provider.of<ServiceCategoryProvider>(context, listen: false);
    
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
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              onSurface: AppTheme.primaryGreen,
              surface: AppTheme.cardBackground,
            ),
            dialogBackgroundColor: AppTheme.cardBackground,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryGreen,
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

  void _removePhoto(String photoPath) {
    setState(() {
      _photos.remove(photoPath);
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final jobOfferProvider = Provider.of<JobOfferProvider>(context, listen: false);

      // Validation
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
        latitude: _currentJobOffer?.latitude ?? 0.0,
        longitude: _currentJobOffer?.longitude ?? 0.0,
        location: _locationController.text.trim(),
        photos: _photos,
        deadline: _selectedDeadline!,
        urgency: _selectedUrgency,
        // Don't change status during edit unless explicitly requested
        // status: _currentJobOffer?.status,
      );

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final success = await jobOfferProvider.updateJobOffer(widget.jobOfferId, request);

      // Dismiss loading indicator
      Get.back();

      if (success) {
        Get.snackbar(
          'Succès',
          'Votre demande a été modifiée avec succès.',
          backgroundColor: AppTheme.successColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back(); // Go back to previous page
      } else {
        Get.snackbar(
          'Erreur',
          jobOfferProvider.errorMessage.isNotEmpty
              ? jobOfferProvider.errorMessage
              : 'Échec de la modification de la demande. Veuillez réessayer.',
          backgroundColor: AppTheme.errorColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> _showPublishDialog() async {
    if (_currentJobOffer?.isDraft != true) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Publier la demande'),
        content: Text(
          'Voulez-vous publier "${_currentJobOffer?.title}" après l\'avoir modifiée ?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non, juste sauvegarder'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
            ),
            child: const Text('Oui, publier'),
          ),
        ],
      ),
    );

    if (result == true) {
      final provider = Provider.of<JobOfferProvider>(context, listen: false);
      final success = await provider.publishJobOffer(widget.jobOfferId);
      
      if (success && mounted) {
        Get.snackbar(
          'Succès',
          'Demande publiée avec succès.',
          backgroundColor: AppTheme.successColor,
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

    if (_isLoading) {
      return Scaffold(
        appBar: PageHeader(
          title: 'Modifier la Demande',
          showBackButton: true,
          showUserProfile: true,
          backgroundColor: Colors.white,
          titleColor: Colors.white,
          backButtonColor: AppTheme.primaryGreen,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: PageHeader(
        title: 'Modifier la Demande',
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
                  // Header with status info
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Modifier la Demande',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: isMediumScreen ? null : 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (_currentJobOffer != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(_currentJobOffer!.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _getStatusColor(_currentJobOffer!.status)),
                          ),
                          child: Text(
                            _getStatusLabel(_currentJobOffer!.status),
                            style: TextStyle(
                              color: _getStatusColor(_currentJobOffer!.status),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
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
                                if (!_categoriesLoaded && categoryProvider.isLoading) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                if (categoryProvider.hasError) {
                                  return _buildErrorSection(
                                    'Catégorie de service',
                                    categoryProvider.errorMessage,
                                    _loadCategories,
                                  );
                                }

                                final categories = categoryProvider.activeServiceCategories;
                                
                                if (categories.isEmpty) {
                                  return _buildInfoSection(
                                    'Catégorie de service',
                                    'Aucune catégorie disponible pour le moment.',
                                    _loadCategories,
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
                                  Get.snackbar(
                                    'Fonctionnalité à venir',
                                    'La sélection de localisation sur carte sera bientôt disponible.',
                                    backgroundColor: AppTheme.accentYellow,
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

                        // Action Buttons
                        Flex(
                          direction: isMediumScreen ? Axis.horizontal : Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _submitForm,
                              icon: const Icon(Icons.save),
                              label: const Text('Sauvegarder les Modifications'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                                textStyle: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27),
                                ),
                                elevation: 4,
                              ),
                            ),
                            if (isMediumScreen) const SizedBox(width: 16) else const SizedBox(height: 12),
                            if (_currentJobOffer?.isDraft == true)
                              OutlinedButton.icon(
                                onPressed: _showPublishDialog,
                                icon: const Icon(Icons.publish),
                                label: const Text('Sauvegarder et Publier'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.accentYellow,
                                  side: BorderSide(color: AppTheme.accentYellow),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                                  textStyle: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27),
                                  ),
                                ),
                              ),
                          ],
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

  // Helper methods for building form sections and fields
  Widget _buildFormSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
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
            border: Theme.of(context).inputDecorationTheme.border,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
            focusedErrorBorder: Theme.of(context).inputDecorationTheme.focusedErrorBorder,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            suffixIcon: suffixIcon,
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
            contentPadding: Theme.of(context).inputDecorationTheme.contentPadding,
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?)? onChanged,
    String? Function(T?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            border: Theme.of(context).inputDecorationTheme.border,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
            focusedErrorBorder: Theme.of(context).inputDecorationTheme.focusedErrorBorder,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: Theme.of(context).inputDecorationTheme.contentPadding,
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
          icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryGreen),
          dropdownColor: Theme.of(context).colorScheme.surface,
        ),
      ],
    );
  }

  Widget _buildErrorSection(String title, String errorMessage, VoidCallback onRetry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
                      errorMessage,
                      style: TextStyle(color: AppTheme.errorColor),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onRetry,
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

  Widget _buildInfoSection(String title, String message, VoidCallback onRetry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: onRetry,
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

  Widget _buildPhotoChip(String photoPath) {
    return Chip(
      avatar: const Icon(Icons.image, color: Colors.white, size: 18),
      label: Text(
        photoPath.split('/').last,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: AppTheme.primaryGreen,
      deleteIcon: const Icon(Icons.close, color: Colors.white, size: 18),
      onDeleted: () => _removePhoto(photoPath),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return AppTheme.mutedText;
      case 'published':
        return Colors.blue;
      case 'in_progress':
        return AppTheme.warningColor;
      case 'completed':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.mutedText;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return 'BROUILLON';
      case 'published':
        return 'PUBLIÉ';
      case 'in_progress':
        return 'EN COURS';
      case 'completed':
        return 'TERMINÉ';
      case 'cancelled':
        return 'ANNULÉ';
      default:
        return status.toUpperCase();
    }
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