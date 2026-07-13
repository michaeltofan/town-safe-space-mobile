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
    required this.visitorJoinPlaceholderTitle,
    required this.visitorJoinPlaceholderBody,
    required this.visitorJoinPlaceholderClose,
    required this.visitorEndedTitle,
    required this.visitorEndedBody,
    required this.visitorLeaveTownAction,
  });

  /// Approved Milano / English chrome (current Feed V1 product).
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
      visitorJoinPlaceholderTitle = 'Join your community',
      visitorJoinPlaceholderBody =
          'Account creation, local verification and annual membership will be added '
          'in the next TOWN phase.',
      visitorJoinPlaceholderClose = 'Close',
      visitorEndedTitle =
          'TOWN is for people who are ready to take part in their community.',
      visitorEndedBody =
          'You can return when you are ready to be part of it.',
      visitorLeaveTownAction = 'Leave TOWN';

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
      visitorJoinPlaceholderTitle = 'Deiner Gemeinschaft beitreten',
      visitorJoinPlaceholderBody =
          'Kontoerstellung, lokale Verifizierung und die jährliche Mitgliedschaft '
          'werden in der nächsten TOWN-Phase hinzugefügt.',
      visitorJoinPlaceholderClose = 'Schließen',
      visitorEndedTitle =
          'TOWN ist für Menschen, die bereit sind, sich an ihrer Gemeinschaft '
          'zu beteiligen.',
      visitorEndedBody =
          'Du kannst zurückkehren, wenn du bereit bist, ein Teil davon zu sein.',
      visitorLeaveTownAction = 'TOWN verlassen';

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
  final String visitorJoinPlaceholderTitle;
  final String visitorJoinPlaceholderBody;
  final String visitorJoinPlaceholderClose;
  final String visitorEndedTitle;
  final String visitorEndedBody;
  final String visitorLeaveTownAction;

  String confirmationCount(int count) =>
      confirmationCountTemplate.replaceAll('{count}', '$count');

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
    return const TownFeedCopy.english();
  }
}
