import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/valto_mascot.dart';
import '../../models/location_data.dart';
import '../../services/notification_service.dart';

class LbsPage extends StatefulWidget {
  final bool showBack;

  const LbsPage({super.key, this.showBack = false});

  @override
  State<LbsPage> createState() => _LbsPageState();
}

class _LbsPageState extends State<LbsPage> {
  DateTime? _scheduledTime;
  LocationData? _selectedLocation;
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  List<Map<String, dynamic>> _locationsWithDistance = [];

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dt.year, dt.month, dt.day);

    final dateLabel = date == today
        ? 'Hari ini'
        : date == tomorrow
            ? 'Besok'
            : '${dt.day}/${dt.month}/${dt.year}';
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$dateLabel, $hour:$minute';
  }

  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    setState(() {
      _scheduledTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _getCurrentLocation() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoadingLocation = true;
      _locationsWithDistance = [];
    });

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
      setState(() => _isLoadingLocation = false);
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
        setState(() => _isLoadingLocation = false);
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
      setState(() => _isLoadingLocation = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    final result = dummyLocations.map((loc) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        loc.lat,
        loc.lng,
      );
      return {'location': loc, 'distance': distance};
    }).toList();

    result.sort(
      (a, b) => (a['distance'] as double).compareTo(b['distance'] as double),
    );

    if (!mounted) return;
    setState(() {
      _currentPosition = position;
      _locationsWithDistance = result;
      _isLoadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.background,
      appBar: widget.showBack
          ? AppBar(
              backgroundColor: VaultColors.background,
              elevation: 0,
              title: Text('LBS Care Centers', style: VaultTypography.sectionTitle),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top 25% Glance Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: VaultColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: VaultColors.hairline),
                ),
                child: Row(
                  children: [
                    const ValtoMascot(size: 52, mood: ValtoMood.detective),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OFFICIAL SERVICE CENTERS',
                            style: VaultTypography.mono(
                              fontSize: 10,
                              letterSpacing: 1.4,
                              color: VaultColors.accentWarm,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentPosition == null
                                ? 'Yogyakarta Directory · GPS Standby'
                                : '${_currentPosition!.latitude.toStringAsFixed(4)}, '
                                    '${_currentPosition!.longitude.toStringAsFixed(4)}',
                            style: VaultTypography.mono(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 1: Immediate Warranty Alert
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VaultColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: VaultColors.hairline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Notifikasi Status Garansi', style: VaultTypography.cardLabel),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: const Text('Tes Notifikasi Garansi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VaultColors.primaryButton,
                        foregroundColor: VaultColors.primaryButtonInk,
                        padding: const EdgeInsets.all(14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await NotificationService().showInstantNotification(
                          title: 'VAULTED Warranty Sentinel',
                          body: 'Pantauan masa berlaku garansi perangkat aktif.',
                        );
                        if (context.mounted) {
                          VaultToast.show(
                            context,
                            icon: Icons.notifications_active_outlined,
                            message: 'Notifikasi garansi dikirim!',
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 2: LBS Nearest Service Centers
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VaultColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: VaultColors.hairline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Cari Service Center Terdekat', style: VaultTypography.cardLabel),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.my_location),
                      label: const Text('Cek Lokasi Saya'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VaultColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                    ),
                    if (_isLoadingLocation) ...[
                      const SizedBox(height: 16),
                      const Center(
                        child: CircularProgressIndicator(color: VaultColors.accent),
                      ),
                    ],
                    if (_locationsWithDistance.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ..._locationsWithDistance.map((item) {
                        final loc = item['location'] as LocationData;
                        final distance = item['distance'] as double;
                        final isNear = distance < 2000;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isNear ? VaultColors.posBg : VaultColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isNear ? VaultColors.pos : VaultColors.hairline,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.build_circle_outlined,
                                size: 20,
                                color: isNear ? VaultColors.pos : VaultColors.ink2,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(loc.name, style: VaultTypography.cardLabel),
                                    Text(loc.address, style: VaultTypography.cardSub),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatDistance(distance),
                                style: VaultTypography.mono(
                                  fontSize: 12,
                                  color: isNear ? VaultColors.pos : VaultColors.ink2,
                                  fontWeight: isNear ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 3: Scheduled Warranty Claim Reminder
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VaultColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: VaultColors.hairline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Jadwalkan Pengingat Klaim Garansi', style: VaultTypography.cardLabel),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<LocationData?>(
                      initialValue: _selectedLocation,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Pilih Service Center tujuan',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Pilih Service Center...')),
                        ...dummyLocations.map(
                          (loc) => DropdownMenuItem(value: loc, child: Text(loc.name)),
                        ),
                      ],
                      onChanged: (val) => setState(() => _selectedLocation = val),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickDateTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: VaultColors.background,
                          border: Border.all(color: VaultColors.hairline),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18, color: VaultColors.ink2),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _scheduledTime == null
                                    ? 'Pilih tanggal & waktu klaim garansi...'
                                    : _formatDateTime(_scheduledTime!),
                                style: VaultTypography.sans(
                                  color: _scheduledTime == null
                                      ? VaultColors.ink3
                                      : VaultColors.ink,
                                ),
                              ),
                            ),
                            if (_scheduledTime != null)
                              GestureDetector(
                                onTap: () => setState(() => _scheduledTime = null),
                                child: const Icon(Icons.close, size: 18, color: VaultColors.ink2),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.alarm),
                      label: const Text('Set Pengingat Klaim'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VaultColors.primaryButton,
                        foregroundColor: VaultColors.primaryButtonInk,
                        padding: const EdgeInsets.all(14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _selectedLocation == null || _scheduledTime == null
                          ? null
                          : () async {
                              await NotificationService().scheduleNotification(
                                id: 1,
                                title: 'Klaim Garansi: ${_selectedLocation!.name}',
                                body: 'Waktunya cek & klaim garansi ke ${_selectedLocation!.name}',
                                scheduledTime: _scheduledTime!,
                              );
                              if (!context.mounted) return;
                              VaultToast.show(
                                context,
                                icon: Icons.alarm_on_outlined,
                                message:
                                    'Pengingat ${_selectedLocation!.name}: ${_formatDateTime(_scheduledTime!)}',
                              );
                              setState(() {
                                _scheduledTime = null;
                                _selectedLocation = null;
                              });
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
