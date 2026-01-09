// App date formats for users to select

enum AppDateFormat {
  date1('yyyy-MM-dd'),
  date2('yyyy/MM/dd'),
  date3('dd-MM-yyyy'),
  date4('dd/MM/yyyy'),
  date5('MM-dd-yyyy'),
  date6('MM/dd/yyyy'),
  date7('yyyy.MM.dd'),
  date8('dd.MM.yyyy'),
  date9('MM.dd.yyyy'),
  date10('MMM dd, yyyy');

  final String pattern;

  const AppDateFormat(this.pattern);
}
