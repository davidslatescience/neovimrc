; extends

(
  (object) @object
)

; object
(
  (object) @_start @_start
  (#make-range! "class_or_object_name" @_start @_start)
)

; value
([
  (pair
  	value: (string (string_content) @json_value.inner) @json_value)
  (pair
  	value: (number) @json_value @json_value.inner)
    (pair
  	value: (true) @json_value @json_value.inner)
        (pair
  	value: (false) @json_value @json_value.inner)
]
)


; key
(
  (pair key: (string (string_content) @json_key.inner) @json_key)
)

; assignment_lhs
(
  (pair key: (string (string_content) @assignment_lhs_inner) @assignment_lhs_outer)
)

; assignment_rhs
([
  (pair
  	value: (string (string_content) @assignment_rhs_inner) @assignment_rhs)
  (pair
  	value: (number) @assignment_rhs @assignment_rhs_inner)
    (pair
  	value: (true) @assignment_rhs @assignment_rhs_inner)
        (pair
  	value: (false) @assignment_rhs @assignment_rhs_inner)
]
)

; class_or_object_name
; (object
;   . (pair 
;     key: (string
;             (string_content) @class_or_object_name)))

