import 'package:hive/hive.dart';

part 'vault_item.g.dart';

@HiveType(typeId: 0)
class VaultItem extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double purchasePrice;

  @HiveField(3)
  final double currentValuation;

  @HiveField(4)
  final String purchaseDate;

  @HiveField(5)
  final String warrantyExpiryDate;

  @HiveField(6)
  final String serialNumber;

  VaultItem({
    required this.name,
    required this.category,
    required this.purchasePrice,
    required this.currentValuation,
    required this.purchaseDate,
    required this.warrantyExpiryDate,
    this.serialNumber = '',
  });
}
