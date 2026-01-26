import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../dashboard/data/models/crm_stats_model.dart';
import '../models/analytics_contract.dart';
import '../models/analytics_period.dart';

/// Result of PDF generation
class PdfGenerationResult {
  final String filePath;
  final bool savedToDownloads;

  const PdfGenerationResult({
    required this.filePath,
    required this.savedToDownloads,
  });
}

/// Translations for PDF content
class PdfTranslations {
  final String reportTitle;
  final String period;
  final String keyMetrics;
  final String totalRevenue;
  final String closedDeals;
  final String activeLeads;
  final String totalClients;
  final String activeContracts;
  final String conversion;
  final String contractStatus;
  final String status;
  final String count;
  final String leadStages;
  final String stage;
  final String recentContracts;
  final String number;
  final String client;
  final String amount;
  final String pageFormat;
  final String moreContracts;
  final Map<String, String> statusTranslations;
  final Map<String, String> stageTranslations;

  const PdfTranslations({
    required this.reportTitle,
    required this.period,
    required this.keyMetrics,
    required this.totalRevenue,
    required this.closedDeals,
    required this.activeLeads,
    required this.totalClients,
    required this.activeContracts,
    required this.conversion,
    required this.contractStatus,
    required this.status,
    required this.count,
    required this.leadStages,
    required this.stage,
    required this.recentContracts,
    required this.number,
    required this.client,
    required this.amount,
    required this.pageFormat,
    required this.moreContracts,
    required this.statusTranslations,
    required this.stageTranslations,
  });
}

/// Service for generating PDF reports from analytics data.
class AnalyticsPdfGenerator {
  static final _currencyFormat = NumberFormat('#,###', 'uz_UZ');

