import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<JobOffer> _jobOffers = [];
  List<ServiceCategory> _serviceCategories = [];
  List<ServiceStat> _serviceStats = [];
  List<BlogPost> _blogPosts = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<JobOffer> get jobOffers => _jobOffers;
  List<ServiceCategory> get serviceCategories => _serviceCategories;
  List<ServiceStat> get serviceStats => _serviceStats;
  List<BlogPost> get blogPosts => _blogPosts;

  // Load sample data - matching HTML exactly
  Future<void> loadData() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

      _loadJobOffers();
      _loadServiceCategories();
      _loadServiceStats();
      _loadBlogPosts();

      _setLoading(false);
    } catch (e) {
      _errorMessage = 'Failed to load data: ${e.toString()}';
      _setLoading(false);
    }
  }

  void _loadJobOffers() {
    // Exact data from HTML
    _jobOffers = [
      JobOffer(
        id: '1',
        title: 'Plumbing Service',
        price: 10000,
        description: 'Professional plumbing repair and installation services',
        category: 'Plumbing',
      ),
      JobOffer(
        id: '2',
        title: 'House Cleaning',
        price: 8000,
        description: 'Complete house cleaning and maintenance service',
        category: 'Cleaning',
      ),
      JobOffer(
        id: '3',
        title: 'Delivery Service',
        price: 5000,
        description: 'Fast and reliable delivery service within the city',
        category: 'Delivery',
      ),
    ];
  }

  void _loadServiceCategories() {
    // Exact categories from HTML in same order
    _serviceCategories = [
      ServiceCategory(
        id: '1',
        name: 'Plumbing',
        icon: Icons.plumbing_outlined, // Using closest Flutter icon
        count: 15,
      ),
      ServiceCategory(
        id: '2',
        name: 'Cleaning',
        icon: Icons.cleaning_services_outlined,
        count: 23,
      ),
      ServiceCategory(
        id: '3',
        name: 'Delivery',
        icon: Icons.local_shipping_outlined,
        count: 18,
      ),
      ServiceCategory(
        id: '4',
        name: 'Gardening',
        icon: Icons.eco_outlined, // Using eco for tree icon
        count: 12,
      ),
      ServiceCategory(
        id: '5',
        name: 'Electrical',
        icon: Icons.electrical_services_outlined,
        count: 9,
      ),
      ServiceCategory(
        id: '6',
        name: 'Carpentry',
        icon: Icons.handyman_outlined,
        count: 14,
      ),
      ServiceCategory(
        id: '7',
        name: 'Painting',
        icon: Icons.format_paint_outlined,
        count: 11,
      ),
      ServiceCategory(
        id: '8',
        name: 'AC Repair',
        icon: Icons.ac_unit_outlined,
        count: 7,
      ),
    ];
  }

  void _loadServiceStats() {
    // Exact stats from HTML with same percentages and order
    _serviceStats = [
      ServiceStat(name: 'Cleaning', percentage: 70),
      ServiceStat(name: 'Plumbing', percentage: 85),
      ServiceStat(name: 'Delivery', percentage: 60),
      ServiceStat(name: 'Electrical', percentage: 45),
      ServiceStat(name: 'Gardening', percentage: 55),
    ];
  }

  void _loadBlogPosts() {
    // Exact blog posts from HTML
    _blogPosts = [
      BlogPost(
        id: '1',
        title: 'How to Choose the Right Plumber',
        description: '5 tips to ensure quality service',
        content: '',
        author: 'YoCombi Team',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      BlogPost(
        id: '2',
        title: 'Home Cleaning Checklist',
        description: 'Essential daily tasks',
        content: '',
        author: 'YoCombi Team',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      BlogPost(
        id: '3',
        title: 'Safe Delivery Practices',
        description: 'Protecting your packages',
        content: '',
        author: 'YoCombi Team',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadData();
  }

  // Search functionality
  List<JobOffer> searchJobOffers(String query) {
    if (query.isEmpty) return _jobOffers;

    return _jobOffers.where((job) =>
        job.title.toLowerCase().contains(query.toLowerCase()) ||
        job.description.toLowerCase().contains(query.toLowerCase()) ||
        job.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Filter by category
  List<JobOffer> filterByCategory(String category) {
    return _jobOffers.where((job) =>
        job.category.toLowerCase() == category.toLowerCase()
    ).toList();
  }

  // Get popular services
  List<ServiceCategory> getPopularServices() {
    return _serviceCategories
        .where((category) => category.count > 15)
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// Data Models - keeping same structure
class JobOffer {
  final String id;
  final String title;
  final int price;
  final String description;
  final String category;

  JobOffer({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
    };
  }

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;
  final int count;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.count,
  });
}

class ServiceStat {
  final String name;
  final int percentage;

  ServiceStat({
    required this.name,
    required this.percentage,
  });
}

class BlogPost {
  final String id;
  final String title;
  final String description;
  final String content;
  final String author;
  final DateTime createdAt;

  BlogPost({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}