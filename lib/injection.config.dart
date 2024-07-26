// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'features/image_processing/domain/usecases/apply_brightness.dart' as _i3;
import 'features/image_processing/domain/usecases/apply_contrast.dart' as _i4;
import 'features/image_processing/domain/usecases/apply_edge_detection.dart'
    as _i5;
import 'features/image_processing/domain/usecases/apply_histogram.dart' as _i6;
import 'features/image_processing/domain/usecases/apply_hue.dart' as _i7;
import 'features/image_processing/domain/usecases/apply_laplacian_edge_detection.dart'
    as _i8;
import 'features/image_processing/domain/usecases/apply_resize.dart' as _i9;
import 'features/image_processing/domain/usecases/apply_rotation.dart' as _i10;
import 'features/image_processing/domain/usecases/apply_saturation.dart'
    as _i11;
import 'features/image_processing/domain/usecases/apply_sharpen.dart' as _i12;
import 'features/image_processing/domain/usecases/apply_smoothing.dart' as _i13;
import 'features/image_processing/domain/usecases/sobel_edge_detection.dart'
    as _i14;
import 'features/image_processing/presentation/providers/image_processor_provider.dart'
    as _i15; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.ApplyBrightness>(() => _i3.ApplyBrightness());
  gh.factory<_i4.ApplyContrast>(() => _i4.ApplyContrast());
  gh.factory<_i5.ApplyEdgeDetection>(() => _i5.ApplyEdgeDetection());
  gh.factory<_i6.ApplyHistogram>(() => _i6.ApplyHistogram());
  gh.factory<_i7.ApplyHue>(() => _i7.ApplyHue());
  gh.factory<_i8.ApplyLaplacianEdgeDetection>(
      () => _i8.ApplyLaplacianEdgeDetection());
  gh.factory<_i9.ApplyResize>(() => _i9.ApplyResize());
  gh.factory<_i10.ApplyRotation>(() => _i10.ApplyRotation());
  gh.factory<_i11.ApplySaturation>(() => _i11.ApplySaturation());
  gh.factory<_i12.ApplySharpen>(() => _i12.ApplySharpen());
  gh.factory<_i13.ApplySmoothing>(() => _i13.ApplySmoothing());
  gh.factory<_i14.ApplySobelEdgeDetection>(
      () => _i14.ApplySobelEdgeDetection());
  gh.factory<_i15.ImageProcessorProvider>(() => _i15.ImageProcessorProvider(
        get<_i6.ApplyHistogram>(),
        get<_i4.ApplyContrast>(),
        get<_i13.ApplySmoothing>(),
        get<_i5.ApplyEdgeDetection>(),
        get<_i10.ApplyRotation>(),
        get<_i9.ApplyResize>(),
        get<_i3.ApplyBrightness>(),
        get<_i11.ApplySaturation>(),
        get<_i7.ApplyHue>(),
        get<_i12.ApplySharpen>(),
        get<_i8.ApplyLaplacianEdgeDetection>(),
      ));
  return get;
}
