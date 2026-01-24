import 'dart:io';

import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../dashboard/data/models/crm_stats_model.dart';
import '../models/analytics_contract.dart';
import '../models/analytics_period.dart';

/// Service for generating PDF reports from analytics data.
class AnalyticsPdfGenerator {
  static final _currencyFormat = NumberFormat('#,###', 'uz_UZ');

  /// Generates a PDF report and returns the file path.
  Future<String> generateReport({
    required CrmStatsModel stats,
    required List<AnalyticsContract> contracts,
    required AnalyticsPeriod period,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(period),
          pw.SizedBox(height: 24),
          _buildKpiSection(stats),
          pw.SizedBox(height: 24),
          _buildContractsByStatusSection(stats),
          pw.SizedBox(height: 24),
          _buildLeadsByStageSection(stats),
          if (contracts.isNotEmpty) ...[
            pw.SizedBox(height: 24),
            _buildContractsTable(contracts),
          ],
        ],
        footer: (context) => _buildFooter(context),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${output.path}/analytics_report_$timestamp.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    await OpenFilex.open(file.path);

    return file.path;
  }

  pw.Widget _buildHeader(AnalyticsPeriod period) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Tahlil hisoboti',
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
            'Davr: ${period.label}',
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

  pw.Widget _buildKpiSection(CrmStatsModel stats) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Asosiy ko\'rsatkichlar',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          children: [
            _buildKpiCard('Umumiy daromad', _formatCurrency(stats.totalRevenue)),
            pw.SizedBox(width: 12),
            _buildKpiCard('Yopilgan bitimlar', stats.completedContracts.toString()),
            pw.SizedBox(width: 12),
            _buildKpiCard('Faol lidlar', stats.activeLeads.toString()),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          children: [
            _buildKpiCard('Jami mijozlar', stats.totalClients.toString()),
            pw.SizedBox(width: 12),
            _buildKpiCard('Faol shartnomalar', stats.activeContracts.toString()),
            pw.SizedBox(width: 12),
            _buildKpiCard('Konversiya', '${stats.conversionRate.toStringAsFixed(1)}%'),
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

  pw.Widget _buildContractsByStatusSection(CrmStatsModel stats) {
    final statuses = stats.contractsByStatus;
    if (statuses.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Shartnomalar holati',
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
                _tableCell('Holat', isHeader: true),
                _tableCell('Soni', isHeader: true),
              ],
            ),
            ...statuses.entries.map(
              (e) => pw.TableRow(
                children: [
                  _tableCell(_translateStatus(e.key)),
                  _tableCell(e.value.toString()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildLeadsByStageSection(CrmStatsModel stats) {
    final stages = stats.leadsByStage;
    if (stages.isEmpty) return pw.SizedBox();

    final nonZeroStages = stages.entries.where((e) => e.value > 0).toList();
    if (nonZeroStages.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Lidlar bosqichlari',
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
                _tableCell('Bosqich', isHeader: true),
                _tableCell('Soni', isHeader: true),
              ],
            ),
            ...nonZeroStages.map(
              (e) => pw.TableRow(
                children: [
                  _tableCell(_translateStage(e.key)),
                  _tableCell(e.value.toString()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildContractsTable(List<AnalyticsContract> contracts) {
    final recentContracts = contracts.take(10).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'So\'nggi shartnomalar',
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
                _tableCell('Raqam', isHeader: true),
                _tableCell('Mijoz', isHeader: true),
                _tableCell('Summa', isHeader: true),
                _tableCell('Holat', isHeader: true),
              ],
            ),
            ...recentContracts.map(
              (contract) => pw.TableRow(
                children: [
                  _tableCell(contract.contractNumber ?? '-'),
                  _tableCell(contract.clientName),
                  _tableCell(_formatCurrency(contract.totalAmount)),
                  _tableCell(_translateStatus(contract.status)),
                ],
              ),
            ),
          ],
        ),
        if (contracts.length > 10)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 8),
            child: pw.Text(
              '... va yana ${contracts.length - 10} ta shartnoma',
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

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 16),
      child: pw.Text(
        'Sahifa ${context.pageNumber} / ${context.pagesCount}',
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

  String _translateStatus(String status) {
    const translations = {
      'draft': 'Qoralama',
      'active': 'Faol',
      'completed': 'Yakunlangan',
      'terminated': 'Bekor qilingan',
      'cancelled': 'Bekor qilingan',
      'rejected': 'Rad etilgan',
      'pending': 'Kutilmoqda',
    };
    return translations[status.toLowerCase()] ?? status;
  }

  String _translateStage(String stage) {
    const translations = {
      'new': 'Yangi',
      'contacted': 'Bog\'lanildi',
      'qualified': 'Tasdiqlandi',
      'showing': 'Ko\'rsatuv',
      'negotiation': 'Muzokara',
      'reservation': 'Band qilish',
      'contract': 'Shartnoma',
      'won': 'Yutildi',
      'lost': 'Yo\'qotildi',
    };
    return translations[stage.toLowerCase()] ?? stage;
  }
}
