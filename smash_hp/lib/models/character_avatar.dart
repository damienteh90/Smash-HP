import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/minecraft_theme.dart';

enum CharacterPose { idle, hit, dead }

class CustomAvatarImages {
  final String idlePath;
  final String hitPath;
  final String deadPath;

  const CustomAvatarImages({
    required this.idlePath,
    required this.hitPath,
    required this.deadPath,
  });

  bool get isComplete =>
      idlePath.trim().isNotEmpty &&
      hitPath.trim().isNotEmpty &&
      deadPath.trim().isNotEmpty;

  String pathForPose(CharacterPose pose) {
    return switch (pose) {
      CharacterPose.idle => idlePath,
      CharacterPose.hit => hitPath,
      CharacterPose.dead => deadPath,
    };
  }
}

class CharacterAvatar {
  static const String customId = 'custom';

  final String id;
  final String label;

  const CharacterAvatar({required this.id, required this.label});

  String assetPath(CharacterPose pose) {
    return 'assets/characters/character_${id}_${pose.name}.png';
  }

  static const List<CharacterAvatar> all = [
    CharacterAvatar(id: 'warrior', label: 'Warrior'),
    CharacterAvatar(id: 'sorcerer', label: 'Sorcerer'),
    CharacterAvatar(id: 'wizard', label: 'Wizard'),
    CharacterAvatar(id: 'dwarf', label: 'Dwarf'),
    CharacterAvatar(id: 'goblin', label: 'Goblin'),
    CharacterAvatar(id: 'elf', label: 'Elf'),
    CharacterAvatar(id: 'skeleton', label: 'Skeleton'),
  ];

  static const CharacterAvatar custom = CharacterAvatar(
    id: customId,
    label: 'Custom',
  );

  static const List<CharacterAvatar> selectionSlots = [...all, custom];

  static const CharacterAvatar fallback = CharacterAvatar(
    id: 'warrior',
    label: 'Warrior',
  );

  static CharacterAvatar byId(String id) {
    return selectionSlots.firstWhere(
      (character) => character.id == id,
      orElse: () => fallback,
    );
  }

  static String normalizeId(Object? value) {
    if (value is String &&
        selectionSlots.any((character) => character.id == value)) {
      return value;
    }

    if (value is int && value >= 1 && value <= all.length) {
      return all[value - 1].id;
    }

    return fallback.id;
  }
}

class CharacterImage extends StatelessWidget {
  final String characterId;
  final CharacterPose pose;
  final CustomAvatarImages? customAvatarImages;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CharacterImage({
    required this.characterId,
    required this.pose,
    this.customAvatarImages,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (characterId == CharacterAvatar.customId) {
      final path = customAvatarImages?.pathForPose(pose);

      if (path == null || path.trim().isEmpty) {
        return _CharacterFallbackIcon(width: width, height: height);
      }

      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.none,
        errorBuilder: (context, error, stackTrace) {
          return _CharacterFallbackIcon(width: width, height: height);
        },
      );
    }

    final character = CharacterAvatar.byId(characterId);

    return Image.asset(
      character.assetPath(pose),
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.none,
      errorBuilder: (context, error, stackTrace) {
        if (pose != CharacterPose.idle) {
          return Image.asset(
            character.assetPath(CharacterPose.idle),
            width: width,
            height: height,
            fit: fit,
            filterQuality: FilterQuality.none,
            errorBuilder: (context, error, stackTrace) {
              return _CharacterFallbackIcon(width: width, height: height);
            },
          );
        }

        return _CharacterFallbackIcon(width: width, height: height);
      },
    );
  }
}

class _CharacterFallbackIcon extends StatelessWidget {
  final double? width;
  final double? height;

  const _CharacterFallbackIcon({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: const Center(
        child: Icon(Icons.person, color: MinecraftTheme.warmCream, size: 42),
      ),
    );
  }
}
