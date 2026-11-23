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
  DateTime? _scheduledTime;
  LocationData? _selectedCenter;

  Future<void> _locateUser() async {
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);

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
      setState(() => _isLoading = false);
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
        setState(() => _isLoading = false);
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
      setState(() => _isLoading = false);
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    if (!mounted) return;
    setState(() {
      _userPosition = pos;
      _isLoading = false;
    });
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    setState(() {
      _scheduledTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
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

            // Service Center List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final loc = filtered[index]['loc'] as LocationData;
                  final dist = filtered[index]['dist'] as double?;
                  final isNear = dist != null && dist < 2000;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isNear ? VaultColors.posBg : VaultColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isNear ? VaultColors.pos : VaultColors.hairline,
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
                            Icons.build_circle_outlined,
                            color: isNear ? VaultColors.pos : VaultColors.accent,
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
                          onPressed: () async {
                            await _pickDateTime();
                            if (_scheduledTime == null || !context.mounted) return;
                            final target = _selectedCenter ?? dummyLocations.first;
                            await NotificationService().scheduleNotification(
                              id: 1,
                              title: 'Klaim Garansi: ${target.name}',
                              body: 'Waktunya kunjungi ${target.name}',
                              scheduledTime: _scheduledTime!,
                            );
                            if (context.mounted) {
                              VaultToast.show(
                                context,
                                icon: Icons.alarm_on_outlined,
                                message: 'Pengingat klaim garansi dijadwalkan!',
                              );
                            }
                          },
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
