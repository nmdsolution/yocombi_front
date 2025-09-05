// lib/presentation/demandeur/pages/mes_demande_page.dart (Responsive with Search)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/top_navbar.dart';
import '../../../core/routes/routes.dart';
import '../../../job-offers/domain/entities/job_offer.dart';
import '../../../job-offers/providers/job_offer_provider.dart';
import '../controllers/sidebar_controller.dart';
import '../widget/universal_sidebar.dart';

class MesDemandePage extends StatefulWidget {
  const MesDemandePage({super.key});

  @override
  State<MesDemandePage> createState() => _MesDemandePageState();
}

class _MesDemandePageState extends State<MesDemandePage> {
  final TextEditingController _searchController = TextEditingController();
  List<JobOffer> _filteredJobOffers = [];
  bool _isInitialized = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadJobOffers();
    });
  }

  void _initControllers() {
    if (!Get.isRegistered<SidebarController>()) {
      Get.put(SidebarController());
    }
    Get.find<SidebarController>().updateCurrentRoute(AppRoutes.mesDemande);
  }

  Future<void> _loadJobOffers() async {
    if (!mounted) return;
    
    final provider = Provider.of<JobOfferProvider>(context, listen: false);
    await provider.getMyJobOffers();
    
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
      _filterJobOffers();
    }
  }

  void _onSearchChanged() {
    if (mounted) {
      _filterJobOffers();
    }
  }

  void _filterJobOffers() {
    if (!mounted) return;
    
    final provider = Provider.of<JobOfferProvider>(context, listen: false);
    List<JobOffer> jobs = provider.myJobOffers;
    
    final searchQuery = _searchController.text.toLowerCase().trim();
    if (searchQuery.isNotEmpty) {
      jobs = jobs.where((job) {
        return job.title.toLowerCase().contains(searchQuery) ||
               job.description.toLowerCase().contains(searchQuery) ||
               job.location.toLowerCase().contains(searchQuery) ||
               (job.categoryName?.toLowerCase().contains(searchQuery) ?? false) ||
               job.categoryId.toLowerCase().contains(searchQuery);
      }).toList();
    }
    
    if (mounted) {
      setState(() {
        _filteredJobOffers = jobs;
        _isSearching = searchQuery.isNotEmpty;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _filterJobOffers();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWideScreen = MediaQuery.of(context).size.width > 1200;
    final isMediumScreen = MediaQuery.of(context).size.width > 768;
    
    return Scaffold(
      appBar: PageHeader(
        title: 'Mes Demandes',
        showBackButton: true,
        showUserProfile: true,
        backgroundColor: Colors.white,
        titleColor: AppTheme.primaryText,
        backButtonColor: AppTheme.primaryGreen,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isMediumScreen ? null : const UniversalSidebar(userType: 'demandeur'),
      body: Row(
        children: [
          // Sidebar - only show on medium+ screens
          if (isMediumScreen)
            const UniversalSidebar(userType: 'demandeur'),
          
          // Main Content
          Expanded(
            child: !_isInitialized
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.all(isMediumScreen ? 32 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with New Request Button
                        Flex(
                          direction: isMediumScreen ? Axis.horizontal : Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: isMediumScreen 
                              ? CrossAxisAlignment.center 
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mes Demandes',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontSize: isMediumScreen ? null : 24,
                              ),
                            ),
                            if (!isMediumScreen) const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => Get.toNamed(AppRoutes.newmDemande),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Nouvelle Demande'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        // Search Bar
                        _buildSearchBar(),
                        const SizedBox(height: 24),
                        
                        // Job Offers Table/List
                        _buildJobOffersContent(isMediumScreen, isWideScreen),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Rechercher par titre, description, localisation...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isSearching
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
          ),
        ),
      ),
    );
  }

  Widget _buildJobOffersContent(bool isMediumScreen, bool isWideScreen) {
    return Consumer<JobOfferProvider>(
      builder: (context, provider, child) {
        if (provider.hasError) {
          return _buildErrorCard(provider.errorMessage);
        }

        if (_filteredJobOffers.isEmpty) {
          return _buildEmptyCard();
        }

        // Use table for wide screens, cards for smaller screens
        return isWideScreen 
            ? _buildJobOffersTable()
            : _buildJobOffersCards();
      },
    );
  }

  Widget _buildErrorCard(String errorMessage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mutedText,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadJobOffers,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: AppTheme.mutedText,
            ),
            const SizedBox(height: 16),
            Text(
              _isSearching 
                  ? 'Aucune demande trouvée pour "${_searchController.text}"'
                  : 'Aucune demande trouvée',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.mutedText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _isSearching
                  ? 'Essayez avec d\'autres mots-clés'
                  : 'Créez votre première demande pour commencer',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mutedText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          /*  ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.newmDemande),
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle Demande'),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildJobOffersTable() {
    return Card(
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryText,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('Titre', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Catégorie', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Budget', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('Localisation', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Photos', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Date limite', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('Urgence', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Statut', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              ],
            ),
          ),
          
          // Table Body
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredJobOffers.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final jobOffer = _filteredJobOffers[index];
              return _buildJobOfferTableRow(jobOffer);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJobOfferTableRow(JobOffer jobOffer) {
    return InkWell(
      onTap: () => _showJobOfferDetails(jobOffer),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobOffer.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (jobOffer.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        jobOffer.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.mutedText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            
            // Category
            Expanded(
              flex: 2,
              child: Text(
                jobOffer.categoryName ?? jobOffer.categoryId,
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Budget
            Expanded(
              flex: 2,
              child: Text(
                '${jobOffer.estimatedPrice.toStringAsFixed(0)} ${jobOffer.currency}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            
            // Location
            Expanded(
              flex: 3,
              child: Text(
                jobOffer.location,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Photos
            Expanded(
              flex: 2,
              child: _buildPhotosPreview(jobOffer.photos),
            ),
            
            // Deadline
            Expanded(
              flex: 2,
              child: Text(
                _formatDate(jobOffer.deadline),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            
            // Urgency
            Expanded(
              flex: 1,
              child: _buildUrgencyChip(jobOffer.urgency),
            ),
            
            // Status
            Expanded(
              flex: 2,
              child: _buildStatusChip(jobOffer.status),
            ),
            
            // Actions
            Expanded(
              flex: 1,
              child: PopupMenuButton<String>(
                onSelected: (value) => _handleAction(value, jobOffer),
                itemBuilder: (context) => _buildActionMenu(jobOffer),
                child: const Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobOffersCards() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredJobOffers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final jobOffer = _filteredJobOffers[index];
        return _buildJobOfferCard(jobOffer);
      },
    );
  }

  Widget _buildJobOfferCard(JobOffer jobOffer) {
    return Card(
      child: InkWell(
        onTap: () => _showJobOfferDetails(jobOffer),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      jobOffer.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleAction(value, jobOffer),
                    itemBuilder: (context) => _buildActionMenu(jobOffer),
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Description
              if (jobOffer.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    jobOffer.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.mutedText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              
              // Info chips row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    Icons.category,
                    jobOffer.categoryName ?? jobOffer.categoryId,
                    AppTheme.primaryGreen,
                  ),
                  _buildInfoChip(
                    Icons.attach_money,
                    '${jobOffer.estimatedPrice.toStringAsFixed(0)} ${jobOffer.currency}',
                    AppTheme.accentYellow,
                  ),
                  _buildUrgencyChip(jobOffer.urgency),
                  _buildStatusChip(jobOffer.status),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Bottom row
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: AppTheme.mutedText),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      jobOffer.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.mutedText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.schedule, size: 16, color: AppTheme.mutedText),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(jobOffer.deadline),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ],
              ),
              
              // Photos preview
              if (jobOffer.photos.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Icon(Icons.photo, size: 16, color: AppTheme.mutedText),
                      const SizedBox(width: 4),
                      Text(
                        '${jobOffer.photos.length} photo(s)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosPreview(List<String> photos) {
    if (photos.isEmpty) {
      return const Text('Aucune photo', style: TextStyle(fontSize: 12, color: Colors.grey));
    }
    
    return Row(
      children: [
        ...photos.take(2).map((photo) => Container(
          margin: const EdgeInsets.only(right: 4),
          width: 40,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.withOpacity(0.3),
          ),
          child: const Icon(Icons.image, size: 16),
        )),
        if (photos.length > 2)
          Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey.withOpacity(0.3),
            ),
            child: Center(
              child: Text(
                '+${photos.length - 2}',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUrgencyChip(String urgency) {
    Color color;
    String label;
    
    switch (urgency.toLowerCase()) {
      case 'high':
        color = AppTheme.errorColor;
        label = 'Haute';
        break;
      case 'medium':
        color = AppTheme.warningColor;
        label = 'Moyenne';
        break;
      case 'low':
        color = AppTheme.successColor;
        label = 'Faible';
        break;
      default:
        color = AppTheme.mutedText;
        label = urgency;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    
    switch (status.toLowerCase()) {
      case 'draft':
        color = AppTheme.mutedText;
        label = 'BROUILLON';
        break;
      case 'published':
        color = Colors.blue;
        label = 'PUBLIÉ';
        break;
      case 'in_progress':
        color = AppTheme.warningColor;
        label = 'EN COURS';
        break;
      case 'completed':
        color = AppTheme.successColor;
        label = 'TERMINÉ';
        break;
      case 'cancelled':
        color = AppTheme.errorColor;
        label = 'ANNULÉ';
        break;
      default:
        color = AppTheme.mutedText;
        label = status.toUpperCase();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildActionMenu(JobOffer jobOffer) {
  return [
    const PopupMenuItem(
      value: 'view',
      child: Row(
        children: [
          Icon(Icons.visibility, size: 16),
          SizedBox(width: 8),
          Text('Voir'),
        ],
      ),
    ),
    // Only show edit for draft and published status
    if (jobOffer.isDraft || jobOffer.isPublished)
      const PopupMenuItem(
        value: 'edit',
        child: Row(
          children: [
            Icon(Icons.edit, size: 16),
            SizedBox(width: 8),
            Text('Modifier'),
          ],
        ),
      ),
    if (jobOffer.isDraft)
      const PopupMenuItem(
        value: 'publish',
        child: Row(
          children: [
            Icon(Icons.publish, size: 16),
            SizedBox(width: 8),
            Text('Publier'),
          ],
        ),
      ),
    if (!jobOffer.isCompleted && !jobOffer.isCancelled)
      const PopupMenuItem(
        value: 'cancel',
        child: Row(
          children: [
            Icon(Icons.cancel, size: 16),
            SizedBox(width: 8),
            Text('Annuler'),
          ],
        ),
      ),
    const PopupMenuItem(
      value: 'delete',
      child: Row(
        children: [
          Icon(Icons.delete, size: 16, color: Colors.red),
          SizedBox(width: 8),
          Text('Supprimer', style: TextStyle(color: Colors.red)),
        ],
      ),
    ),
  ];
}
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

void _handleAction(String action, JobOffer jobOffer) async {
  final provider = Provider.of<JobOfferProvider>(context, listen: false);
  
  switch (action) {
    case 'view':
      _showJobOfferDetails(jobOffer);
      break;
    case 'edit':
      // Navigate to the new edit page
      Get.toNamed('${AppRoutes.editDemande}/${jobOffer.id}');
      break;
    case 'publish':
      final success = await provider.publishJobOffer(jobOffer.id);
      if (success && mounted) {
        Get.snackbar(
          'Succès',
          'Demande publiée avec succès',
          backgroundColor: AppTheme.successColor,
          colorText: Colors.white,
        );
        _filterJobOffers();
      }
      break;
    case 'cancel':
      _showCancelDialog(jobOffer);
      break;
    case 'delete':
      _showDeleteDialog(jobOffer);
      break;
  }
}

  void _showJobOfferDetails(JobOffer jobOffer) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(jobOffer.title),
        content: SizedBox(
          width: isMobile ? double.maxFinite : 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(jobOffer.description),
                const SizedBox(height: 16),
                Text('Budget: ${jobOffer.estimatedPrice.toStringAsFixed(0)} ${jobOffer.currency}'),
                const SizedBox(height: 8),
                Text('Localisation: ${jobOffer.location}'),
                const SizedBox(height: 8),
                Text('Date limite: ${_formatDate(jobOffer.deadline)}'),
                const SizedBox(height: 8),
                Text('Statut: ${jobOffer.statusLabel ?? jobOffer.status}'),
                if (jobOffer.photos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Photos:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: jobOffer.photos.map((photo) => Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: const Icon(Icons.image, size: 20),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(JobOffer jobOffer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la demande'),
        content: Text('Êtes-vous sûr de vouloir annuler "${jobOffer.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = Provider.of<JobOfferProvider>(context, listen: false);
              final success = await provider.cancelJobOffer(jobOffer.id);
              if (success && mounted) {
                Get.snackbar(
                  'Succès',
                  'Demande annulée',
                  backgroundColor: AppTheme.warningColor,
                  colorText: Colors.white,
                );
                _filterJobOffers();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warningColor),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(JobOffer jobOffer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la demande'),
        content: Text('Êtes-vous sûr de vouloir supprimer définitivement "${jobOffer.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = Provider.of<JobOfferProvider>(context, listen: false);
              final success = await provider.deleteJobOffer(jobOffer.id);
              if (success && mounted) {
                Get.snackbar(
                  'Succès',
                  'Demande supprimée',
                  backgroundColor: AppTheme.errorColor,
                  colorText: Colors.white,
                );
                _filterJobOffers();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}