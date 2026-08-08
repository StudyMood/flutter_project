import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/intern_model.dart';

class PdfService {
  static Future<void> printOrDownloadIdCard(InternModel intern) async {
    final pdf = pw.Document();

    // Fonts & Colors
    final primaryOrange = PdfColor.fromHex('#FF6B00');
    final secondaryGreen = PdfColor.fromHex('#00A651');
    final darkNavy = PdfColor.fromHex('#0A192F');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'DigiCoders Intern Digital ID Card',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: darkNavy,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'DigiCoders Technologies Private Limited',
                  style: pw.TextStyle(fontSize: 14, color: secondaryGreen),
                ),
                pw.SizedBox(height: 20),

                // Front Card Container
                pw.Container(
                  width: 320,
                  height: 480,
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(16),
                    border: pw.Border.all(color: primaryOrange, width: 2),
                    color: PdfColors.white,
                  ),
                  child: pw.Column(
                    children: [
                      // Header
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.symmetric(vertical: 12),
                        decoration: pw.BoxDecoration(
                          color: primaryOrange,
                          borderRadius: const pw.BorderRadius.only(
                            topLeft: pw.Radius.circular(14),
                            topRight: pw.Radius.circular(14),
                          ),
                        ),
                        child: pw.Column(
                          children: [
                            pw.Text(
                              'DIGICODERS',
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            pw.Text(
                              'TRAINING INSTITUTE',
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 10,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 15),

                      // Avatar circle / placeholder
                      pw.Container(
                        width: 90,
                        height: 90,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          border: pw.Border.all(color: secondaryGreen, width: 3),
                          color: PdfColors.grey200,
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            intern.fullName.isNotEmpty ? intern.fullName[0].toUpperCase() : 'I',
                            style: pw.TextStyle(
                              fontSize: 36,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryOrange,
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 10),

                      // Name & ID
                      pw.Text(
                        intern.fullName,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: darkNavy,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.orange50,
                          borderRadius: pw.BorderRadius.circular(6),
                        ),
                        child: pw.Text(
                          'ID: ${intern.internId}',
                          style: pw.TextStyle(
                            color: primaryOrange,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 8),

                      // Technology Tag
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: pw.BoxDecoration(
                          color: secondaryGreen,
                          borderRadius: pw.BorderRadius.circular(12),
                        ),
                        child: pw.Text(
                          intern.technology,
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 12),

                      // Details Table
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text('Joining Date:', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                                pw.Text(intern.joiningDate, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                            pw.SizedBox(height: 4),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text('Status:', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                                pw.Text(intern.status, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: secondaryGreen)),
                              ],
                            ),
                            pw.SizedBox(height: 4),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text('Phone:', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                                pw.Text(intern.phone, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.Spacer(),

                      // QR Code representation & Barcode ID
                      pw.BarcodeWidget(
                        barcode: pw.Barcode.code128(),
                        data: intern.internId,
                        width: 180,
                        height: 35,
                        drawText: true,
                        textStyle: const pw.TextStyle(fontSize: 8),
                      ),
                      pw.SizedBox(height: 10),

                      // Footer stripe
                      pw.Container(
                        height: 12,
                        width: double.infinity,
                        decoration: pw.BoxDecoration(
                          color: secondaryGreen,
                          borderRadius: const pw.BorderRadius.only(
                            bottomLeft: pw.Radius.circular(14),
                            bottomRight: pw.Radius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Official Digital Document • DigiCoders Verification Engine',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'ID_Card_${intern.internId}.pdf',
    );
  }
}
