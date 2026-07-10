import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:town_safe_space_mobile/services/boundary_asset_loader.dart';

/// Expected SHA-256 digests from data/boundaries/CHECKSUMS.sha256.
const String kExpectedMilanoSimplifiedSha256 =
    '6f4e7c0b68afad26fe5de137929a4162b2495f9bb402c8876f36eee2a2d18a6b';
const String kExpectedMunichSimplifiedSha256 =
    'b6c0b97cc9979742e45ab19219fcf5fd03bdf7cce6758b1de1b6f2533f0f2918';

const String kMilanoSourcePath =
    'data/boundaries/derived/milano_boundary_simplified.geojson';
const String kMunichSourcePath =
    'data/boundaries/derived/munich_boundary_simplified.geojson';
const String kMilanoAssetPath =
    'assets/boundaries/milano_boundary_simplified.geojson';
const String kMunichAssetPath =
    'assets/boundaries/munich_boundary_simplified.geojson';

String _sha256OfFile(String path) {
  final ProcessResult result = Process.runSync('sha256sum', <String>[path]);
  expect(result.exitCode, 0, reason: result.stderr.toString());
  final String stdout = result.stdout.toString().trim();
  return stdout.split(RegExp(r'\s+')).first;
}

bool _filesAreByteIdentical(String a, String b) {
  final ProcessResult result = Process.runSync('cmp', <String>[a, b]);
  return result.exitCode == 0;
}

