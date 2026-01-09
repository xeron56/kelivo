// App supported currencies
import 'package:collection/collection.dart';

enum Currency {
  usd(
      name: "US Dollar",
      symbol: "\$",
      isoCode: "USD",
      format: "#,##0.00",
      countryCode: "US"),
  eur(
      name: "Euro",
      symbol: "€",
      isoCode: "EUR",
      format: "#,##0.00",
      countryCode: "EU"),
  gbp(
      name: "British Pound",
      symbol: "£",
      isoCode: "GBP",
      format: "#,##0.00",
      countryCode: "GB"),
  inr(
      name: "Indian Rupee",
      symbol: "₹",
      isoCode: "INR",
      format: "#,##,##0.00",
      countryCode: "IN"),
  jpy(
      name: "Japanese Yen",
      symbol: "¥",
      isoCode: "JPY",
      format: "#,##0",
      countryCode: "JP"),
  aud(
      name: "Australian Dollar",
      symbol: "A\$",
      isoCode: "AUD",
      format: "#,##0.00",
      countryCode: "AU"),
  cad(
      name: "Canadian Dollar",
      symbol: "C\$",
      isoCode: "CAD",
      format: "#,##0.00",
      countryCode: "CA"),
  chf(
      name: "Swiss Franc",
      symbol: "CHF",
      isoCode: "CHF",
      format: "#,##0.00",
      countryCode: "CH"),
  cny(
      name: "Chinese Yuan",
      symbol: "¥",
      isoCode: "CNY",
      format: "#,##0.00",
      countryCode: "CN"),
  sek(
      name: "Swedish Krona",
      symbol: "kr",
      isoCode: "SEK",
      format: "#,##0.00",
      countryCode: "SE"),
  nzd(
      name: "New Zealand Dollar",
      symbol: "NZ\$",
      isoCode: "NZD",
      format: "#,##0.00",
      countryCode: "NZ"),
  zar(
      name: "South African Rand",
      symbol: "R",
      isoCode: "ZAR",
      format: "#,##0.00",
      countryCode: "ZA"),
  rub(
      name: "Russian Ruble",
      symbol: "₽",
      isoCode: "RUB",
      format: "#,##0.00",
      countryCode: "RU"),
  sgd(
      name: "Singapore Dollar",
      symbol: "S\$",
      isoCode: "SGD",
      format: "#,##0.00",
      countryCode: "SG"),
  hkd(
      name: "Hong Kong Dollar",
      symbol: "HK\$",
      isoCode: "HKD",
      format: "#,##0.00",
      countryCode: "HK"),
  thb(
      name: "Thai Baht",
      symbol: "฿",
      isoCode: "THB",
      format: "#,##0.00",
      countryCode: "TH"),
  mxn(
      name: "Mexican Peso",
      symbol: "\$",
      isoCode: "MXN",
      format: "#,##0.00",
      countryCode: "MX"),
  brl(
      name: "Brazilian Real",
      symbol: "R\$",
      isoCode: "BRL",
      format: "#,##0.00",
      countryCode: "BR"),
  krw(
      name: "South Korean Won",
      symbol: "₩",
      isoCode: "KRW",
      format: "#,##0",
      countryCode: "KR"),
  nok(
      name: "Norwegian Krone",
      symbol: "kr",
      isoCode: "NOK",
      format: "#,##0.00",
      countryCode: "NO"),
  try_(
      name: "Turkish Lira",
      symbol: "₺",
      isoCode: "TRY",
      format: "#,##0.00",
      countryCode: "TR"),
  idr(
      name: "Indonesian Rupiah",
      symbol: "Rp",
      isoCode: "IDR",
      format: "#,##0",
      countryCode: "ID"),
  myr(
      name: "Malaysian Ringgit",
      symbol: "RM",
      isoCode: "MYR",
      format: "#,##0.00",
      countryCode: "MY"),
  php(
      name: "Philippine Peso",
      symbol: "₱",
      isoCode: "PHP",
      format: "#,##0.00",
      countryCode: "PH"),
  dkk(
      name: "Danish Krone",
      symbol: "kr",
      isoCode: "DKK",
      format: "#,##0.00",
      countryCode: "DK"),
  pln(
      name: "Polish Zloty",
      symbol: "zł",
      isoCode: "PLN",
      format: "#,##0.00",
      countryCode: "PL"),
  ars(
      name: "Argentine Peso",
      symbol: "ARS",
      isoCode: "ARS",
      format: "#,##0.00",
      countryCode: "AR"),
  uah(
      name: "Ukrainian Hryvnia",
      symbol: "₴",
      isoCode: "UAH",
      format: "#,##0.00",
      countryCode: "UA"),
  vnd(
      name: "Vietnamese Dong",
      symbol: "₫",
      isoCode: "VND",
      format: "#,##0",
      countryCode: "VN"),
  ron(
      name: "Romanian Leu",
      symbol: "RON",
      isoCode: "RON",
      format: "#,##0.00",
      countryCode: "RO"),
  huf(
      name: "Hungarian Forint",
      symbol: "Ft",
      isoCode: "HUF",
      format: "#,##0",
      countryCode: "HU"),
  czk(
      name: "Czech Koruna",
      symbol: "Kč",
      isoCode: "CZK",
      format: "#,##0.00",
      countryCode: "CZ"),
  isk(
      name: "Icelandic Krona",
      symbol: "kr",
      isoCode: "ISK",
      format: "#,##0",
      countryCode: "IS"),
  bgn(
      name: "Bulgarian Lev",
      symbol: "lev",
      isoCode: "BGN",
      format: "#,##0.00",
      countryCode: "BG"),
  all(
      name: "Albanian Lek",
      symbol: "Lek",
      isoCode: "ALL",
      format: "#,##0.00",
      countryCode: "AL"),
  rsd(
      name: "Serbian Dinar",
      symbol: "din",
      isoCode: "RSD",
      format: "#,##0.00",
      countryCode: "RS"),
  afn(
      name: "Afghan Afghani",
      symbol: "Af.",
      isoCode: "AFN",
      format: "#,##0.00",
      countryCode: "AF"),
  kzt(
      name: "Kazakhstani Tenge",
      symbol: "₸",
      isoCode: "KZT",
      format: "#,##0.00",
      countryCode: "KZ"),
  gel(
      name: "Georgian Lari",
      symbol: "GEL",
      isoCode: "GEL",
      format: "#,##0.00",
      countryCode: "GE"),
  azn(
      name: "Azerbaijani Manat",
      symbol: "man.",
      isoCode: "AZN",
      format: "#,##0.00",
      countryCode: "AZ"),
  amd(
      name: "Armenian Dram",
      symbol: "Dram",
      isoCode: "AMD",
      format: "#,##0",
      countryCode: "AM"),
  byn(
      name: "Belarusian Ruble",
      symbol: "BYN",
      isoCode: "BYN",
      format: "#,##0.00",
      countryCode: "BY"),
  kes(
      name: "Kenyan Shilling",
      symbol: "KSh",
      isoCode: "KES",
      format: "#,##0.00",
      countryCode: "KE"),
  ngn(
      name: "Nigerian Naira",
      symbol: "₦",
      isoCode: "NGN",
      format: "#,##0.00",
      countryCode: "NG"),
  egp(
      name: "Egyptian Pound",
      symbol: "E£",
      isoCode: "EGP",
      format: "#,##0.00",
      countryCode: "EG"),
  twd(
      name: "New Taiwan Dollar",
      symbol: "NT\$",
      isoCode: "TWD",
      format: "#,##0.00",
      countryCode: "TW"),
  pkr(
      name: "Pakistani Rupee",
      symbol: "Rs",
      isoCode: "PKR",
      format: "#,##0.00",
      countryCode: "PK"),
  lkr(
      name: "Sri Lankan Rupee",
      symbol: "Rs",
      isoCode: "LKR",
      format: "#,##0.00",
      countryCode: "LK"),
  mmk(
      name: "Burmese Kyat",
      symbol: "K",
      isoCode: "MMK",
      format: "#,##0",
      countryCode: "MM"),
  khr(
      name: "Cambodian Riel",
      symbol: "Riel",
      isoCode: "KHR",
      format: "#,##0",
      countryCode: "KH"),
  irr(
      name: "Iranian Rial",
      symbol: "Rial",
      isoCode: "IRR",
      format: "#,##0",
      countryCode: "IR"),
  tnd(
      name: "Tunisian Dinar",
      symbol: "DT",
      isoCode: "TND",
      format: "#,##0.00",
      countryCode: "TN"),
  ugx(
      name: "Ugandan Shilling",
      symbol: "UGX",
      isoCode: "UGX",
      format: "#,##0",
      countryCode: "UG"),
  tzs(
      name: "Tanzanian Shilling",
      symbol: "TSh",
      isoCode: "TZS",
      format: "#,##0",
      countryCode: "TZ"),
  lak(
      name: "Lao Kip",
      symbol: "₭",
      isoCode: "LAK",
      format: "#,##0",
      countryCode: "LA"),
  mnt(
      name: "Mongolian Tugrik",
      symbol: "₮",
      isoCode: "MNT",
      format: "#,##0",
      countryCode: "MN"),
  xof(
      name: "West African CFA Franc",
      symbol: "CFA",
      isoCode: "XOF",
      format: "#,##0",
      countryCode: "SN"), // Using Senegal as representative
  xcd(
      name: "East Caribbean Dollar",
      symbol: "EC\$",
      isoCode: "XCD",
      format: "#,##0.00",
      countryCode: "AG"), // Antigua and Barbuda
  mad(
      name: "Moroccan Dirham",
      symbol: "DH",
      isoCode: "MAD",
      format: "#,##0.00",
      countryCode: "MA"),

