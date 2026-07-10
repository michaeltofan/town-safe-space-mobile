import 'dart:convert';

import 'package:flutter/services.dart';

/// Known asset paths for the approved simplified city boundaries.
abstract final class BoundaryAssetPaths {
  static const String milano =
      'assets/boundaries/milano_boundary_simplified.geojson';
  static const String munich =
      'assets/boundaries/munich_boundary_simplified.geojson';
}

/// Non-sensitive metadata returned after loading and validating a boundary
/// asset. Does not include coordinate arrays or any user location data.
class BoundaryAssetMetadata {
  const BoundaryAssetMetadata({
    required this.city,
    required this.geometryType,
    required this.featureCount,
    required this.crs,
    required this.intendedUse,
    required this.bundledStatus,
    required this.internalBoundaryVersion,
    required this.authority,
    required this.dataset,
    required this.licence,
  });

  final String city;
  final String geometryType;
  final int featureCount;
  final String crs;
  final String intendedUse;
  final String bundledStatus;
  final String internalBoundaryVersion;
  final String authority;
  final String dataset;
  final String licence;
}

/// Thrown when a boundary asset is missing, malformed, or fails structural
/// / metadata validation. Messages never include coordinate content.
class BoundaryAssetException implements Exception {
  const BoundaryAssetException(this.message);

  final String message;

  @override
  String toString() => 'BoundaryAssetException: $message';
}

/// Read-only loader for approved simplified city-boundary GeoJSON assets.
///
/// Loads text, decodes JSON, and validates structure and required metadata.
/// Does not accept user coordinates, does not perform inside/outside checks,
/// and does not retain or expose app-user location data.
class BoundaryAssetLoader {
  const BoundaryAssetLoader({AssetBundle? bundle})
      : _bundle = bundle;

  final AssetBundle? _bundle;

  AssetBundle get _resolvedBundle => _bundle ?? rootBundle;

  /// Loads [assetPath] from the Flutter asset bundle and returns validated
  /// boundary metadata only.
  Future<BoundaryAssetMetadata> loadBoundary(String assetPath) async {
    final String text;
    try {
      text = await _resolvedBundle.loadString(assetPath);
    } catch (_) {
      throw BoundaryAssetException(
        'Failed to load boundary asset "$assetPath".',
      );
    }
    return decodeAndValidate(text);
  }

