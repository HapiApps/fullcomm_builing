import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullcomm_billing/res/components/k_text.dart';
import 'package:fullcomm_billing/utils/sized_box.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';

import 'dart:async';

class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.inputFormatters,
    this.suffixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.height,
    this.labelText,
    this.width,
    this.prefixIcon,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization,
    this.enabled,
    this.autofocus,
    this.obscureText,
    this.autofillHints,
    this.textAlign,
    this.maxLines,
    this.minLines,
    required this.isOptional,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final double? height;
  final String? labelText;
  final String? hintText;
  final double? width;
  final bool? enabled;
  final int? maxLines;
  final int? minLines;
  final bool? autofocus;
  final bool? obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final bool isOptional;
  final Widget? prefixIcon;
  final TextCapitalization? textCapitalization;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final Iterable<String>? autofillHints;
  final TextAlign? textAlign;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();

    // ✅ Web-safe autofocus
    if (widget.autofocus == true) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: widget.height ?? screenHeight * 0.08,
      width: widget.width ?? screenWidth * 0.35,
      child: TextFormField(
        controller: widget.controller,
        style: GoogleFonts.lato(fontSize: 14),
        textCapitalization:
        widget.textCapitalization ?? TextCapitalization.none,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        autofocus: false, // ✅ handled manually above
        obscureText: widget.obscureText ?? false,
        obscuringCharacter: '•',
        textAlign: widget.textAlign ?? TextAlign.start,
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.textFieldBackground,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText(text: widget.labelText ?? ""),
              widget.isOptional == false
                  ? const MyText(
                text: "*",
                color: Colors.red,
                fontSize: 20,
              )
                  : 0.height,
            ],
          ),
          labelStyle: GoogleFonts.lato(),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.lato(),
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          contentPadding: const EdgeInsets.fromLTRB(10, 30, 5, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              width: 0,
              color: AppColors.textFieldBackground,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              width: 0,
              color: AppColors.textFieldBackground,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              width: 0,
              color: AppColors.primary,
            ),
          ),
        ),
        onChanged: widget.onChanged,
        autofillHints: widget.autofillHints,
        onFieldSubmitted: widget.onFieldSubmitted,
        onEditingComplete: widget.onEditingComplete,
        enabled: widget.enabled ?? true,
      ),
    );
  }
}

