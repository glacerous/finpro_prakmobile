import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
import '../../core/widgets/vault_back_button.dart';
import '../../models/location_data.dart';
import '../../services/notification_service.dart';

class WarrantyLbsScreen extends StatefulWidget {
  final bool showBack;

  const WarrantyLbsScreen({super.key, this.showBack = false});

  @override
  State<WarrantyLbsScreen> createState() => _WarrantyLbsScreenState();
}

class _WarrantyLbsScreenState extends State<WarrantyLbsScreen> {
  Position? _userPosition;
  bool _isLoading = false;
  String _selectedBrand = 'All';
  LocationData? _selectedCenter;

  Future<void> _locateUser() async {
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          VaultToast.show(
            context,
            icon: Icons.location_off_outlined,
            iconColor: VaultColors.neg,
            message: 'GPS tidak aktif.',
          );
        }
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            VaultToast.show(
              context,
              icon: Icons.location_off_outlined,
              iconColor: VaultColors.neg,
              message: 'Permission lokasi ditolak.',
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          VaultToast.show(
            context,
            icon: Icons.location_off_outlined,
            iconColor: VaultColors.neg,
            message: 'Permission lokasi diblokir.',
          );
        }
        return;
      }

      // coba posisi terkini dengan timeout, fallback ke lokasi terakhir jika emulator lambat
      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
      } catch (_) {
        pos = await Geolocator.getLastKnownPosition();
      }

      if (!mounted) return;
      if (pos == null) {
        VaultToast.show(
          context,
          icon: Icons.location_off_outlined,
          iconColor: VaultColors.neg,
          message: 'Gagal mendapatkan koordinat GPS.',
        );
        return;
      }
      setState(() => _userPosition = pos);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // kembalikan datetime baru (null jika user tekan cancel) agar tidak pakai jadwal lama
  Future<DateTime?> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 1))),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _handleScheduleReminder(LocationData target) async {
    final picked = await _pickDateTime();
    if (picked == null || !mounted) return;

    if (!picked.isAfter(DateTime.now())) {
      VaultToast.show(
        context,
        icon: Icons.error_outline_rounded,
        iconColor: VaultColors.neg,
        message: 'Pilih waktu di masa depan.',
      );
      return;
    }

    try {
      await NotificationService().scheduleNotification(
        id: 1,
        title: 'Klaim Garansi: ${target.name}',
        body: 'Waktunya kunjungi ${target.name}',
        scheduledTime: picked,
      );
      if (!mounted) return;
      final hh = picked.hour.toString().padLeft(2, '0');
      final mm = picked.minute.toString().padLeft(2, '0');
      VaultToast.show(
        context,
        icon: Icons.alarm_on_outlined,
        message: 'Reminder ${target.name} diset jam $hh:$mm',
      );
    } catch (e) {
      if (mounted) {
        VaultToast.show(
          context,
          icon: Icons.error_outline_rounded,
          iconColor: VaultColors.neg,
          message: 'Gagal menjadwalkan reminder.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brands = ['All', 'Asus', 'Apple', 'Samsung', 'Xiaomi', 'Lenovo', 'Sony'];
    final filtered = dummyLocations
        .where((loc) => _selectedBrand == 'All' || loc.brand == _selectedBrand)
        .map((loc) {
      final dist = _userPosition == null
          ? null
          : Geolocator.distanceBetween(
              _userPosition!.latitude,
              _userPosition!.longitude,
              loc.lat,
              loc.lng,
            );
      return {'loc': loc, 'dist': dist};
    }).toList();

    if (_userPosition != null) {
      filtered.sort(
        (a, b) => ((a['dist'] as double?) ?? 0).compareTo((b['dist'] as double?) ?? 0),
      );
    }

    final defaultTarget = filtered.isNotEmpty
        ? filtered.first['loc'] as LocationData
        : dummyLocations.first;
    final reminderTarget = _selectedCenter ?? defaultTarget;

    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: widget.showBack
          ? AppBar(
              backgroundColor: VaultColors.background,
              elevation: 0,
              leading: const VaultBackButton(),
              title: Text('LBS Care Centers', style: VaultTypography.sectionTitle),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // Top 25% Glance Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VaultColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: VaultColors.hairline),
                ),
                child: Row(
                  children: [
                    const ValtoMascot(size: 48, mood: ValtoMood.detective),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OFFICIAL SERVICE RADAR',
                            style: VaultTypography.mono(
                              fontSize: 10,
                              letterSpacing: 1.2,
                              color: VaultColors.accentWarm,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _userPosition == null
                                ? 'Yogyakarta Directory (${dummyLocations.length} centers)'
                                : '${_userPosition!.latitude.toStringAsFixed(4)}, '
                                    '${_userPosition!.longitude.toStringAsFixed(4)}',
                            style: VaultTypography.mono(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_active_outlined, color: VaultColors.ink),
                      onPressed: () async {
                        await NotificationService().showInstantNotification(
                          title: 'VAULTED Warranty Sentinel',
                          body: 'Service center resmi siap untuk klaim garansi.',
                        );
                        if (context.mounted) {
                          VaultToast.show(context, message: 'Notifikasi garansi dikirim!');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Service Center List (tap card untuk pilih tujuan reminder)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final loc = filtered[index]['loc'] as LocationData;
                  final dist = filtered[index]['dist'] as double?;
                  final isNear = dist != null && dist < 2000;
                  final isSelected = _selectedCenter?.name == loc.name;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedCenter = isSelected ? null : loc);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isNear ? VaultColors.posBg : VaultColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? VaultColors.ink
                              : (isNear ? VaultColors.pos : VaultColors.hairline),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: VaultColors.cardHover,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isSelected
                                  ? Icons.check_circle_rounded
                                  : Icons.build_circle_outlined,
                              color: isSelected
                                  ? VaultColors.ink
                                  : (isNear ? VaultColors.pos : VaultColors.accent),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(loc.name, style: VaultTypography.cardLabel),
                                Text(loc.address, style: VaultTypography.cardSub),
                              ],
                            ),
                          ),
                          if (dist != null)
                            Text(
                              dist < 1000
                                  ? '${dist.toStringAsFixed(0)} m'
                                  : '${(dist / 1000).toStringAsFixed(1)} km',
                              style: VaultTypography.mono(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isNear ? VaultColors.pos : VaultColors.ink,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom 40% Thumb Zone: Brand Filter Dock + GPS & Reminder Controls
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: VaultColors.card,
                border: Border(top: BorderSide(color: VaultColors.hairline)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: brands.map((b) {
                        final sel = _selectedBrand == b;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedBrand = b);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: sel ? VaultColors.ink : VaultColors.cardHover,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              b,
                              style: VaultTypography.sans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: sel ? Colors.white : VaultColors.ink2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _locateUser,
                          icon: const Icon(Icons.my_location, size: 16),
                          label: Text(_isLoading ? 'Locating...' : 'GPS Terdekat'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: VaultColors.accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _handleScheduleReminder(reminderTarget),
                          icon: const Icon(Icons.alarm, size: 16),
                          label: const Text('Set Reminder'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: VaultColors.primaryButton,
                            foregroundColor: VaultColors.primaryButtonInk,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
