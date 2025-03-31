part of 'image_bloc.dart';

abstract class ImageEvent {}

class LoadImage extends ImageEvent {
  final String imagePath;
  LoadImage(this.imagePath);
}

class ApplyFilter extends ImageEvent {
  final String filterType;
  ApplyFilter(this.filterType);
}

class AddTextLayer extends ImageEvent {
  final String text;
  final TextStyle style;
  final Offset position;
  final Uint8List layerData;
  AddTextLayer(this.text, this.style, this.position, this.layerData);
}

class AddDrawingLayer extends ImageEvent {
  final Uint8List layerData;
  AddDrawingLayer(this.layerData);
}

class SetTool extends ImageEvent {
  final String tool;
  SetTool(this.tool);
}

class SetBrushSize extends ImageEvent {
  final double size;
  SetBrushSize(this.size);
}

class SetBrushOpacity extends ImageEvent {
  final double opacity;
  SetBrushOpacity(this.opacity);
}

class SetFontSize extends ImageEvent {
  final double size;
  SetFontSize(this.size);
}

class SetFilterIntensity extends ImageEvent {
  final double intensity;
  SetFilterIntensity(this.intensity);
}

class ApplyAIEnhancement extends ImageEvent {}

class UndoAction extends ImageEvent {}

class RedoAction extends ImageEvent {}

class SaveImage extends ImageEvent {}
