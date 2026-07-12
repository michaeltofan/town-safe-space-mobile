/// Immutable mock content for TOWN Feed — Experience Prototype V1 parity.
///
/// **FICTIONAL PROTOTYPE CONTENT** — authors and incidents are not real.
/// Copy and hierarchy match published Experience Prototype V1
/// (`ace5062d37b5c368ebc0266b46cea6bee3cad7a9`).
library;

import 'package:flutter/painting.dart';

/// Civic issue status labels from Experience Prototype V1.
enum CommunitySignalStatus {
  newSignal('New signal'),
  locallyConfirmed('Locally confirmed'),
  reported('Reported'),
  inProgress('In progress'),
  resolved('Resolved');

  const CommunitySignalStatus(this.label);

  final String label;
}

/// Photographic presentation mode for full-bleed scene cover crops.
enum CivicMediaPresentation {
  /// Wide civic context — approximately 16:9.
  landscape(1.7777778, 'landscape'),

  /// Vertical street/path depth — approximately 4:5.
  portrait(0.8, 'portrait'),

  /// Balanced civic frame — approximately 1:1.
  square(1.0, 'square');

  const CivicMediaPresentation(this.aspectRatio, this.keyName);

  final double aspectRatio;
  final String keyName;
}

/// One fictional COMMUNITY SIGNAL matching Experience Prototype V1 HTML.
class CommunitySignalMock {
  const CommunitySignalMock({
    required this.id,
    required this.category,
    required this.authorName,
    required this.observedTime,
    required this.status,
    required this.area,
    required this.headline,
    required this.summary,
    required this.imageAsset,
    required this.initialConfirmationCount,
    required this.mediaPresentation,
    required this.mediaFocus,
  });

  final String id;
  final String category;
  final String authorName;
  final String observedTime;
  final CommunitySignalStatus status;

  /// Neighbourhood-only area label (prototype `.status-area`).
  final String area;
  final String headline;
  final String summary;
  final String imageAsset;
  final int initialConfirmationCount;
  final CivicMediaPresentation mediaPresentation;

  /// Cover focal alignment matching prototype `object-position`.
  final Alignment mediaFocus;

  /// Prototype `.meta` line: `Author · observed time`.
  String get metaLine => '$authorName · $observedTime';
}

/// Exactly three fictional Milano Community Signals — Experience Prototype V1.
///
/// Card 1 landscape · Card 2 portrait · Card 3 square.
const List<CommunitySignalMock>
kMilanoFeedV1MockSignals = <CommunitySignalMock>[
  CommunitySignalMock(
    id: 'milano-signal-1',
    category: 'SPAZIO PUBBLICO',
    authorName: 'Marta Rinaldi',
    observedTime: 'Osservato ieri',
    status: CommunitySignalStatus.locallyConfirmed,
    area: 'Città Studi',
    headline: 'Marciapiede danneggiato davanti alla scuola di via Padova',
    summary:
        'Le radici hanno sollevato il marciapiede. Bambini e anziani sono '
        'costretti sulla carreggiata.',
    imageAsset: 'assets/images/feed/signal_citta_studi_pavement.jpg',
    initialConfirmationCount: 18,
    mediaPresentation: CivicMediaPresentation.landscape,
    // object-position: 50% 42%
    mediaFocus: Alignment(0, -0.16),
  ),
  CommunitySignalMock(
    id: 'milano-signal-2',
    category: 'ILLUMINAZIONE',
    authorName: 'Chiara Valli',
    observedTime: 'Segnalato due giorni fa',
    status: CommunitySignalStatus.reported,
    area: 'Porta Romana',
    headline: 'Il percorso vicino alla scuola resta al buio la sera',
    summary:
        'Diversi lampioni non funzionano sul tratto pedonale. I residenti '
        'hanno già segnalato il Comune.',
    imageAsset: 'assets/images/feed/signal_porta_romana_lighting.jpg',
    initialConfirmationCount: 11,
    mediaPresentation: CivicMediaPresentation.portrait,
    // object-position: 58% 40%
    mediaFocus: Alignment(0.16, -0.20),
  ),
  CommunitySignalMock(
    id: 'milano-signal-3',
    category: 'LAVORI PUBBLICI',
    authorName: 'Luca Ferri',
    observedTime: 'Osservato questa settimana',
    status: CommunitySignalStatus.inProgress,
    area: 'Lorenteggio',
    headline:
        'Il cantiere restringe il passaggio pedonale senza indicazioni chiare',
    summary:
        'Il percorso temporaneo è stretto e poco segnalato. Servono tempi '
        'chiari e un passaggio più sicuro.',
    imageAsset: 'assets/images/feed/signal_lorenteggio_works.jpg',
    initialConfirmationCount: 7,
    mediaPresentation: CivicMediaPresentation.square,
    // object-position: 50% 45%
    mediaFocus: Alignment(0, -0.10),
  ),
];
