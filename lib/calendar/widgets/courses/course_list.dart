import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/date_utils.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:mailandcalendaruppa/calendar/models/courses/base_course.dart';
import 'package:mailandcalendaruppa/calendar/models/courses/course.dart';
import 'package:mailandcalendaruppa/calendar/param/string_key.dart';
import 'package:mailandcalendaruppa/calendar/ui/base_state.dart';
import 'package:mailandcalendaruppa/calendar/models/calendar_type.dart';
import 'package:mailandcalendaruppa/calendar/utils/date.dart';
import 'package:mailandcalendaruppa/calendar/utils/preferences.dart';
import 'package:mailandcalendaruppa/calendar/utils/translations.dart';
import 'package:mailandcalendaruppa/calendar/widgets/calendar/calendar_event.dart';
import 'package:mailandcalendaruppa/calendar/widgets/courses/course_row.dart';
import 'package:mailandcalendaruppa/calendar/widgets/courses/course_row_header.dart';
import 'package:mailandcalendaruppa/calendar/widgets/ui/message/empty_day.dart';
import 'package:mailandcalendaruppa/mail/models/EmailItemProvider.dart';
import 'package:mailandcalendaruppa/mail/models/email.dart';
import 'package:mailandcalendaruppa/mail/ui/common/email_tile.dart';

class CourseList extends StatefulWidget {
  final Map<int, List<Course>> coursesData;
  final CalendarType calType;

