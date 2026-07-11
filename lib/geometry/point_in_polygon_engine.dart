/// Isolated local point-in-polygon geometry engine.
///
/// Pure, deterministic classification of an explicit [GeoPoint] against
/// parsed Polygon / MultiPolygon boundary geometry.
///
/// Coordinates are EPSG:4326 degrees (longitude, latitude).
///
/// [kBoundaryEpsilon] is used only for floating-point stability when deciding
/// whether a point lies on a segment (boundary). It is intentionally small and
/// is **not** a GPS-accuracy acceptance radius. This isolated engine is not
/// yet the final GPS-accuracy acceptance policy.
///
/// This library contains no device-location, UI, navigation, storage, or
/// network logic. Input points are not retained beyond a [classify] call.
library;

import 'dart:convert';
import 'dart:math' as math;

/// Absolute tolerance (degrees, EPSG:4326) for collinearity / on-segment tests.
///
/// Chosen small enough to avoid a fuzzy acceptance zone while absorbing
/// typical double-precision noise on degree-scale coordinates.
const double kBoundaryEpsilon = 1e-9;

/// Result of classifying a point against boundary geometry.
enum PointContainment {
  /// Strictly inside an exterior ring and outside all holes of that polygon.
  inside,

  /// Outside every polygon (including points that fall inside a hole).
  outside,

  /// Lies on an exterior-ring or hole-ring boundary (edge or vertex).
  boundary,
}

/// Explicit immutable geometry test point (longitude, latitude).
///
/// For pure geometry input only. Not a device-location or user-location type.
class GeoPoint {
  const GeoPoint({
    required this.longitude,
    required this.latitude,
  });

  /// Longitude in EPSG:4326 degrees.
  final double longitude;

  /// Latitude in EPSG:4326 degrees.
  final double latitude;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeoPoint &&
          longitude == other.longitude &&
          latitude == other.latitude;

  @override
  int get hashCode => Object.hash(longitude, latitude);
}

/// One polygon: exterior ring plus zero or more interior rings (holes).
class GeoPolygon {
  const GeoPolygon({
    required this.exterior,
    this.holes = const <List<GeoPoint>>[],
  });

  /// Exterior ring positions (closed or unclosed; engine treats as closed).
  final List<GeoPoint> exterior;

  /// Interior rings / holes (each treated as closed).
  final List<List<GeoPoint>> holes;
}

/// Parsed boundary geometry: one or more polygons (Polygon or MultiPolygon).
class BoundaryGeometry {
  const BoundaryGeometry({required this.polygons});

  /// Non-empty list of polygons. A GeoJSON Polygon yields one entry;
  /// MultiPolygon yields one entry per member polygon.
  final List<GeoPolygon> polygons;
}

/// Thrown when GeoJSON geometry cannot be parsed into [BoundaryGeometry].
///
/// Messages never include coordinate values.
class GeometryParseException implements Exception {
  const GeometryParseException(this.message);

  final String message;

  @override
  String toString() => 'GeometryParseException: $message';
}

/// Parses Polygon / MultiPolygon coordinate structures into [BoundaryGeometry].
class BoundaryGeometryParser {
  const BoundaryGeometryParser();

  /// Parses a GeoJSON geometry object (`type` + `coordinates`).
  BoundaryGeometry parseGeometry(Object? geometry) {
    if (geometry is! Map) {
      throw const GeometryParseException(
        'Geometry must be a JSON object.',
      );
    }
    final Map<dynamic, dynamic> map = geometry;
    final Object? type = map['type'];
    if (type != 'Polygon' && type != 'MultiPolygon') {
      throw const GeometryParseException(
        'Unsupported geometry type; only Polygon and MultiPolygon are allowed.',
      );
    }
    if (!map.containsKey('coordinates')) {
      throw const GeometryParseException(
        'Geometry is missing coordinates.',
      );
    }
    final Object? coordinates = map['coordinates'];
    if (coordinates == null) {
      throw const GeometryParseException(
        'Geometry coordinates must not be null.',
      );
    }
    if (coordinates is! List) {
      throw const GeometryParseException(
        'Geometry coordinates must be a list.',
      );
    }
    if (coordinates.isEmpty) {
      throw const GeometryParseException(
        'Geometry coordinates must not be empty.',
      );
    }

    if (type == 'Polygon') {
      return BoundaryGeometry(
        polygons: <GeoPolygon>[_parsePolygon(coordinates)],
      );
    }
    return BoundaryGeometry(polygons: _parseMultiPolygon(coordinates));
  }

