import 'package:flutter/widgets.dart';

import 'screens/town_feed_screen.dart';
import 'screens/welcome_screen.dart';

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
