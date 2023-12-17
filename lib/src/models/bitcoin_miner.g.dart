// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bitcoin_miner.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BitcoinMinerAdapter extends TypeAdapter<BitcoinMiner> {
  @override
  final int typeId = 0;

  @override
  BitcoinMiner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BitcoinMiner(
      minerName: fields[0] as String,
      hashrate: fields[1] as double,
      consumption: fields[2] as int,
      efficiency: fields[3] as double,
      profitability: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BitcoinMiner obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.minerName)
      ..writeByte(1)
      ..write(obj.hashrate)
      ..writeByte(2)
      ..write(obj.consumption)
      ..writeByte(3)
      ..write(obj.efficiency)
      ..writeByte(4)
      ..write(obj.profitability);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BitcoinMinerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
