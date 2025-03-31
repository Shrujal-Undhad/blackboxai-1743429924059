part of 'image_bloc.dart';

class ImageState {
  final List<Uint8List> imageLayers;
  final List<Uint8List> historyStack;
  final int historyIndex;
  final String? currentTool;
  final bool isLoading;
  final double brushSize;
  final double brushOpacity;
  final double fontSize;
  final double filterIntensity;

  ImageState({
    required this.imageLayers,
    required this.historyStack,
    this.historyIndex = 0,
    this.currentTool,
    this.isLoading = false,
    this.brushSize = 5.0,
    this.brushOpacity = 1.0,
    this.fontSize = 24.0,
    this.filterIntensity = 0.5,
  });

  ImageState copyWith({
    List<Uint8List>? imageLayers,
    List<Uint8List>? historyStack,
    int? historyIndex,
    String? currentTool,
    bool? isLoading,
    double? brushSize,
    double? brushOpacity,
    double? fontSize,
    double? filterIntensity,
  }) {
    return ImageState(
      imageLayers: imageLayers ?? this.imageLayers,
      historyStack: historyStack ?? this.historyStack,
      historyIndex: historyIndex ?? this.historyIndex,
      currentTool: currentTool ?? this.currentTool,
      isLoading: isLoading ?? this.isLoading,
      brushSize: brushSize ?? this.brushSize,
      brushOpacity: brushOpacity ?? this.brushOpacity,
      fontSize: fontSize ?? this.fontSize,
      filterIntensity: filterIntensity ?? this.filterIntensity,
    );
  }
}