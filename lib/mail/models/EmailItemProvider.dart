import 'package:enough_mail/enough_mail.dart';
import 'package:mailandcalendaruppa/calendar/param/string_key.dart';
import 'package:mailandcalendaruppa/calendar/utils/preferences.dart';

class EmailItemProvider{

  PreferencesProviderState prefs;
  ImapClient client;
  var loginResponse;


  EmailItemProvider(this.prefs);

  bool isConnected(){
    return client.isLoggedIn;
  }

  void logOut(){
    client.logout();
  }

  Future<ImapClient> bindImapclient() async {
    client = ImapClient(isLogEnabled: false);
    await client.connectToServer(prefs.imapHostServer, prefs.imapPort, isSecure: true);
    print("JEANPAUL SERVER ${prefs.imapHostServer} ${prefs.imapPort}");

    return client;
  }

  Future<List<MimeMessage>> imapInbox() async {
    List<MimeMessage> messages = List();

    loginResponse = !isConnected() ? await client.login(prefs.username, prefs.password): loginResponse;
    if (loginResponse.isOkStatus) {
      var inboxResponse = await client.selectInbox();
      if (inboxResponse.isOkStatus) {
        // fetch 30 most recent messages:
        var fetchResponse = await client.fetchRecentMessages(
            messageCount: 10, criteria: 'BODY.PEEK[]');
        if (fetchResponse.isOkStatus) {
          messages = fetchResponse.result.messages;
        }
      }
    }
    return messages;
  }

  Future<List<MimeMessage>> imapSent() async {
    List<MimeMessage> messages = List();
    loginResponse = !isConnected() ? await client.login(prefs.username, prefs.password): loginResponse;
    if (loginResponse.isOkStatus) {
      var inboxResponse = await client.selectMailboxByPath(StrKey.SENT);
      if (inboxResponse.isOkStatus) {
        // fetch 30 most recent messages:
        var fetchResponse = await client.fetchRecentMessages(
            messageCount: 5, criteria: 'BODY.PEEK[]');
        if (fetchResponse.isOkStatus) {
          messages = fetchResponse.result.messages;
        }
      }
    }
    return messages;
  }

  Future<List<MimeMessage>> imapDraft() async {
    List<MimeMessage> messages = List();
    loginResponse = !isConnected() ? await client.login(prefs.username, prefs.password): loginResponse;
    if (loginResponse.isOkStatus) {
      var inboxResponse = await client.selectMailboxByPath(StrKey.DRAFTS);
      if (inboxResponse.isOkStatus) {
        // fetch 30 most recent messages:
        var fetchResponse = await client.fetchRecentMessages(
            messageCount: 5, criteria: 'BODY.PEEK[]');
        if (fetchResponse.isOkStatus) {
          messages = fetchResponse.result.messages;
        }
      }
    }
    return messages;
  }

  Future<List<MimeMessage>> imapJunk() async {
    List<MimeMessage> messages = List();
    loginResponse = !isConnected() ? await client.login(prefs.username, prefs.password): loginResponse;
    if (loginResponse.isOkStatus) {
      var inboxResponse = await client.selectMailboxByPath(StrKey.JUNK);
      if (inboxResponse.isOkStatus) {
        // fetch 30 most recent messages:
        var fetchResponse = await client.fetchRecentMessages(
            messageCount: 5, criteria: 'BODY.PEEK[]');
        if (fetchResponse.isOkStatus) {
          messages = fetchResponse.result.messages;
        }
      }
    }
    return messages;
  }

  Future<List<MimeMessage>> imapTrash() async {
    List<MimeMessage> messages = List();
    loginResponse = isConnected() ? await client.login(prefs.username, prefs.password): loginResponse;
    if (loginResponse.isOkStatus) {
      var inboxResponse = await client.selectMailboxByPath(StrKey.TRASH);
      if (inboxResponse.isOkStatus) {
        // fetch 30 most recent messages:
        var fetchResponse = await client.fetchRecentMessages(
            messageCount: 5, criteria: 'BODY.PEEK[]');
        if (fetchResponse.isOkStatus) {
          messages = fetchResponse.result.messages;
        }
      }
    }
    return messages;
  }
}