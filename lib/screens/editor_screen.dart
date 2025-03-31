import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_editing_app/bloc/image_bloc.dart';
import 'package:image_editing_app/widgets/filter_widget.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  Future<void> _saveImage(BuildContext context, Uint8List imageBytes) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final result = await ImageGallerySaver.saveImage(imageBytes);
        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image saved to gallery')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Editor'),
        actions: [
          BlocBuilder<ImageBloc, ImageState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.save),
                onPressed: state.imageLayers.isNotEmpty
                    ? () => _saveImage(context, state.imageLayers.last)
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ImageBloc, ImageState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return Column(
            children: [
              // Filter Row
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    FilterOption(name: 'Original', filter: 'none'),
                    FilterOption(name: 'Grayscale', filter: 'grayscale'),
                    FilterOption(name: 'Sepia', filter: 'sepia'),
                    FilterOption(name: 'Vintage', filter: 'vintage'),
                    FilterOption(name: 'Blur', filter: 'blur'),
                  ],
                ),
              ),
              
              // Canvas Area
              Expanded(
                child: Center(
                  child: state.imageLayers.isNotEmpty
                      ? InteractiveViewer(
                          child: Image.memory(state.imageLayers.last),
                        )
                      : const Text('No image loaded'),
                ),
              ),
              
              // Filter Intensity Slider
              if (state.currentTool == 'filter')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Slider(
                    value: state.filterIntensity,
                    min: 0,
                    max: 1,
                    onChanged: (value) => context.read<ImageBloc>().add(
                      SetFilterIntensity(value),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  final String name;
  final String filter;
  
  const FilterOption({
    super.key,
    required this.name,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.filter),
            onPressed: () => context.read<ImageBloc>().add(
              ApplyFilter(filter),
            ),
          ),
          Text(name),
        ],
      ),
    );
  }
}