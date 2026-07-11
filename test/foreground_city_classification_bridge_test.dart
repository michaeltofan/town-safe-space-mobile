import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:town_safe_space_mobile/geometry/point_in_polygon_engine.dart';
import 'package:town_safe_space_mobile/services/city_boundary_classification_service.dart';
import 'package:town_safe_space_mobile/services/foreground_city_classification_bridge.dart';
import 'package:town_safe_space_mobile/services/foreground_position_reader.dart';

/// Fixed geometry regression points (not live GPS / user locations).
const double kMilanoInsideLon = 9.185;
const double kMilanoInsideLat = 45.464;
const double kMilanoOutsideLon = 8.99;
const double kMilanoOutsideLat = 45.33;
const double kMilanoBoundaryLon = 9.06993922272781;
const double kMilanoBoundaryLat = 45.48067034963818;

const double kMunichInsideLon = 11.575;
const double kMunichInsideLat = 48.137;
const double kMunichOutsideLon = 11.31;
const double kMunichOutsideLat = 48.01;
const double kMunichBoundaryLon = 11.542378141861187;
const double kMunichBoundaryLat = 48.07785667816808;

class _FakeCoordinateReader implements OneTimeForegroundCoordinateReader {
  _FakeCoordinateReader({
    this.longitude = kMilanoInsideLon,
    this.latitude = kMilanoInsideLat,
    this.accuracy = 12.4,
    this.throwFailure,
    this.onRead,
  });

  double longitude;
  double latitude;
  double accuracy;
  ForegroundCoordinateReadException? throwFailure;
  void Function()? onRead;

  int readCalls = 0;
  Completer<void>? blockUntil;

  @override
  Future<T> readCoordinatesOnce<T>(
    Future<T> Function({
      required double longitude,
      required double latitude,
      required double accuracy,
    }) use,
  ) async {
    readCalls += 1;
    onRead?.call();
    if (throwFailure != null) {
      throw throwFailure!;
    }
    final Completer<void>? gate = blockUntil;
    if (gate != null) {
      await gate.future;
    }
    return use(
      longitude: longitude,
      latitude: latitude,
      accuracy: accuracy,
    );
  }
}

class _RecordingClassificationService
    extends CityBoundaryClassificationService {
  _RecordingClassificationService({
    super.clock,
    this.throwOnClassify,
  });

  final Object? throwOnClassify;

  int classifyCalls = 0;
  final List<String> selectedCities = <String>[];
  final List<double> longitudes = <double>[];
  final List<double> latitudes = <double>[];
  final List<double> accuracies = <double>[];

  @override
  Future<CityBoundaryClassificationResult> classifyCoordinatesTransiently({
    required String selectedCity,
    required double longitude,
    required double latitude,
    required double accuracyMeters,
  }) async {
    classifyCalls += 1;
    selectedCities.add(selectedCity);
    longitudes.add(longitude);
    latitudes.add(latitude);
    accuracies.add(accuracyMeters);
    if (throwOnClassify != null) {
      throw throwOnClassify!;
    }
    return super.classifyCoordinatesTransiently(
      selectedCity: selectedCity,
      longitude: longitude,
      latitude: latitude,
      accuracyMeters: accuracyMeters,
    );
  }
}

class _MapAssetBundle extends CachingAssetBundle {
  _MapAssetBundle(this._assets);

  final Map<String, String> _assets;

  @override
  Future<ByteData> load(String key) async {
    final String? text = _assets[key];
    if (text == null) {
      throw FlutterError('Unable to load asset: $key');
    }
    final Uint8List encoded = Uint8List.fromList(utf8.encode(text));
    return ByteData.view(encoded.buffer);
  }
}