  /// Generates a PDF report and saves to Downloads folder.
  /// On Android: Saves directly to Downloads folder.
  /// On iOS: Opens share sheet for user to save.
  Future<PdfGenerationResult> generateReport({
    required CrmStatsModel stats,
    required List<AnalyticsContract> contracts,
    required AnalyticsPeriod period,
    required PdfTranslations translations,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(period, translations),
          pw.SizedBox(height: 24),
          _buildKpiSection(stats, translations),
          pw.SizedBox(height: 24),
          _buildContractsByStatusSection(stats, translations),
          pw.SizedBox(height: 24),
          _buildLeadsByStageSection(stats, translations),
          if (contracts.isNotEmpty) ...[
            pw.SizedBox(height: 24),
            _buildContractsTable(contracts, translations),
          ],
        ],
        footer: (context) => _buildFooter(context, translations),
      ),
    );

    final pdfBytes = await pdf.save();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'analytics_report_$timestamp.pdf';

    if (Platform.isAndroid) {
      // Try to save to Downloads folder on Android
      final savedPath = await _saveToDownloads(pdfBytes, fileName);
      if (savedPath != null) {
        return PdfGenerationResult(
          filePath: savedPath,
          savedToDownloads: true,
        );
      }
    }

    // Fallback: Save to temp and open share sheet (iOS or Android fallback)
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(pdfBytes);

    // Open share sheet
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: translations.reportTitle,
    );

    return PdfGenerationResult(
      filePath: file.path,
      savedToDownloads: false,
    );
  }

  /// Attempts to save PDF to Android Downloads folder.
  /// Returns the file path if successful, null otherwise.
  Future<String?> _saveToDownloads(List<int> bytes, String fileName) async {
    try {
      // Try common Downloads folder paths on Android
      final downloadPaths = [
        '/storage/emulated/0/Download',
        '/sdcard/Download',
      ];

      for (final path in downloadPaths) {
        final dir = Directory(path);
        if (await dir.exists()) {
          final file = File('$path/$fileName');
          await file.writeAsBytes(bytes);
          return file.path;
        }
      }

      // Fallback: Try external storage directory
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        // Navigate up to find Download folder
        // External storage is usually /storage/emulated/0/Android/data/package/files
        final parts = externalDir.path.split('/');
        final storageIndex = parts.indexOf('Android');
        if (storageIndex > 0) {
          final basePath = parts.sublist(0, storageIndex).join('/');
          final downloadDir = Directory('$basePath/Download');
          if (await downloadDir.exists()) {
            final file = File('${downloadDir.path}/$fileName');
            await file.writeAsBytes(bytes);
            return file.path;
          }
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  pw.Widget _buildHeader(AnalyticsPeriod period, PdfTranslations translations) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              translations.reportTitle,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now()),
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            translations.period.replaceAll('{period}', period.label),
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ),
        pw.SizedBox(height: 16),
        pw.Divider(thickness: 1, color: PdfColors.grey300),
      ],
    );
  }

  pw.Widget _buildKpiSection(CrmStatsModel stats, PdfTranslations translations) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          translations.keyMetrics,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          children: [
            _buildKpiCard(translations.totalRevenue, _formatCurrency(stats.totalRevenue)),
            pw.SizedBox(width: 12),
            _buildKpiCard(translations.closedDeals, stats.completedContracts.toString()),
            pw.SizedBox(width: 12),
            _buildKpiCard(translations.activeLeads, stats.activeLeads.toString()),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          children: [
            _buildKpiCard(translations.totalClients, stats.totalClients.toString()),
            pw.SizedBox(width: 12),
            _buildKpiCard(translations.activeContracts, stats.activeContracts.toString()),
            pw.SizedBox(width: 12),
            _buildKpiCard(translations.conversion, '${stats.conversionRate.toStringAsFixed(1)}%'),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildKpiCard(String label, String value) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildContractsByStatusSection(CrmStatsModel stats, PdfTranslations translations) {
    final statuses = stats.contractsByStatus;
    if (statuses.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          translations.contractStatus,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _tableCell(translations.status, isHeader: true),
                _tableCell(translations.count, isHeader: true),
              ],
            ),
            ...statuses.entries.map(
              (e) => pw.TableRow(
                children: [
                  _tableCell(_translateStatus(e.key, translations)),
                  _tableCell(e.value.toString()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildLeadsByStageSection(CrmStatsModel stats, PdfTranslations translations) {
    final stages = stats.leadsByStage;
    if (stages.isEmpty) return pw.SizedBox();

    final nonZeroStages = stages.entries.where((e) => e.value > 0).toList();
    if (nonZeroStages.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          translations.leadStages,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _tableCell(translations.stage, isHeader: true),
                _tableCell(translations.count, isHeader: true),
              ],
            ),
            ...nonZeroStages.map(
              (e) => pw.TableRow(
                children: [
                  _tableCell(_translateStage(e.key, translations)),
                  _tableCell(e.value.toString()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildContractsTable(List<AnalyticsContract> contracts, PdfTranslations translations) {
    final recentContracts = contracts.take(10).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          translations.recentContracts,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.5),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _tableCell(translations.number, isHeader: true),
                _tableCell(translations.client, isHeader: true),
                _tableCell(translations.amount, isHeader: true),
                _tableCell(translations.status, isHeader: true),
              ],
            ),
            ...recentContracts.map(
              (contract) => pw.TableRow(
                children: [
                  _tableCell(contract.contractNumber ?? '-'),
                  _tableCell(contract.clientName),
                  _tableCell(_formatCurrency(contract.totalAmount)),
                  _tableCell(_translateStatus(contract.status, translations)),
                ],
              ),
            ),
          ],
        ),
        if (contracts.length > 10)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 8),
            child: pw.Text(
              translations.moreContracts.replaceAll('{count}', (contracts.length - 10).toString()),
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey600,
              ),
            ),
          ),
      ],
    );
  }

  pw.Widget _tableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context, PdfTranslations translations) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 16),
      child: pw.Text(
        translations.pageFormat
            .replaceAll('{current}', context.pageNumber.toString())
            .replaceAll('{total}', context.pagesCount.toString()),
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1e9) {
      return '${(amount / 1e9).toStringAsFixed(1)} mlrd UZS';
    } else if (amount >= 1e6) {
      return '${(amount / 1e6).toStringAsFixed(1)} mln UZS';
    }
    return '${_currencyFormat.format(amount)} UZS';
  }

  String _translateStatus(String status, PdfTranslations translations) {
    return translations.statusTranslations[status.toLowerCase()] ?? status;
  }

  String _translateStage(String stage, PdfTranslations translations) {
    return translations.stageTranslations[stage.toLowerCase()] ?? stage;
  }
}
