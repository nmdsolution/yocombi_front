// lib/presentation/demandeur/pages/published_demandes_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/top_navbar.dart';
import '../../../job-offers/domain/entities/job_offer.dart';
import '../../../job-offers/providers/job_offer_provider.dart';
import '../controllers/sidebar_controller.dart';
import '../widget/universal_sidebar.dart';

class PublishedDemandesPage extends StatefulWidget {
  const PublishedDemandesPage({super.key});

  @override
  State<PublishedDemandesPage> createState() => _PublishedDemandesPageState();
}

class _PublishedDemandesPageState extends State<PublishedDemandesPage> {
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
    // Only get published job offers
    List<JobOffer> jobs = provider.myPublishedJobs;
    
    final searchQuery = _searchController.text.toLowerCase().trim();
    if (searchQuery.isNotEmpty) {
      jobs = jobs.where((job) {
        return job.title.toLowerCase().contains(searchQuery) ||
               job.description.toLowerCase().contains(searchQuery) ||
               job.location.toLowerCase().contains(searchQuery) ||
               (job.categoryName?.toLowerCase().contains(searchQuery) ?? false);
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
        title: 'Demandes Publiées',
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
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Mes Demandes Publiées',
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  fontSize: isMediumScreen ? null : 24,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue),
                              ),
                              child: Text(
                                '${_filteredJobOffers.length} demande(s)',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        // Search Bar
                        _buildSearchBar(),
                        const SizedBox(height: 24),
                        
                        // Job Offers Content
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
            hintText: 'Rechercher dans vos demandes publiées...',
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

        // Use cards for better readability (no edit actions needed)
        return _buildJobOffersCards();
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
              Icons.publish,
              size: 64,
              color: AppTheme.mutedText,
            ),
            const SizedBox(height: 16),
            Text(
              _isSearching 
                  ? 'Aucune demande publiée trouvée pour "${_searchController.text}"'
                  : 'Aucune demande publiée',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.mutedText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _isSearching
                  ? 'Essayez avec d\'autres mots-clés'
                  : 'Publiez vos demandes pour qu\'elles apparaissent ici',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mutedText,
              ),
              textAlign: TextAlign.center,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      jobOffer.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          'PUBLIÉ',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Description
              if (jobOffer.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    jobOffer.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.mutedText,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              
              // Info section
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      Icons.category,
                      jobOffer.categoryName ?? jobOffer.categoryId,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoRow(
                      Icons.attach_money,
                      jobOffer.formattedPrice,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      Icons.location_on,
                      jobOffer.location,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoRow(
                      Icons.schedule,
                      _formatDate(jobOffer.deadline),
                    ),
                  ),
                ],
              ),
              
              // Additional info
              if (jobOffer.photos.isNotEmpty || jobOffer.applicationsCount > 0) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (jobOffer.photos.isNotEmpty)
                      Expanded(
                        child: _buildInfoRow(
                          Icons.photo_library,
                          '${jobOffer.photos.length} photo(s)',
                        ),
                      ),
                    if (jobOffer.applicationsCount > 0)
                      Expanded(
                        child: _buildInfoRow(
                          Icons.people,
                          '${jobOffer.applicationsCount} candidature(s)',
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                  ],
                ),
              ],
              
              // Urgency indicator
              const SizedBox(height: 16),
              _buildUrgencyChip(jobOffer.urgency),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(
          icon, 
          size: 16, 
          color: color ?? AppTheme.mutedText,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: color ?? AppTheme.mutedText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
        label = 'Urgence Élevée';
        break;
      case 'medium':
        color = AppTheme.warningColor;
        label = 'Urgence Moyenne';
        break;
      case 'low':
        color = AppTheme.successColor;
        label = 'Urgence Faible';
        break;
      default:
        color = AppTheme.mutedText;
        label = urgency;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showJobOfferDetails(JobOffer jobOffer) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(jobOffer.title)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'PUBLIÉ',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: isMobile ? double.maxFinite : 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(jobOffer.description),
                const SizedBox(height: 16),
                
                Text('Budget: ${jobOffer.formattedPrice}'),
                const SizedBox(height: 8),
                Text('Localisation: ${jobOffer.location}'),
                const SizedBox(height: 8),
                Text('Date limite: ${_formatDate(jobOffer.deadline)}'),
                const SizedBox(height: 8),
                Text('Catégorie: ${jobOffer.categoryName ?? jobOffer.categoryId}'),
                
                if (jobOffer.applicationsCount > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Candidatures: ${jobOffer.applicationsCount}',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                
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

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}