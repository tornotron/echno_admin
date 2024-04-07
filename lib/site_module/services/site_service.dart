import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/site_module/utilities/site_status.dart';
import 'package:echno_attendance/site_module/domain/firestore/firestore_site_handler.dart';
import 'package:echno_attendance/site_module/domain/firestore/site_handler.dart';

class SiteService implements SiteHandler {
  final SiteHandler _handler;
  const SiteService(this._handler);

  factory SiteService.firestore() {
    return SiteService(FirestoreSiteHandler());
  }
  @override
  Future<void> createSiteOffice(
      {required String siteName,
      required String siteStatus,
      required String siteAddress,
      required double siteLatitude,
      required double siteLongitude,
      required double siteRadius,
      required List<String>? memberList}) {
    return _handler.createSiteOffice(
      siteName: siteName,
      siteStatus: siteStatus,
      siteAddress: siteAddress,
      siteLatitude: siteLatitude,
      siteLongitude: siteLongitude,
      siteRadius: siteRadius,
      memberList: memberList,
    );
  }

  @override
  Future<void> updateSiteOffice(
      {required String siteName,
      required SiteStatus? siteStatus,
      required String? siteAddress,
      required double? siteLatitude,
      required double? siteLongitude,
      required double? siteRadius,
      required List<String>? memberList}) {
    return _handler.updateSiteOffice(
      siteName: siteName,
      siteStatus: siteStatus,
      siteAddress: siteAddress,
      siteLatitude: siteLatitude,
      siteLongitude: siteLongitude,
      siteRadius: siteRadius,
      memberList: memberList,
    );
  }

  @override
  Future<void> addSiteMember(
      {required String siteName, required List<String>? memberList}) {
    return _handler.addSiteMember(
      siteName: siteName,
      memberList: memberList,
    );
  }

  @override
  Future<void> removeSiteMember(
      {required String siteName, required List<String>? memberList}) {
    return _handler.removeSiteMember(
      siteName: siteName,
      memberList: memberList,
    );
  }

  @override
  Stream<List<SiteOffice>> fetchSiteOffices() {
    return _handler.fetchSiteOffices();
  }
}