  /// Decodes and validates GeoJSON text without loading from the asset bundle.
  ///
  /// Exposed for focused unit tests of malformed / incomplete payloads.
  /// Does not accept user coordinates and does not return coordinate arrays.
  BoundaryAssetMetadata decodeAndValidate(String jsonText) {
    final Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } on FormatException {
      throw const BoundaryAssetException(
        'Boundary asset is not valid JSON.',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw const BoundaryAssetException(
        'Boundary asset top-level value must be a JSON object.',
      );
    }

    final Object? type = decoded['type'];
    if (type != 'FeatureCollection') {
      throw const BoundaryAssetException(
        'Boundary asset type must be FeatureCollection.',
      );
    }

    final Object? features = decoded['features'];
    if (features == null) {
      throw const BoundaryAssetException(
        'Boundary asset is missing features.',
      );
    }
    if (features is! List) {
      throw const BoundaryAssetException(
        'Boundary asset features must be a list.',
      );
    }
    if (features.length != 1) {
      throw BoundaryAssetException(
        'Boundary asset must contain exactly one feature '
        '(found ${features.length}).',
      );
    }

    final Object? feature = features.first;
    if (feature is! Map<String, dynamic>) {
      throw const BoundaryAssetException(
        'Boundary feature must be a JSON object.',
      );
    }
    if (feature['type'] != 'Feature') {
      throw const BoundaryAssetException(
        'Boundary feature type must be Feature.',
      );
    }

    final Object? geometry = feature['geometry'];
    if (geometry == null) {
      throw const BoundaryAssetException(
        'Boundary feature is missing geometry.',
      );
    }
    if (geometry is! Map<String, dynamic>) {
      throw const BoundaryAssetException(
        'Boundary geometry must be a JSON object.',
      );
    }

    final Object? geometryType = geometry['type'];
    if (geometryType != 'Polygon' && geometryType != 'MultiPolygon') {
      throw const BoundaryAssetException(
        'Boundary geometry type must be Polygon or MultiPolygon.',
      );
    }

    if (!geometry.containsKey('coordinates')) {
      throw const BoundaryAssetException(
        'Boundary geometry is missing coordinates.',
      );
    }
    final Object? coordinates = geometry['coordinates'];
    if (coordinates == null) {
      throw const BoundaryAssetException(
        'Boundary geometry coordinates must not be null.',
      );
    }
    if (coordinates is! List) {
      throw const BoundaryAssetException(
        'Boundary geometry coordinates must be a list.',
      );
    }

    final String crs = _extractCrs(decoded, feature);

    final Object? properties = feature['properties'];
    if (properties == null) {
      throw const BoundaryAssetException(
        'Boundary feature is missing properties.',
      );
    }
    if (properties is! Map<String, dynamic>) {
      throw const BoundaryAssetException(
        'Boundary properties must be a JSON object.',
      );
    }

    final String intendedUse = _requireString(properties, 'intended_use');
    if (intendedUse != 'city_access') {
      throw BoundaryAssetException(
        'Boundary intended_use must be city_access (found "$intendedUse").',
      );
    }

    final String bundledStatus = _requireString(properties, 'bundled_status');
    if (bundledStatus != 'NOT YET BUNDLED') {
      throw BoundaryAssetException(
        'Boundary bundled_status must be NOT YET BUNDLED '
        '(found "$bundledStatus").',
      );
    }

    final String city = _requireString(properties, 'city');
    if (city != 'milano' && city != 'munich') {
      throw BoundaryAssetException(
        'Boundary city must be milano or munich (found "$city").',
      );
    }

    final String internalBoundaryVersion =
        _requireString(properties, 'internal_boundary_version');
    final String authority = _requireString(properties, 'authority');
    final String dataset = _requireString(properties, 'dataset');
    final String licence = _requireString(properties, 'licence');

    return BoundaryAssetMetadata(
      city: city,
      geometryType: geometryType as String,
      featureCount: features.length,
      crs: crs,
      intendedUse: intendedUse,
      bundledStatus: bundledStatus,
      internalBoundaryVersion: internalBoundaryVersion,
      authority: authority,
      dataset: dataset,
      licence: licence,
    );
  }

  String _extractCrs(
    Map<String, dynamic> collection,
    Map<String, dynamic> feature,
  ) {
    final Object? topCrs = collection['crs'];
    if (topCrs is Map<String, dynamic>) {
      final Object? crsProps = topCrs['properties'];
      if (crsProps is Map<String, dynamic>) {
        final Object? name = crsProps['name'];
        if (name is String && _isEpsg4326(name)) {
          return 'EPSG:4326';
        }
      }
    }

    final Object? properties = feature['properties'];
    if (properties is Map<String, dynamic>) {
      final Object? crsEpsg = properties['crs_epsg'];
      if (crsEpsg == 4326 || crsEpsg == '4326') {
        return 'EPSG:4326';
      }
    }

    throw const BoundaryAssetException(
      'Boundary CRS metadata must indicate EPSG:4326.',
    );
  }

  bool _isEpsg4326(String name) {
    final String normalized = name.toUpperCase();
    return normalized.contains('EPSG') && normalized.contains('4326');
  }

  String _requireString(Map<String, dynamic> properties, String key) {
    if (!properties.containsKey(key)) {
      throw BoundaryAssetException(
        'Boundary properties missing required field "$key".',
      );
    }
    final Object? value = properties[key];
    if (value is! String || value.isEmpty) {
      throw BoundaryAssetException(
        'Boundary properties field "$key" must be a non-empty string.',
      );
    }
    return value;
  }
}
