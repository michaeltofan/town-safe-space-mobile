/// Local UI copy for TOWN Feed chrome, Open signal, and visitor gate.
///
/// Same pattern as Select City / Location Confirmation: private string maps
/// per official language. Not a global localization platform.
library;

import 'community_signal_mock.dart';

/// Official-language chrome for the feed experience.
class TownFeedCopy {
  const TownFeedCopy({
    required this.openSignalAction,
    required this.openSignalSheetTitle,
    required this.openSignalPrototypeMessage,
    required this.openSignalClose,
    required this.seeThisToo,
    required this.youConfirmedLocally,
    required this.confirmationCountTemplate,
    required this.statusLocallyConfirmed,
    required this.statusReported,
    required this.statusInProgress,
    required this.statusNewSignal,
    required this.statusResolved,
    required this.visitorInvitationTitle,
    required this.visitorInvitationBody,
    required this.visitorInvitationBodySecond,
    required this.visitorJoinAction,
    required this.visitorNotNowAction,
    required this.visitorEndedTitle,
    required this.visitorEndedBody,
    required this.visitorLeaveTownAction,
    required this.membershipEntryLabel,
    required this.membershipEntryHeadlineTemplate,
    required this.membershipEntryBody,
    required this.membershipEntryBodySecond,
    required this.membershipEntryPrice,
    required this.membershipEntryRenewal,
    required this.membershipEntryRenewalSecond,
    required this.membershipEntryConditionsTitle,
    required this.membershipEntryCondition1,
    required this.membershipEntryCondition2,
    required this.membershipEntryCondition3,
    required this.membershipEntryRights,
    required this.membershipEntryContinue,
    required this.membershipEntrySecondaryBack,
    required this.accountSetupIntroLabel,
    required this.accountSetupIntroHeadline,
    required this.accountSetupIntroBody,
    required this.accountSetupIntroWhyTitle,
    required this.accountSetupIntroWhyBody,
    required this.accountSetupIntroWhyBodySecond,
    required this.accountSetupIntroVerificationTitle,
    required this.accountSetupIntroVerification1,
    required this.accountSetupIntroVerification2,
    required this.accountSetupIntroVerification3,
    required this.accountSetupIntroPrivacyTitle,
    required this.accountSetupIntroPrivacyBody,
    required this.accountSetupIntroPrivacyBodySecond,
    required this.accountSetupIntroStart,
    required this.accountSetupIntroSecondaryBack,
    required this.accountSetupIntroPrototypeMessage,
    required this.accountSetupIntroPrototypeDismiss,
  });

