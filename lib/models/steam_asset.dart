class SteamAsset {
  final String name;
  final String category;
  final String marketHashName;
  final String imageUrl;
  final double priceUsd;

  SteamAsset({
    required this.name,
    required this.category,
    required this.marketHashName,
    required this.imageUrl,
    required this.priceUsd,
  });

  SteamAsset copyWith({double? priceUsd}) => SteamAsset(
        name: name,
        category: category,
        marketHashName: marketHashName,
        imageUrl: imageUrl,
        priceUsd: priceUsd ?? this.priceUsd,
      );
}

final List<SteamAsset> initialSteamAssets = [
  SteamAsset(
    name: 'MAC-10 | Sakkaku (Well-Worn)',
    category: 'Steam / Restricted SMG',
    marketHashName: 'MAC-10 | Sakkaku (Well-Worn)',
    imageUrl:
        'https://community.steamstatic.com/economy/image/i0CoZ81Ui0m-9KwlBY1L_18myuGuq1wfhWSaZgMttyVfPaERSR0Wqmu7LAocGIGz3UqlXOLrxM-vMGmW8VNxu5Dx60noTyL8n5WxrR1Y-s2jaac8cM-AD2ybwOVjj-xsSyCmmFMk5mnRzdeqdSnCPVN2DpV3QeELtELrlIbiPrzqsVOMjdlBnySvjH5O8G81tOTP5a5f',
    priceUsd: 0.46,
  ),
  SteamAsset(
    name: 'AK-47 | Uncharted (Field-Tested)',
    category: 'Steam / Mil-Spec Rifle',
    marketHashName: 'AK-47 | Uncharted (Field-Tested)',
    imageUrl:
        'https://community.steamstatic.com/economy/image/i0CoZ81Ui0m-9KwlBY1L_18myuGuq1wfhWSaZgMttyVfPaERSR0Wqmu7LAocGIGz3UqlXOLrxM-vMGmW8VNxu5Dx60noTyLwlcK3wiFO0POlPPNSIeqHC2SvzOtyufRkAXrlwkwj5m3dyt-scX2SZw8kDJN5EONbsUPtkYfnYbvmtlCMi4MQyiTgznQeFZeHgOE',
    priceUsd: 0.75,
  ),
  SteamAsset(
    name: 'Revolution Case',
    category: 'Steam / Container',
    marketHashName: 'Revolution Case',
    imageUrl:
        'https://community.steamstatic.com/economy/image/i0CoZ81Ui0m-9KwlBY1L_18myuGuq1wfhWSaZgMttyVfPaERSR0Wqmu7LAocGJKz2lu_XsnXwtmkJjSU91dh8bj35VTqVBP4io_frnAVvfb6aqduc_TFVjTCxbx05OU4S3jilE9w4DzRnImtIy2Sa1JzDJEhRPlK7EcO4U8gfA',
    priceUsd: 0.20,
  ),
  SteamAsset(
    name: 'Fracture Case',
    category: 'Steam / Container',
    marketHashName: 'Fracture Case',
    imageUrl:
        'https://community.steamstatic.com/economy/image/i0CoZ81Ui0m-9KwlBY1L_18myuGuq1wfhWSaZgMttyVfPaERSR0Wqmu7LAocGJKz2lu_XsnXwtmkJjSU91dh8bj35VTqVBP4io_fr3QV7aD7OP01IfbGDzPCmbsm4LU5GnvkzUsi4WvUmIqtci_CPQNyApsjE_lK7EfrhW545A',
    priceUsd: 0.48,
  ),
];
