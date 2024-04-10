import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
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
        final List<Future<void>> updateTasks = [];
        final CollectionReference employeeRef =
            _firestore.collection('employees');
        for (String employeeId in memberList) {
          updateTasks.add(employeeRef.doc(employeeId).update({
            'site-office': FieldValue.arrayUnion([siteName]),
          }));
        }
        await Future.wait(updateTasks);
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
      required SiteStatus? newSiteStatus,
      required String? newSiteAddress,
      required double? newSiteLatitude,
      required double? newSiteLongitude,
      required double? newSiteRadius,
      required List<String>? newMemberList}) async {
    try {
      // Document Reference
      final DocumentReference siteDocRef =
          FirebaseFirestore.instance.collection('site').doc(siteName);

      // Fetch existing data of the site
      final siteSnapshot = await siteDocRef.get();
      final Map<String, dynamic> oldSiteData =
          siteSnapshot.data() as Map<String, dynamic>;

      // Map to update new values
      final Map<String, dynamic> updateData = {};

      // Checking weather optional attributes are null
      if (newSiteStatus != null) {
        updateData['site-status'] = newSiteStatus;
      }
      if (newSiteAddress != null) {
        updateData['site-address'] = newSiteAddress;
      }
      if (newSiteLatitude != null) {
        updateData['site-latitude'] = newSiteLatitude;
      }
      if (newSiteLongitude != null) {
        updateData['site-longitude'] = newSiteLongitude;
      }
      if (newSiteRadius != null) {
        updateData['site-radius'] = newSiteRadius;
      }
      if (newMemberList != null) {
        updateData['employee-list'] = newMemberList;
      }

      // Update the site data to firestore
      await siteDocRef.update(updateData);

      final List<String> oldMemberList = oldSiteData['employee-list'];

      // List of api calls to update employee document with
      // new site list
      final List<Future<void>> updateEmpoyeeSiteOffice = [];

      // Collection reference for employee collection
      final CollectionReference employeeRef =
          FirebaseFirestore.instance.collection('employees');

      if (newMemberList != null && newMemberList.isNotEmpty) {
        // Compare old and new list to identify members removed
        final List<String> removedMembers = oldMemberList
            .where((member) => !newMemberList.contains(member))
            .toList();

        for (String removedMemberId in removedMembers) {
          updateEmpoyeeSiteOffice.add(employeeRef.doc(removedMemberId).update({
            'site-office': FieldValue.arrayRemove([siteName]),
          }));
        }
        for (String employeeId in newMemberList) {
          updateEmpoyeeSiteOffice.add(employeeRef.doc(employeeId).update({
            'site-office': FieldValue.arrayUnion([siteName]),
          }));
        }
      }

      // Waiting to update all employee docs
      await Future.wait(updateEmpoyeeSiteOffice);
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong! Please try again.';
    }
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

  @override
  Stream<List<SiteOffice>> fetchSiteOffices() {
    try {
      return _firestore.collection('site').snapshots().map(
        (QuerySnapshot<Object?> querySnapshot) {
          return querySnapshot.docs.map((doc) {
            return SiteOffice.fromFirestore(
                doc as QueryDocumentSnapshot<Map<String, dynamic>>);
          }).toList();
        },
      );
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.! Please try again.';
    }
  }
}
