import 'package:cashier/models/branch_model.dart';
import 'package:cashier/models/company_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authmethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const int notAdmin = 0;

  //create Company
  Future<String> createCompany(
      {required String email,
      required String password,
      required String companyName,
      required String currencyCode,
      required String fullAddress,
      required String hqLocation,
      required String phoneNumber}) async {
    String res = 'Some error occured!';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          companyName.isNotEmpty &&
          fullAddress.isNotEmpty &&
          hqLocation.isNotEmpty &&
          phoneNumber.isNotEmpty) {
        // register admin
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // create branch as hq branch
        Branch _branch = Branch(
          email: email,
          companyKey: cred.user!.uid,
          branchName: companyName,
          branchLocation: hqLocation,
          value: 1,
          uid: cred.user!.uid,
        );

        await _firestore
            .collection('branches')
            .doc(cred.user!.uid)
            .set(_branch.toJson());

        //create company

        Company _company = Company(
          companyName: companyName,
          currencyCode: currencyCode,
          companyKey: cred.user!.uid,
          companyEmail: email,
          phoneNumber: phoneNumber,
          fullAddress: fullAddress,
          hqLocation: hqLocation,
          uid: cred.user!.uid,
        );
        await _firestore
            .collection('company')
            .doc(cred.user!.uid)
            .set(_company.toJson());
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //signup User
  Future<String> signUpUser(
      {required String email,
      required String password,
      required String branchName,
      required String branchLocation,
      required String companyKey}) async {
    String res = 'Some error occurred!';

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          branchName.isNotEmpty ||
          branchLocation.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // user details to database
        Branch _branch = Branch(
          email: email,
          companyKey: companyKey,
          branchName: branchName,
          branchLocation: branchLocation,
          value: notAdmin,
          uid: cred.user!.uid,
        );

        await _firestore
            .collection('branches')
            .doc(cred.user!.uid)
            .set(_branch.toJson());
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //login user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = 'Please enter all fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // user can reset password using email address..._

  Future<String> resetPassword({required String email}) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: email);
        res = 'success';
      } else {
        res = 'Please enter all fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //get branch details

  Future<Branch> getBranchDetails() async {
    User currentBranch = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('branches').doc(currentBranch.uid).get();

    return Branch.fromSnap(snap);
  }

  // TODO: get company details where company.document id = brnach.company key...

  Future<Company> getCompamy() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapkey =
        await _firestore.collection('branches').doc(currentUser.uid).get();
    String _branchCompanyKey =
        (snapkey.data() as Map<String, dynamic>)['companyKey'];
    DocumentSnapshot snap =
        await _firestore.collection('company').doc(_branchCompanyKey).get();

    return Company.fromSnap(snap);
  }
}
