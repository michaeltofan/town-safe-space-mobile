/// Immutable mock content for TOWN Feed V1 Community Signal cards.
///
/// **FICTIONAL PROTOTYPE CONTENT** — authors and incidents are not real.
/// Images are neutral local prototype visuals, not verified real events.
library;

/// Civic issue status labels approved for Feed V1.
enum CommunitySignalStatus {
  newSignal('New signal'),
  locallyConfirmed('Locally confirmed'),
  reported('Reported'),
  inProgress('In progress'),
  resolved('Resolved');

  const CommunitySignalStatus(this.label);

  final String label;
}

/// One fictional COMMUNITY SIGNAL used only in the Feed V1 prototype.
class CommunitySignalMock {
  const CommunitySignalMock({
    required this.id,
    required this.category,
    required this.authorName,
    required this.localRelationship,
    required this.cityZone,
    required this.observedTime,
    required this.status,
    required this.headline,
    required this.summary,
    required this.imageAsset,
    required this.placeLabel,
    required this.initialConfirmationCount,
  });

  final String id;
  final String category;
  final String authorName;
  final String localRelationship;
  final String cityZone;
  final String observedTime;
  final CommunitySignalStatus status;
  final String headline;
  final String summary;
  final String imageAsset;
  final String placeLabel;
  final int initialConfirmationCount;
}

/// Exactly three fictional Milano Community Signals for Feed V1.
///
/// FICTIONAL PROTOTYPE CONTENT — do not treat as real people or incidents.
const List<CommunitySignalMock>
kMilanoFeedV1MockSignals = <CommunitySignalMock>[
  CommunitySignalMock(
    id: 'milano-signal-1',
    category: 'SPAZIO PUBBLICO',
    authorName: 'Marta Rinaldi',
    localRelationship: 'Residente del quartiere',
    cityZone: 'Milano · Città Studi',
    observedTime: 'Osservato ieri',
    status: CommunitySignalStatus.locallyConfirmed,
    headline: 'Marciapiede danneggiato davanti alla scuola di via Padova',
    summary:
        'Le radici degli alberi hanno sollevato il marciapiede. Bambini, anziani e passeggini sono costretti a scendere sulla carreggiata.',
    imageAsset: 'assets/images/feed/signal_citta_studi_pavement.png',
    placeLabel: 'Via Padova · Città Studi · Milano',
    initialConfirmationCount: 18,
  ),
  CommunitySignalMock(
    id: 'milano-signal-2',
    category: 'ILLUMINAZIONE',
    authorName: 'Chiara Valli',
    localRelationship: 'Genitore del quartiere',
    cityZone: 'Milano · Porta Romana',
    observedTime: 'Segnalato due giorni fa',
    status: CommunitySignalStatus.reported,
    headline: 'Il percorso vicino alla scuola resta al buio la sera',
    summary:
        'Diversi lampioni non funzionano lungo il tratto pedonale. Famiglie e residenti hanno già inviato una segnalazione al Comune.',
    imageAsset: 'assets/images/feed/signal_porta_romana_lighting.png',
    placeLabel: 'Porta Romana · Milano',
    initialConfirmationCount: 11,
  ),
  CommunitySignalMock(
    id: 'milano-signal-3',
    category: 'LAVORI PUBBLICI',
    authorName: 'Luca Ferri',
    localRelationship: 'Residente del quartiere',
    cityZone: 'Milano · Lorenteggio',
    observedTime: 'Osservato questa settimana',
    status: CommunitySignalStatus.inProgress,
    headline:
        'Il cantiere restringe il passaggio pedonale senza indicazioni chiare',
    summary:
        'Il percorso temporaneo è stretto e poco segnalato. I residenti chiedono tempi chiari e una sistemazione più sicura durante i lavori.',
    imageAsset: 'assets/images/feed/signal_lorenteggio_works.png',
    placeLabel: 'Lorenteggio · Milano',
    initialConfirmationCount: 7,
  ),
];
