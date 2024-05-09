import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditableRow<T> extends StatefulWidget {
  final IconData? iconData;
  final Function(String)? onChanged;
  final String hintText;
  final bool multiline;
  final T? initialInformation;
  final int? maxLength;

  const EditableRow({
    Key? key,
    this.iconData,
    this.onChanged,
    this.hintText = "",
    this.multiline = false,
    this.initialInformation,
    this.maxLength,
  }) : super(key: key);

  @override
  State<EditableRow> createState() => _EditableRowState();
}

class _EditableRowState extends State<EditableRow> {
  static const double radius = 13;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialInformation != null) _controller.text = widget.initialInformation!;
    if (widget.onChanged != null)
      _controller.addListener(() {
        widget.onChanged!(_controller.text);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
              child: TextFormField(
                enabled: widget.onChanged != null,
                readOnly: widget.onChanged == null,
                controller: _controller,
                keyboardType: widget.multiline ? TextInputType.multiline : TextInputType.text,
                maxLines: widget.multiline ? null : 1,
                decoration: InputDecoration(hintText: widget.hintText, border: InputBorder.none),
                inputFormatters: widget.maxLength != null ? [LengthLimitingTextInputFormatter(widget.maxLength)] : [],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Icon(
              widget.iconData,
              color: widget.onChanged == null ? Colors.grey : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}