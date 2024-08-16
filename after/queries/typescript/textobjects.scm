; extends

; Method name
(method_definition
  name: (property_identifier) @method_name)

; Method with docstring
(
  (comment)? @_start
  .
  (method_definition) @_end
  (#make-range! "method_with_optional_docstring" @_start @_end)
)

; Class constant
(
  (comment)? @class_constant_comment
  .
  (public_field_definition
    name: (property_identifier) @class_constant_name) @class_constant_property
  (#match? @class_constant_property "static readonly")
  (#make-range! "class_constant" @class_constant_comment @class_constant_property)
)

; Section header
(
  (comment) @section_header_start
  .
  (comment) @section_header_fold
  (#match? @section_header_fold "<editor-fold")
  (#make-range! "section_header" @section_header_start @section_header_fold)
)

; Section footer
(
  (comment) @section_footer
  (#eq? @section_footer "//</editor-fold>")
)


