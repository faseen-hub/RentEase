import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentease/main.dart';
import 'package:rentease/model/signupmodel/mobx/signup_model.dart';
import 'package:rentease/model/signupmodel/user_model.dart';
import 'package:rentease/view/core/const_colors.dart';
import 'package:rentease/view/core/utils.dart';

Future<void> signUp(
    {required context, required email, required password}) async {
  showDialog(
    context: context,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    Utils.showSnackBar(
      e.message,
      color: Colors.red[900],
      textColor: kwhiteColor,
    );
  }
  navigatorKey.currentState!.popUntil((route) => route.isFirst);
}

Future<void> userSignupDetailsToFireStore(
    {required name,
    required email,
    required phoneNumber,
    required password}) async {
  Get.dialog(
    const Center(
      child: CircularProgressIndicator(),
    ),
  );

  final SignUpModel signupmodel = SignUpModel();
  // final name = signupmodel.fullnameController.text.trim();
  // final email = signupmodel.emailController.text.trim();
  // final phoneNumber = signupmodel.numberController.text.trim();
  // // final location = signupmodel.locationController.text.trim();
  // final password = signupmodel.passwordController.text.trim();

  ///
  ///
  ///

  // final metaData = SettableMetadata(contentType: 'image/jpeg');
  // final storageRef = FirebaseStorage.instance.ref("userIDs");
  // Reference ref = storageRef.child("$email.jpg");
  // final uploadTask = ref.putFile(File(signupmodel.picture), metaData);
  // final taskSnapshot = await uploadTask.whenComplete(() => null);
  // String url = await taskSnapshot.ref.getDownloadURL();

  final docUser = FirebaseFirestore.instance.collection("Users").doc(email);

  CreateUser createUser = CreateUser(
    name: name,
    email: email,
    password: password,
    location: 'location',
    phoneNumber: phoneNumber,
    idImage: 'url',
  );

  Map<String, dynamic> userDataToSend = createUser.toMap();
  await docUser.set(userDataToSend);
  signupmodel.clearAll();
  navigatorKey.currentState!.popUntil((route) => route.isFirst);
}