Matcher _bridgeFailure(ForegroundCityClassificationBridgeFailure failure) {
  return throwsA(
    isA<ForegroundCityClassificationBridgeException>().having(
      (ForegroundCityClassificationBridgeException e) => e.failure,
      'failure',
      failure,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final DateTime fixedClock = DateTime.utc(2026, 7, 11, 12);

  group('explicit city parameter', () {
    test('1. Milano is passed explicitly to classification', () async {
      final _FakeCoordinateReader reader = _FakeCoordinateReader();
      final _RecordingClassificationService classification =
          _RecordingClassificationService(
        clock: () => fixedClock,
      );
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: classification,
      );

      await bridge.readAndClassifyOnce(selectedCity: 'Milano');

      expect(classification.selectedCities, <String>['Milano']);
      expect(classification.classifyCalls, 1);
    });

    test('2. Munich is passed explicitly to classification', () async {
      final _FakeCoordinateReader reader = _FakeCoordinateReader(
        longitude: kMunichInsideLon,
        latitude: kMunichInsideLat,
      );
      final _RecordingClassificationService classification =
          _RecordingClassificationService(
        clock: () => fixedClock,
      );
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: classification,
      );

      await bridge.readAndClassifyOnce(selectedCity: 'Munich');

      expect(classification.selectedCities, <String>['Munich']);
      expect(classification.classifyCalls, 1);
    });
  });

  group('one-read and concurrency', () {
    test('3. exactly one position request per successful operation', () async {
      final _FakeCoordinateReader reader = _FakeCoordinateReader();
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: CityBoundaryClassificationService(
          clock: () => fixedClock,
        ),
      );

      await bridge.readAndClassifyOnce(selectedCity: 'Milano');
      expect(reader.readCalls, 1);

      await bridge.readAndClassifyOnce(selectedCity: 'Milano');
      expect(reader.readCalls, 2);
    });

    test('4. concurrent bridge calls use busy guard without duplicate reads',
        () async {
      final Completer<void> gate = Completer<void>();
      final _FakeCoordinateReader reader = _FakeCoordinateReader()
        ..blockUntil = gate;
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: CityBoundaryClassificationService(
          clock: () => fixedClock,
        ),
      );

      final Future<CityBoundaryClassificationResult> first =
          bridge.readAndClassifyOnce(selectedCity: 'Milano');
      await Future<void>.delayed(Duration.zero);

      await expectLater(
        bridge.readAndClassifyOnce(selectedCity: 'Milano'),
        _bridgeFailure(ForegroundCityClassificationBridgeFailure.busy),
      );
      expect(reader.readCalls, 1);

      gate.complete();
      await first;
      expect(reader.readCalls, 1);
    });

    test('5. longitude, latitude, accuracy passed correctly', () async {
      final _FakeCoordinateReader reader = _FakeCoordinateReader(
        longitude: 9.11,
        latitude: 45.22,
        accuracy: 7.6,
      );
      final _RecordingClassificationService classification =
          _RecordingClassificationService(
        clock: () => fixedClock,
      );
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: classification,
      );

      await bridge.readAndClassifyOnce(selectedCity: 'Milano');

      expect(classification.longitudes, <double>[9.11]);
      expect(classification.latitudes, <double>[45.22]);
      expect(classification.accuracies, <double>[7.6]);
    });
  });

  group('privacy-safe result', () {
    test('6. returned value contains only safe fields', () async {
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: _FakeCoordinateReader(),
        classificationService: CityBoundaryClassificationService(
          clock: () => fixedClock,
        ),
      );

      final CityBoundaryClassificationResult result =
          await bridge.readAndClassifyOnce(selectedCity: 'Milano');

      expect(result.city, 'Milano');
      expect(result.containment, PointContainment.inside);
      expect(result.accuracyMeters, 12);
      expect(result.classifiedAt, fixedClock);

      final List<String> fieldNames = result.runtimeType
          .toString()
          .split(RegExp(r'[^A-Za-z]'))
          .where((String s) => s.isNotEmpty)
          .toList();
      expect(fieldNames.contains('CityBoundaryClassificationResult'), isTrue);

      // Reflect via toString of public fields only — no coordinate getters.
      expect(
        () => (result as dynamic).latitude,
        throwsA(anything),
      );
      expect(
        () => (result as dynamic).longitude,
        throwsA(anything),
      );
      expect(
        () => (result as dynamic).position,
        throwsA(anything),
      );
      expect(
        () => (result as dynamic).geoPoint,
        throwsA(anything),
      );
    });

    test('7. no Position/lat/lon/GeoPoint retained on bridge', () async {
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: _FakeCoordinateReader(),
        classificationService: CityBoundaryClassificationService(
          clock: () => fixedClock,
        ),
      );

      await bridge.readAndClassifyOnce(selectedCity: 'Milano');

      final String bridgeSource = File(
        'lib/services/foreground_city_classification_bridge.dart',
      ).readAsStringSync();

      // Bridge may mention Position only in documentation of discard rules.
      // It must not declare Position / GeoPoint / lat / lon fields.
      expect(
        RegExp(r'Position\s+\w+\s*=').hasMatch(bridgeSource),
        isFalse,
      );
      expect(
        RegExp(r'GeoPoint\s+\w+\s*=').hasMatch(bridgeSource),
        isFalse,
      );
      expect(
        RegExp(r'(latitude|longitude)\s*[;=]').hasMatch(bridgeSource),
        isFalse,
      );
      expect(bridgeSource.contains('SharedPreferences'), isFalse);
      expect(bridgeSource.contains('FlutterSecureStorage'), isFalse);
    });
  });

  group('Milano fixtures through bridge', () {
    late ForegroundCityClassificationBridge Function({
      required double lon,
      required double lat,
    }) build;

    setUp(() {
      build = ({required double lon, required double lat}) {
        return ForegroundCityClassificationBridge(
          coordinateReader: _FakeCoordinateReader(
            longitude: lon,
            latitude: lat,
            accuracy: 10,
          ),
          classificationService: CityBoundaryClassificationService(
            clock: () => fixedClock,
          ),
        );
      };
    });

    test('8. Milano inside fixture returns inside', () async {
      final CityBoundaryClassificationResult result =
          await build(lon: kMilanoInsideLon, lat: kMilanoInsideLat)
              .readAndClassifyOnce(selectedCity: 'Milano');
      expect(result.containment, PointContainment.inside);
      expect(result.city, 'Milano');
    });

    test('9. Milano outside fixture returns outside', () async {
      final CityBoundaryClassificationResult result =
          await build(lon: kMilanoOutsideLon, lat: kMilanoOutsideLat)
              .readAndClassifyOnce(selectedCity: 'Milano');
      expect(result.containment, PointContainment.outside);
    });

    test('10. Milano boundary fixture returns boundary', () async {
      final CityBoundaryClassificationResult result =
          await build(lon: kMilanoBoundaryLon, lat: kMilanoBoundaryLat)
              .readAndClassifyOnce(selectedCity: 'Milano');
      expect(result.containment, PointContainment.boundary);
    });
  });

  group('Munich fixtures through bridge', () {
    late ForegroundCityClassificationBridge Function({
      required double lon,
      required double lat,
    }) build;

    setUp(() {
      build = ({required double lon, required double lat}) {
        return ForegroundCityClassificationBridge(
          coordinateReader: _FakeCoordinateReader(
            longitude: lon,
            latitude: lat,
            accuracy: 10,
          ),
          classificationService: CityBoundaryClassificationService(
            clock: () => fixedClock,
          ),
        );
      };
    });

    test('11. Munich inside fixture returns inside', () async {
      final CityBoundaryClassificationResult result =
          await build(lon: kMunichInsideLon, lat: kMunichInsideLat)
              .readAndClassifyOnce(selectedCity: 'Munich');
      expect(result.containment, PointContainment.inside);
      expect(result.city, 'Munich');
    });

    test('12. Munich outside fixture returns outside', () async {
      final CityBoundaryClassificationResult result =
          await build(lon: kMunichOutsideLon, lat: kMunichOutsideLat)
              .readAndClassifyOnce(selectedCity: 'Munich');
      expect(result.containment, PointContainment.outside);
    });

    test('13. Munich boundary fixture returns boundary', () async {
      final CityBoundaryClassificationResult result =
          await build(lon: kMunichBoundaryLon, lat: kMunichBoundaryLat)
              .readAndClassifyOnce(selectedCity: 'Munich');
      expect(result.containment, PointContainment.boundary);
    });
  });

  group('prerequisite and read failures', () {
    test('14. location services disabled fails before position read use',
        () async {
      final _FakeCoordinateReader reader = _FakeCoordinateReader(
        throwFailure: const ForegroundCoordinateReadException(
          ForegroundCoordinateReadFailure.locationServicesDisabled,
          'Location services are disabled.',
        ),
      );
      final _RecordingClassificationService classification =
          _RecordingClassificationService(
        clock: () => fixedClock,
      );
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: classification,
      );

      await expectLater(
        bridge.readAndClassifyOnce(selectedCity: 'Milano'),
        _bridgeFailure(
          ForegroundCityClassificationBridgeFailure.locationServicesDisabled,
        ),
      );
      expect(reader.readCalls, 1);
      expect(classification.classifyCalls, 0);
    });

    test('15. permission denied fails before classification', () async {
      final _FakeCoordinateReader reader = _FakeCoordinateReader(
        throwFailure: const ForegroundCoordinateReadException(
          ForegroundCoordinateReadFailure.permissionDenied,
          'Location permission not granted.',
        ),
      );
      final _RecordingClassificationService classification =
          _RecordingClassificationService(clock: () => fixedClock);
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: classification,
      );

      await expectLater(
        bridge.readAndClassifyOnce(selectedCity: 'Milano'),
        _bridgeFailure(
          ForegroundCityClassificationBridgeFailure.permissionDenied,
        ),
      );
      expect(classification.classifyCalls, 0);
    });

    test('16. permission permanently denied fails before classification',
        () async {
      final _FakeCoordinateReader reader = _FakeCoordinateReader(
        throwFailure: const ForegroundCoordinateReadException(
          ForegroundCoordinateReadFailure.permissionPermanentlyDenied,
          'Location permission permanently denied.',
        ),
      );
      final _RecordingClassificationService classification =
          _RecordingClassificationService(clock: () => fixedClock);
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: classification,
      );

      await expectLater(
        bridge.readAndClassifyOnce(selectedCity: 'Milano'),
        _bridgeFailure(
          ForegroundCityClassificationBridgeFailure
              .permissionPermanentlyDenied,
        ),
      );
      expect(classification.classifyCalls, 0);
    });

    test('17. timeout produces a safe bridge failure', () async {
      final _FakeCoordinateReader reader = _FakeCoordinateReader(
        throwFailure: const ForegroundCoordinateReadException(
          ForegroundCoordinateReadFailure.timeout,
          'Location request timed out.',
        ),
      );
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: CityBoundaryClassificationService(
          clock: () => fixedClock,
        ),
      );

      await expectLater(
        bridge.readAndClassifyOnce(selectedCity: 'Milano'),
        _bridgeFailure(ForegroundCityClassificationBridgeFailure.timeout),
      );

      try {
        await bridge.readAndClassifyOnce(selectedCity: 'Milano');
      } on ForegroundCityClassificationBridgeException catch (e) {
        expect(e.message.contains('9.'), isFalse);
        expect(e.message.contains('45.'), isFalse);
        expect(e.toString().contains('latitude'), isFalse);
        expect(e.toString().contains('longitude'), isFalse);
        expect(e.toString().contains('GeoPoint'), isFalse);
        expect(RegExp(r'\baccuracy\b').hasMatch(e.toString()), isFalse);
      }
    });

    test('18. generic position-read failure produces safe bridge failure',
        () async {
      final _FakeCoordinateReader reader = _FakeCoordinateReader(
        throwFailure: const ForegroundCoordinateReadException(
          ForegroundCoordinateReadFailure.positionReadFailed,
          'Location request failed.',
        ),
      );
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: CityBoundaryClassificationService(
          clock: () => fixedClock,
        ),
      );

      await expectLater(
        bridge.readAndClassifyOnce(selectedCity: 'Milano'),
        _bridgeFailure(
          ForegroundCityClassificationBridgeFailure.positionReadFailed,
        ),
      );
    });

    test('19. unsupported city produces a safe failure without position use',
        () async {
      final _FakeCoordinateReader reader = _FakeCoordinateReader();
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: CityBoundaryClassificationService(
          clock: () => fixedClock,
        ),
      );

      await expectLater(
        bridge.readAndClassifyOnce(selectedCity: 'Rome'),
        _bridgeFailure(
          ForegroundCityClassificationBridgeFailure.unsupportedCity,
        ),
      );
      expect(reader.readCalls, 0);
    });

    test('20. classification failure is wrapped safely', () async {
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: _FakeCoordinateReader(),
        classificationService: _RecordingClassificationService(
          clock: () => fixedClock,
          throwOnClassify: const CityBoundaryClassificationException(
            'Classification failed.',
          ),
        ),
      );

      await expectLater(
        bridge.readAndClassifyOnce(selectedCity: 'Milano'),
        _bridgeFailure(
          ForegroundCityClassificationBridgeFailure.classificationFailed,
        ),
      );
    });

    test('20b. boundary asset failure is wrapped safely', () async {
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: _FakeCoordinateReader(),
        classificationService: CityBoundaryClassificationService(
          bundle: _MapAssetBundle(<String, String>{}),
          clock: () => fixedClock,
        ),
      );

      await expectLater(
        bridge.readAndClassifyOnce(selectedCity: 'Milano'),
        _bridgeFailure(
          ForegroundCityClassificationBridgeFailure.boundaryAssetFailed,
        ),
      );
    });

    test('21. no automatic retry occurs', () async {
      int attempts = 0;
      final _FakeCoordinateReader reader = _FakeCoordinateReader(
        throwFailure: const ForegroundCoordinateReadException(
          ForegroundCoordinateReadFailure.timeout,
          'Location request timed out.',
        ),
        onRead: () => attempts += 1,
      );
      final ForegroundCityClassificationBridge bridge =
          ForegroundCityClassificationBridge(
        coordinateReader: reader,
        classificationService: CityBoundaryClassificationService(
          clock: () => fixedClock,
        ),
      );

      await expectLater(
        bridge.readAndClassifyOnce(selectedCity: 'Milano'),
        _bridgeFailure(ForegroundCityClassificationBridgeFailure.timeout),
      );
      expect(attempts, 1);
      expect(reader.readCalls, 1);
    });
  });

  group('scope source scans', () {
    late String bridgeSource;
    late String readerSource;
    late String screenSource;

    setUpAll(() {
      bridgeSource = File(
        'lib/services/foreground_city_classification_bridge.dart',
      ).readAsStringSync();
      readerSource = File(
        'lib/services/foreground_position_reader.dart',
      ).readAsStringSync();
      screenSource = File(
        'lib/screens/location_confirmation_screen.dart',
      ).readAsStringSync();
    });

    test('22. no getPositionStream', () {
      expect(bridgeSource.contains('getPositionStream'), isFalse);
      expect(readerSource.contains('getPositionStream'), isFalse);
    });

    test('23. no getLastKnownPosition', () {
      expect(bridgeSource.contains('getLastKnownPosition'), isFalse);
      expect(readerSource.contains('getLastKnownPosition'), isFalse);
    });

    test('24. no screen or navigation integration in bridge', () {
      expect(bridgeSource.contains('Navigator'), isFalse);
      expect(bridgeSource.contains('MaterialPageRoute'), isFalse);
      expect(bridgeSource.contains('LocationConfirmationScreen'), isFalse);
      expect(bridgeSource.contains('package:flutter/material.dart'), isFalse);
      expect(bridgeSource.contains('/screens/'), isFalse);
    });

    test('25. no persistence, network, analytics, membership, account, eligibility',
        () {
      for (final String token in <String>[
        'SharedPreferences',
        'secure storage',
        'FlutterSecureStorage',
        'dio',
        'analytics',
        'Firebase',
        'jsonEncode',
        'membership',
        'account',
        'eligible',
        'approved',
        'rejected',
        'startMembership',
        'createAccount',
      ]) {
        expect(
          bridgeSource.contains(token),
          isFalse,
          reason: 'Forbidden token "$token"',
        );
      }
      expect(RegExp(r'\bhttp\b').hasMatch(bridgeSource), isFalse);
      expect(RegExp(r'\bprint\s*\(').hasMatch(bridgeSource), isFalse);
      expect(bridgeSource.contains('debugPrint('), isFalse);
    });

    test('26. LocationConfirmationScreen wires bridge readAndClassifyOnce', () {
      expect(
        screenSource.contains('foreground_city_classification_bridge'),
        isTrue,
      );
      expect(
        screenSource.contains('ForegroundCityClassificationBridge'),
        isTrue,
      );
      expect(
        screenSource.contains('readAndClassifyOnce'),
        isTrue,
      );
      // Screen must not construct/call the classification service directly.
      expect(
        screenSource.contains('CityBoundaryClassificationService('),
        isFalse,
      );
      expect(
        screenSource.contains('classifyCoordinatesTransiently'),
        isFalse,
      );
    });

    test('exactly one Geolocator.getCurrentPosition call site', () {
      final Iterable<Match> matches =
          RegExp(r'await Geolocator\.getCurrentPosition')
              .allMatches(readerSource);
      expect(matches.length, 1);

      expect(bridgeSource.contains('Geolocator.getCurrentPosition'), isFalse);
      expect(bridgeSource.contains('getCurrentPosition'), isFalse);
    });

    test('reuses approved one-time settings', () {
      expect(readerSource.contains('LocationAccuracy.high'), isTrue);
      expect(readerSource.contains('kForegroundPositionTimeout'), isTrue);
      expect(kForegroundPositionTimeout, const Duration(seconds: 15));
      expect(readerSource.contains('bestForNavigation'), isFalse);
      expect(readerSource.contains('distanceFilter'), isFalse);
    });

    test('changed-files source scan report', () {
      final List<File> changed = <File>[
        File('lib/services/foreground_city_classification_bridge.dart'),
        File('lib/services/foreground_position_reader.dart'),
      ];
      final List<String> tokens = <String>[
        'getCurrentPosition',
        'getPositionStream',
        'getLastKnownPosition',
        'Position',
        'latitude',
        'longitude',
        'GeoPoint',
        'SharedPreferences',
        'secure storage',
        'http',
        'dio',
        'analytics',
        'print(',
        'debugPrint(',
        'jsonEncode',
        'Navigator',
        'LocationConfirmationScreen',
        'membership',
        'account',
        'eligible',
        'approved',
        'rejected',
      ];

      for (final File file in changed) {
        final String source = file.readAsStringSync();
        // ignore: avoid_print
        // Report occurrences for delivery; assertions encode expectations.
        for (final String token in tokens) {
          final bool present = token == 'print('
              ? RegExp(r'\bprint\s*\(').hasMatch(source)
              : token == 'http'
                  ? RegExp(r'\bhttp\b').hasMatch(source)
                  : source.contains(token);

          if (file.path.endsWith('foreground_city_classification_bridge.dart')) {
            if (token == 'latitude' || token == 'longitude') {
              // Allowed only as transient callback parameter names.
              expect(source.contains('required double $token'), isTrue);
            } else if (token == 'Position') {
              // Bridge must not retain or construct Position objects.
              expect(RegExp(r'\bfinal Position\b').hasMatch(source), isFalse);
              expect(source.contains('Position('), isFalse);
            } else if (token == 'GeoPoint' ||
                token == 'getCurrentPosition' ||
                token == 'getPositionStream' ||
                token == 'getLastKnownPosition' ||
                token == 'SharedPreferences' ||
                token == 'secure storage' ||
                token == 'http' ||
                token == 'dio' ||
                token == 'analytics' ||
                token == 'print(' ||
                token == 'debugPrint(' ||
                token == 'jsonEncode' ||
                token == 'Navigator' ||
                token == 'LocationConfirmationScreen' ||
                token == 'membership' ||
                token == 'account' ||
                token == 'eligible' ||
                token == 'approved' ||
                token == 'rejected') {
              expect(present, isFalse, reason: '${file.path} token $token');
            }
          }

          if (file.path.endsWith('foreground_position_reader.dart')) {
            if (token == 'getCurrentPosition' ||
                token == 'Position' ||
                token == 'latitude' ||
                token == 'longitude') {
              expect(present, isTrue);
            } else if (token == 'GeoPoint' ||
                token == 'getPositionStream' ||
                token == 'getLastKnownPosition' ||
                token == 'SharedPreferences' ||
                token == 'secure storage' ||
                token == 'http' ||
                token == 'dio' ||
                token == 'analytics' ||
                token == 'print(' ||
                token == 'debugPrint(' ||
                token == 'jsonEncode' ||
                token == 'Navigator' ||
                token == 'LocationConfirmationScreen' ||
                token == 'membership' ||
                token == 'account' ||
                token == 'eligible' ||
                token == 'approved' ||
                token == 'rejected') {
              expect(present, isFalse, reason: '${file.path} token $token');
            }
          }
        }
      }
    });
  });
}