  /// Explicit English chrome (legacy override / tests).
  const TownFeedCopy.english()
    : openSignalAction = 'Open signal',
      openSignalSheetTitle = 'Signal detail',
      openSignalPrototypeMessage =
          'Signal details will be added in the next TOWN phase.',
      openSignalClose = 'Close',
      seeThisToo = 'I SEE THIS TOO',
      youConfirmedLocally = 'You confirmed this locally',
      confirmationCountTemplate = 'Confirmed by {count} people nearby',
      statusLocallyConfirmed = 'Locally confirmed',
      statusReported = 'Reported',
      statusInProgress = 'In progress',
      statusNewSignal = 'New signal',
      statusResolved = 'Resolved',
      visitorInvitationTitle =
          'You care about what happens in your community.',
      visitorInvitationBody =
          'To confirm this signal and become part of the solution, join TOWN as a '
          'verified local member.',
      visitorInvitationBodySecond =
          'TOWN is built around real people from the same community — not anonymous '
          'accounts, followers or social media popularity.',
      visitorJoinAction = 'Join your community',
      visitorNotNowAction = 'Not now',
      visitorEndedTitle =
          'TOWN is for people who are ready to take part in their community.',
      visitorEndedBody =
          'You can return when you are ready to be part of it.',
      visitorLeaveTownAction = 'Leave TOWN',
      membershipEntryLabel = 'LOCAL MEMBERSHIP',
      membershipEntryHeadlineTemplate = 'Join the {city} community.',
      membershipEntryBody =
          'TOWN is a local civic space for real people.',
      membershipEntryBodySecond =
          'To take part you need an account, a valid local verification and an '
          'active subscription.',
      membershipEntryPrice = '€12 per year',
      membershipEntryRenewal = 'Annual renewal.',
      membershipEntryRenewalSecond =
          'You can cancel at any time. Access stays active until the end of the '
          'period already paid.',
      membershipEntryConditionsTitle = 'To take part:',
      membershipEntryCondition1 = '1. Create your account',
      membershipEntryCondition2 = '2. Verify your local community',
      membershipEntryCondition3 = '3. Activate the annual subscription',
      membershipEntryRights =
          'With an active membership you can confirm signals, publish, comment '
          'and take part in community decisions.',
      membershipEntryContinue = 'Continue',
      membershipEntrySecondaryBack = 'Back to the community',
      accountSetupIntroLabel = 'PERSONAL ACCOUNT',
      accountSetupIntroHeadline = 'Start with a personal account.',
      accountSetupIntroBody =
          'To take part in TOWN, every member needs a personal account linked to '
          'one local community.',
      accountSetupIntroWhyTitle = 'Why an account is needed',
      accountSetupIntroWhyBody =
          'TOWN wants to reduce bots, fake accounts and anonymous behaviour that '
          'harms the community.',
      accountSetupIntroWhyBodySecond =
          'A personal account makes participation more responsible and better '
          'protects other members.',
      accountSetupIntroVerificationTitle = 'During setup we will confirm:',
      accountSetupIntroVerification1 =
          '1. A secure way to access your account',
      accountSetupIntroVerification2 = '2. Your local community',
      accountSetupIntroVerification3 = '3. The status of your membership',
      accountSetupIntroPrivacyTitle = 'Your privacy matters',
      accountSetupIntroPrivacyBody =
          'Your exact location will not be public.',
      accountSetupIntroPrivacyBodySecond =
          'TOWN does not store full card details and does not create advertising '
          'or political profiles from your civic activity.',
      accountSetupIntroStart = 'Start',
      accountSetupIntroSecondaryBack = 'Back to membership',
      accountSetupIntroPrototypeMessage =
          'Account creation is not active in this prototype yet.',
      accountSetupIntroPrototypeDismiss = 'Got it';

