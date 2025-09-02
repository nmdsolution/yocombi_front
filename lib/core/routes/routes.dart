// lib/core/routes/routes.dart
class AppRoutes {
  static const home = '/home';
  static const splash = '/splash';
  static const signin = '/signin';
  static const signupForm = '/signup-form';
  static const completeRegistration = '/complete-registration';
  static const forgotPassword = '/forgot-password';
  static const user = '/user';
  static const profile = '/profile';
  
  // Travailleur (Worker) Dashboard Routes
  static const travailleurDashboard = '/travailleur/dashboard';
  static const travailleurMissions = '/travailleur/missions';
  static const travailleurNewMission = '/travailleur/new-mission';
  static const travailleurLocation = '/travailleur/location';
  static const travailleurSettings = '/travailleur/settings';
  
  // Demandeur (Requester) Dashboard Routes
  static const demandeurDashboard = '/demandeur/dashboard';
  static const newmDemande = '/demandeur/newmDemande';
  static const mesDemande = '/demandeur/mesDemande';
  static const broullion= '/demandeur/broullion';
  static const demandeurSettings = '/demandeur/settings';
  
  // Legacy route for backward compatibility
  static const dashboard = '/dashboard'; // Keep for backward compatibility, redirects to travailleur
  
  // Job Offers Routes
  static const jobOffers = '/job-offers';
  static const jobOffersCreate = '/job-offers/create';
  static const jobOffersDetail = '/job-offers/:id';
  static const jobOffersEdit = '/job-offers/:id/edit';
  static const jobOffersSearch = '/job-offers/search';
  static const jobOffersFeatured = '/job-offers/featured';
  static const jobOffersRecent = '/job-offers/recent';
  static const jobOffersByCategory = '/job-offers/category/:categoryId';
  static const jobOffersByLocation = '/job-offers/location';
  
  // User Job Offers Routes (My Job Offers)
  static const myJobOffers = '/job-offers/my-jobs';
  static const myJobOffersDrafts = '/job-offers/my-jobs/drafts';
  static const myJobOffersPublished = '/job-offers/my-jobs/published';
  static const myJobOffersInProgress = '/job-offers/my-jobs/in-progress';
  static const myJobOffersCompleted = '/job-offers/my-jobs/completed';
  static const myJobOffersCancelled = '/job-offers/my-jobs/cancelled';
  
  // Job Offer Management Routes
  static const jobOffersManagement = '/job-offers/management';
  static const jobOffersStatistics = '/job-offers/statistics';
  static const jobOffersPublicStats = '/job-offers/public-stats';
  
  // Service Categories Routes (existing)
  static const serviceCategories = '/service-categories';
  static const serviceCategoriesCreate = '/service-categories/create';
  static const serviceCategoriesEdit = '/service-categories/:id/edit';
  
  // Helper methods for dynamic routes
  static String jobOfferDetail(String id) => '/job-offers/$id';
  static String jobOfferEdit(String id) => '/job-offers/$id/edit';
  static String serviceCategoryEdit(String id) => '/service-categories/$id/edit';
}