import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/site_module/utilities/site_status.dart';
import 'package:echno_attendance/logger.dart';
import 'package:logger/logger.dart';

class SiteOffice {
  final logs = logger(SiteOffice, Level.info);
  final String siteOfficeName;
  final String siteAddress;
  final SiteStatus siteStatus;
  final double siteLongitude;
  final double siteLatitude;
  final double siteRadius;
  List<String> membersList;

  SiteOffice({
    required this.siteOfficeName,
    required this.siteAddress,
    required this.siteStatus,
    required this.siteLongitude,
    required this.siteLatitude,
    required this.siteRadius,
    required this.membersList,
  });

  factory SiteOffice.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SiteOffice(
      siteOfficeName: data['site-name'] ?? '',
      siteAddress: data['site-address'] ?? '',
      siteStatus: getSiteStatus(data['site-status']) ?? SiteStatus.upcoming,
      siteLongitude: data['site-longitude'] ?? 0.0,
      siteLatitude: data['site-latitude'] ?? 0.0,
      siteRadius: data['site-radius'] ?? 0.0,
      membersList: List<String>.from(data['employee-list']),
    );
  }

  factory SiteOffice.fromDocumentSnapshot(DocumentSnapshot doc) {
    if (!doc.exists) {
      throw ArgumentError("DocumentSnapshot doesn't exist");
    }

    final data = doc.data() as Map<String, dynamic>;

    final siteName = data['site-name'] ?? '';
    final siteAddress = data['site-address'] ?? '';
    final siteStatus =
        getSiteStatus(data['site-status']) ?? SiteStatus.upcoming;
    final siteLongitude = (data['site-longitude'] ?? 0.0) as double;
    final siteLatitude = (data['site-latitude'] ?? 0.0) as double;
    final siteRadius = (data['site-radius'] ?? 0.0) as double;
    final membersList = List<String>.from(data['employee-list'] ?? []);

    return SiteOffice(
      siteOfficeName: siteName,
      siteAddress: siteAddress,
      siteStatus: siteStatus,
      siteLongitude: siteLongitude,
      siteLatitude: siteLatitude,
      siteRadius: siteRadius,
      membersList: membersList,
    );
  }
}