Map<String, dynamic> _validMinimalBoundary({
  String city = 'milano',
  String geometryType = 'Polygon',
  String intendedUse = 'city_access',
  String bundledStatus = 'NOT YET BUNDLED',
  String internalVersion = 'milano-admin-2024-11-04-v1',
  bool includeFeatures = true,
  bool includeProperties = true,
  bool includeGeometry = true,
  bool includeCoordinates = true,
  bool includeCrs = true,
}) {
  final Map<String, dynamic> geometry = <String, dynamic>{
    'type': geometryType,
  };
  if (includeCoordinates) {
    geometry['coordinates'] = <dynamic>[
      <dynamic>[
        <dynamic>[9.0, 45.0],
        <dynamic>[9.1, 45.0],
        <dynamic>[9.1, 45.1],
        <dynamic>[9.0, 45.0],
      ],
    ];
  }

  final Map<String, dynamic> feature = <String, dynamic>{
    'type': 'Feature',
  };
  if (includeGeometry) {
    feature['geometry'] = geometry;
  }
  if (includeProperties) {
    feature['properties'] = <String, dynamic>{
      'city': city,
      'intended_use': intendedUse,
      'bundled_status': bundledStatus,
      'internal_boundary_version': internalVersion,
      'authority': 'Test Authority',
      'dataset': 'Test Dataset',
      'licence': 'CC BY 4.0',
      'crs_epsg': 4326,
    };
  }

  final Map<String, dynamic> collection = <String, dynamic>{
    'type': 'FeatureCollection',
  };
  if (includeFeatures) {
    collection['features'] = <dynamic>[feature];
  }
  if (includeCrs) {
    collection['crs'] = <String, dynamic>{
      'type': 'name',
      'properties': <String, dynamic>{
        'name': 'urn:ogc:def:crs:EPSG::4326',
      },
    };
  }
  return collection;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const BoundaryAssetLoader loader = BoundaryAssetLoader();

  group('approved source checksums', () {
    test('Milano approved source checksum matches expected', () {
      expect(File(kMilanoSourcePath).existsSync(), isTrue);
      expect(_sha256OfFile(kMilanoSourcePath), kExpectedMilanoSimplifiedSha256);
    });

    test('Munich approved source checksum matches expected', () {
      expect(File(kMunichSourcePath).existsSync(), isTrue);
      expect(_sha256OfFile(kMunichSourcePath), kExpectedMunichSimplifiedSha256);
    });
  });

  group('asset copies are byte-identical to approved sources', () {
    test('Milano asset copy matches derived source bytes and checksum', () {
      expect(File(kMilanoAssetPath).existsSync(), isTrue);
      expect(
        _filesAreByteIdentical(kMilanoSourcePath, kMilanoAssetPath),
        isTrue,
      );
      expect(_sha256OfFile(kMilanoAssetPath), kExpectedMilanoSimplifiedSha256);
    });

    test('Munich asset copy matches derived source bytes and checksum', () {
      expect(File(kMunichAssetPath).existsSync(), isTrue);
      expect(
        _filesAreByteIdentical(kMunichSourcePath, kMunichAssetPath),
        isTrue,
      );
      expect(_sha256OfFile(kMunichAssetPath), kExpectedMunichSimplifiedSha256);
    });
  });

  group('Flutter asset loading and structural validation', () {
    test('Milano asset loads successfully through Flutter asset loading',
        () async {
      final BoundaryAssetMetadata metadata =
          await loader.loadBoundary(BoundaryAssetPaths.milano);
      expect(metadata.city, 'milano');
      expect(metadata.featureCount, 1);
      expect(
        metadata.geometryType == 'Polygon' ||
            metadata.geometryType == 'MultiPolygon',
        isTrue,
      );
      expect(metadata.crs, 'EPSG:4326');
      expect(metadata.intendedUse, 'city_access');
      expect(metadata.bundledStatus, 'NOT YET BUNDLED');
      expect(
        metadata.internalBoundaryVersion,
        'milano-admin-2024-11-04-v1',
      );
      expect(metadata.licence, 'CC BY 4.0');
      expect(metadata.authority, isNotEmpty);
      expect(metadata.dataset, isNotEmpty);
    });

    test('Munich asset loads successfully through Flutter asset loading',
        () async {
      final BoundaryAssetMetadata metadata =
          await loader.loadBoundary(BoundaryAssetPaths.munich);
      expect(metadata.city, 'munich');
      expect(metadata.featureCount, 1);
      expect(
        metadata.geometryType == 'Polygon' ||
            metadata.geometryType == 'MultiPolygon',
        isTrue,
      );
      expect(metadata.crs, 'EPSG:4326');
      expect(metadata.intendedUse, 'city_access');
      expect(metadata.bundledStatus, 'NOT YET BUNDLED');
      expect(
        metadata.internalBoundaryVersion,
        'munich-admin-2026-05-27-v1',
      );
      expect(metadata.licence, 'dl-de/by-2.0');
      expect(metadata.authority, isNotEmpty);
      expect(metadata.dataset, isNotEmpty);
    });

    test('both assets are FeatureCollection with one Feature', () async {
      for (final String path in <String>[
        BoundaryAssetPaths.milano,
        BoundaryAssetPaths.munich,
      ]) {
        final String text = await rootBundle.loadString(path);
        final Object? decoded = jsonDecode(text);
        expect(decoded, isA<Map<String, dynamic>>());
        final Map<String, dynamic> map = decoded! as Map<String, dynamic>;
        expect(map['type'], 'FeatureCollection');
        expect(map['features'], isA<List<dynamic>>());
        expect((map['features'] as List<dynamic>).length, 1);
        final Map<String, dynamic> feature =
            (map['features'] as List<dynamic>).first as Map<String, dynamic>;
        expect(feature['type'], 'Feature');
      }
    });
  });

  group('decodeAndValidate rejects malformed assets', () {
    test('malformed JSON is rejected', () {
      expect(
        () => loader.decodeAndValidate('{not-json'),
        throwsA(
          isA<BoundaryAssetException>().having(
            (BoundaryAssetException e) => e.message,
            'message',
            contains('not valid JSON'),
          ),
        ),
      );
    });

    test('missing features is rejected', () {
      final Map<String, dynamic> payload =
          _validMinimalBoundary(includeFeatures: false);
      expect(
        () => loader.decodeAndValidate(jsonEncode(payload)),
        throwsA(
          isA<BoundaryAssetException>().having(
            (BoundaryAssetException e) => e.message,
            'message',
            contains('missing features'),
          ),
        ),
      );
    });

    test('invalid geometry type is rejected', () {
      final Map<String, dynamic> payload =
          _validMinimalBoundary(geometryType: 'Point');
      expect(
        () => loader.decodeAndValidate(jsonEncode(payload)),
        throwsA(
          isA<BoundaryAssetException>().having(
            (BoundaryAssetException e) => e.message,
            'message',
            contains('Polygon or MultiPolygon'),
          ),
        ),
      );
    });

    test('missing required metadata is rejected', () {
      final Map<String, dynamic> payload = _validMinimalBoundary();
      final Map<String, dynamic> feature =
          (payload['features'] as List<dynamic>).first as Map<String, dynamic>;
      final Map<String, dynamic> properties =
          feature['properties'] as Map<String, dynamic>;
      properties.remove('authority');

      expect(
        () => loader.decodeAndValidate(jsonEncode(payload)),
        throwsA(
          isA<BoundaryAssetException>().having(
            (BoundaryAssetException e) => e.message,
            'message',
            contains('authority'),
          ),
        ),
      );
    });

    test('wrong intended_use is rejected', () {
      final Map<String, dynamic> payload =
          _validMinimalBoundary(intendedUse: 'other');
      expect(
        () => loader.decodeAndValidate(jsonEncode(payload)),
        throwsA(isA<BoundaryAssetException>()),
      );
    });

    test('wrong bundled_status is rejected', () {
      final Map<String, dynamic> payload =
          _validMinimalBoundary(bundledStatus: 'BUNDLED');
      expect(
        () => loader.decodeAndValidate(jsonEncode(payload)),
        throwsA(isA<BoundaryAssetException>()),
      );
    });

    test('unknown city is rejected', () {
      final Map<String, dynamic> payload =
          _validMinimalBoundary(city: 'rome');
      expect(
        () => loader.decodeAndValidate(jsonEncode(payload)),
        throwsA(isA<BoundaryAssetException>()),
      );
    });

    test('missing CRS is rejected', () {
      final Map<String, dynamic> payload =
          _validMinimalBoundary(includeCrs: false);
      final Map<String, dynamic> feature =
          (payload['features'] as List<dynamic>).first as Map<String, dynamic>;
      final Map<String, dynamic> properties =
          feature['properties'] as Map<String, dynamic>;
      properties.remove('crs_epsg');

      expect(
        () => loader.decodeAndValidate(jsonEncode(payload)),
        throwsA(
          isA<BoundaryAssetException>().having(
            (BoundaryAssetException e) => e.message,
            'message',
            contains('EPSG:4326'),
          ),
        ),
      );
    });

    test('valid MultiPolygon is accepted', () {
      final Map<String, dynamic> payload =
          _validMinimalBoundary(geometryType: 'MultiPolygon');
      final Map<String, dynamic> feature =
          (payload['features'] as List<dynamic>).first as Map<String, dynamic>;
      final Map<String, dynamic> geometry =
          feature['geometry'] as Map<String, dynamic>;
      geometry['coordinates'] = <dynamic>[
        <dynamic>[
          <dynamic>[
            <dynamic>[9.0, 45.0],
            <dynamic>[9.1, 45.0],
            <dynamic>[9.1, 45.1],
            <dynamic>[9.0, 45.0],
          ],
        ],
      ];

      final BoundaryAssetMetadata metadata =
          loader.decodeAndValidate(jsonEncode(payload));
      expect(metadata.geometryType, 'MultiPolygon');
    });
  });

  group('loader API and scope guards', () {
    test('loader API contains no coordinate-verification method', () {
      final String source =
          File('lib/services/boundary_asset_loader.dart').readAsStringSync();
      expect(source.contains('loadBoundary'), isTrue);
      expect(source.contains('decodeAndValidate'), isTrue);

      final List<String> forbiddenApiTokens = <String>[
        'verifyCity',
        'isInside',
        'isOutside',
        'containsPoint',
        'pointInPolygon',
        'point_in_polygon',
        'checkInside',
        'checkOutside',
        'verifyLocation',
        'userLatitude',
        'userLongitude',
        'getCurrentPosition',
        'getPositionStream',
      ];
      for (final String token in forbiddenApiTokens) {
        expect(
          source.contains(token),
          isFalse,
          reason: 'Forbidden API token "$token" found in loader',
        );
      }
    });

    test('no point-in-polygon implementation exists in loader', () {
      final String source =
          File('lib/services/boundary_asset_loader.dart').readAsStringSync();
      for (final String token in <String>[
        'pointInPolygon',
        'ray cast',
        'rayCast',
        'winding',
        'windingNumber',
        'containsPoint',
      ]) {
        expect(source.toLowerCase().contains(token.toLowerCase()), isFalse);
      }
    });

    test('no user location API is used in loader', () {
      final String source =
          File('lib/services/boundary_asset_loader.dart').readAsStringSync();
      expect(source.contains('geolocator'), isFalse);
      expect(source.contains('getCurrentPosition'), isFalse);
      expect(source.contains('getPositionStream'), isFalse);
      expect(source.contains('Position'), isFalse);
      expect(source.contains('latitude'), isFalse);
      expect(source.contains('longitude'), isFalse);
    });

    test('BoundaryAssetMetadata does not expose coordinates', () {
      final String source =
          File('lib/services/boundary_asset_loader.dart').readAsStringSync();
      expect(source.contains('class BoundaryAssetMetadata'), isTrue);
      // Public model fields must not include coordinate arrays.
      final RegExp metadataClass = RegExp(
        r'class BoundaryAssetMetadata \{[\s\S]*?\n\}',
      );
      final Match? match = metadataClass.firstMatch(source);
      expect(match, isNotNull);
      expect(
        match!.group(0)!.toLowerCase().contains('coordinate'),
        isFalse,
      );
    });

    test('no screen or navigation behaviour changed by this task', () {
      // This task must not modify screens or navigation. Confirm screen
      // sources exist and the new loader does not import them.
      expect(File('lib/screens/welcome_screen.dart').existsSync(), isTrue);
      expect(File('lib/screens/select_city_screen.dart').existsSync(), isTrue);
      expect(
        File('lib/screens/location_confirmation_screen.dart').existsSync(),
        isTrue,
      );
      final String loader =
          File('lib/services/boundary_asset_loader.dart').readAsStringSync();
      expect(loader.contains("package:town_safe_space_mobile/screens/"), isFalse);
      expect(loader.contains('MaterialPageRoute'), isFalse);
      expect(loader.contains('pushNamed'), isFalse);
    });
  });
}
