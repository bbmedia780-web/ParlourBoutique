enum BusinessType { parlour, boutique }

enum GenderType { male, female,other }

/// Parlour-only service type shown under the business name on the header
/// Boutique businesses should not use this
enum ParlourServiceType { homeService, parlourService }

extension ParlourServiceTypeLabel on ParlourServiceType {
  String get label => this == ParlourServiceType.homeService
      ? 'Home service'
      : 'Parlour service';
}
