// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VaultItemAdapter extends TypeAdapter<VaultItem> {
  @override
  final int typeId = 0;

  @override
  VaultItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VaultItem(
      name: fields[0] as String,
      category: fields[1] as String,
      purchasePrice: fields[2] as double,
      currentValuation: fields[3] as double,
      purchaseDate: fields[4] as String,
      warrantyExpiryDate: fields[5] as String,
      serialNumber: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VaultItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.purchasePrice)
      ..writeByte(3)
      ..write(obj.currentValuation)
      ..writeByte(4)
      ..write(obj.purchaseDate)
      ..writeByte(5)
      ..write(obj.warrantyExpiryDate)
      ..writeByte(6)
      ..write(obj.serialNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaultItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
