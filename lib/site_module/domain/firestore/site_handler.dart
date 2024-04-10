import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/site_module/utilities/site_status.dart';

abstract class SiteHandler {
  Future<void> createSiteOffice({
    required String siteName,
    required String siteStatus,
    required String siteAddress,
    required double siteLatitude,
    required double siteLongitude,
    required double siteRadius,
    required List<String>? memberList,
  });

  Future<void> updateSiteOffice({
    required String siteName,
    required SiteStatus? newSiteStatus,
    required String? newSiteAddress,
    required double? newSiteLatitude,
    required double? newSiteLongitude,
    required double? newSiteRadius,
    required List<String>? newMemberList,
  });

  Future<void> addSiteMember({
    required String siteName,
    required List<String>? memberList,
  });

  Future<void> removeSiteMember({
    required String siteName,
    required List<String>? memberList,
  });

  Stream<List<SiteOffice>> fetchSiteOffices();

  Future<List<SiteOffice>> populateSiteOfficeList(
      {required List<String> siteNameList});
}
