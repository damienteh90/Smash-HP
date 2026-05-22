import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/character_avatar.dart';
import '../services/local_storage_service.dart';
import '../theme/minecraft_theme.dart';
import '../widgets/pixel_button.dart';

class CustomAvatarSetupDialog extends StatefulWidget {
  const CustomAvatarSetupDialog({this.initialImages, super.key});

  final CustomAvatarImages? initialImages;

  @override
  State<CustomAvatarSetupDialog> createState() =>
      _CustomAvatarSetupDialogState();
}

class _CustomAvatarSetupDialogState extends State<CustomAvatarSetupDialog> {
  final ImagePicker _picker = ImagePicker();

  String? _idlePath;
  String? _hitPath;
  String? _deadPath;
  String? _message;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final initialImages = widget.initialImages;
    _idlePath = initialImages?.idlePath;
    _hitPath = initialImages?.hitPath;
    _deadPath = initialImages?.deadPath;
  }

  Future<void> _pickImage(CharacterPose pose, ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source, imageQuality: 90);

      if (image == null) {
        return;
      }

      final storedPath = await _copyImageToAvatarStorage(image.path, pose);

      if (!mounted) {
        return;
      }

      setState(() {
        _message = null;
        switch (pose) {
          case CharacterPose.idle:
            _idlePath = storedPath;
          case CharacterPose.hit:
            _hitPath = storedPath;
          case CharacterPose.dead:
            _deadPath = storedPath;
        }
      });
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() => _message = _pickerErrorMessage(error, source));
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(
        () => _message = 'Could not save that image. Try a different one.',
      );
    }
  }

  Future<String> _copyImageToAvatarStorage(
    String sourcePath,
    CharacterPose pose,
  ) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw FileSystemException('Image not found', sourcePath);
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final avatarDirectory = Directory(
      '${documentsDirectory.path}${Platform.pathSeparator}custom_avatar',
    );

    if (!await avatarDirectory.exists()) {
      await avatarDirectory.create(recursive: true);
    }

    final extension = _fileExtension(sourcePath);
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final targetPath =
        '${avatarDirectory.path}${Platform.pathSeparator}'
        'custom_${pose.name}_$timestamp$extension';

    final copiedFile = await sourceFile.copy(targetPath);
    return copiedFile.path;
  }

  String _fileExtension(String path) {
    final index = path.lastIndexOf('.');
    if (index == -1 || index == path.length - 1) {
      return '.jpg';
    }

    final extension = path.substring(index).toLowerCase();
    const allowedExtensions = {'.jpg', '.jpeg', '.png', '.webp', '.heic'};
    return allowedExtensions.contains(extension) ? extension : '.jpg';
  }

  String _pickerErrorMessage(PlatformException error, ImageSource source) {
    final code = error.code.toLowerCase();
    if (code.contains('denied') || code.contains('restricted')) {
      return source == ImageSource.camera
          ? 'Camera permission was denied.'
          : 'Photo access was denied.';
    }

    return 'Could not open the image picker.';
  }

  Future<void> _save() async {
    final images = CustomAvatarImages(
      idlePath: _idlePath ?? '',
      hitPath: _hitPath ?? '',
      deadPath: _deadPath ?? '',
    );

    if (!images.isComplete) {
      setState(() => _message = 'Add idle, hit, and dead images first.');
      return;
    }

    final paths = [images.idlePath, images.hitPath, images.deadPath];
    final exists = await Future.wait(paths.map((path) => File(path).exists()));

    if (exists.any((exists) => !exists)) {
      setState(
        () => _message = 'One image is missing. Pick the missing image again.',
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _message = null;
    });

    await localStorage.saveCustomAvatarImages(images);

    if (mounted) {
      Navigator.of(context).pop(images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: MinecraftTheme.darkBrownWood,
          border: Border.all(
            color: MinecraftTheme.deepStoneCharcoal,
            width: MinecraftTheme.chunkBorderWidth,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF2A1D12),
              offset: Offset(6, 6),
              blurRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'CUSTOM AVATAR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MinecraftTheme.textLight,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: MinecraftTheme.textLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _AvatarImagePickerRow(
                label: 'Idle Image',
                path: _idlePath,
                onChoose: () =>
                    _pickImage(CharacterPose.idle, ImageSource.gallery),
                onTakePhoto: () =>
                    _pickImage(CharacterPose.idle, ImageSource.camera),
              ),
              const SizedBox(height: 12),
              _AvatarImagePickerRow(
                label: 'Hit Image',
                path: _hitPath,
                onChoose: () =>
                    _pickImage(CharacterPose.hit, ImageSource.gallery),
                onTakePhoto: () =>
                    _pickImage(CharacterPose.hit, ImageSource.camera),
              ),
              const SizedBox(height: 12),
              _AvatarImagePickerRow(
                label: 'Dead Image',
                path: _deadPath,
                onChoose: () =>
                    _pickImage(CharacterPose.dead, ImageSource.gallery),
                onTakePhoto: () =>
                    _pickImage(CharacterPose.dead, ImageSource.camera),
              ),
              if (_message != null) ...[
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: MinecraftTheme.warmCream,
                    border: Border.all(
                      color: MinecraftTheme.battleRed,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _message!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: MinecraftTheme.battleRed,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              PixelButton(
                label: _isSaving ? 'SAVING...' : 'SAVE CUSTOM AVATAR',
                onPressed: _isSaving ? () {} : _save,
                isPrimary: true,
                isDisabled: _isSaving,
                backgroundColor: MinecraftTheme.primaryGold,
                borderColor: MinecraftTheme.deepStoneCharcoal,
                textColor: MinecraftTheme.deepStoneCharcoal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarImagePickerRow extends StatelessWidget {
  const _AvatarImagePickerRow({
    required this.label,
    required this.path,
    required this.onChoose,
    required this.onTakePhoto,
  });

  final String label;
  final String? path;
  final VoidCallback onChoose;
  final VoidCallback onTakePhoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MinecraftTheme.warmCream,
        border: Border.all(color: MinecraftTheme.deepStoneCharcoal, width: 2),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: MinecraftTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: MinecraftTheme.deepStoneCharcoal,
                  border: Border.all(
                    color: MinecraftTheme.darkBrownWood,
                    width: 2,
                  ),
                ),
                child: _AvatarPreview(path: path),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    PixelButton(
                      label: 'UPLOAD IMAGE',
                      onPressed: onChoose,
                      isPrimary: false,
                      padding: 6,
                      backgroundColor: MinecraftTheme.darkBrownWood,
                      borderColor: MinecraftTheme.deepStoneCharcoal,
                    ),
                    const SizedBox(height: 8),
                    PixelButton(
                      label: 'TAKE PHOTO',
                      onPressed: onTakePhoto,
                      isPrimary: false,
                      padding: 6,
                      backgroundColor: MinecraftTheme.deepStoneCharcoal,
                      borderColor: MinecraftTheme.darkBrownWood,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final imagePath = path;
    if (imagePath == null || imagePath.isEmpty) {
      return const Icon(
        Icons.add_photo_alternate,
        color: MinecraftTheme.warmCream,
        size: 28,
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.none,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.broken_image,
          color: MinecraftTheme.warmCream,
          size: 28,
        );
      },
    );
  }
}
