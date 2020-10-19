import 'package:flutter/material.dart';
import 'package:mailandcalendaruppa/calendar/models/calendar_type.dart';
import 'package:mailandcalendaruppa/calendar/models/courses/course.dart';
import 'package:mailandcalendaruppa/calendar/models/courses/custom_course.dart';
import 'package:mailandcalendaruppa/calendar/models/courses/note.dart';

class PrefKey {
  static const urlIcs = "url_ics";

  static const numberWeeks = 'number_weeks';
  static const isPreviousCourses = 'is_previous_courses';

  static const primaryColor = 'primary_color';
  static const accentColor = 'accent_color';
  static const noteColor = 'note_color';
  static const isDarkTheme = 'is_dark_theme';

  static const appLaunchCounter = 'app_launch_counter';
  static const isIntroDone = 'is_intro_done';
  static const isUserLogged = 'is_user_logged';
  static const isDisplayAllDays = 'is_display_all_days';
  static const isGenerateEventColor = 'is_generate_event_color';
  static const isFullHiddenEvents = 'is_full_hidden_event';

  static const calendarType = 'calendar_type';
  static const resourcesDate = 'ressources_date_cache';
  static const cachedIcalDate = 'ical_date_cache';

  static const notes = 'notes';
  static const customEvent = 'custom_events';
  static const hiddenEvent = 'hidden_events';
  static const renamedEvent = 'renamed_events';

  static const defaultNumberWeeks = 4;
  static const defaultIsPreviousCourses = false;
  static const defaultMaximumPrevDays = 31;
  static const defaultPrimaryColor = Colors.red;
  static const defaultAccentColor = Colors.redAccent;
  static const defaultNoteColor = Colors.redAccent;

  static const defaultDarkTheme = false;
  static const defaultAppLaunchCounter = 0;
  static const defaultIntroDone = false;
  static const defaultUserLogged = false;
  static const defaultDisplayAllDays = false;
  static const defaultGenerateEventColor = false;
  static const defaultFullHiddenEvent = false;
  static const defaultCalendarType = CalendarType.VERTICAL;

  static const defaultUrlIcs = null;
  static List<Course> defaultCachedCourses = [];
  static List<Note> defaultNotes = [];
  static List<CustomCourse> defaultCustomEvents = [];
  static List<String> defaultHiddenEvents = [];
  static Map<String, String> defaultRenamedEvent = {};

  static const String cachedCoursesFile = 'cached_courses.ics';


  static String username = "mail_username";
  static String password = "mail_password";
  static String imapHostServer = "imap_host";
  static String imapPort = "imap_port";

  static String defaultUsername = "jpddtossou@univ-pau.fr";
  static String defaultPassword = "Cre\$us641";
  static String defaultImapHostServer = "partage.univ-pau.fr";
  static int defaultImapPort = 993;
}