  /// Official Italian chrome for Milano Feed V1.
  const TownFeedCopy.italian()
    : openSignalAction = 'Apri segnale',
      openSignalSheetTitle = 'Dettaglio del segnale',
      openSignalPrototypeMessage =
          'I dettagli di questo segnale saranno aggiunti nella prossima fase di TOWN.',
      openSignalClose = 'Chiudi',
      seeThisToo = 'LO VEDO ANCH’IO',
      youConfirmedLocally = 'Hai confermato questo sul posto',
      confirmationCountTemplate = 'Confermato da {count} persone vicine',
      statusLocallyConfirmed = 'Confermato sul posto',
      statusReported = 'Segnalato',
      statusInProgress = 'In corso',
      statusNewSignal = 'Nuovo segnale',
      statusResolved = 'Risolto',
      visitorInvitationTitle =
          'Ti sta a cuore ciò che accade nella tua comunità.',
      visitorInvitationBody =
          'Per confermare questo segnale e diventare parte della soluzione, unisciti '
          'a TOWN come membro locale verificato.',
      visitorInvitationBodySecond =
          'TOWN è costruito intorno a persone reali della stessa comunità — non su '
          'account anonimi, follower o popolarità sui social.',
      visitorJoinAction = 'Unisciti alla tua comunità',
      visitorNotNowAction = 'Non ora',
      visitorEndedTitle =
          'TOWN è per chi è pronto a partecipare alla propria comunità.',
      visitorEndedBody =
          'Puoi tornare quando sei pronto a farne parte.',
      visitorLeaveTownAction = 'Esci da TOWN',
      membershipEntryLabel = 'MEMBERSHIP LOCALE',
      membershipEntryHeadlineTemplate = 'Entra nella comunità di {city}.',
      membershipEntryBody =
          'TOWN è uno spazio civico locale per persone reali.',
      membershipEntryBodySecond =
          'Per partecipare servono un account, una verifica locale valida e un '
          'abbonamento attivo.',
      membershipEntryPrice = '€12 all’anno',
      membershipEntryRenewal = 'Rinnovo annuale.',
      membershipEntryRenewalSecond =
          'Puoi annullare in qualsiasi momento. L’accesso resta attivo fino alla '
          'fine del periodo già pagato.',
      membershipEntryConditionsTitle = 'Per partecipare:',
      membershipEntryCondition1 = '1. Crea il tuo account',
      membershipEntryCondition2 = '2. Verifica la tua comunità locale',
      membershipEntryCondition3 = '3. Attiva l’abbonamento annuale',
      membershipEntryRights =
          'Con un’iscrizione attiva puoi confermare segnali, pubblicare, '
          'commentare e partecipare alle decisioni della comunità.',
      membershipEntryContinue = 'Continua',
      membershipEntrySecondaryBack = 'Torna alla comunità',
      accountSetupIntroLabel = 'ACCOUNT PERSONALE',
      accountSetupIntroHeadline = 'Inizia con un account personale.',
      accountSetupIntroBody =
          'Per partecipare a TOWN, ogni membro deve avere un account personale '
          'collegato a una sola comunità locale.',
      accountSetupIntroWhyTitle = 'Perché serve un account',
      accountSetupIntroWhyBody =
          'TOWN vuole ridurre bot, account falsi e comportamenti anonimi che '
          'danneggiano la comunità.',
      accountSetupIntroWhyBodySecond =
          'Un account personale rende la partecipazione più responsabile e '
          'protegge meglio gli altri membri.',
      accountSetupIntroVerificationTitle =
          'Durante la configurazione confermeremo:',
      accountSetupIntroVerification1 =
          '1. Un metodo sicuro per accedere al tuo account',
      accountSetupIntroVerification2 = '2. La tua comunità locale',
      accountSetupIntroVerification3 = '3. Lo stato della tua iscrizione',
      accountSetupIntroPrivacyTitle = 'La tua privacy conta',
      accountSetupIntroPrivacyBody =
          'La tua posizione esatta non sarà pubblica.',
      accountSetupIntroPrivacyBodySecond =
          'TOWN non conserva i dati completi della carta e non crea profili '
          'pubblicitari o politici dalla tua attività civica.',
      accountSetupIntroStart = 'Inizia',
      accountSetupIntroSecondaryBack = 'Torna all’iscrizione',
      accountSetupIntroPrototypeMessage =
          'La creazione dell’account non è ancora attiva in questo prototipo.',
      accountSetupIntroPrototypeDismiss = 'Ho capito';

