import 'package:enough_mail/enough_mail.dart';

class EmailItem {

  EmailItem({
    this.avatar,
    this.date,
    this.description,
    this.favorite,
    this.title,
  });

  EmailItem.fromMessage(MimeMessage message){
    this.avatar = message.fromEmail.substring(0,1).toUpperCase();
    this.date = message.decodeDate().toLocal();
    this.description = message.decodeTextPlainPart();
    this.favorite = message.isFlagged;
    this.title = message.decodeSubject();
    this.message = message;
  }

  String title;

  String description;

  String avatar;

  DateTime date;

  MimeMessage message;

  bool favorite = false;
}

