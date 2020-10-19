import 'package:flutter/material.dart';
import 'package:mailandcalendaruppa/calendar/ui/detail_course/detail_course.dart';
import 'package:mailandcalendaruppa/calendar/utils/custom_route.dart';
import 'package:mailandcalendaruppa/mail/models/email.dart';
import 'package:intl/intl.dart';
import 'package:mailandcalendaruppa/mail/ui/common/common.dart';

class EmailListTile extends StatefulWidget {
  @override
  _EmailListTileState createState() => _EmailListTileState();

  const EmailListTile({
    Key key,
    this.favoriteChanged,
    @required this.item,
  }) : super(key: key);

  final EmailItem item;
  final VoidCallback favoriteChanged;
}

class _EmailListTileState extends State<EmailListTile> {

  void _onCourseTap(BuildContext context) {
    Navigator.of(context).push(
      CustomRoute<EmailItem>(
        builder: (context) => EmailView(item: widget.item),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: InkWell(
          onTap: ()=>{
            _onCourseTap(context)
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  radius: 25.0,
                  child: Text(widget.item?.avatar ?? ""),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.item?.title ?? "",
                        style: Theme.of(context).textTheme.display1.copyWith(
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        widget.item?.description ?? "",
                        maxLines: 3,
                        style: Theme.of(context).textTheme.body1.copyWith(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(DateFormat.jm().format(DateTime.now())),
                  IconButton(
                    icon: (widget.item?.favorite ?? false)
                        ? Icon(Icons.star, color: Colors.amber)
                        : Icon(Icons.star_border),
                    onPressed: widget.favoriteChanged,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}