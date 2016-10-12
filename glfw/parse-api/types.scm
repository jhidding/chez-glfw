(library (glfw parse-api types)
  (export get-types translate-ctype)

  (import (rnrs base (6))
          (rnrs lists (6))
          (rnrs control (6))
          (lyonesse match)
          (lyonesse functional)
          (lyonesse parsing xml)
          (only (srfi :13) string-tokenize string-join string-prefix?))

  (define (get-simple-type type) 
    (match type
      [(type (,attrs ...) ,def (name () ,name) ,semi-colon)
       (and name def (cons name (translate-ctype (cdr (string-tokenize def)))))]
      [,x #f]))

  (define khronos_types
    '(("khronos_int8_t"     . integer-8)
      ("khronos_uint8_t"    . unsigned-8)
      ("khronos_int16_t"    . integer-16)
      ("khronos_uint16_t"   . unsigned-16)
      ("khronos_int32_t"    . integer-32)
      ("khronos_uint32_t"   . unsigned-32)
      ("khronos_int64_t"    . integer-64)
      ("khronos_uint64_t"   . unsigned-64)
      ("khronos_intptr_t"   . iptr)
      ("khronos_uintptr_t"  . uptr) 
      ("khronos_ssize_t"    . ssize_t)
      ("khronos_usize_t"    . size_t)
      ("khronos_float_t"    . float)))

  (define stdint_types
    '(("int8_t"             . integer-8)
      ("uint8_t"            . unsigned-8)
      ("int16_t"            . integer-16)
      ("uint16_t"           . unsigned-16)
      ("int32_t"            . integer-32)
      ("uint32_t"           . unsigned-32)
      ("int64_t"            . integer-64)
      ("uint64_t"           . unsigned-64)))

  (define stdc_types
    '(("void"               . void)
      ("char"               . char)
      ("signed char"        . integer-8)
      ("unsigned char"      . unsigned-8)
      ("short"              . short)
      ("unsigned short"     . unsigned-short)
      ("int"                . int)
      ("unsigned int"       . unsigned-int)
      ("long"               . long)
      ("unsigned long"      . unsigned-long)
      ("long long"          . long-long)
      ("unsigned long long" . unsigned-long-long)
      ("ptrdiff_t"          . ptrdiff_t)
      ("size_t"             . size_t)
      ("float"              . float)
      ("double"             . double)))

  (define ptr_types
    '(("void *"             . uptr)))

  (define (translate-ctype type)
    (let ([type-str (string-join type)])
      (cond
        [(assoc type-str khronos_types) => cdr]
        [(assoc type-str stdint_types)  => cdr]
        [(assoc type-str stdc_types)    => cdr]
        [(assoc type-str ptr_types)     => cdr]
        [(string-prefix? "struct" type-str) 'uptr]
        [else type-str])))

  (define (resolve-self-ref types)
    (map (lambda (typedef)
           (if (string? (cdr typedef))
             (cons (car typedef) (cdr (assoc (cdr typedef) types)))
             typedef)) types))

  (define extract-types
    (compose resolve-self-ref 
             ($ filter id <>) 
             ($ map get-simple-type <>)
             xml:get))

  (define get-types
    (case-lambda
      [(registry)     (extract-types (xml:get* registry '(registry ()) '(types ()))
                                     'type '((api . #f)))]
      [(registry api) (extract-types (xml:get* registry '(registry ()) '(types ()))
                                     'type `((api . ,api)))]))
)
