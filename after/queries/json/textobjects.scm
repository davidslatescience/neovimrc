; extends


; object
(
  (object) @_start @_start
  (#make-range! "json_object" @_start @_start)
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


