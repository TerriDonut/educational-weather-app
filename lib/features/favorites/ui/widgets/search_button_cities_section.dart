part of '../favorites_screen.dart';

// TODO(kshabanov): rename to SearchField
// TODO(kshabanov): создать отдельный блок и убрать жесткую связность со страницей избранного. +
// TODO(kshabanov): (пока не делать) сделать так чтобы поле поиска можно было на любой странице переиспользовать
// TODO(kshabanov): поправить баг чтобы при открытии клавиатуры она не закрывала поле поиска
class _SearchButtonCitiesSection extends StatefulWidget {
  final SearchButtonState state;
  final void Function(String query) onQueryChanged;
  final void Function(ListCitiesModel city) onSelectedCity;

  const _SearchButtonCitiesSection({
    required this.state,
    required this.onQueryChanged,
    required this.onSelectedCity,
  });

  @override
  State<_SearchButtonCitiesSection> createState() =>
      _SearchButtonCitiesSectionState();
}

class _SearchButtonCitiesSectionState
    extends State<_SearchButtonCitiesSection> {
  final GlobalKey _fieldKey = GlobalKey();
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitFirstSuggestion(
    List<ListCitiesModel> suggestions,
    bool hasCitiesError,
  ) {
    if (hasCitiesError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось загрузить список городов'),
        ),
      );
      return;
    }

    if (suggestions.isNotEmpty) {
      final city = suggestions.first;
      widget.onSelectedCity(city);
      _controller.clear();
      _focusNode.unfocus();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Город не найден')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = widget.state is SearchButtonState$LoadingCities;

    final SearchButtonState$Ready? readyState =
        widget.state is SearchButtonState$Ready
        ? widget.state as SearchButtonState$Ready
        : null;

    final bool hasCitiesError = readyState?.hasCitiesError ?? false;
    final List<ListCitiesModel> suggestions =
        readyState?.suggestions ?? const <ListCitiesModel>[];

    final String hintText = isLoading
        ? 'Загрузка списка городов...'
        : hasCitiesError
        ? 'Список городов не загружен'
        : 'Поиск города или аэропорта';

    final bool isEnabled = !isLoading && !hasCitiesError;

    return Autocomplete<ListCitiesModel>(
      textEditingController: _controller,
      focusNode: _focusNode,
      displayStringForOption: (city) => city.city,
      optionsViewOpenDirection: OptionsViewOpenDirection.up,
      optionsBuilder: (value) {
        if (!isEnabled || value.text.trim().isEmpty) {
          return const Iterable<ListCitiesModel>.empty();
        }

        return suggestions;
      },
      onSelected: (city) {
        widget.onSelectedCity(city);
        _controller.clear();
        _focusNode.unfocus();
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return Container(
          key: _fieldKey,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(80),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: isEnabled,
            textInputAction: TextInputAction.search,
            onChanged: widget.onQueryChanged,
            onSubmitted: (_) => _submitFirstSuggestion(
              suggestions,
              hasCitiesError,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final items = options.toList(growable: false);

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        final Size screenSize = MediaQuery.sizeOf(context);
        final RenderBox? renderBox =
            _fieldKey.currentContext?.findRenderObject() as RenderBox?;
        final double fieldTop =
            renderBox?.localToGlobal(Offset.zero).dy ?? screenSize.height * 0.8;
        final double overlayHeight = fieldTop.clamp(0.0, screenSize.height);

        return Material(
          color: Colors.black,
          child: SizedBox(
            width: screenSize.width,
            height: overlayHeight,
            child: SafeArea(
              bottom: false,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                itemCount: items.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
                itemBuilder: (context, index) {
                  final city = items[index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    title: Text(
                      city.city,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () => onSelected(city),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
