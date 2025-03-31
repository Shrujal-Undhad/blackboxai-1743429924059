import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_editing_app/controllers/ai_controller.dart';
import 'package:image_editing_app/utils/image_utils.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageState(
    imageLayers: [],
    historyStack: [],
  )) {
    on<LoadImage>(_onLoadImage);
    on<ApplyFilter>(_onApplyFilter);
    on<AddTextLayer>(_onAddTextLayer);
    on<AddDrawingLayer>(_onAddDrawingLayer);
    on<SetTool>(_onSetTool);
    on<SetBrushSize>(_onSetBrushSize);
    on<SetBrushOpacity>(_onSetBrushOpacity);
    on<SetFontSize>(_onSetFontSize);
    on<SetFilterIntensity>(_onSetFilterIntensity);
    on<ApplyAIEnhancement>(_onApplyAIEnhancement);
    on<UndoAction>(_onUndoAction);
    on<RedoAction>(_onRedoAction);
    on<SaveImage>(_onSaveImage);
  }

  void _onLoadImage(LoadImage event, Emitter<ImageState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final file = File(event.imagePath);
      final bytes = await file.readAsBytes();
      emit(state.copyWith(
        imageLayers: [bytes],
        historyStack: [bytes],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // TODO: Show error to user
    }
  }

  void _onApplyFilter(ApplyFilter event, Emitter<ImageState> emit) {
    if (state.imageLayers.isEmpty) return;
    
    final filtered = ImageUtils.applyFilter(
      state.imageLayers.last,
      event.filterType,
    );
    final newLayers = [...state.imageLayers, filtered];
    emit(state.copyWith(
      imageLayers: newLayers,
      historyStack: [...state.historyStack, filtered],
    ));
  }

  void _onAddTextLayer(AddTextLayer event, Emitter<ImageState> emit) {
    final newLayers = [...state.imageLayers, event.layerData];
    emit(state.copyWith(
      imageLayers: newLayers,
      historyStack: [...state.historyStack, event.layerData],
    ));
  }

  void _onAddDrawingLayer(AddDrawingLayer event, Emitter<ImageState> emit) {
    final newLayers = [...state.imageLayers, event.layerData];
    emit(state.copyWith(
      imageLayers: newLayers,
      historyStack: [...state.historyStack, event.layerData],
    ));
  }

  void _onSetTool(SetTool event, Emitter<ImageState> emit) {
    emit(state.copyWith(currentTool: event.tool));
  }

  void _onSetBrushSize(SetBrushSize event, Emitter<ImageState> emit) {
    emit(state.copyWith(brushSize: event.size));
  }

  void _onSetBrushOpacity(SetBrushOpacity event, Emitter<ImageState> emit) {
    emit(state.copyWith(brushOpacity: event.opacity));
  }

  void _onSetFontSize(SetFontSize event, Emitter<ImageState> emit) {
    emit(state.copyWith(fontSize: event.size));
  }

  void _onSetFilterIntensity(SetFilterIntensity event, Emitter<ImageState> emit) {
    emit(state.copyWith(filterIntensity: event.intensity));
  }

  void _onApplyAIEnhancement(ApplyAIEnhancement event, Emitter<ImageState> emit) async {
    if (state.imageLayers.isEmpty) return;
    
    emit(state.copyWith(isLoading: true));
    try {
      final enhanced = await AIController().enhanceImage(state.imageLayers.last);
      final newLayers = [...state.imageLayers, enhanced];
      emit(state.copyWith(
        imageLayers: newLayers,
        historyStack: [...state.historyStack, enhanced],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // TODO: Show error to user
    }
  }

  void _onUndoAction(UndoAction event, Emitter<ImageState> emit) {
    if (state.historyIndex > 0) {
      emit(state.copyWith(
        historyIndex: state.historyIndex - 1,
        imageLayers: [state.historyStack[state.historyIndex - 1]],
      ));
    }
  }

  void _onRedoAction(RedoAction event, Emitter<ImageState> emit) {
    if (state.historyIndex < state.historyStack.length - 1) {
      emit(state.copyWith(
        historyIndex: state.historyIndex + 1,
        imageLayers: [state.historyStack[state.historyIndex + 1]],
      ));
    }
  }

  void _onSaveImage(SaveImage event, Emitter<ImageState> emit) async {
    emit(state.copyWith(isLoading: true));
    // TODO: Implement image saving logic
    emit(state.copyWith(isLoading: false));
  }
}