  /// Official German chrome for Munich Feed V1.
  const TownFeedCopy.german()
    : openSignalAction = 'Signal öffnen',
      openSignalSheetTitle = 'Signaldetails',
      openSignalPrototypeMessage =
          'Weitere Informationen zu diesem Signal werden in der nächsten '
          'TOWN-Phase hinzugefügt.',
      openSignalClose = 'Schließen',
      seeThisToo = 'ICH SEHE DAS AUCH',
      youConfirmedLocally = 'Du hast dies vor Ort bestätigt',
      confirmationCountTemplate = 'Von {count} Menschen in der Nähe bestätigt',
      statusLocallyConfirmed = 'Lokal bestätigt',
      statusReported = 'Gemeldet',
      statusInProgress = 'In Bearbeitung',
      statusNewSignal = 'Neues Signal',
      statusResolved = 'Gelöst',
      visitorInvitationTitle =
          'Dir ist wichtig, was in deiner Gemeinschaft geschieht.',
      visitorInvitationBody =
          'Um dieses Signal zu bestätigen und Teil der Lösung zu werden, tritt '
          'TOWN als verifiziertes lokales Mitglied bei.',
      visitorInvitationBodySecond =
          'TOWN wird von echten Menschen aus derselben Gemeinschaft getragen — '
          'nicht von anonymen Konten, Followern oder Popularität in sozialen Medien.',
      visitorJoinAction = 'Deiner Gemeinschaft beitreten',
      visitorNotNowAction = 'Noch nicht',
      visitorEndedTitle =
          'TOWN ist für Menschen, die bereit sind, sich an ihrer Gemeinschaft '
          'zu beteiligen.',
      visitorEndedBody =
          'Du kannst zurückkehren, wenn du bereit bist, ein Teil davon zu sein.',
      visitorLeaveTownAction = 'TOWN verlassen',
      membershipEntryLabel = 'LOKALE MITGLIEDSCHAFT',
      membershipEntryHeadlineTemplate =
          'Werde Mitglied in deiner Münchner Gemeinschaft.',
      membershipEntryBody =
          'TOWN ist ein lokaler zivilgesellschaftlicher Raum für echte Menschen.',
      membershipEntryBodySecond =
          'Für die Teilnahme brauchst du ein Konto, eine gültige lokale '
          'Verifizierung und eine aktive Mitgliedschaft.',
      membershipEntryPrice = '€12 pro Jahr',
      membershipEntryRenewal = 'Jährliche Verlängerung.',
      membershipEntryRenewalSecond =
          'Du kannst jederzeit kündigen. Der Zugang bleibt bis zum Ende des '
          'bereits bezahlten Zeitraums aktiv.',
      membershipEntryConditionsTitle = 'Für die Teilnahme:',
      membershipEntryCondition1 = '1. Erstelle dein Konto',
      membershipEntryCondition2 = '2. Verifiziere deine lokale Gemeinschaft',
      membershipEntryCondition3 = '3. Aktiviere die jährliche Mitgliedschaft',
      membershipEntryRights =
          'Mit einer aktiven Mitgliedschaft kannst du Signale bestätigen, '
          'Beiträge veröffentlichen, kommentieren und an Entscheidungen der '
          'Gemeinschaft teilnehmen.',
      membershipEntryContinue = 'Weiter',
      membershipEntrySecondaryBack = 'Zurück zur Gemeinschaft',
      accountSetupIntroLabel = 'PERSÖNLICHES KONTO',
      accountSetupIntroHeadline = 'Beginne mit einem persönlichen Konto.',
      accountSetupIntroBody =
          'Um an TOWN teilzunehmen, benötigt jedes Mitglied ein persönliches '
          'Konto, das mit genau einer lokalen Gemeinschaft verbunden ist.',
      accountSetupIntroWhyTitle = 'Warum ein Konto erforderlich ist',
      accountSetupIntroWhyBody =
          'TOWN möchte Bots, gefälschte Konten und anonymes Verhalten reduzieren, '
          'das der Gemeinschaft schadet.',
      accountSetupIntroWhyBodySecond =
          'Ein persönliches Konto macht die Teilnahme verantwortungsvoller und '
          'schützt andere Mitglieder besser.',
      accountSetupIntroVerificationTitle =
          'Während der Einrichtung bestätigen wir:',
      accountSetupIntroVerification1 =
          '1. Eine sichere Methode für den Zugang zu deinem Konto',
      accountSetupIntroVerification2 = '2. Deine lokale Gemeinschaft',
      accountSetupIntroVerification3 = '3. Den Status deiner Mitgliedschaft',
      accountSetupIntroPrivacyTitle = 'Deine Privatsphäre zählt',
      accountSetupIntroPrivacyBody =
          'Dein genauer Standort wird nicht öffentlich angezeigt.',
      accountSetupIntroPrivacyBodySecond =
          'TOWN speichert keine vollständigen Kartendaten und erstellt aus '
          'deiner zivilgesellschaftlichen Aktivität keine Werbe- oder '
          'politischen Profile.',
      accountSetupIntroStart = 'Starten',
      accountSetupIntroSecondaryBack = 'Zurück zur Mitgliedschaft',
      accountSetupIntroPrototypeMessage =
          'Die Kontoerstellung ist in diesem Prototyp noch nicht verfügbar.',
      accountSetupIntroPrototypeDismiss = 'Verstanden';

