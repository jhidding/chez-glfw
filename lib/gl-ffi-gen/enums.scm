(library (gl-ffi-gen enums)

  (export get-enums
          enum? enum-name enum-value enum-group)

  (import (rnrs base (6))
          (rnrs lists (6))
          (rnrs io simple (6))
          (rnrs records syntactic (6))
          (rnrs hashtables (6))

          (parsing xml)
          (gl-ffi-gen private utility))

  (define (list-enums registry)
    (xml:get-all registry 'enums `(group . ,values)))

  (define (list-ungrouped-enums registry)
    (xml:get-all registry 'enums `(group . #f)))

  (define (parse-hex s)
    (let* ((s1 (substring s 1 (string-length s)))
           (s2 (string-append "#" s1)))
      (string->number s2)))

  (define (parse-num s)
    (if (and (< 2 (string-length s)) (eq? (string-ref s 1) #\x))
      (parse-hex s)
      (string->number s)))

  (define (get-enum enums)
    (let ([api-check (lambda (enum)
                       (let ((api (xml:get-attr enum 'api)))
                         (or (not api) (equal? api "gl"))))])
      (map (lambda (enum)
             (cons (xml:get-attr enum 'name)
                   (parse-num (xml:get-attr enum 'value))))
           (filter api-check (xml:get-all enums 'enum)))))

  (define (get-enum-groups registry)
    (cons
      (cons "ungrouped"
            (apply append (map get-enum
                               (list-ungrouped-enums registry))))
      (map (lambda (enums)
             (cons (xml:get-attr enums 'group)
                   (get-enum enums)))
           (list-enums registry))))

  (define-record-type enum
    (fields name value group))

  (define (get-enums registry)
    (let ([groups (get-enum-groups registry)]
          [enums  (make-hashtable string-hash equal?)])
      (for-each (lambda (group)
        (for-each (lambda (enum)
          (hashtable-set! enums (car enum)
                          (make-enum (car enum) (cdr enum) (car group))))
          (cdr group)))
        groups)
      enums))
)