  const CourseList({
    Key key,
    @required this.coursesData,
    this.calType = CalendarType.VERTICAL,
  }) : super(key: key);

  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends BaseState<CourseList> {
  List<MimeMessage> inbox;
  List<MimeMessage> sent;
  List<MimeMessage> junk;
  List<MimeMessage> trash;
  List<MimeMessage> draft;

  Widget _buildListCours(BuildContext context, List<BaseCourse> courses) {
    List<Widget> widgets = [];

    final noteColor = prefs.theme.noteColor;

    bool classicView = (widget.calType == CalendarType.HORIZONTAL ||
        widget.calType == CalendarType.VERTICAL);

    if (courses != null && courses.isNotEmpty) {
      courses.forEach((course) {
        if (course == null)
          widgets.add(const EmptyDay());
        else if (course is CourseHeader)
          widgets.add(CourseRowHeader(coursHeader: course));
        else if (course is Course)
          widgets.add(CourseRow(course: course, noteColor: noteColor));
      });
    } else {
      widgets.add(const EmptyDay(
        padding: EdgeInsets.fromLTRB(26.0, 10.0, 26.0, 16.0),
      ));
    }

    return ListView(
      children: widgets,
      padding: EdgeInsets.only(
        bottom: classicView ? 36.0 : 2.0,
        top: widget.calType == CalendarType.VERTICAL ? 0.0 : 12.0,
      ),
    );
  }

  Widget _buildbox(List<MimeMessage> messages) {
    List<Widget> widgets = [];

    if (messages == null && messages.isEmpty) widgets.add(const EmptyDay(textKey: StrKey.NO_MAIL, padding: EdgeInsets.fromLTRB(26.0, 10.0, 26.0, 16.0),));

    messages.forEach((message) {
      EmailItem emailItem = EmailItem.fromMessage(message);
      widgets.add(EmailListTile(item: emailItem, favoriteChanged: () {setState(() => emailItem.favorite = !emailItem.favorite);}));
    });

    return ListView(
      children: widgets,
      padding: EdgeInsets.only(
        bottom: /*classicView ? 36.0 :*/ 2.0,
        top: widget.calType == CalendarType.VERTICAL ? 0.0 : 12.0,
      ),
    );
  }

  Widget defaultTabController(BuildContext context, int initialIndex,
      List<Widget> tabs, List<Widget> listTabView) {
    final theme = Theme.of(context);

    final baseStyle = theme.primaryTextTheme.headline6;
    final unselectedStyle = baseStyle.copyWith(
      fontSize: 17.0,
      color: baseStyle.color.withAlpha(180),
    );
    final labelStyle = unselectedStyle.copyWith(color: baseStyle.color);

    return DefaultTabController(
      length: tabs.length,
      initialIndex: initialIndex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: theme.primaryColor,
            child: TabBar(
              isScrollable: true,
              tabs: tabs,
              labelColor: labelStyle.color,
              labelStyle: labelStyle,
              unselectedLabelColor: theme.primaryTextTheme.caption.color,
              unselectedLabelStyle: unselectedStyle,
              indicatorPadding: const EdgeInsets.only(bottom: 0.2),
              indicatorWeight: 2.5,
              indicatorColor: labelStyle.color,
            ),
          ),
          Expanded(child: TabBarView(children: listTabView)),
        ],
      ),
    );
  }

  Future<Widget> _buildMailClient(context) async {
    // if (elements.isEmpty) return const SizedBox.shrink();

    List<Widget> listTabView = [];
    List<Widget> tabs = [];

    int initialIndex = 0;

    EmailItemProvider provider =
        EmailItemProvider(PreferencesProvider.of(context));
    await provider.bindImapclient();
    print("JEANPAUL after BINDER");
    tabs.add(Tab(text: i18n.text(StrKey.INBOX)));
    tabs.add(Tab(text: i18n.text(StrKey.SENT)));
    tabs.add(Tab(text: i18n.text(StrKey.DRAFTS)));
    tabs.add(Tab(text: i18n.text(StrKey.JUNK)));
    tabs.add(Tab(text: i18n.text(StrKey.TRASH)));
    print("JEANPAUL before INBOX");

    listTabView.add(_buildbox(await provider.imapInbox()));
    listTabView.add(_buildbox(await provider.imapSent()));
    listTabView.add(_buildbox(await provider.imapDraft()));
    listTabView.add(_buildbox(await provider.imapJunk()));
    listTabView.add(_buildbox(await provider.imapTrash()));
    provider.logOut();

    /*tabs.add(Tab(text: i18n.text(StrKey.INBOX)));
    inbox.isEmpty || inbox == null
        ? listTabView.add(_buildbox(inbox = await provider.imapInbox()))
        : listTabView.add(_buildbox(inbox));
    print("JEANPAUL after INBOX");
    tabs.add(Tab(text: i18n.text(StrKey.SENT)));
    sent.isEmpty
        ? listTabView.add(_buildbox(sent = await provider.imapSent()))
        : listTabView.add(_buildbox(sent));

    tabs.add(Tab(text: i18n.text(StrKey.DRAFTS)));
    draft.isEmpty
        ? listTabView.add(_buildbox(draft = await provider.imapDraft()))
        : listTabView.add(_buildbox(draft));

    tabs.add(Tab(text: i18n.text(StrKey.JUNK)));
    junk.isEmpty
        ? listTabView.add(_buildbox(junk = await provider.imapJunk()))
        : listTabView.add(_buildbox(junk));

    tabs.add(Tab(text: i18n.text(StrKey.TRASH)));
    trash.isEmpty
        ? listTabView.add(_buildbox(trash = await provider.imapTrash()))
        : listTabView.add(_buildbox(trash));
    provider.logOut();*/

    return defaultTabController(context, initialIndex, tabs, listTabView);
  }

  Widget _buildHorizontal(context, Map<int, List<Course>> elements) {
    if (elements.isEmpty) return const SizedBox.shrink();

    List<Widget> listTabView = [];
    List<Widget> tabs = [];

    // Build horizontal view
    final today = Date.dateToInt(DateTime.now());
    int initialIndex = 0;
    bool isIndexFound = false;

    elements.forEach((date, courses) {
      if (!prefs.isDisplayAllDays && (courses == null || courses.isEmpty))
        return;
      tabs.add(Tab(text: Date.dateFromNow(Date.intToDate(date), true)));

      listTabView.add(_buildListCours(context, courses));

      final isMinEvent = date >= today;
      if (!isMinEvent && !isIndexFound) {
        initialIndex++;
      } else if (isMinEvent && !isIndexFound) {
        isIndexFound = true;
      }
    });

    if (initialIndex >= elements.length) initialIndex = 0;

    final theme = Theme.of(context);

    final baseStyle = theme.primaryTextTheme.headline6;
    final unselectedStyle = baseStyle.copyWith(
      fontSize: 17.0,
      color: baseStyle.color.withAlpha(180),
    );
    final labelStyle = unselectedStyle.copyWith(color: baseStyle.color);

    return defaultTabController(context, initialIndex, tabs, listTabView);
  }

  Widget _buildVertical(context, Map<int, List<Course>> elements) {
    // Build vertical view
    final List<BaseCourse> listChildren = [];
    elements.forEach((date, courses) {
      if (courses == null || courses.isEmpty) return;

      List<Course> filteredCourses =
          courses.where((c) => c.dateEnd.isAfter(DateTime.now())).toList();

      if (filteredCourses.isEmpty) return;

      listChildren.add(CourseHeader(Date.intToDate(date)));
      listChildren.addAll(filteredCourses);
    });

    return _buildListCours(context, listChildren);
  }

  Widget _buildDialog(BuildContext context, DateTime date, Map events) {
    List<Course> courseEvents = _getDayEvents(date, events);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 480),
        child: _buildListCours(context, courseEvents),
      ),
    );
  }

  List<Course> _getDayEvents(DateTime day, Map<DateTime, List<Course>> data) {
    DateTime key = data.keys.firstWhere(
      (d) => DateUtils.isSameDay(day, d),
      orElse: () => null,
    );
    if (key != null)
      return data[key]
          .map((e) => e is Course ? e : null)
          .where((c) => c != null)
          .toList();
    return [];
  }

  Widget _buildCalendar(context, Map<int, List<Course>> elements) {
    var events = elements.map(
      (intDate, events) => MapEntry(Date.intToDate(intDate), events),
    );

    final isGenColor = PreferencesProvider.of(context).isGenerateEventColor;

    // Build calendar view
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Calendar(
        monthView: widget.calType == CalendarType.MONTH_VIEW,
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        initialSelectedDate: DateTime.now(),
        dayBuilder: (_, date) => _getDayEvents(date, events).map((e) {
          return Event(
            title: e.isHidden ? null : e.getTitle(),
            color: e.getColor(isGenColor),
          );
        }).toList(),
        onDateSelected: (date) {
          showDialog(
            context: context,
            builder: (dCtx) => _buildDialog(dCtx, date, events),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    //Future.delayed(Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.calType == CalendarType.VERTICAL)
      content = _buildVertical(context, widget.coursesData);
    else if (widget.calType == CalendarType.HORIZONTAL)
      content = _buildHorizontal(context, widget.coursesData);
    else if (widget.calType == CalendarType.MAIL_CLIENT)
      content = FutureBuilder<Widget>(
        future: _buildMailClient(context),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            print("JEANAN");
            return snapshot.data;
          } else {
            return CircularProgressIndicator();
          }
        },
      );
    else
      content = _buildCalendar(context, widget.coursesData);

    return content;
  }
}
