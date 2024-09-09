import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/image_processing/presentation/pages/home_page.dart';
import 'features/image_processing/presentation/pages/splash_screen.dart';
import 'features/image_processing/presentation/providers/image_processor_provider.dart';
import 'features/image_processing/domain/usecases/apply_histogram.dart';
import 'features/image_processing/domain/usecases/apply_contrast.dart';
import 'features/image_processing/domain/usecases/apply_smoothing.dart';
import 'features/image_processing/domain/usecases/apply_edge_detection.dart';
import 'features/image_processing/domain/usecases/apply_rotation.dart';
import 'features/image_processing/domain/usecases/apply_resize.dart';
import 'features/image_processing/domain/usecases/apply_brightness.dart';
import 'features/image_processing/domain/usecases/apply_saturation.dart';
import 'features/image_processing/domain/usecases/apply_hue.dart';
import 'features/image_processing/domain/usecases/apply_sharpen.dart';
import 'features/image_processing/domain/usecases/apply_laplacian_edge_detection.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'app_router.dart';
import 'injection.config.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

final getIt = GetIt.instance;

@injectableInit
void configureDependencies() => $initGetIt(getIt);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImageProcessorProvider(
            getIt<ApplyHistogram>(),
            getIt<ApplyContrast>(),
            getIt<ApplySmoothing>(),
            getIt<ApplyEdgeDetection>(),
            getIt<ApplyRotation>(),
            getIt<ApplyResize>(),
            getIt<ApplyBrightness>(),
            getIt<ApplySaturation>(),
            getIt<ApplyHue>(),
            getIt<ApplySharpen>(),
            getIt<ApplyLaplacianEdgeDetection>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Computer Vision App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: '/', // Utilisez '/' pour le splash screen
        routes: {
          '/': (context) => SplashScreen(),
          '/home': (context) => HomePage(),
        },
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
