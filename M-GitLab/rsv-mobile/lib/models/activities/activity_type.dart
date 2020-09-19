part of activity;

enum ActivityType {
  webinar,
  meeting,
  session,
  course,
}

class ActivityAttribute {
  static Map<ActivityType, ActivityTypeAttribute> _info = {
    ActivityType.meeting: ActivityTypeAttribute(const Color(0xff3AA0FD),
        const Color(0x503AA0FD), 'Встреча', FontAwesomeIcons.solidHandshake),
    ActivityType.webinar: ActivityTypeAttribute(const Color(0xff51BA20),
        const Color(0x5051BA20), 'Вебинар', FontAwesomeIcons.video),
    ActivityType.course: ActivityTypeAttribute(const Color(0xffFC923A),
        const Color(0x50FC923A), 'Курс', FontAwesomeIcons.bookOpen),
    ActivityType.session: ActivityTypeAttribute(const Color(0xff783AFC),
        const Color(0x50783AFC), 'Сессия', FontAwesomeIcons.graduationCap),
  };
  static ActivityTypeAttribute attributeOf(ActivityType type) {
    return _info[type];
  }
}

class ActivityTypeAttribute {
  final Color color;
  final Color opacityColor;
  final String title;
  final IconData icon;

  ActivityTypeAttribute(
    this.color,
    this.opacityColor,
    this.title,
    this.icon,
  );
}
