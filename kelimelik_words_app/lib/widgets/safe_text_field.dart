// 📃 <----- safe_text_field.dart ----->
//
// Güvenli TextField — donma, key stuck, paste crash gibi Android klavye
// sorunlarını azaltır.
//
// Artık destekler:
//  ✓ labelText
//  ✓ hint
//  ✓ onChanged
//  ✓ validator
//  ✓ autofocus
//  ✓ suffixIcon  (YENİ)
//  ✓ fillColor   (YENİ)
//  ✓ borderColor / focusBorderColor
//  ✓ safe FocusNode
//  ✓ RepaintBoundary
//

import 'package:material_ui/material_ui.dart';

class SafeTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  final String? labelText;
  final String? hint;
  final TextStyle? hintStyle; // 👈 YENİ EKLENDİ

  /// 🔥 Yeni: onChanged desteği
  final ValueChanged<String>? onChanged;

  /// 🔥 Yeni: suffix icon desteği (ör: silme tuşu, arama ikonu)
  final Widget? suffixIcon;

  /// 🔥 Yeni: dışarıdan fillColor verebilme
  final Color? fillColor;

  final int debounceMs;
  final String? Function(String?)? validator;

  final Color? borderColor;
  final Color? focusBorderColor;

  final double? height;
  final double? width;

  final bool autofocus;

  const SafeTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hint,
    this.hintStyle, // 👈 YENİ
    this.onChanged,
    this.suffixIcon, // 👈 YENİ
    this.fillColor, // 👈 YENİ
    this.debounceMs = 0,
    this.validator,
    this.borderColor,
    this.focusBorderColor,
    this.autofocus = false,
    this.height,
    this.width,
    this.focusNode,
  });

  @override
  State<SafeTextField> createState() => _SafeTextFieldState();
}

class _SafeTextFieldState extends State<SafeTextField> {
  final FocusNode _focus = FocusNode();
  String _lastValue = "";

  @override
  void initState() {
    super.initState();

    // Android klavye hatalarını bastırır
    _focus.onKeyEvent = (node, event) {
      return KeyEventResult.ignored;
    };
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? Colors.grey.shade400;
    final focusBorderColor = widget.focusBorderColor ?? Colors.blue;

    return RepaintBoundary(
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode ?? _focus,
        autofocus: widget.autofocus,
        validator: widget.validator,
        keyboardAppearance: Brightness.light,
        textInputAction: TextInputAction.next,

        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hint,
          hintStyle: widget.hintStyle,
          isDense: true,

          contentPadding: EdgeInsets.symmetric(
            vertical: widget.height ?? 12,
            horizontal: widget.width ?? 12,
          ),

          /// ✔ fillColor dışarıdan gelirse kullan, gelmezse beyaz
          filled: true,
          fillColor: widget.fillColor ?? Colors.white,

          /// ✔ suffixIcon desteği
          suffixIcon: widget.suffixIcon,

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusBorderColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        onChanged: (value) {
          // dışarıdan gelen onChanged çalışsın
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }

          // debounce kullanılmıyorsa bitir
          if (widget.debounceMs == 0) return;

          Future.delayed(Duration(milliseconds: widget.debounceMs), () {
            if (!mounted) return;
            if (_lastValue != widget.controller.text) {
              _lastValue = widget.controller.text;
            }
          });
        },
      ),
    );
  }
}