  // GCC Currencies
  sar(
      name: "Saudi Riyal",
      symbol: "﷼",
      isoCode: "SAR",
      format: "#,##0.00",
      countryCode: "SA"),
  aed(
      name: "UAE Dirham",
      symbol: "د.إ",
      isoCode: "AED",
      format: "#,##0.00",
      countryCode: "AE"),
  kwd(
      name: "Kuwaiti Dinar",
      symbol: "د.ك",
      isoCode: "KWD",
      format: "#,##0.000",
      countryCode: "KW"),
  qar(
      name: "Qatari Riyal",
      symbol: "ر.ق",
      isoCode: "QAR",
      format: "#,##0.00",
      countryCode: "QA"),
  bhd(
      name: "Bahraini Dinar",
      symbol: ".د.ب",
      isoCode: "BHD",
      format: "#,##0.000",
      countryCode: "BH"),
  omr(
      name: "Omani Rial",
      symbol: "ر.ع.",
      isoCode: "OMR",
      format: "#,##0.000",
      countryCode: "OM");

  final String name;
  final String symbol;
  final String isoCode;
  final String format;
  final String countryCode;

  const Currency({
    required this.name,
    required this.symbol,
    required this.isoCode,
    required this.format,
    required this.countryCode,
  });

  String displayLabel() => "$name ($symbol)";

  static Currency? fromIsoCode(String code) =>
      Currency.values.firstWhereOrNull((currency) => currency.isoCode == code);
}
