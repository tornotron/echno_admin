import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/site_module/utilities/site_status.dart';
import 'package:echno_attendance/site_module/domain/firestore/site_handler.dart';
import 'package:echno_attendance/utilities/exceptions/firebase_exceptions.dart';
import 'package:echno_attendance/utilities/exceptions/platform_exceptions.dart';
import 'package:flutter/services.dart';

class FirestoreSiteHandler implements SiteHandler {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createSiteOffice(
      {required String siteName,
      required String siteStatus,
      required String siteAddress,
      required double siteLatitude,
      required double siteLongitude,
      required double siteRadius,
      required List<String>? memberList}) async {
    try {
      final CollectionReference siteRef = _firestore.collection('site');
      await siteRef.doc(siteName).set({
        'site-name': siteName,
        'site-status': siteStatus,
        'site-address': siteAddress,
        'site-latitude': siteLatitude,
        'site-longitude': siteLongitude,
        'site-radius': siteRadius,
        'employee-list': memberList,
      });

      if (memberList != null) {
        final CollectionReference employeeRef =
            _firestore.collection('employees');
        for (String employeeId in memberList) {
          await employeeRef.doc(employeeId).update({
            'site-office': FieldValue.arrayUnion([siteName]),
          });
        }
      }
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.! Please try again.';
    }
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
    // TODO: implement addSiteMember
    throw UnimplementedError();
  }

  @override
  Future<void> addSiteMember(
      {required String siteName, required List<String>? memberList}) {
    // TODO: implement addSiteMember
    throw UnimplementedError();
  }

  @override
  Future<void> removeSiteMember(
      {required String siteName, required List<String>? memberList}) {
    // TODO: implement removeSiteMember
    throw UnimplementedError();
  }
}
