import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Deimos/theme/app_theme.dart';
import 'package:Deimos/widgets/instrument_widgets.dart';

class ProofDataPage extends StatelessWidget {
  final String proofData;
  final String algorithm;
  final String framework;

  const ProofDataPage({
    super.key,
    required this.proofData,
    required this.algorithm,
    required this.framework,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: proofData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: SIMono('Copied to clipboard', color: AppTheme.background),
        backgroundColor: AppTheme.success,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGroth16 = proofData.contains('groth16') || proofData.contains('Groth16');
    final isBn128 = proofData.contains('bn128');

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            SIBar(
              title: '// PROOF CALLDATA',
              onBack: () => Navigator.pop(context),
              right: GestureDetector(
                onTap: () => _copyToClipboard(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(border: Border.all(color: AppTheme.border)),
                  child: const Row(
                    children: [
                      Icon(Icons.copy_outlined, size: 11, color: AppTheme.text),
                      SizedBox(width: 4),
                      SIMono('COPY', fontSize: 10, letterSpacing: 1.5),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      Expanded(child: _MetaChip(label: 'PROTOCOL', value: isGroth16 ? 'groth16' : framework)),
                      const SizedBox(width: 8),
                      Expanded(child: _MetaChip(label: 'CURVE', value: isBn128 ? 'bn128' : 'N/A')),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: SelectableText(
                      proofData,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        height: 1.55,
                        color: AppTheme.text,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'EXPORT JSON',
                          onTap: () => _copyToClipboard(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionButton(
                          label: 'SHARE',
                          onTap: () => _copyToClipboard(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final String value;

  const _MetaChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SIMono(label, fontSize: 9, letterSpacing: 1.5, color: AppTheme.textDim),
          const SizedBox(height: 2),
          SIMono(value, fontSize: 15),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.border),
        ),
        alignment: Alignment.center,
        child: SIMono(label, fontSize: 11, letterSpacing: 1.5),
      ),
    );
  }
}
