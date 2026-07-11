import 'package:flutter_test/flutter_test.dart';
import 'package:town_safe_space_mobile/geometry/point_in_polygon_engine.dart';

/// Synthetic geometry tests for the isolated point-in-polygon engine.
///
/// These points are pure geometry fixtures — not user locations, not GPS.
void main() {
  const PointInPolygonEngine engine = PointInPolygonEngine();
  const BoundaryGeometryParser parser = BoundaryGeometryParser();

  /// Axis-aligned unit square: (0,0)-(1,0)-(1,1)-(0,1)-(0,0).
  Map<String, dynamic> closedSquare({
    double minLon = 0,
    double minLat = 0,
    double maxLon = 1,
    double maxLat = 1,
  }) {
    return <String, dynamic>{
      'type': 'Polygon',
      'coordinates': <dynamic>[
        <dynamic>[
          <dynamic>[minLon, minLat],
          <dynamic>[maxLon, minLat],
          <dynamic>[maxLon, maxLat],
          <dynamic>[minLon, maxLat],
          <dynamic>[minLon, minLat],
        ],
      ],
    };
  }

  group('simple square containment', () {
    late BoundaryGeometry square;

    setUp(() {
      square = parser.parseGeometry(closedSquare());
    });

    test('1. point inside a simple square', () {
      expect(
        engine.classify(
          geometry: square,
          point: const GeoPoint(longitude: 0.5, latitude: 0.5),
        ),
        PointContainment.inside,
      );
    });

    test('2. point outside a simple square', () {
      expect(
        engine.classify(
          geometry: square,
          point: const GeoPoint(longitude: 2.0, latitude: 2.0),
        ),
        PointContainment.outside,
      );
    });

    test('3. point on an edge', () {
      expect(
        engine.classify(
          geometry: square,
          point: const GeoPoint(longitude: 0.5, latitude: 0.0),
        ),
        PointContainment.boundary,
      );
    });

    test('4. point on a vertex', () {
      expect(
        engine.classify(
          geometry: square,
          point: const GeoPoint(longitude: 0.0, latitude: 0.0),
        ),
        PointContainment.boundary,
      );
    });

    test('5. point just inside', () {
      expect(
        engine.classify(
          geometry: square,
          point: const GeoPoint(longitude: 0.001, latitude: 0.001),
        ),
        PointContainment.inside,
      );
    });

    test('6. point just outside', () {
      expect(
        engine.classify(
          geometry: square,
          point: const GeoPoint(longitude: -0.001, latitude: 0.5),
        ),
        PointContainment.outside,
      );
    });

    test('7. horizontal edge', () {
      expect(
        engine.classify(
          geometry: square,
          point: const GeoPoint(longitude: 0.25, latitude: 1.0),
        ),
        PointContainment.boundary,
      );
    });

    test('8. vertical edge', () {
      expect(
        engine.classify(
          geometry: square,
          point: const GeoPoint(longitude: 1.0, latitude: 0.75),
        ),
        PointContainment.boundary,
      );
    });
  });

  group('unclosed ring', () {
    test('9. unclosed input ring handled correctly', () {
      final BoundaryGeometry geometry = parser.parseGeometry(<String, dynamic>{
        'type': 'Polygon',
        'coordinates': <dynamic>[
          <dynamic>[
            <dynamic>[0.0, 0.0],
            <dynamic>[1.0, 0.0],
            <dynamic>[1.0, 1.0],
            <dynamic>[0.0, 1.0],
            // deliberately unclosed — engine connects last to first
          ],
        ],
      });

      expect(
        engine.classify(
          geometry: geometry,
          point: const GeoPoint(longitude: 0.5, latitude: 0.5),
        ),
        PointContainment.inside,
      );
      expect(
        engine.classify(
          geometry: geometry,
          point: const GeoPoint(longitude: 0.0, latitude: 0.5),
        ),
        PointContainment.boundary,
      );
      expect(
        engine.classify(
          geometry: geometry,
          point: const GeoPoint(longitude: 2.0, latitude: 0.5),
        ),
        PointContainment.outside,
      );
    });
  });

  group('polygon with holes', () {
    /// Outer square [0,0]-[4,0]-[4,4]-[0,4], hole [1,1]-[2,1]-[2,2]-[1,2].
    late BoundaryGeometry withHole;

    setUp(() {
      withHole = parser.parseGeometry(<String, dynamic>{
        'type': 'Polygon',
        'coordinates': <dynamic>[
          <dynamic>[
            <dynamic>[0.0, 0.0],
            <dynamic>[4.0, 0.0],
            <dynamic>[4.0, 4.0],
            <dynamic>[0.0, 4.0],
            <dynamic>[0.0, 0.0],
          ],
          <dynamic>[
            <dynamic>[1.0, 1.0],
            <dynamic>[2.0, 1.0],
            <dynamic>[2.0, 2.0],
            <dynamic>[1.0, 2.0],
            <dynamic>[1.0, 1.0],
          ],
        ],
      });
    });

    test('10a. inside exterior and outside hole → inside', () {
      expect(
        engine.classify(
          geometry: withHole,
          point: const GeoPoint(longitude: 0.5, latitude: 0.5),
        ),
        PointContainment.inside,
      );
    });

    test('10b. inside hole → outside', () {
      expect(
        engine.classify(
          geometry: withHole,
          point: const GeoPoint(longitude: 1.5, latitude: 1.5),
        ),
        PointContainment.outside,
      );
    });

    test('10c. on hole edge → boundary', () {
      expect(
        engine.classify(
          geometry: withHole,
          point: const GeoPoint(longitude: 1.5, latitude: 1.0),
        ),
        PointContainment.boundary,
      );
    });

    test('10d. on hole vertex → boundary', () {
      expect(
        engine.classify(
          geometry: withHole,
          point: const GeoPoint(longitude: 1.0, latitude: 1.0),
        ),
        PointContainment.boundary,
      );
    });

    test('11. polygon with multiple holes', () {
      final BoundaryGeometry multiHole = parser.parseGeometry(<String, dynamic>{
        'type': 'Polygon',
        'coordinates': <dynamic>[
          <dynamic>[
            <dynamic>[0.0, 0.0],
            <dynamic>[6.0, 0.0],
            <dynamic>[6.0, 6.0],
            <dynamic>[0.0, 6.0],
            <dynamic>[0.0, 0.0],
          ],
          <dynamic>[
            <dynamic>[1.0, 1.0],
            <dynamic>[2.0, 1.0],
            <dynamic>[2.0, 2.0],
            <dynamic>[1.0, 2.0],
            <dynamic>[1.0, 1.0],
          ],
          <dynamic>[
            <dynamic>[3.0, 3.0],
            <dynamic>[4.0, 3.0],
            <dynamic>[4.0, 4.0],
            <dynamic>[3.0, 4.0],
            <dynamic>[3.0, 3.0],
          ],
        ],
      });

      expect(
        engine.classify(
          geometry: multiHole,
          point: const GeoPoint(longitude: 0.5, latitude: 0.5),
        ),
        PointContainment.inside,
      );
      expect(
        engine.classify(
          geometry: multiHole,
          point: const GeoPoint(longitude: 1.5, latitude: 1.5),
        ),
        PointContainment.outside,
      );
      expect(
        engine.classify(
          geometry: multiHole,
          point: const GeoPoint(longitude: 3.5, latitude: 3.5),
        ),
        PointContainment.outside,
      );
      expect(
        engine.classify(
          geometry: multiHole,
          point: const GeoPoint(longitude: 5.0, latitude: 5.0),
        ),
        PointContainment.inside,
      );
      expect(
        engine.classify(
          geometry: multiHole,
          point: const GeoPoint(longitude: 3.5, latitude: 3.0),
        ),
        PointContainment.boundary,
      );
    });
  });

  group('MultiPolygon', () {
    late BoundaryGeometry multi;

    setUp(() {
      // Two disjoint unit squares: [0,0]-[1,1] and [3,0]-[4,1].
      multi = parser.parseGeometry(<String, dynamic>{
        'type': 'MultiPolygon',
        'coordinates': <dynamic>[
          <dynamic>[
            <dynamic>[
              <dynamic>[0.0, 0.0],
              <dynamic>[1.0, 0.0],
              <dynamic>[1.0, 1.0],
              <dynamic>[0.0, 1.0],
              <dynamic>[0.0, 0.0],
            ],
          ],
          <dynamic>[
            <dynamic>[
              <dynamic>[3.0, 0.0],
              <dynamic>[4.0, 0.0],
              <dynamic>[4.0, 1.0],
              <dynamic>[3.0, 1.0],
              <dynamic>[3.0, 0.0],
            ],
          ],
        ],
      });
    });

    test('12a. inside first polygon', () {
      expect(
        engine.classify(
          geometry: multi,
          point: const GeoPoint(longitude: 0.5, latitude: 0.5),
        ),
        PointContainment.inside,
      );
    });

    test('12b. inside second polygon', () {
      expect(
        engine.classify(
          geometry: multi,
          point: const GeoPoint(longitude: 3.5, latitude: 0.5),
        ),
        PointContainment.inside,
      );
    });

    test('12c. outside all polygons', () {
      expect(
        engine.classify(
          geometry: multi,
          point: const GeoPoint(longitude: 2.0, latitude: 0.5),
        ),
        PointContainment.outside,
      );
    });

    test('12d. on one polygon boundary', () {
      expect(
        engine.classify(
          geometry: multi,
          point: const GeoPoint(longitude: 1.0, latitude: 0.5),
        ),
        PointContainment.boundary,
      );
    });
  });

  group('malformed geometry rejected', () {
    test('13. malformed Polygon rejected', () {
      expect(
        () => parser.parseGeometry(<String, dynamic>{
          'type': 'Polygon',
          'coordinates': <dynamic>[
            <dynamic>[
              <dynamic>[0.0, 0.0],
              <dynamic>[1.0, 0.0],
              // only two positions — not enough for a ring
            ],
          ],
        }),
        throwsA(isA<GeometryParseException>()),
      );

      expect(
        () => parser.parseGeometry(<String, dynamic>{
          'type': 'Polygon',
          'coordinates': <dynamic>[
            <dynamic>[0.0, 0.0], // ring is not a list of positions
          ],
        }),
        throwsA(isA<GeometryParseException>()),
      );
    });

    test('14. malformed MultiPolygon rejected', () {
      expect(
        () => parser.parseGeometry(<String, dynamic>{
          'type': 'MultiPolygon',
          'coordinates': <dynamic>[
            <dynamic>[0.0, 0.0], // not a polygon nesting
          ],
        }),
        throwsA(isA<GeometryParseException>()),
      );

      expect(
        () => parser.parseGeometry(<String, dynamic>{
          'type': 'MultiPolygon',
          'coordinates': <dynamic>[
            <dynamic>[], // empty member
          ],
        }),
        throwsA(isA<GeometryParseException>()),
      );
    });

    test('15. empty coordinates rejected', () {
      expect(
        () => parser.parseGeometry(<String, dynamic>{
          'type': 'Polygon',
          'coordinates': <dynamic>[],
        }),
        throwsA(isA<GeometryParseException>()),
      );
    });

    test('16. unsupported geometry type rejected', () {
      expect(
        () => parser.parseGeometry(<String, dynamic>{
          'type': 'Point',
          'coordinates': <dynamic>[0.0, 0.0],
        }),
        throwsA(isA<GeometryParseException>()),
      );

      expect(
        () => parser.parseGeometry(<String, dynamic>{
          'type': 'LineString',
          'coordinates': <dynamic>[
            <dynamic>[0.0, 0.0],
            <dynamic>[1.0, 1.0],
          ],
        }),
        throwsA(isA<GeometryParseException>()),
      );
    });

    test('17. non-numeric coordinate rejected', () {
      expect(
        () => parser.parseGeometry(<String, dynamic>{
          'type': 'Polygon',
          'coordinates': <dynamic>[
            <dynamic>[
              <dynamic>['x', 0.0],
              <dynamic>[1.0, 0.0],
              <dynamic>[1.0, 1.0],
              <dynamic>['x', 0.0],
            ],
          ],
        }),
        throwsA(isA<GeometryParseException>()),
      );
    });
  });

  group('epsilon and determinism', () {
    test('kBoundaryEpsilon is documented and small', () {
      expect(kBoundaryEpsilon, 1e-9);
      expect(kBoundaryEpsilon < 1e-6, isTrue);
    });

    test('same geometry + same point is deterministic', () {
      final BoundaryGeometry square = parser.parseGeometry(closedSquare());
      const GeoPoint point = GeoPoint(longitude: 0.5, latitude: 0.5);
      final PointContainment a =
          engine.classify(geometry: square, point: point);
      final PointContainment b =
          engine.classify(geometry: square, point: point);
      expect(a, b);
      expect(a, PointContainment.inside);
    });

    test('negative coordinates supported', () {
      final BoundaryGeometry square = parser.parseGeometry(
        closedSquare(minLon: -2, minLat: -2, maxLon: -1, maxLat: -1),
      );
      expect(
        engine.classify(
          geometry: square,
          point: const GeoPoint(longitude: -1.5, latitude: -1.5),
        ),
        PointContainment.inside,
      );
      expect(
        engine.classify(
          geometry: square,
          point: const GeoPoint(longitude: -0.5, latitude: -0.5),
        ),
        PointContainment.outside,
      );
      expect(
        engine.classify(
          geometry: square,
          point: const GeoPoint(longitude: -2.0, latitude: -1.5),
        ),
        PointContainment.boundary,
      );
    });
  });

  group('parse model', () {
    test('Polygon parsing yields one GeoPolygon', () {
      final BoundaryGeometry geometry = parser.parseGeometry(closedSquare());
      expect(geometry.polygons, hasLength(1));
      expect(geometry.polygons.first.exterior, hasLength(5));
      expect(geometry.polygons.first.holes, isEmpty);
    });

    test('MultiPolygon parsing yields multiple GeoPolygons', () {
      final BoundaryGeometry geometry = parser.parseGeometry(<String, dynamic>{
        'type': 'MultiPolygon',
        'coordinates': <dynamic>[
          closedSquare()['coordinates'],
          closedSquare(minLon: 3, maxLon: 4)['coordinates'],
        ],
      });
      expect(geometry.polygons, hasLength(2));
    });
  });
}
