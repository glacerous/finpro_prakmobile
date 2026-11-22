class LocationData {
  final String name;
  final String brand;
  final String address;
  final double lat;
  final double lng;

  const LocationData({
    required this.name,
    required this.brand,
    required this.address,
    required this.lat,
    required this.lng,
  });
}

const List<LocationData> dummyLocations = [
  LocationData(
    name: 'Asus Service Center Jogja',
    brand: 'Asus',
    address: 'Jl. Ring Road Utara No. 10, Sleman',
    lat: -7.7583,
    lng: 110.4045,
  ),
  LocationData(
    name: 'Apple Authorized (iBox Ambarrukmo)',
    brand: 'Apple',
    address: 'Plaza Ambarrukmo Lt. 2, Sleman',
    lat: -7.7828,
    lng: 110.4011,
  ),
  LocationData(
    name: 'Samsung Service Center Ambarrukmo',
    brand: 'Samsung',
    address: 'Jl. Laksda Adisucipto No. 165, Sleman',
    lat: -7.7825,
    lng: 110.3985,
  ),
  LocationData(
    name: 'Xiaomi Service Center Sagan',
    brand: 'Xiaomi',
    address: 'Ruko Sagan Square, Yogyakarta',
    lat: -7.7770,
    lng: 110.3790,
  ),
  LocationData(
    name: 'Lenovo Service Center Jogja',
    brand: 'Lenovo',
    address: 'Jl. Kaliurang KM 5 No. 28, Sleman',
    lat: -7.7645,
    lng: 110.3780,
  ),
  LocationData(
    name: 'Sony Authorized Service Station',
    brand: 'Sony',
    address: 'Jl. C. Simanjuntak No. 42, Yogyakarta',
    lat: -7.7791,
    lng: 110.3732,
  ),
];
