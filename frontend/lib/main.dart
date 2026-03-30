import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/routes/routes.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/home/daily_news.dart';
import 'config/theme/app_themes.dart';
import 'config/theme/bloc/theme_cubit.dart';
import 'features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Injecting dummy options to bypass Windows native file requirement for Emulators
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'dummy-api-key-for-emulators',
      appId: '1:123:web:123',
      messagingSenderId: '1234567890',
      projectId: 'symmetry-journalist-gabo',
    ),
  );

  try {
    // If you run on Windows, 127.0.0.1 is correct. 
    // If you run on Android Emulator, change this to 10.0.2.2
    FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
  } catch (e) {
    debugPrint("Firestore Emulator already initialized or failed: $e");
  }
  
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteArticlesBloc>(
          create: (context) => sl()..add(const GetArticles()),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final currentTheme = themeState.themeMode == AppThemeMode.dark
              ? darkTheme()
              : (themeState.themeMode == AppThemeMode.newspaper
                  ? newspaperTheme()
                  : lightTheme());

          return AnimatedTheme(
            data: currentTheme,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOutCubic,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: currentTheme,
              onGenerateRoute: AppRoutes.onGenerateRoutes,
              home: const DailyNews(),
            ),
          );
        },
      ),
    );
  }
}
