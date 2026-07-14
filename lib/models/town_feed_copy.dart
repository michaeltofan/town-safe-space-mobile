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
    required this.accountCreationEmailLabel,
    required this.accountCreationEmailHeadline,
    required this.accountCreationEmailBody,
    required this.accountCreationEmailBodySecond,
    required this.accountCreationEmailFieldLabel,
    required this.accountCreationEmailPlaceholder,
    required this.accountCreationEmailPrivacyNote,
    required this.accountCreationEmailContinue,
    required this.accountCreationEmailEmpty,
    required this.accountCreationEmailInvalid,
    required this.accountCreationCodeLabel,
    required this.accountCreationCodeHeadline,
    required this.accountCreationCodeBody,
    required this.accountCreationCodeFieldLabel,
    required this.accountCreationCodeVerify,
    required this.accountCreationCodeChangeEmail,
    required this.accountCreationCodeEmpty,
    required this.accountCreationCodeInvalid,
    required this.accountCreationCodePrototypeNote,
    required this.accountCreationPasskeyLabel,
    required this.accountCreationPasskeyHeadline,
    required this.accountCreationPasskeyBody,
    required this.accountCreationPasskeyBodySecond,
    required this.accountCreationPasskeyBenefit1,
    required this.accountCreationPasskeyBenefit2,
    required this.accountCreationPasskeyBenefit3,
    required this.accountCreationPasskeyCreate,
    required this.accountCreationPasskeyPrototypeMessage,
    required this.accountCreationPasskeySimulate,
    required this.accountCreationReadyLabel,
    required this.accountCreationReadyHeadline,
    required this.accountCreationReadyBody,
    required this.accountCreationReadyBodySecond,
    required this.accountCreationReadyEmailStatus,
    required this.accountCreationReadyPasskeyStatus,
    required this.accountCreationReadyNextStep,
    required this.accountCreationReadyContinue,
    required this.accountCreationPaymentBoundaryMessage,
    required this.accountCreationPaymentBoundaryDismiss,
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
      accountCreationEmailLabel = 'CREATE YOUR ACCOUNT',
      accountCreationEmailHeadline = 'Enter your email.',
      accountCreationEmailBody =
          'We will send you a 6-digit verification code.',
      accountCreationEmailBodySecond = 'You do not need a password.',
      accountCreationEmailFieldLabel = 'Email address',
      accountCreationEmailPlaceholder = 'name@example.com',
      accountCreationEmailPrivacyNote =
          'We will use this email to verify your account, send essential '
          'communications and help you recover access.',
      accountCreationEmailContinue = 'Continue',
      accountCreationEmailEmpty = 'Enter your email address.',
      accountCreationEmailInvalid = 'Enter a valid email address.',
      accountCreationCodeLabel = 'VERIFY EMAIL',
      accountCreationCodeHeadline = 'Check your email.',
      accountCreationCodeBody = 'We sent a 6-digit code to:',
      accountCreationCodeFieldLabel = 'Verification code',
      accountCreationCodeVerify = 'Verify',
      accountCreationCodeChangeEmail = 'Change email',
      accountCreationCodeEmpty = 'Enter the 6-digit code.',
      accountCreationCodeInvalid = 'The code is incorrect.',
      accountCreationCodePrototypeNote =
          'In the prototype, enter 123456 to continue.',
      accountCreationPasskeyLabel = 'SECURE ACCESS',
      accountCreationPasskeyHeadline = 'Protect your TOWN account.',
      accountCreationPasskeyBody =
          'Use Face ID, Touch ID, your fingerprint or your device PIN.',
      accountCreationPasskeyBodySecond =
          'TOWN uses a passkey: you do not need to create or remember a password.',
      accountCreationPasskeyBenefit1 = 'Better resistance to phishing',
      accountCreationPasskeyBenefit2 = 'No password is shared with TOWN',
      accountCreationPasskeyBenefit3 = 'You can add other devices later',
      accountCreationPasskeyCreate = 'Create secure access',
      accountCreationPasskeyPrototypeMessage =
          'Real passkey creation is not active in this prototype yet.',
      accountCreationPasskeySimulate = 'Simulate setup',
      accountCreationReadyLabel = 'SECURE ACCOUNT',
      accountCreationReadyHeadline = 'Your account is ready.',
      accountCreationReadyBody =
          'Your email is verified and your secure access is set up.',
      accountCreationReadyBodySecond =
          'The next step is to activate the annual TOWN membership.',
      accountCreationReadyEmailStatus = 'Email verified',
      accountCreationReadyPasskeyStatus = 'Secure access configured',
      accountCreationReadyNextStep = 'TOWN membership — €12 per year',
      accountCreationReadyContinue = 'Continue to membership',
      accountCreationPaymentBoundaryMessage =
          'Annual membership payment is not active in this prototype yet.',
      accountCreationPaymentBoundaryDismiss = 'Got it';

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
      accountCreationEmailLabel = 'CREA IL TUO ACCOUNT',
      accountCreationEmailHeadline = 'Inserisci la tua email.',
      accountCreationEmailBody =
          'Ti invieremo un codice di verifica di 6 cifre.',
      accountCreationEmailBodySecond = 'Non serve una password.',
      accountCreationEmailFieldLabel = 'Indirizzo email',
      accountCreationEmailPlaceholder = 'nome@esempio.it',
      accountCreationEmailPrivacyNote =
          'Useremo questa email per verificare il tuo account, inviarti '
          'comunicazioni essenziali e aiutarti a recuperare l’accesso.',
      accountCreationEmailContinue = 'Continua',
      accountCreationEmailEmpty = 'Inserisci il tuo indirizzo email.',
      accountCreationEmailInvalid =
          'Inserisci un indirizzo email valido.',
      accountCreationCodeLabel = 'VERIFICA EMAIL',
      accountCreationCodeHeadline = 'Controlla la tua email.',
      accountCreationCodeBody =
          'Abbiamo inviato un codice di 6 cifre a:',
      accountCreationCodeFieldLabel = 'Codice di verifica',
      accountCreationCodeVerify = 'Verifica',
      accountCreationCodeChangeEmail = 'Cambia email',
      accountCreationCodeEmpty = 'Inserisci il codice di 6 cifre.',
      accountCreationCodeInvalid = 'Il codice non è corretto.',
      accountCreationCodePrototypeNote =
          'Nel prototipo, inserisci 123456 per continuare.',
      accountCreationPasskeyLabel = 'ACCESSO SICURO',
      accountCreationPasskeyHeadline = 'Proteggi il tuo account TOWN.',
      accountCreationPasskeyBody =
          'Usa Face ID, Touch ID, l’impronta digitale o il PIN del tuo '
          'dispositivo.',
      accountCreationPasskeyBodySecond =
          'TOWN utilizza una passkey: non devi creare o ricordare una password.',
      accountCreationPasskeyBenefit1 = 'Resiste meglio al phishing',
      accountCreationPasskeyBenefit2 =
          'Non viene condivisa una password con TOWN',
      accountCreationPasskeyBenefit3 =
          'Puoi aggiungere altri dispositivi in seguito',
      accountCreationPasskeyCreate = 'Crea accesso sicuro',
      accountCreationPasskeyPrototypeMessage =
          'La creazione reale della passkey non è ancora attiva in questo '
          'prototipo.',
      accountCreationPasskeySimulate = 'Simula configurazione',
      accountCreationReadyLabel = 'ACCOUNT SICURO',
      accountCreationReadyHeadline = 'Il tuo account è pronto.',
      accountCreationReadyBody =
          'La tua email è verificata e il tuo accesso sicuro è configurato.',
      accountCreationReadyBodySecond =
          'Il prossimo passo è attivare l’iscrizione annuale a TOWN.',
      accountCreationReadyEmailStatus = 'Email verificata',
      accountCreationReadyPasskeyStatus = 'Accesso sicuro configurato',
      accountCreationReadyNextStep = 'Iscrizione TOWN — €12 all’anno',
      accountCreationReadyContinue = 'Continua all’iscrizione',
      accountCreationPaymentBoundaryMessage =
          'Il pagamento dell’iscrizione annuale non è ancora attivo in questo '
          'prototipo.',
      accountCreationPaymentBoundaryDismiss = 'Ho capito';

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
      accountCreationEmailLabel = 'KONTO ERSTELLEN',
      accountCreationEmailHeadline = 'Gib deine E-Mail-Adresse ein.',
      accountCreationEmailBody =
          'Wir senden dir einen sechsstelligen Bestätigungscode.',
      accountCreationEmailBodySecond = 'Du brauchst kein Passwort.',
      accountCreationEmailFieldLabel = 'E-Mail-Adresse',
      accountCreationEmailPlaceholder = 'name@beispiel.de',
      accountCreationEmailPrivacyNote =
          'Wir verwenden diese E-Mail-Adresse, um dein Konto zu bestätigen, '
          'dir notwendige Mitteilungen zu senden und dir bei der '
          'Wiederherstellung des Zugangs zu helfen.',
      accountCreationEmailContinue = 'Weiter',
      accountCreationEmailEmpty = 'Gib deine E-Mail-Adresse ein.',
      accountCreationEmailInvalid =
          'Gib eine gültige E-Mail-Adresse ein.',
      accountCreationCodeLabel = 'E-MAIL BESTÄTIGEN',
      accountCreationCodeHeadline = 'Prüfe deine E-Mails.',
      accountCreationCodeBody =
          'Wir haben einen sechsstelligen Code gesendet an:',
      accountCreationCodeFieldLabel = 'Bestätigungscode',
      accountCreationCodeVerify = 'Bestätigen',
      accountCreationCodeChangeEmail = 'E-Mail-Adresse ändern',
      accountCreationCodeEmpty = 'Gib den sechsstelligen Code ein.',
      accountCreationCodeInvalid = 'Der Code ist nicht korrekt.',
      accountCreationCodePrototypeNote =
          'Gib im Prototyp 123456 ein, um fortzufahren.',
      accountCreationPasskeyLabel = 'SICHERER ZUGANG',
      accountCreationPasskeyHeadline = 'Schütze dein TOWN-Konto.',
      accountCreationPasskeyBody =
          'Verwende Face ID, Touch ID, deinen Fingerabdruck oder die '
          'Geräte-PIN.',
      accountCreationPasskeyBodySecond =
          'TOWN verwendet einen Passkey. Du musst kein Passwort erstellen oder '
          'merken.',
      accountCreationPasskeyBenefit1 = 'Besserer Schutz vor Phishing',
      accountCreationPasskeyBenefit2 =
          'Kein Passwort wird mit TOWN geteilt',
      accountCreationPasskeyBenefit3 =
          'Du kannst später weitere Geräte hinzufügen',
      accountCreationPasskeyCreate = 'Sicheren Zugang erstellen',
      accountCreationPasskeyPrototypeMessage =
          'Die echte Passkey-Erstellung ist in diesem Prototyp noch nicht '
          'verfügbar.',
      accountCreationPasskeySimulate = 'Einrichtung simulieren',
      accountCreationReadyLabel = 'KONTO GESICHERT',
      accountCreationReadyHeadline = 'Dein Konto ist bereit.',
      accountCreationReadyBody =
          'Deine E-Mail-Adresse ist bestätigt und dein sicherer Zugang ist '
          'eingerichtet.',
      accountCreationReadyBodySecond =
          'Als Nächstes aktivierst du deine jährliche TOWN-Mitgliedschaft.',
      accountCreationReadyEmailStatus = 'E-Mail bestätigt',
      accountCreationReadyPasskeyStatus = 'Sicherer Zugang eingerichtet',
      accountCreationReadyNextStep =
          'TOWN-Mitgliedschaft — €12 pro Jahr',
      accountCreationReadyContinue = 'Weiter zur Mitgliedschaft',
      accountCreationPaymentBoundaryMessage =
          'Die Zahlung für die jährliche Mitgliedschaft ist in diesem Prototyp '
          'noch nicht verfügbar.',
      accountCreationPaymentBoundaryDismiss = 'Verstanden';

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
  final String accountCreationEmailLabel;
  final String accountCreationEmailHeadline;
  final String accountCreationEmailBody;
  final String accountCreationEmailBodySecond;
  final String accountCreationEmailFieldLabel;
  final String accountCreationEmailPlaceholder;
  final String accountCreationEmailPrivacyNote;
  final String accountCreationEmailContinue;
  final String accountCreationEmailEmpty;
  final String accountCreationEmailInvalid;
  final String accountCreationCodeLabel;
  final String accountCreationCodeHeadline;
  final String accountCreationCodeBody;
  final String accountCreationCodeFieldLabel;
  final String accountCreationCodeVerify;
  final String accountCreationCodeChangeEmail;
  final String accountCreationCodeEmpty;
  final String accountCreationCodeInvalid;
  final String accountCreationCodePrototypeNote;
  final String accountCreationPasskeyLabel;
  final String accountCreationPasskeyHeadline;
  final String accountCreationPasskeyBody;
  final String accountCreationPasskeyBodySecond;
  final String accountCreationPasskeyBenefit1;
  final String accountCreationPasskeyBenefit2;
  final String accountCreationPasskeyBenefit3;
  final String accountCreationPasskeyCreate;
  final String accountCreationPasskeyPrototypeMessage;
  final String accountCreationPasskeySimulate;
  final String accountCreationReadyLabel;
  final String accountCreationReadyHeadline;
  final String accountCreationReadyBody;
  final String accountCreationReadyBodySecond;
  final String accountCreationReadyEmailStatus;
  final String accountCreationReadyPasskeyStatus;
  final String accountCreationReadyNextStep;
  final String accountCreationReadyContinue;
  final String accountCreationPaymentBoundaryMessage;
  final String accountCreationPaymentBoundaryDismiss;

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