  final String openSignalAction;
  final String openSignalSheetTitle;
  final String openSignalPrototypeMessage;
  final String openSignalClose;
  final String seeThisToo;
  final String youConfirmedLocally;
  final String confirmationCountTemplate;
  final String statusLocallyConfirmed;
  final String statusReported;
  final String statusInProgress;
  final String statusNewSignal;
  final String statusResolved;
  final String visitorInvitationTitle;
  final String visitorInvitationBody;
  final String visitorInvitationBodySecond;
  final String visitorJoinAction;
  final String visitorNotNowAction;
  final String visitorEndedTitle;
  final String visitorEndedBody;
  final String visitorLeaveTownAction;
  final String membershipEntryLabel;
  final String membershipEntryHeadlineTemplate;
  final String membershipEntryBody;
  final String membershipEntryBodySecond;
  final String membershipEntryPrice;
  final String membershipEntryRenewal;
  final String membershipEntryRenewalSecond;
  final String membershipEntryConditionsTitle;
  final String membershipEntryCondition1;
  final String membershipEntryCondition2;
  final String membershipEntryCondition3;
  final String membershipEntryRights;
  final String membershipEntryContinue;
  final String membershipEntrySecondaryBack;
  final String accountSetupIntroLabel;
  final String accountSetupIntroHeadline;
  final String accountSetupIntroBody;
  final String accountSetupIntroWhyTitle;
  final String accountSetupIntroWhyBody;
  final String accountSetupIntroWhyBodySecond;
  final String accountSetupIntroVerificationTitle;
  final String accountSetupIntroVerification1;
  final String accountSetupIntroVerification2;
  final String accountSetupIntroVerification3;
  final String accountSetupIntroPrivacyTitle;
  final String accountSetupIntroPrivacyBody;
  final String accountSetupIntroPrivacyBodySecond;
  final String accountSetupIntroStart;
  final String accountSetupIntroSecondaryBack;
  final String accountSetupIntroPrototypeMessage;
  final String accountSetupIntroPrototypeDismiss;

  String confirmationCount(int count) =>
      confirmationCountTemplate.replaceAll('{count}', '$count');

  /// City-specific Membership Entry headline.
  ///
  /// Italian uses `{city}` from [selectedCity]. German uses the approved
  /// München wording and does not interpolate the canonical city id.
  String membershipEntryHeadline(String selectedCity) =>
      membershipEntryHeadlineTemplate.replaceAll('{city}', selectedCity);

  String statusLabel(CommunitySignalStatus status) {
    switch (status) {
      case CommunitySignalStatus.newSignal:
        return statusNewSignal;
      case CommunitySignalStatus.locallyConfirmed:
        return statusLocallyConfirmed;
      case CommunitySignalStatus.reported:
        return statusReported;
      case CommunitySignalStatus.inProgress:
        return statusInProgress;
      case CommunitySignalStatus.resolved:
        return statusResolved;
    }
  }

  /// Official language for the approved country/city pairs.
  factory TownFeedCopy.forCountry(String country) {
    assert(
      country == 'Italy' || country == 'Germany',
      'Unsupported feed country: $country',
    );
    if (country == 'Germany') {
      return const TownFeedCopy.german();
    }
    return const TownFeedCopy.italian();
  }
}
