import 'package:cashier/providers/branch_provider.dart';
import 'package:cashier/providers/cart_providers.dart';
import 'package:cashier/providers/company_provider.dart';
import 'package:cashier/providers/invoice_provider.dart';
import 'package:cashier/screens/common_screens/home.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/common_screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD7tbSVElUrZ2gVtOuvk3l-IF2elokzuLU",
        appId: "1:343958666925:web:fc9b646c2aef534d1e5024",
        messagingSenderId: "343958666925",
        projectId: "cashier-ea96e",
        storageBucket: "cashier-ea96e.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BranchProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvide(),
        ),
        ChangeNotifierProvider(
          create: (_) => CompanyProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => InvoiceProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const HomePage();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const LoginBranch();
          },
        ),
      ),
    );
  }
}
