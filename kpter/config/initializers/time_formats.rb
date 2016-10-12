# 0秒 - 59秒 => a few seconds ago
# 1分 => 1 minute ago
# 2分 - 59分 => x minutes ago
# 1時間 => 1 hour ago
# 2時間 - 23時間 => x hours ago
# 1日 =>　yyyy/mm/dd
Time::DATE_FORMATS[:distance] = lambda {|date|
  seconds = (Time.now - date).round;
  days    = seconds / (60 * 60 * 24); return I18n.t("datetime.distance_in_original_words.over_x_day", {year: "#{date.year}", month: date.strftime("%b"), day: "#{date.day}"}) if days > 0;
  hours   = seconds / (60 * 60);      return I18n.t("datetime.distance_in_original_words.within_x_24_hours.one") if hours == 1;
  hours   = seconds / (60 * 60);      return I18n.t("datetime.distance_in_original_words.within_x_24_hours.other", {hours: "#{hours}"}) if hours > 1;
  minutes = seconds / 60;             return I18n.t("datetime.distance_in_original_words.within_1_hour.one") if  minutes == 1;
  minutes = seconds / 60;             return I18n.t("datetime.distance_in_original_words.within_1_hour.other", {minutes: "#{minutes}"}) if minutes > 1;
  minutes = seconds / 60;             return I18n.t("datetime.distance_in_original_words.within_1_minute") if seconds > 0;
  return I18n.t("datetime.distance_in_original_words.within_1_minute");
}
