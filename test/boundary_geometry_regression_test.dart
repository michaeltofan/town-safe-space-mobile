import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:town_safe_space_mobile/geometry/point_in_polygon_engine.dart';
import 'package:town_safe_space_mobile/services/boundary_asset_loader.dart';

/// Fixed regression points against the approved Milano and Munich assets.
///
/// These are synthetic geometry fixtures derived from the bundled GeoJSON.
/// They are **not** user locations, live GPS readings, addresses, or
/// third-party map lookups. No network data is used.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const PointInPolygonEngine engine = PointInPolygonEngine();
  const BoundaryGeometryParser parser = BoundaryGeometryParser();

  // ---------------------------------------------------------------------------
  // Milano fixed regression points
  //
  // Asset: assets/boundaries/milano_boundary_simplified.geojson (Polygon).
  // Bounding box (from exterior ring): lon ≈ [9.0406, 9.2780],
  // lat ≈ [45.3867, 45.5359].
  //
  // Internal (9.185, 45.464):
  //   Selected near the interior of the bbox (Duomo / centro area in degrees).
  //   Verified by the engine itself as PointContainment.inside before recording.
  //   Not a bounding-box centre claim — classification was confirmed.
  //
  // External (8.99, 45.33):
  //   Southwest of the asset bbox with ≥0.05° margin on both axes
  //   (bbox min lon 9.0406 − 0.05 ≈ 8.99; min lat 45.3867 − 0.05 ≈ 45.34).
  //
  // Boundary vertex:
  //   Exact first exterior-ring coordinate from the asset (closed ring).
  // ---------------------------------------------------------------------------
  const GeoPoint milanoInside =
      GeoPoint(longitude: 9.185, latitude: 45.464);
  const GeoPoint milanoOutside =
      GeoPoint(longitude: 8.99, latitude: 45.33);
  const GeoPoint milanoBoundaryVertex = GeoPoint(
    longitude: 9.06993922272781,
    latitude: 45.48067034963818,
  );

  // ---------------------------------------------------------------------------
  // Munich fixed regression points
  //
  // Asset: assets/boundaries/munich_boundary_simplified.geojson (Polygon).
  // Bounding box (from exterior ring): lon ≈ [11.3608, 11.7229],
  // lat ≈ [48.0616, 48.2481].
  //
  // Internal (11.575, 48.137):
  //   Selected near the interior of the bbox (Marienplatz area in degrees).
  //   Verified by the engine as PointContainment.inside before recording.
  //
  // External (11.31, 48.01):
  //   Southwest of the asset bbox with ≥0.05° margin
  //   (bbox min lon 11.3608 − 0.05 ≈ 11.31; min lat 48.0616 − 0.05 ≈ 48.01).
  //
  // Boundary vertex:
  //   Exact first exterior-ring coordinate from the asset (closed ring).
  // ---------------------------------------------------------------------------
  const GeoPoint munichInside =
      GeoPoint(longitude: 11.575, latitude: 48.137);
  const GeoPoint munichOutside =
      GeoPoint(longitude: 11.31, latitude: 48.01);
  const GeoPoint munichBoundaryVertex = GeoPoint(
    longitude: 11.542378141861187,
    latitude: 48.07785667816808,
  );

  Future<BoundaryGeometry> loadAssetGeometry(String assetPath) async {
    final String text = await rootBundle.loadString(assetPath);
    return parser.parseFeatureCollectionJson(text);
  }

  group('Milano approved asset regression', () {
    late BoundaryGeometry milano;

    setUp(() async {
      milano = await loadAssetGeometry(BoundaryAssetPaths.milano);
    });

    test('loads Polygon geometry from Flutter asset', () {
      expect(milano.polygons, hasLength(1));
      expect(milano.polygons.first.exterior.length, greaterThan(3));
      expect(milano.polygons.first.holes, isEmpty);
    });

    test('fixed internal point → inside', () {
      expect(
        engine.classify(geometry: milano, point: milanoInside),
        PointContainment.inside,
      );
    });

    test('fixed external point → outside', () {
      expect(
        engine.classify(geometry: milano, point: milanoOutside),
        PointContainment.outside,
      );
    });

    test('fixed exterior vertex → boundary', () {
      expect(
        engine.classify(geometry: milano, point: milanoBoundaryVertex),
        PointContainment.boundary,
      );
    });
  });

  group('Munich approved asset regression', () {
    late BoundaryGeometry munich;

    setUp(() async {
      munich = await loadAssetGeometry(BoundaryAssetPaths.munich);
    });

    test('loads Polygon geometry from Flutter asset', () {
      expect(munich.polygons, hasLength(1));
      expect(munich.polygons.first.exterior.length, greaterThan(3));
      expect(munich.polygons.first.holes, isEmpty);
    });

    test('fixed internal point → inside', () {
      expect(
        engine.classify(geometry: munich, point: munichInside),
        PointContainment.inside,
      );
    });

    test('fixed external point → outside', () {
      expect(
        engine.classify(geometry: munich, point: munichOutside),
        PointContainment.outside,
      );
    });

    test('fixed exterior vertex → boundary', () {
      expect(
        engine.classify(geometry: munich, point: munichBoundaryVertex),
        PointContainment.boundary,
      );
    });
  });

  group('deterministic parse + classify smoke (no loops)', () {
    test('each approved boundary parses and one classify completes', () async {
      for (final String path in <String>[
        BoundaryAssetPaths.milano,
        BoundaryAssetPaths.munich,
      ]) {
        final BoundaryGeometry geometry = await loadAssetGeometry(path);
        expect(geometry.polygons, isNotEmpty);

        final PointContainment result = engine.classify(
          geometry: geometry,
          point: const GeoPoint(longitude: 0, latitude: 0),
        );
        // Far from Europe → outside; proves classify returns without error.
        expect(result, PointContainment.outside);
      }
      // No continuous loop or background task is started by the engine.
    });
  });
}
