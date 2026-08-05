// example/lib/main.dart
//
// Aplikasi demo untuk memverifikasi seluruh komponen design system
// di package hyperlocal_shared. Jalankan dengan:
//   cd example && flutter run
//
// File ini dipakai untuk screenshot PR — pastikan semua state
// (Normal, Loading, Error, Empty) dan semua varian komponen terlihat.

import 'package:flutter/material.dart';
import 'package:hyperlocal_shared/hyperlocal_shared.dart';

void main() {
  runApp(const DesignSystemPreviewApp());
}

class DesignSystemPreviewApp extends StatelessWidget {
  const DesignSystemPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design System Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const DesignSystemPreviewScreen(),
    );
  }
}

class DesignSystemPreviewScreen extends StatefulWidget {
  const DesignSystemPreviewScreen({super.key});

  @override
  State<DesignSystemPreviewScreen> createState() =>
      _DesignSystemPreviewScreenState();
}

class _DesignSystemPreviewScreenState extends State<DesignSystemPreviewScreen> {
  // State untuk demo StateView — bisa di-toggle via tombol di UI
  ViewState _stateViewState = ViewState.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Preview'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ═══════════════════════════════════════════════════════════
          // SECTION 1: StateView Demo (Interactive Toggle)
          // ═══════════════════════════════════════════════════════════
          _buildSectionHeader('1. StateView (3 State Wajib)'),
          _buildSectionDescription(
            'Tap tombol di bawah untuk berpindah state. '
            'Ini dipakai untuk screenshot PR.',
          ),
          const SizedBox(height: 12),

          // Toggle buttons untuk berpindah state
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStateToggleButton('Normal', ViewState.normal),
              _buildStateToggleButton('Loading', ViewState.loading),
              _buildStateToggleButton('Error', ViewState.error),
              _buildStateToggleButton('Empty', ViewState.empty),
            ],
          ),
          const SizedBox(height: 16),

          // Preview StateView dengan border agar terlihat jelas
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: StateView(
                state: _stateViewState,
                errorMessage: 'Ada gangguan sebentar. Coba lagi ya',
                emptyMessage: 'Belum ada pesanan. Yuk coba pesan sekarang!',
                actionLabel: 'Coba Lagi',
                onAction: () {
                  setState(() => _stateViewState = ViewState.normal);
                },
                child: const Center(
                  child: Text(
                    'Konten normal tampil di sini',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),

          const Divider(height: 48),

          // ═══════════════════════════════════════════════════════════
          // SECTION 2: PrimaryButton Variants
          // ═══════════════════════════════════════════════════════════
          _buildSectionHeader('2. PrimaryButton'),
          _buildSectionDescription(
            'Tombol disabled tetap tampil dengan alasan di bawahnya '
            '(Rule §6.10).',
          ),
          const SizedBox(height: 12),

          // Varian 1: Normal
          _buildButtonLabel('Normal:'),
          PrimaryButton(
            label: 'Pesan Sekarang',
            onPressed: () => _showSnackbar('Tombol normal ditekan'),
          ),
          const SizedBox(height: 16),

          // Varian 2: Disabled dengan alasan (Rule §6.10)
          _buildButtonLabel('Disabled dengan alasan:'),
          PrimaryButton(
            label: 'GO ONLINE',
            disabledReason: 'Top up dulu minimal Rp 20.000 untuk mulai ya',
          ),
          const SizedBox(height: 16),

          // Varian 3: Loading
          _buildButtonLabel('Loading:'),
          PrimaryButton(label: 'Memproses...', isLoading: true),
          const SizedBox(height: 16),

          // Varian 4: Disabled tanpa alasan (edge case)
          _buildButtonLabel('Disabled tanpa alasan:'),
          PrimaryButton(label: 'Tidak Tersedia', disabledReason: null),

          const Divider(height: 48),

          // ═══════════════════════════════════════════════════════════
          // SECTION 3: AppCard Examples
          // ═══════════════════════════════════════════════════════════
          _buildSectionHeader('3. AppCard'),
          _buildSectionDescription(
            'Card untuk list item seperti riwayat pesanan.',
          ),
          const SizedBox(height: 12),

          // Contoh 1: Riwayat pesanan customer (C6)
          AppCard(
            onTap: () => _showSnackbar('Card riwayat ditekan'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '10 Jun  •  Budi S.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const Text(' 4.9', style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Selesai',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Jl. Sudirman → Kantor ABC',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Rp 6.000',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Contoh 2: Card saldo deposit mitra (D1)
          AppCard(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo Deposit:',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rp 47.000',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _showSnackbar('Top up ditekan'),
                  child: const Text('Top Up', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),

          const Divider(height: 48),

          // ═══════════════════════════════════════════════════════════
          // SECTION 4: AppBanner Examples
          // ═══════════════════════════════════════════════════════════
          _buildSectionHeader('4. AppBanner'),
          _buildSectionDescription(
            'Banner notifikasi ringan untuk reminder di Home.',
          ),
          const SizedBox(height: 12),

          // Contoh 1: Banner reminder notifikasi (Customer)
          AppBanner(
            message:
                'Aktifkan notifikasi agar kamu tidak ketinggalan update pesanan ya',
            actionText: 'Aktifkan',
            onAction: () => _showSnackbar('Aktifkan notifikasi ditekan'),
          ),
          const SizedBox(height: 12),

          // Contoh 2: Banner reminder mitra (lebih kritis)
          AppBanner(
            message: 'Aktifkan notifikasi agar order tidak terlewat ya!',
            actionText: 'Aktifkan',
            onAction: () => _showSnackbar('Aktifkan notifikasi ditekan'),
            icon: Icons.notifications_active_outlined,
          ),
          const SizedBox(height: 12),

          // Contoh 3: Banner warning saldo
          AppBanner(
            message:
                'Saldo kamu di bawah Rp 20.000. Top up dulu untuk lanjut ya',
            actionText: 'Top Up',
            onAction: () => _showSnackbar('Top up ditekan'),
            icon: Icons.warning_amber_rounded,
            backgroundColor: Colors.orange.shade50,
            textColor: Colors.orange.shade900,
          ),

          const SizedBox(height: 48),

          // Footer
          Center(
            child: Text(
              'hyperlocal_shared — Design System Preview',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Helper Widgets
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSectionDescription(String description) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        description,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildButtonLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildStateToggleButton(String label, ViewState state) {
    final isSelected = _stateViewState == state;
    return ElevatedButton(
      onPressed: () => setState(() => _stateViewState = state),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
