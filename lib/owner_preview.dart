import 'package:flutter/widgets.dart';

import 'screens/town_feed_screen.dart';
import 'screens/welcome_screen.dart';

/// Path segment that scopes the privileged owner verification journey.
///
/// Matches only when the Flutter web app is served under
/// `/owner-journey-v1/` (for example
/// `/town-safe-space-mobile/owner-journey-v1/`).
const String kOwnerJourneyPathSegment = 'owner-journey-v1';

/// PUBLIC WEB VISUAL PREVIEW ONLY.
/// NOT AUTHENTICATION.
/// NOT OWNER AUTHORIZATION.
/// NOT FOR PRODUCTION ACCESS CONTROL.
///
/// GitHub Pages is public. Anyone who knows
/// `?ownerPreview=feed` may open Feed V1 without location
/// verification. This is a temporary visual-prototype convenience
/// only and must be removed or replaced before production access
/// control.
///
/// Exact query match required: `ownerPreview=feed`.
/// Unknown values do nothing. Non-web builds ignore the parameter.
/// No persistence, cookies, tokens, accounts, membership, or
/// entitlements are created.
bool shouldOpenOwnerFeedPreview({required Uri uri, required bool isWeb}) {
  if (!isWeb) {
    return false;
  }
  return uri.queryParameters['ownerPreview'] == 'feed';
}

/// OWNER JOURNEY MODE — path-scoped product verification only.
/// NOT AUTHENTICATION.
/// NOT OWNER AUTHORIZATION.
/// NOT FOR PRODUCTION ACCESS CONTROL.
///
/// Active only on web when a path segment equals
/// [kOwnerJourneyPathSegment]. Production root `/`,
/// `/experience-v1/`, `/pr30-preview/`, `/pr33-preview/`,
/// country/city selection alone, and non-web builds never
/// activate this mode. No query parameter is required or used.
bool isOwnerJourneyMode({required Uri uri, required bool isWeb}) {
  if (!isWeb) {
    return false;
  }
  return uri.pathSegments.contains(kOwnerJourneyPathSegment);
}

/// Chooses the app's initial screen from a URI + platform flag.
///
/// Production web uses [Uri.base] and `kIsWeb`. Tests inject both
/// so the decision can be proven without depending on browser state.
Widget initialHomeForApp({required Uri uri, required bool isWeb}) {
  if (shouldOpenOwnerFeedPreview(uri: uri, isWeb: isWeb)) {
    return const TownFeedScreen();
  }
  return const WelcomeScreen();
}