  /// Parses a FeatureCollection JSON string and extracts the single feature
  /// geometry. Used for loading approved boundary assets offline.
  BoundaryGeometry parseFeatureCollectionJson(String jsonText) {
    final Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } on FormatException {
      throw const GeometryParseException(
        'FeatureCollection text is not valid JSON.',
      );
    }
    if (decoded is! Map) {
      throw const GeometryParseException(
        'FeatureCollection top-level value must be a JSON object.',
      );
    }
    if (decoded['type'] != 'FeatureCollection') {
      throw const GeometryParseException(
        'Top-level type must be FeatureCollection.',
      );
    }
    final Object? features = decoded['features'];
    if (features is! List || features.isEmpty) {
      throw const GeometryParseException(
        'FeatureCollection must contain features.',
      );
    }
    if (features.length != 1) {
      throw const GeometryParseException(
        'FeatureCollection must contain exactly one feature.',
      );
    }
    final Object? feature = features.first;
    if (feature is! Map) {
      throw const GeometryParseException(
        'Feature must be a JSON object.',
      );
    }
    return parseGeometry(feature['geometry']);
  }

  List<GeoPolygon> _parseMultiPolygon(List<dynamic> coordinates) {
    final List<GeoPolygon> polygons = <GeoPolygon>[];
    for (final Object? polygonCoords in coordinates) {
      if (polygonCoords is! List) {
        throw const GeometryParseException(
          'MultiPolygon member must be a polygon coordinate list.',
        );
      }
      if (polygonCoords.isEmpty) {
        throw const GeometryParseException(
          'MultiPolygon member must not be empty.',
        );
      }
      polygons.add(_parsePolygon(polygonCoords));
    }
    if (polygons.isEmpty) {
      throw const GeometryParseException(
        'MultiPolygon must contain at least one polygon.',
      );
    }
    return polygons;
  }

  GeoPolygon _parsePolygon(List<dynamic> coordinates) {
    if (coordinates.isEmpty) {
      throw const GeometryParseException(
        'Polygon coordinates must not be empty.',
      );
    }
    final List<List<GeoPoint>> rings = <List<GeoPoint>>[];
    for (final Object? ringCoords in coordinates) {
      if (ringCoords is! List) {
        throw const GeometryParseException(
          'Polygon ring must be a list of positions.',
        );
      }
      rings.add(_parseRing(ringCoords));
    }
    final List<GeoPoint> exterior = rings.first;
    final List<List<GeoPoint>> holes =
        rings.length > 1 ? rings.sublist(1) : const <List<GeoPoint>>[];
    return GeoPolygon(exterior: exterior, holes: holes);
  }

  List<GeoPoint> _parseRing(List<dynamic> ringCoords) {
    if (ringCoords.isEmpty) {
      throw const GeometryParseException(
        'Ring must contain positions.',
      );
    }
    final List<GeoPoint> points = <GeoPoint>[];
    for (final Object? position in ringCoords) {
      points.add(_parsePosition(position));
    }

    final bool closed = points.length >= 2 && points.first == points.last;
    final int uniqueCount = closed ? points.length - 1 : points.length;
    // A ring needs at least three distinct vertices to enclose an area.
    if (uniqueCount < 3) {
      throw const GeometryParseException(
        'Ring does not have enough positions to form a polygon.',
      );
    }
    return List<GeoPoint>.unmodifiable(points);
  }

  GeoPoint _parsePosition(Object? position) {
    if (position is! List) {
      throw const GeometryParseException(
        'Position must be a list of numeric coordinates.',
      );
    }
    if (position.length < 2) {
      throw const GeometryParseException(
        'Position must contain at least longitude and latitude.',
      );
    }
    final double longitude = _requireFiniteNumber(position[0], 'longitude');
    final double latitude = _requireFiniteNumber(position[1], 'latitude');
    return GeoPoint(longitude: longitude, latitude: latitude);
  }

  double _requireFiniteNumber(Object? value, String label) {
    if (value is! num) {
      throw GeometryParseException(
        'Position $label must be numeric.',
      );
    }
    final double d = value.toDouble();
    if (d.isNaN || d.isInfinite) {
      throw GeometryParseException(
        'Position $label must be a finite number.',
      );
    }
    return d;
  }
}

/// Deterministic local point-in-polygon classifier.
///
/// Algorithm:
/// 1. Boundary first: if the point lies on any exterior or hole segment
///    (including vertices), return [PointContainment.boundary].
/// 2. Ring containment uses even-odd ray casting to +∞ longitude.
/// 3. A point is inside a polygon when it is inside the exterior ring and
///    outside every hole.
/// 4. For MultiPolygon: boundary if on any ring; inside if inside ≥1 polygon;
///    otherwise outside.
///
/// Horizontal segments are skipped by the ray-cast crossing test (no
/// division-by-zero). Vertex double-counting is avoided via the standard
/// half-open y-straddle rule `(y0 > py) != (y1 > py)`.
class PointInPolygonEngine {
  const PointInPolygonEngine();

