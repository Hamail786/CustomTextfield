import 'package:flutter/material.dart';
import '../../Utils/App Theme/App Colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final String text;
  final IconData icon;

  CustomTextField({
    required this.controller,
    required this.textInputType,
    required this.text, required this.icon,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;
  final _form = GlobalKey<FormState>();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    // Check if it's a email field
    if (widget.textInputType == TextInputType.emailAddress && widget.controller is TextEditingController) {
      obscureText = false;
    }
    // Check if it's a name  field
    if (widget.textInputType == TextInputType.name && widget.controller is TextEditingController) {
      obscureText = false;
    }
    // Check if it's a password field
    if (widget.textInputType == TextInputType.visiblePassword) {
      obscureText = false;
    }
    // Add a listener to the text controller for real-time validation
    widget.controller.addListener(_saveForm);
  }
   @override
  void dispose() {
    // Clean up the listener when the widget is disposed
    widget.controller.removeListener(_saveForm);
    super.dispose();
  }


//--- To save the form
  void _saveForm() {
    setState(() {
      _isValid = _form.currentState!.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _form,
        child: TextFormField(
          validator: (value) {
            // Check if this field is empty
      if (widget.textInputType == TextInputType.emailAddress) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
      }
            // Using regular expression
            if (widget.textInputType == TextInputType.emailAddress) {
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
                return 'Please enter a valid email address';
              }
            }

            // the email is valid
            return null;
          },
          onChanged: (_) => _saveForm(),
      controller: widget.controller,
      //----TextField Text Color and Style
      style: TextStyle(
        color: AppColors.appColor,
      ),
      autofocus: false,
      keyboardType: widget.textInputType,
      // Type of keyboard e.g email, number, text
      decoration: InputDecoration(
        hintText: widget.text,
        hintStyle: TextStyle(color: AppColors.appColor.withOpacity(0.5)),
        prefixIcon:Icon(widget.icon,color: AppColors.appColor,size: 25,) ,
        // Suffix Icon for password
        suffixIcon: widget.textInputType == TextInputType.visiblePassword
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppColors.appColor,
          ),
          onPressed: () {
            // Toggle the password visibility
            setState(() {
              obscureText = !obscureText;
            });
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: false, // filled false so the text-field has no color, otherwise having gray filled color
        enabledBorder: OutlineInputBorder(
          //----- Enable Border when there's no text in text-field
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(width: 2, color: AppColors.appColor),
        ),
        focusColor: AppColors.appColor, // ---- color of the border when writing in the text field
        focusedBorder: OutlineInputBorder(
          // ----focus border color
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(width: 2, color: AppColors.appColor),
        ),
      ),
      obscureText: obscureText,
        )
    );
  }
}

