import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space_mobile/services/foreground_position_reader.dart';

void main() {
  group('ForegroundPositionReader.classifyAccuracyMeters', () {
    test('good at and below 50 m', () {
      final ForegroundPositionReadResult result =
          ForegroundPositionReader.classifyAccuracyMeters(50);
      expect(result.state, ForegroundPositionReadState.successGood);
      expect(result.accuracyMeters, 50);
    });

    test('limited between 51 and 150 m', () {
      expect(
        ForegroundPositionReader.classifyAccuracyMeters(51).state,
        ForegroundPositionReadState.successLimited,
      );
      expect(
        ForegroundPositionReader.classifyAccuracyMeters(150).state,
        ForegroundPositionReadState.successLimited,
      );
    });

    test('insufficient above 150 m', () {
      final ForegroundPositionReadResult result =
          ForegroundPositionReader.classifyAccuracyMeters(151);
      expect(result.state, ForegroundPositionReadState.insufficientAccuracy);
      expect(result.accuracyMeters, 151);
    });
  });

  test('timeout constant is 15 seconds', () {
    expect(kForegroundPositionTimeout, const Duration(seconds: 15));
  });
}
