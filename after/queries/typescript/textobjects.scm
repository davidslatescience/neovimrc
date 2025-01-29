; extends

; Method name
(method_signature
  name: (property_identifier) @method_name)
(method_definition
  name: (property_identifier) @method_name)

; Method (including docstring)
(
  (comment)? @_start
  .
  (method_definition) @_end
  (#make-range! "method" @_start @_end)
)

; Function call name
(member_expression
  property: (property_identifier) @function_call_name)

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

; Types
(type_annotation
  (_) @type_identifier
)
(type_identifier) @type_identifier
(predefined_type) @type_identifier
(extends_clause
  value: (_) @type_identifier)

; Assignment LHS
(lexical_declaration
  (variable_declarator 
    name: (_) @assignment_lhs_inner
  )
) @assignment_lhs_outer
(expression_statement
  (assignment_expression 
    left: (member_expression
           property: (property_identifier) @assignment_lhs_inner) 
  )
) @assignment_lhs_outer
(expression_statement
  (assignment_expression 
    left: (identifier) @assignment_lhs_inner 
  )
) @assignment_lhs_outer
(public_field_definition
    name: (_) @assignment_lhs_inner
) @assignment_lhs_outer


; Assignment RHS
(lexical_declaration
  (variable_declarator 
    value: (_) @assignment_rhs_inner @assignment_rhs_outer
  )
) 
(expression_statement
  (assignment_expression 
    right: (_) @assignment_rhs_inner @assignment_rhs_outer
  )
)
(public_field_definition
    value: (_) @assignment_rhs_inner
) @assignment_rhs_outer

; Class or object name 
(class_declaration
  name: (type_identifier) @class_or_object_name)
(interface_declaration
  name: (type_identifier) @class_or_object_name)

; If statement condition (within the parenthesized expression)
(if_statement 
  condition: (parenthesized_expression (_) @if_statement_condition_inner) @if_statement_condition_outer)

; Statement block
(statement_block . (_) @statement_block_start)

; Comments
(comment) @comment_inner
; It looks like the inner nodes of a comment aren't available, even though they are there when using :InspectTree
; (
;  (comment
;  (_)) @comment_inner)

; Variables
(identifier) @variable_outer
