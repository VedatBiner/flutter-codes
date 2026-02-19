import 'package:flutter/material.dart';

import '../models/filter_option.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import 'filter_chips.dart';
import 'body_widgets/movie_section.dart';
import 'body_widgets/series_section.dart';

class CustomBody extends StatefulWidget {
  final bool loading;
  final List<NetflixItem> movies;
  final List<SeriesGroup> series;
  final FilterOption filter;

  final ValueChanged<FilterOption> onFilterSelected;
  final ValueChanged<NetflixItem> onMovieTap;
  //final Future<void> Function(SeriesGroup group)? onSeriesTap;

  const CustomBody({
    super.key,
    required this.loading,
    required this.movies,
    required this.series,
    required this.filter,
    required this.onFilterSelected,
    required this.onMovieTap,
  });

  @override
  State<CustomBody> createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  final _seriesController = ExpansibleController();
  final _moviesController = ExpansibleController();

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        FilterChips(
          filter: widget.filter,
          onSelected: widget.onFilterSelected,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              SeriesSection(
                series: widget.series,
                seriesController: _seriesController,
                onExpand: () => _moviesController.collapse(),
              ),
              const SizedBox(height: 20),
              MovieSection(
                movies: widget.movies,
                moviesController: _moviesController,
                onExpand: () => _seriesController.collapse(),
                onMovieTap: widget.onMovieTap,
              ),

            ],
          ),
        ),
      ],
    );
  }
}
