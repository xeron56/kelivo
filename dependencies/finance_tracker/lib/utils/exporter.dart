import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:finance_tracker/app/global/date_formats.dart';
import 'package:finance_tracker/app/global/values.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/enums/currency.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/transaction.dart';
import 'package:finance_tracker/utils/app_logger.dart';
import 'package:path/path.dart' as path;
import 'package:finance_tracker/utils/db_utils.dart';

const excelRowDateFormat = "dd-MMM-yyyy HH:mm AM/PM";

mixin Exporter {
  static Future<Directory> _getDefaultExportFolder() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    return documentsDirectory;
  }

  static Future<String> genTransactionsPDF({
    required List<Transaction> transactions,
    required DateTime startDate,
    required DateTime endDate,
    required Currency currency,
    String? title,
    bool openFileByDefault = true,
  }) async {
    try {
      final pdf = pw.Document(
        author: appName,
        creator: appName,
        title: "$appName transactions",
        keywords: "pursenal,transactions",
        subject: "Transactions",
      );

      // Load custom font
      final fontData = await rootBundle.load(notoSansFontPath);
      final ttf = pw.Font.ttf(fontData);

      // Get the date range for subtitle
      String fromDate = defaultDate2.format(startDate);
      String toDate = defaultDate2.format(endDate);
      Uint8List appIconData =
          (await rootBundle.load('assets/icons/app_icon_rounded.png'))
              .buffer
              .asUint8List();

      pdf.addPage(
        pw.MultiPage(
          maxPages: 1200,
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              // Title
              pw.Text(
                title ?? 'Transactions',
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              // Subtitle (Date Range)
              pw.Text(
                'From $fromDate to $toDate',
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.normal,
                  color: PdfColors.grey700,
                ),
              ),

              pw.SizedBox(height: 20), // Space before table

              // Table with fixed widths
              pw.Table(
                border: const pw.TableBorder(horizontalInside: pw.BorderSide()),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(),
                  2: const pw.FlexColumnWidth(4),
                  3: const pw.FlexColumnWidth(3),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Date',
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('No.',
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Details',
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Amount',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),

                  // Table Rows (Paginated)
                  for (var t in transactions)
                    pw.TableRow(
                      children: [
                        // Date Column
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                              textAlign: pw.TextAlign.center,
                              defaultDate2.format(t.voucherDate),
                              style: pw.TextStyle(font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(t.dbID.toString(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(font: ttf)),
                        ),

                        // Details Column (Formatted Dr./Cr./Details)
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                  t.voucherType == VoucherType.payment
                                      ? t.drAccount.name
                                      : t.crAccount.name,
                                  overflow: pw.TextOverflow.clip,
                                  maxLines: 1,
                                  style: pw.TextStyle(
                                      font: ttf,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12,
                                      color: PdfColors.black)),
                              pw.Text(
                                  t.voucherType == VoucherType.receipt
                                      ? "Received in ${t.drAccount.name}"
                                      : "Paid from ${t.crAccount.name}",
                                  overflow: pw.TextOverflow.clip,
                                  maxLines: 1,
                                  style: pw.TextStyle(
                                      font: ttf,
                                      fontSize: 11,
                                      color: PdfColors.grey800)),
                              pw.Text(t.narration,
                                  style: pw.TextStyle(
                                      font: ttf,
                                      fontSize: 10,
                                      color: PdfColors.grey600)),
                            ],
                          ),
                        ),

                        // Amount Column
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            (t.amount *
                                    (t.voucherType == VoucherType.payment
                                        ? -1
                                        : 1))
                                .toCurrencyStringWSymbol(currency),
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                                font: ttf,
                                color: t.voucherType == VoucherType.payment
                                    ? PdfColors.red
                                    : PdfColors.black),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              pw.Expanded(
                  child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  // App Icon
                  pw.Container(
                    width: 20,
                    height: 20,
                    child: pw.Image(
                      pw.MemoryImage(
                        appIconData,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 8), // Space between icon and text
                  pw.UrlLink(
                    destination: appURL,
                    child: pw.Text(
                      appName,
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 10,
                        color: PdfColors.black,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )),
            ];
          },
        ),
      );

      // Save the PDF file
      final output = await _getDefaultExportFolder();
      final file = await File(
              path.join(output.path, appName, "${title ?? "Transactions"}.pdf"))
          .create(recursive: true);
      await file.writeAsBytes(await pdf.save());
      if (openFileByDefault) openFile(file.path);
      AppLogger.instance.info(
          "Exported ${transactions.length} transactions PDF to : ${path.join(output.path, appName)}");
      return "Saved in ${path.join(output.path, appName)}";
    } catch (e) {
      AppLogger.instance.error(' ${e.toString()}');
      rethrow;
    }
  }

  static Future<String> genLTransactionsPDF({
    required List<Transaction> transactions,
    required DateTime startDate,
    required DateTime endDate,
    required int openingBalance,
    required int closingBalance,
    required Currency currency,
    required DateTime openDate,
    required Account account,
    bool openFileByDefault = true,
  }) async {
    try {
      final pdf = pw.Document(
        author: appName,
        creator: appName,
        title: "${account.name} transactions",
        keywords: "pursenal,transactions,${account.name}",
        subject: "Transactions",
      );

      // Load custom font
      final fontData = await rootBundle.load(notoSansFontPath);
      final ttf = pw.Font.ttf(fontData);
      Uint8List appIconData =
          (await rootBundle.load('assets/icons/app_icon_rounded.png'))
              .buffer
              .asUint8List();
      // Get the date range for subtitle
      String fromDate = defaultDate2.format(startDate);
      String toDate = defaultDate2.format(endDate);
      pdf.addPage(
        pw.MultiPage(
          maxPages: 1200,
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              // Title
              pw.Text(
                account.name,
                style: pw.TextStyle(
                    font: ttf,
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900),
              ),

              pw.Text(
                'Transactions',
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              // Subtitle (Date Range)
              pw.Text(
                'From $fromDate to $toDate',
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.normal,
                  color: PdfColors.grey700,
                ),
              ),

              pw.SizedBox(height: 20), // Space before table

              // Table with fixed widths
              pw.Table(
                border: const pw.TableBorder(horizontalInside: pw.BorderSide()),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(),
                  2: const pw.FlexColumnWidth(4),
                  3: const pw.FlexColumnWidth(3),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Date',
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('No.',
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Details',
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Amount',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),

                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          defaultDate2.format(openDate),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('',
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Opening Balance',
                            style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                            openingBalance.toCurrencyStringWSymbol(currency),
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),

                  // Table Rows (Paginated)
                  for (var t in transactions)
                    pw.TableRow(
                      children: [
                        // Date Column
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                              textAlign: pw.TextAlign.center,
                              defaultDate2.format(t.voucherDate),
                              style: pw.TextStyle(font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(t.dbID.toString(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(font: ttf)),
                        ),

                        // Details Column (Formatted Dr./Cr./Details)
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                  t.crAccount.dbID == account.dbID
                                      ? t.drAccount.name
                                      : t.crAccount.name,
                                  overflow: pw.TextOverflow.clip,
                                  maxLines: 1,
                                  style: pw.TextStyle(
                                      font: ttf,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12,
                                      color: PdfColors.black)),
                              pw.Text(t.narration,
                                  style: pw.TextStyle(
                                      font: ttf,
                                      fontSize: 10,
                                      color: PdfColors.grey600)),
                            ],
                          ),
                        ),

                        // Amount Column
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            (t.amount *
                                    ((DBUtils.isLiabilityOrIncome(
                                                    account.accountType) &&
                                                t.drAccount.dbID ==
                                                    account.dbID) ||
                                            (DBUtils.isAssetOrExpense(
                                                    account.accountType) &&
                                                t.crAccount.dbID ==
                                                    account.dbID)
                                        ? -1
                                        : 1))
                                .toCurrencyStringWSymbol(currency),
                            textAlign: pw.TextAlign.right,
                            style:
                                pw.TextStyle(font: ttf, color: PdfColors.black),
                          ),
                        ),
                      ],
                    ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          defaultDate2.format(endDate),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('',
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Closing Balance',
                            style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                            closingBalance.toCurrencyStringWSymbol(currency),
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Expanded(
                  child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  // App Icon
                  pw.Container(
                    width: 20,
                    height: 20,
                    child: pw.Image(
                      pw.MemoryImage(
                        appIconData,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 8), // Space between icon and text
                  pw.UrlLink(
                    destination: appURL,
                    child: pw.Text(
                      appName,
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 10,
                        color: PdfColors.black,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )),
            ];
          },
        ),
      );

      // Save the PDF file
      final output = await _getDefaultExportFolder();
      final file = await File(path.join(
              output.path, appName, "${account.name} Transactions.pdf"))
          .create(recursive: true);
      await file.writeAsBytes(await pdf.save());
      if (openFileByDefault) openFile(file.path);
      AppLogger.instance.info(
          "Exported ${transactions.length} transactions PDF to : ${path.join(output.path, appName)}");
      return "Saved in ${path.join(output.path, appName)}";
    } catch (e) {
      AppLogger.instance.error(' ${e.toString()}');
      rethrow;
    }
  }

  static openFile(filePath) async {
    await OpenFilex.open(filePath);
  }

  static Future<String> genTransactionsXLSX({
    required List<Transaction> transactions,
    required DateTime startDate,
    required DateTime endDate,
    required Currency currency,
    String? title,
    bool openFileByDefault = true,
  }) async {
    String fromDate = defaultDate2.format(startDate);
    String toDate = defaultDate2.format(endDate);
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['Transactions'];
      excel.delete('Sheet1');

      // Set A1 = "Transactions" and A2 = "Table"
      sheet.cell(CellIndex.indexByString("A1"))
        ..value = TextCellValue(title ?? "Transactions")
        ..cellStyle = CellStyle(
          bold: true,
          fontSize: 18,
        );
      sheet.cell(CellIndex.indexByString("A2")).value = TextCellValue(
        'From $fromDate to $toDate',
      );

      List<String> headers = [
        'Date',
        'No.',
        'Type',
        'Fund',
        'Account',
        'Ref no.',
        'Description',
        'Amount'
      ];
      sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());

      // Style headers
      CellStyle headerStyle = CellStyle(
        bold: true,
        fontSize: 12,
        bottomBorder: Border(borderStyle: BorderStyle.Thin),
        topBorder: Border(borderStyle: BorderStyle.Thin),
        leftBorder: Border(borderStyle: BorderStyle.Thin),
        rightBorder: Border(borderStyle: BorderStyle.Thin),
      );

      for (int i = 0; i < headers.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 2))
            .cellStyle = headerStyle;
      }

      for (int i = 0; i < transactions.length; i++) {
        final t = transactions[i];

        final isTransfer =
            (fundingAccountIDs.contains(t.crAccount.accountType) &&
                fundingAccountIDs.contains(t.drAccount.accountType));
        final isPayment = t.voucherType == VoucherType.payment;

        final vchDate = t.voucherDate;
        List<CellValue> row = [
          DateTimeCellValue(
              day: vchDate.day,
              month: vchDate.month,
              year: vchDate.year,
              hour: vchDate.hour,
              minute: vchDate.minute),
          TextCellValue(t.dbID.toString()),
          TextCellValue(isTransfer
              ? "Transfer"
              : isPayment
                  ? VoucherType.payment.label
                  : VoucherType.receipt.label),
          TextCellValue(!isPayment ? t.drAccount.name : t.crAccount.name),
          TextCellValue(isPayment ? t.drAccount.name : t.crAccount.name),
          TextCellValue(t.refNo),
          TextCellValue(t.narration),
          DoubleCellValue(
              (t.amount * ((!isTransfer && isPayment) ? -1 : 1)).toCurrency()),
        ];

        sheet.appendRow(row);

        // Apply border and red color for "Amount" column
        for (int j = 0; j < row.length; j++) {
          CellStyle cellStyle = CellStyle(
            bottomBorder: Border(borderStyle: BorderStyle.Thin),
            topBorder: Border(borderStyle: BorderStyle.Thin),
            leftBorder: Border(borderStyle: BorderStyle.Thin),
            rightBorder: Border(borderStyle: BorderStyle.Thin),
          );

          // Apply red color for "Amount" column
          if (j == 7) {
            if (!isTransfer && isPayment) {
              cellStyle.fontColor = ExcelColor.fromHexString("#FF0000");
            }

            cellStyle.numberFormat = NumFormat.custom(
                formatCode:
                    "${currency.symbol}* ${currency.format};${currency.symbol}* -${currency.format}");
          }
          if (j == 0) {
            cellStyle.numberFormat =
                NumFormat.custom(formatCode: excelRowDateFormat);
          }
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 3))
              .cellStyle = cellStyle;
        }
      }
      sheet.appendRow([
        TextCellValue('Created with Pursenal'),
      ]);

      // Save the PDF file
      Directory directory = await _getDefaultExportFolder();
      String filePath =
          path.join(directory.path, appName, '${title ?? "Transactions"}.xlsx');

      // Save file
      List<int>? encodedExcel = excel.encode();
      if (encodedExcel != null) {
        final file = File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(encodedExcel);

        if (openFileByDefault) openFile(file.path);

        AppLogger.instance.debug('Excel file saved at $filePath');
      } else {
        AppLogger.instance.debug('Failed to generate Excel file.');
      }

      return "Saved in $filePath";
    } catch (e) {
      AppLogger.instance.error(' ${e.toString()}');
      rethrow;
    }
  }

  static Future<String> genLTransactionsXLSX({
    required List<Transaction> transactions,
    required DateTime startDate,
    required DateTime endDate,
    required int openingBalance,
    required int closingBalance,
    required Currency currency,
    required DateTime openDate,
    required Account account,
    bool openFileByDefault = true,
  }) async {
    String fromDate = defaultDate2.format(startDate);
    String toDate = defaultDate2.format(endDate);
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['Transactions'];
      excel.delete('Sheet1');

      // Set A1 = "Transactions" and A2 = "Table"
      sheet.cell(CellIndex.indexByString("A1"))
        ..value = TextCellValue("${account.name} Transactions")
        ..cellStyle = CellStyle(
          bold: true,
          fontSize: 18,
        );
      sheet.cell(CellIndex.indexByString("A2")).value = TextCellValue(
        'From $fromDate to $toDate',
      );

      List<String> headers = [
        'Date',
        'No.',
        'Type',
        'Account',
        'Ref no.',
        'Description',
        'Amount'
      ];
      sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());

      // Style headers
      CellStyle headerStyle = CellStyle(
        bold: true,
        fontSize: 12,
        bottomBorder: Border(borderStyle: BorderStyle.Thin),
        topBorder: Border(borderStyle: BorderStyle.Thin),
        leftBorder: Border(borderStyle: BorderStyle.Thin),
        rightBorder: Border(borderStyle: BorderStyle.Thin),
      );

      for (int i = 0; i < headers.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 2))
            .cellStyle = headerStyle;
      }

      final openingRow = [
        DateTimeCellValue(
            day: startDate.day,
            month: startDate.month,
            year: startDate.year,
            hour: startDate.hour,
            minute: startDate.minute),
        TextCellValue(""),
        TextCellValue(
          "Opening Balance",
        ),
        TextCellValue(""),
        TextCellValue(""),
        TextCellValue(""),
        DoubleCellValue((openingBalance.toCurrency())),
      ];

      sheet.appendRow(openingRow);

      final cs = CellStyle(
        bottomBorder: Border(borderStyle: BorderStyle.Thin),
        topBorder: Border(borderStyle: BorderStyle.Thin),
        leftBorder: Border(borderStyle: BorderStyle.Thin),
        rightBorder: Border(borderStyle: BorderStyle.Thin),
      );

      for (int col = 0; col < openingRow.length; col++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 3)).cellStyle =
            cs.copyWith(
                numberFormat: col == 6
                    ? NumFormat.custom(
                        formatCode:
                            "${currency.symbol}* ${currency.format};${currency.symbol}* -${currency.format}")
                    : col == 0
                        ? NumFormat.custom(formatCode: excelRowDateFormat)
                        : null);
      }

      for (int i = 0; i < transactions.length; i++) {
        final t = transactions[i];

        final isTransfer =
            (fundingAccountIDs.contains(t.crAccount.accountType) &&
                fundingAccountIDs.contains(t.drAccount.accountType));
        final isPayment = t.voucherType == VoucherType.payment;

        final isNegative = (DBUtils.isLiabilityOrIncome(account.accountType) &&
                t.drAccount.dbID == account.dbID) ||
            (DBUtils.isAssetOrExpense(account.accountType) &&
                t.crAccount.dbID == account.dbID);

        final vchDate = t.voucherDate;
        List<CellValue> row = [
          DateTimeCellValue(
              day: vchDate.day,
              month: vchDate.month,
              year: vchDate.year,
              hour: vchDate.hour,
              minute: vchDate.minute),
          TextCellValue(t.dbID.toString()),
          TextCellValue(isTransfer
              ? "Transfer"
              : isPayment
                  ? VoucherType.payment.label
                  : VoucherType.receipt.label),
          TextCellValue(
            t.crAccount.dbID == account.dbID
                ? t.drAccount.name
                : t.crAccount.name,
          ),
          TextCellValue(t.refNo),
          TextCellValue(t.narration),
          DoubleCellValue((t.amount * (isNegative ? -1 : 1)).toCurrency()),
        ];

        sheet.appendRow(row);

        // Apply border and red color for "Amount" column
        for (int j = 0; j < row.length; j++) {
          CellStyle cellStyle = CellStyle(
            bottomBorder: Border(borderStyle: BorderStyle.Thin),
            topBorder: Border(borderStyle: BorderStyle.Thin),
            leftBorder: Border(borderStyle: BorderStyle.Thin),
            rightBorder: Border(borderStyle: BorderStyle.Thin),
          );

          // Apply red color for "Amount" column
          if (j == 6) {
            cellStyle.numberFormat = NumFormat.custom(
                formatCode:
                    "${currency.symbol}* ${currency.format};${currency.symbol}* -${currency.format}");
          }

          if (j == 0) {
            cellStyle.numberFormat =
                NumFormat.custom(formatCode: excelRowDateFormat);
          }

          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 4))
              .cellStyle = cellStyle;
        }
      }

      final closingRow = [
        DateTimeCellValue(
            day: endDate.day,
            month: endDate.month,
            year: endDate.year,
            hour: endDate.hour,
            minute: endDate.minute),
        TextCellValue(""),
        TextCellValue(
          "Closing Balance",
        ),
        TextCellValue(""),
        TextCellValue(""),
        TextCellValue(""),
        DoubleCellValue((closingBalance.toCurrency())),
      ];

      sheet.appendRow(closingRow);
      int lastRow = sheet.maxRows - 1; // Get last row index

      for (int col = 0; col < openingRow.length; col++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: lastRow)).cellStyle =
            cs.copyWith(
                numberFormat: col == 6
                    ? NumFormat.custom(
                        formatCode:
                            "${currency.symbol}* ${currency.format};${currency.symbol}* -${currency.format}")
                    : col == 0
                        ? NumFormat.custom(formatCode: excelRowDateFormat)
                        : null);
      }

      sheet.appendRow([
        TextCellValue('Created with Pursenal'),
      ]);

      // Save the PDF file
      Directory directory = await _getDefaultExportFolder();
      String filePath = path.join(
          directory.path, appName, '${account.name} Transactions.xlsx');

      // Save file
      List<int>? encodedExcel = excel.encode();
      if (encodedExcel != null) {
        final file = File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(encodedExcel);
        if (openFileByDefault) openFile(file.path);

        AppLogger.instance.debug('Excel file saved at $filePath');
      } else {
        AppLogger.instance.debug('Failed to generate Excel file.');
      }

      return "Saved in $filePath";
    } catch (e) {
      AppLogger.instance.error(' ${e.toString()}');
      rethrow;
    }
  }
}

