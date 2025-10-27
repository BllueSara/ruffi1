class CategoryModel {
  final String name;
  final String displayName;
  final List<String> searchQueries;
  final String? iconPath;

  CategoryModel({
    required this.name,
    required this.displayName,
    required this.searchQueries,
    this.iconPath,
  });

  static List<CategoryModel> getDefaultCategories() {
    return [
      CategoryModel(
        name: 'all',
        displayName: 'الكل',
        searchQueries: [
          'فن اللامبالاة',
          'ثلاثية غرناطة',
          'العادات الذرية',
          'ابي الذي اكره',
          'عقدك النفسية سجنك الأبدي',
          'الطنطورية'
        ],
        iconPath: 'assets/icons/all.png',
      ),
      CategoryModel(
        name: 'novels',
        displayName: 'الروايات',
        searchQueries: ['ثلاثية غرناطة', 'الطنطورية'],
        iconPath: 'assets/icons/novels.png',
      ),
      CategoryModel(
        name: 'self_development',
        displayName: 'تطوير الذات',
        searchQueries: ['فن اللامبالاة', 'العادات الذرية'],
        iconPath: 'assets/icons/self_development.png',
      ),
      CategoryModel(
        name: 'psychology',
        displayName: 'علم النفس',
        searchQueries: ['ابي الذي اكره', 'عقدك النفسية سجنك الأبدي'],
        iconPath: 'assets/icons/psychology.png',
      ),
    ];
  }

  @override
  String toString() {
    return 'CategoryModel(name: $name, displayName: $displayName)';
  }
}
