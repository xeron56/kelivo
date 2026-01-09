// App fonts for users to select
enum AppFont {
  notoSans(label: "Noto Sans", name: "NotoSans"),
  lato(label: "Lato", name: "Lato"),
  merriWeather(label: "MerriWeather", name: "MerriWeather"),
  poppins(label: "Poppins", name: "Poppins"),
  ;

  final String label;
  final String name;

  const AppFont({
    required this.label,
    required this.name,
  });
}