  /// Classifies [point] against [geometry].
  ///
  /// Same geometry + same point always yields the same [PointContainment].
  /// The point is not stored after the call returns.
  PointContainment classify({
    required BoundaryGeometry geometry,
    required GeoPoint point,
  }) {
    if (geometry.polygons.isEmpty) {
      return PointContainment.outside;
    }

    bool anyInside = false;
    for (final GeoPolygon polygon in geometry.polygons) {
      final PointContainment local = _classifyPolygon(polygon, point);
      if (local == PointContainment.boundary) {
        return PointContainment.boundary;
      }
      if (local == PointContainment.inside) {
        anyInside = true;
      }
    }
    return anyInside ? PointContainment.inside : PointContainment.outside;
  }

  PointContainment _classifyPolygon(GeoPolygon polygon, GeoPoint point) {
    // Boundary tests run before inside/outside toggling.
    if (_pointOnRing(point, polygon.exterior)) {
      return PointContainment.boundary;
    }
    for (final List<GeoPoint> hole in polygon.holes) {
      if (_pointOnRing(point, hole)) {
        return PointContainment.boundary;
      }
    }

    if (!_ringContains(point, polygon.exterior)) {
      return PointContainment.outside;
    }
    for (final List<GeoPoint> hole in polygon.holes) {
      if (_ringContains(point, hole)) {
        // Inside a hole → outside the polygon.
        return PointContainment.outside;
      }
    }
    return PointContainment.inside;
  }

  /// True if [point] lies on any segment of [ring] (closed treatment).
  bool _pointOnRing(GeoPoint point, List<GeoPoint> ring) {
    final int segmentCount = _segmentCount(ring);
    for (int i = 0; i < segmentCount; i++) {
      final GeoPoint a = ring[i];
      final GeoPoint b = ring[_nextIndex(ring, i)];
      if (_pointOnSegment(point, a, b)) {
        return true;
      }
    }
    return false;
  }

  /// Even-odd ray casting: count crossings of a horizontal ray to +∞ lon.
  bool _ringContains(GeoPoint point, List<GeoPoint> ring) {
    final double px = point.longitude;
    final double py = point.latitude;
    bool inside = false;
    final int segmentCount = _segmentCount(ring);
    for (int i = 0; i < segmentCount; i++) {
      final GeoPoint a = ring[i];
      final GeoPoint b = ring[_nextIndex(ring, i)];
      final double ax = a.longitude;
      final double ay = a.latitude;
      final double bx = b.longitude;
      final double by = b.latitude;

      // Skip horizontal segments: (ay > py) == (by > py) when ay == by.
      // Also avoids division by zero when computing the intersection.
      if ((ay > py) == (by > py)) {
        continue;
      }

      // Intersection longitude of the edge with the horizontal line y = py.
      final double t = (py - ay) / (by - ay);
      final double xIntersect = ax + t * (bx - ax);

      // If the ray origin lies on the edge within epsilon, treat as boundary
      // (should already be caught by _pointOnRing; defensive).
      if ((xIntersect - px).abs() <= kBoundaryEpsilon) {
        continue;
      }

      if (xIntersect > px) {
        inside = !inside;
      }
    }
    return inside;
  }

  /// Point-on-segment with [kBoundaryEpsilon] collinearity and bbox checks.
  bool _pointOnSegment(GeoPoint p, GeoPoint a, GeoPoint b) {
    final double px = p.longitude;
    final double py = p.latitude;
    final double ax = a.longitude;
    final double ay = a.latitude;
    final double bx = b.longitude;
    final double by = b.latitude;

    final double minX = math.min(ax, bx) - kBoundaryEpsilon;
    final double maxX = math.max(ax, bx) + kBoundaryEpsilon;
    final double minY = math.min(ay, by) - kBoundaryEpsilon;
    final double maxY = math.max(ay, by) + kBoundaryEpsilon;
    if (px < minX || px > maxX || py < minY || py > maxY) {
      return false;
    }

    // Cross product (b-a) × (p-a); near zero ⇒ collinear.
    final double cross = (bx - ax) * (py - ay) - (by - ay) * (px - ax);
    final double scale = math.max(1.0, (bx - ax).abs() + (by - ay).abs());
    return cross.abs() <= kBoundaryEpsilon * scale;
  }

  /// Number of edges when treating the ring as closed.
  ///
  /// If first == last, the closing duplicate is not counted twice.
  /// If unclosed, the final vertex is connected to the first.
  int _segmentCount(List<GeoPoint> ring) {
    if (ring.length < 2) {
      return 0;
    }
    final bool closed = ring.first == ring.last;
    return closed ? ring.length - 1 : ring.length;
  }

  int _nextIndex(List<GeoPoint> ring, int i) {
    final bool closed = ring.first == ring.last;
    if (closed) {
      return i + 1;
    }
    return (i + 1) % ring.length;
  }
}
