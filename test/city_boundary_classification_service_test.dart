import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:town_safe_space_mobile/geometry/point_in_polygon_engine.dart';
import 'package:town_safe_space_mobile/services/boundary_asset_loader.dart';
import 'package:town_safe_space_mobile/services/city_boundary_classification_service.dart';

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

Map<String, dynamic> _minimalBoundary({
  required String city,
  String geometryType = 'Polygon',
  List<dynamic>? coordinates,
}) {
  return <String, dynamic>{
    'type': 'FeatureCollection',
    'crs': <String, dynamic>{
      'type': 'name',
      'properties': <String, dynamic>{
        'name': 'urn:ogc:def:crs:EPSG::4326',
      },
    },
    'features': <dynamic>[
      <String, dynamic>{
        'type': 'Feature',
        'properties': <String, dynamic>{
          'city': city,
          'intended_use': 'city_access',
          'bundled_status': 'NOT YET BUNDLED',
          'internal_boundary_version': '$city-test-v1',
          'authority': 'Test Authority',
          'dataset': 'Test Dataset',
          'licence': 'CC BY 4.0',
          'crs_epsg': 4326,
        },
        'geometry': <String, dynamic>{
          'type': geometryType,
          'coordinates': coordinates ??
              <dynamic>[
                <dynamic>[
                  <dynamic>[9.0, 45.0],
                  <dynamic>[9.2, 45.0],
                  <dynamic>[9.2, 45.2],
                  <dynamic>[9.0, 45.2],
                  <dynamic>[9.0, 45.0],
                ],
              ],
        },
      },
    ],
  };
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

class _ThrowingGeometryParser extends BoundaryGeometryParser {
  @override
  BoundaryGeometry parseFeatureCollectionJson(String jsonText) {
    throw const GeometryParseException('Forced parse failure.');
  }
}

class _ThrowingEngine extends PointInPolygonEngine {
  @override
  PointContainment classify({
    required BoundaryGeometry geometry,
    required GeoPoint point,
  }) {
    throw StateError('Forced classification failure.');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('city-to-asset mapping', () {
    test('Milano maps to the Milano approved asset', () {
      expect(
        CityBoundaryClassificationService.assetPathForCity('Milano'),
        BoundaryAssetPaths.milano,
      );
      expect(
        CityBoundaryClassificationService.cityAssetPaths['Milano'],
        'assets/boundaries/milano_boundary_simplified.geojson',
      );
    });

    test('Munich maps to the Munich approved asset', () {
      expect(
        CityBoundaryClassificationService.assetPathForCity('Munich'),
        BoundaryAssetPaths.munich,
      );
      expect(
        CityBoundaryClassificationService.cityAssetPaths['Munich'],
        'assets/boundaries/munich_boundary_simplified.geojson',
      );
    });

    test('unsupported city is rejected', () {
      expect(
        () => CityBoundaryClassificationService.assetPathForCity('Rome'),
        throwsA(
          isA<CityBoundaryClassificationException>().having(
            (CityBoundaryClassificationException e) => e.message,
            'message',
            'Unsupported city.',
          ),
        ),
      );
      expect(
        () => CityBoundaryClassificationService.assetPathForCity('milano'),
        throwsA(isA<CityBoundaryClassificationException>()),
      );
      expect(
        () => CityBoundaryClassificationService.assetPathForCity(''),
        throwsA(isA<CityBoundaryClassificationException>()),
      );
    });
  });

  group('metadata city mismatch', () {
    test('metadata city mismatch is rejected without classifying', () async {
      final String swapped = jsonEncode(_minimalBoundary(city: 'munich'));
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        bundle: _MapAssetBundle(<String, String>{
          BoundaryAssetPaths.milano: swapped,
        }),
      );

      await expectLater(
        service.classifyCoordinatesTransiently(
          selectedCity: 'Milano',
          longitude: kMilanoInsideLon,
          latitude: kMilanoInsideLat,
          accuracyMeters: 12.4,
        ),
        throwsA(
          isA<CityBoundaryClassificationException>().having(
            (CityBoundaryClassificationException e) => e.message,
            'message',
            'Boundary metadata city does not match selected city.',
          ),
        ),
      );
    });
  });

  group('real-asset geometry regression (Milano)', () {
    late CityBoundaryClassificationService service;

    setUp(() {
      service = CityBoundaryClassificationService(
        clock: () => DateTime.utc(2026, 7, 11, 12),
      );
    });

    test('Milano fixed inside point returns inside', () async {
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Milano',
        longitude: kMilanoInsideLon,
        latitude: kMilanoInsideLat,
        accuracyMeters: 10,
      );
      expect(result.city, 'Milano');
      expect(result.containment, PointContainment.inside);
    });

    test('Milano fixed outside point returns outside', () async {
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Milano',
        longitude: kMilanoOutsideLon,
        latitude: kMilanoOutsideLat,
        accuracyMeters: 10,
      );
      expect(result.containment, PointContainment.outside);
    });

    test('Milano fixed boundary vertex returns boundary', () async {
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Milano',
        longitude: kMilanoBoundaryLon,
        latitude: kMilanoBoundaryLat,
        accuracyMeters: 10,
      );
      expect(result.containment, PointContainment.boundary);
    });
  });

  group('real-asset geometry regression (Munich)', () {
    late CityBoundaryClassificationService service;

    setUp(() {
      service = CityBoundaryClassificationService(
        clock: () => DateTime.utc(2026, 7, 11, 12),
      );
    });

    test('Munich fixed inside point returns inside', () async {
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Munich',
        longitude: kMunichInsideLon,
        latitude: kMunichInsideLat,
        accuracyMeters: 10,
      );
      expect(result.city, 'Munich');
      expect(result.containment, PointContainment.inside);
    });

    test('Munich fixed outside point returns outside', () async {
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Munich',
        longitude: kMunichOutsideLon,
        latitude: kMunichOutsideLat,
        accuracyMeters: 10,
      );
      expect(result.containment, PointContainment.outside);
    });

    test('Munich fixed boundary vertex returns boundary', () async {
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Munich',
        longitude: kMunichBoundaryLon,
        latitude: kMunichBoundaryLat,
        accuracyMeters: 10,
      );
      expect(result.containment, PointContainment.boundary);
    });
  });

  group('accuracy, timestamp, and result shape', () {
    test('accuracy is rounded correctly', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        clock: () => DateTime.utc(2026, 7, 11, 12),
      );

      final CityBoundaryClassificationResult down =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Milano',
        longitude: kMilanoInsideLon,
        latitude: kMilanoInsideLat,
        accuracyMeters: 12.4,
      );
      expect(down.accuracyMeters, 12);

      final CityBoundaryClassificationResult up =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Milano',
        longitude: kMilanoInsideLon,
        latitude: kMilanoInsideLat,
        accuracyMeters: 12.5,
      );
      expect(up.accuracyMeters, 13);
    });

    test('zero accuracy is accepted and retained as 0', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        clock: () => DateTime.utc(2026, 7, 11, 12),
      );
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Milano',
        longitude: kMilanoInsideLon,
        latitude: kMilanoInsideLat,
        accuracyMeters: 0,
      );
      expect(result.accuracyMeters, 0);
    });

    test('NaN accuracy is rejected', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        clock: () => DateTime.utc(2026, 7, 11, 12),
      );
      try {
        await service.classifyCoordinatesTransiently(
          selectedCity: 'Milano',
          longitude: kMilanoInsideLon,
          latitude: kMilanoInsideLat,
          accuracyMeters: double.nan,
        );
        fail('Expected CityBoundaryClassificationException');
      } on CityBoundaryClassificationException catch (e) {
        expect(e.message, 'Invalid accuracy value.');
        expect(e.message.contains('NaN'), isFalse);
        expect(e.toString().contains('NaN'), isFalse);
      }
    });

    test('positive infinity accuracy is rejected', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        clock: () => DateTime.utc(2026, 7, 11, 12),
      );
      try {
        await service.classifyCoordinatesTransiently(
          selectedCity: 'Milano',
          longitude: kMilanoInsideLon,
          latitude: kMilanoInsideLat,
          accuracyMeters: double.infinity,
        );
        fail('Expected CityBoundaryClassificationException');
      } on CityBoundaryClassificationException catch (e) {
        expect(e.message, 'Invalid accuracy value.');
        expect(e.message.contains('Infinity'), isFalse);
        expect(e.toString().contains('Infinity'), isFalse);
      }
    });

    test('negative infinity accuracy is rejected', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        clock: () => DateTime.utc(2026, 7, 11, 12),
      );
      try {
        await service.classifyCoordinatesTransiently(
          selectedCity: 'Milano',
          longitude: kMilanoInsideLon,
          latitude: kMilanoInsideLat,
          accuracyMeters: double.negativeInfinity,
        );
        fail('Expected CityBoundaryClassificationException');
      } on CityBoundaryClassificationException catch (e) {
        expect(e.message, 'Invalid accuracy value.');
        expect(e.message.contains('Infinity'), isFalse);
      }
    });

    test('negative finite accuracy is rejected', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        clock: () => DateTime.utc(2026, 7, 11, 12),
      );
      try {
        await service.classifyCoordinatesTransiently(
          selectedCity: 'Milano',
          longitude: kMilanoInsideLon,
          latitude: kMilanoInsideLat,
          accuracyMeters: -0.1,
        );
        fail('Expected CityBoundaryClassificationException');
      } on CityBoundaryClassificationException catch (e) {
        expect(e.message, 'Invalid accuracy value.');
        expect(e.message.contains('-0.1'), isFalse);
        expect(e.toString().contains('-0.1'), isFalse);
      }
    });

    test('default clock produces UTC classifiedAt', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService();
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Milano',
        longitude: kMilanoInsideLon,
        latitude: kMilanoInsideLat,
        accuracyMeters: 10,
      );
      expect(result.classifiedAt.isUtc, isTrue);
    });

    test('injected UTC clock remains unchanged', () async {
      final DateTime fixed = DateTime.utc(2026, 1, 2, 3, 4, 5);
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(clock: () => fixed);
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Munich',
        longitude: kMunichInsideLon,
        latitude: kMunichInsideLat,
        accuracyMeters: 8.2,
      );
      expect(result.classifiedAt, fixed);
      expect(result.classifiedAt.isUtc, isTrue);
      expect(result.accuracyMeters, 8);
    });

    test('injected local DateTime is converted to equivalent UTC instant',
        () async {
      final DateTime local = DateTime(2026, 3, 15, 14, 30, 0);
      expect(local.isUtc, isFalse);
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(clock: () => local);
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Milano',
        longitude: kMilanoInsideLon,
        latitude: kMilanoInsideLat,
        accuracyMeters: 10,
      );
      expect(result.classifiedAt.isUtc, isTrue);
      expect(result.classifiedAt, local.toUtc());
      expect(
        result.classifiedAt.millisecondsSinceEpoch,
        local.millisecondsSinceEpoch,
      );
    });

    test('injected offset DateTime is converted to equivalent UTC instant',
        () async {
      final DateTime offset =
          DateTime.parse('2026-07-11T12:00:00+02:00');
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(clock: () => offset);
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Munich',
        longitude: kMunichInsideLon,
        latitude: kMunichInsideLat,
        accuracyMeters: 10,
      );
      expect(result.classifiedAt.isUtc, isTrue);
      expect(result.classifiedAt, offset.toUtc());
      expect(
        result.classifiedAt.millisecondsSinceEpoch,
        offset.millisecondsSinceEpoch,
      );
      expect(result.classifiedAt, DateTime.utc(2026, 7, 11, 10));
    });

    test('final result contains only privacy-safe fields', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        clock: () => DateTime.utc(2026, 7, 11, 12),
      );
      final CityBoundaryClassificationResult result =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Milano',
        longitude: kMilanoInsideLon,
        latitude: kMilanoInsideLat,
        accuracyMeters: 10.1,
      );

      expect(result.city, 'Milano');
      expect(result.containment, PointContainment.inside);
      expect(result.accuracyMeters, 10);
      expect(result.classifiedAt, DateTime.utc(2026, 7, 11, 12));

      // Source-level: result class must not declare coordinate fields.
      final String source = File(
        'lib/services/city_boundary_classification_service.dart',
      ).readAsStringSync();
      final RegExp resultClass = RegExp(
        r'class CityBoundaryClassificationResult \{[\s\S]*?\n\}',
      );
      final Match? match = resultClass.firstMatch(source);
      expect(match, isNotNull);
      final String body = match!.group(0)!;
      expect(body.contains('latitude'), isFalse);
      expect(body.contains('longitude'), isFalse);
      expect(body.contains('Position'), isFalse);
      expect(body.contains('GeoPoint'), isFalse);
      expect(body.contains('geometry'), isFalse);
      expect(body.contains('coordinates'), isFalse);
      expect(body.contains('serialize'), isFalse);
      expect(body.contains('toJson'), isFalse);
      expect(body.contains('SharedPreferences'), isFalse);
    });
  });

  group('error handling without coordinate leakage', () {
    test('asset load failure has no coordinate values in error', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        bundle: _MapAssetBundle(<String, String>{}),
      );

      try {
        await service.classifyCoordinatesTransiently(
          selectedCity: 'Milano',
          longitude: kMilanoInsideLon,
          latitude: kMilanoInsideLat,
          accuracyMeters: 10,
        );
        fail('Expected CityBoundaryClassificationException');
      } on CityBoundaryClassificationException catch (e) {
        expect(e.message.contains('latitude'), isFalse);
        expect(e.message.contains('longitude'), isFalse);
        expect(e.message.contains('$kMilanoInsideLon'), isFalse);
        expect(e.message.contains('$kMilanoInsideLat'), isFalse);
        expect(e.toString().contains('$kMilanoInsideLon'), isFalse);
        expect(e.toString().contains('$kMilanoInsideLat'), isFalse);
      }
    });

    test('malformed boundary metadata is rejected safely', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        bundle: _MapAssetBundle(<String, String>{
          BoundaryAssetPaths.milano: '{not-json',
        }),
      );

      await expectLater(
        service.classifyCoordinatesTransiently(
          selectedCity: 'Milano',
          longitude: kMilanoInsideLon,
          latitude: kMilanoInsideLat,
          accuracyMeters: 10,
        ),
        throwsA(
          isA<CityBoundaryClassificationException>().having(
            (CityBoundaryClassificationException e) => e.message,
            'message',
            isNot(contains('9.185')),
          ),
        ),
      );
    });

    test('geometry parse failure is handled without coordinates', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        bundle: _MapAssetBundle(<String, String>{
          BoundaryAssetPaths.milano: jsonEncode(
            _minimalBoundary(city: 'milano'),
          ),
        }),
        geometryParser: _ThrowingGeometryParser(),
      );

      try {
        await service.classifyCoordinatesTransiently(
          selectedCity: 'Milano',
          longitude: 9.1,
          latitude: 45.1,
          accuracyMeters: 5,
        );
        fail('Expected CityBoundaryClassificationException');
      } on CityBoundaryClassificationException catch (e) {
        expect(e.message, 'Failed to parse boundary geometry.');
        expect(e.message.contains('9.1'), isFalse);
        expect(e.message.contains('45.1'), isFalse);
        expect(e.toString().contains('9.1'), isFalse);
      }
    });

    test('classification failure is handled without coordinates', () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        bundle: _MapAssetBundle(<String, String>{
          BoundaryAssetPaths.milano: jsonEncode(
            _minimalBoundary(city: 'milano'),
          ),
        }),
        engine: _ThrowingEngine(),
      );

      try {
        await service.classifyCoordinatesTransiently(
          selectedCity: 'Milano',
          longitude: 9.1,
          latitude: 45.1,
          accuracyMeters: 5,
        );
        fail('Expected CityBoundaryClassificationException');
      } on CityBoundaryClassificationException catch (e) {
        expect(e.message, 'Classification failed.');
        expect(e.toString().contains('9.1'), isFalse);
        expect(e.toString().contains('45.1'), isFalse);
      }
    });

    test('unsupported city classify call rejects without loading GPS',
        () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        bundle: _MapAssetBundle(<String, String>{}),
      );
      await expectLater(
        service.classifyCoordinatesTransiently(
          selectedCity: 'Berlin',
          longitude: 13.4,
          latitude: 52.5,
          accuracyMeters: 10,
        ),
        throwsA(
          isA<CityBoundaryClassificationException>().having(
            (CityBoundaryClassificationException e) => e.message,
            'message',
            'Unsupported city.',
          ),
        ),
      );
    });
  });

  group('determinism and isolation', () {
    test('repeated calls are deterministic for geometry classification',
        () async {
      final CityBoundaryClassificationService service =
          CityBoundaryClassificationService(
        clock: () => DateTime.utc(2026, 7, 11, 12),
      );

      final CityBoundaryClassificationResult a =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Milano',
        longitude: kMilanoInsideLon,
        latitude: kMilanoInsideLat,
        accuracyMeters: 10,
      );
      final CityBoundaryClassificationResult b =
          await service.classifyCoordinatesTransiently(
        selectedCity: 'Milano',
        longitude: kMilanoInsideLon,
        latitude: kMilanoInsideLat,
        accuracyMeters: 10,
      );

      expect(a.containment, b.containment);
      expect(a.city, b.city);
      expect(a.accuracyMeters, b.accuracyMeters);
      expect(a.classifiedAt, b.classifiedAt);
      expect(a.containment, PointContainment.inside);
    });

    test('classification does not call getCurrentPosition', () {
      final String source = File(
        'lib/services/city_boundary_classification_service.dart',
      ).readAsStringSync();
      expect(source.contains('getCurrentPosition'), isFalse);
      expect(source.contains('getPositionStream'), isFalse);
      expect(source.contains('getLastKnownPosition'), isFalse);
      expect(source.contains('Geolocator'), isFalse);
      expect(source.contains('geolocator'), isFalse);
    });
  });

  group('scope and privacy source scan', () {
    late String serviceSource;
    late List<File> changedLibFiles;
    late List<File> screenFiles;

    setUpAll(() {
      serviceSource = File(
        'lib/services/city_boundary_classification_service.dart',
      ).readAsStringSync();
      changedLibFiles = <File>[
        File('lib/services/city_boundary_classification_service.dart'),
      ];
      screenFiles = Directory('lib/screens')
          .listSync()
          .whereType<File>()
          .where((File f) => f.path.endsWith('.dart'))
          .toList();
    });

    test('no persistence, transmission, logging, or analytics in service', () {
      for (final String token in <String>[
        'SharedPreferences',
        'secure storage',
        'FlutterSecureStorage',
        'http',
        'dio',
        'analytics',
        'Firebase',
        'jsonEncode',
        'writeAsString',
        'File(',
      ]) {
        expect(
          serviceSource.contains(token),
          isFalse,
          reason: 'Forbidden token "$token" in classification service',
        );
      }
      expect(RegExp(r'\bprint\s*\(').hasMatch(serviceSource), isFalse);
      expect(serviceSource.contains('debugPrint('), isFalse);
    });

    test('no screen, navigation, membership, or account logic', () {
      expect(serviceSource.contains('Navigator'), isFalse);
      expect(serviceSource.contains('LocationConfirmationScreen'), isFalse);
      expect(serviceSource.contains('MaterialPageRoute'), isFalse);
      expect(serviceSource.contains('membership'), isFalse);
      expect(serviceSource.contains('account'), isFalse);
      expect(serviceSource.contains('eligibility'), isFalse);
      expect(serviceSource.contains('startMembership'), isFalse);
      expect(serviceSource.contains('createAccount'), isFalse);
    });

    test('only local boundary assets are used', () {
      expect(serviceSource.contains('BoundaryAssetPaths.milano'), isTrue);
      expect(serviceSource.contains('BoundaryAssetPaths.munich'), isTrue);
      expect(
        CityBoundaryClassificationService.cityAssetPaths['Milano'],
        'assets/boundaries/milano_boundary_simplified.geojson',
      );
      expect(
        CityBoundaryClassificationService.cityAssetPaths['Munich'],
        'assets/boundaries/munich_boundary_simplified.geojson',
      );
      expect(serviceSource.contains('http://'), isFalse);
      expect(serviceSource.contains('https://'), isFalse);
      expect(serviceSource.contains('data/boundaries/'), isFalse);
    });

    test('no continuous location APIs anywhere in changed service', () {
      expect(serviceSource.contains('getPositionStream'), isFalse);
      expect(serviceSource.contains('getLastKnownPosition'), isFalse);
      expect(serviceSource.contains('getCurrentPosition'), isFalse);
    });

    test('screens were not modified by this task', () {
      // Classification service must not import screens; screens must not
      // import the classification service yet.
      for (final File screen in screenFiles) {
        final String source = screen.readAsStringSync();
        expect(
          source.contains('city_boundary_classification_service'),
          isFalse,
          reason: '${screen.path} must not reference classification service',
        );
      }
      expect(
        serviceSource.contains("package:town_safe_space_mobile/screens/"),
        isFalse,
      );
    });

    test('result model has no serialization or persistence methods', () {
      final RegExp resultClass = RegExp(
        r'class CityBoundaryClassificationResult \{[\s\S]*?\n\}',
      );
      final String body = resultClass.firstMatch(serviceSource)!.group(0)!;
      expect(body.contains('toJson'), isFalse);
      expect(body.contains('fromJson'), isFalse);
      expect(body.contains('serialize'), isFalse);
      expect(body.contains('persist'), isFalse);
      expect(body.contains('save'), isFalse);
      expect(body.contains('upload'), isFalse);
      expect(body.contains('send'), isFalse);
    });

    test('coordinate tokens appear only as transient parameters/locals', () {
      // Allowed: method parameter names and local GeoPoint construction.
      expect(serviceSource.contains('required double longitude'), isTrue);
      expect(serviceSource.contains('required double latitude'), isTrue);
      expect(serviceSource.contains('GeoPoint'), isTrue);

      // Forbidden: retained fields on the result.
      final RegExp resultClass = RegExp(
        r'class CityBoundaryClassificationResult \{[\s\S]*?\n\}',
      );
      final String resultBody =
          resultClass.firstMatch(serviceSource)!.group(0)!;
      expect(resultBody.contains('latitude'), isFalse);
      expect(resultBody.contains('longitude'), isFalse);
      expect(resultBody.contains('Position'), isFalse);
      expect(resultBody.contains('GeoPoint'), isFalse);

      // Exception messages must not interpolate coordinates.
      expect(
        RegExp(r'throw[^;]*\$longitude').hasMatch(serviceSource),
        isFalse,
      );
      expect(
        RegExp(r'throw[^;]*\$latitude').hasMatch(serviceSource),
        isFalse,
      );
    });

    test('changed files source scan report tokens', () {
      final List<String> tokens = <String>[
        'latitude',
        'longitude',
        'Position',
        'GeoPoint',
        'getCurrentPosition',
        'getPositionStream',
        'getLastKnownPosition',
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
      ];

      for (final File file in changedLibFiles) {
        final String source = file.readAsStringSync();
        for (final String token in tokens) {
          final bool present = token == 'print('
              ? RegExp(r'\bprint\s*\(').hasMatch(source)
              : token == 'http'
                  ? RegExp(r'\bhttp\b').hasMatch(source)
                  : source.contains(token);
          if (token == 'latitude' ||
              token == 'longitude' ||
              token == 'GeoPoint') {
            expect(
              present,
              isTrue,
              reason:
                  '${file.path}: "$token" expected as transient only',
            );
          } else if (token == 'Position') {
            // geolocator Position type must not be imported or used.
            expect(
              RegExp(r'\bPosition\b').hasMatch(source),
              isFalse,
              reason: '${file.path}: geolocator Position must not appear',
            );
            expect(source.contains('package:geolocator'), isFalse);
          } else {
            expect(
              present,
              isFalse,
              reason: '${file.path}: forbidden token "$token"',
            );
          }
        }
      }
    });
  });
}
