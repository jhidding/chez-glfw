(library (glfw parse-api enums)

  (export get-enums
          enum? enum-name enum-value enum-group)

  (import (rnrs base (6))
          (rnrs lists (6))
          (rnrs records syntactic (6))
          (rnrs hashtables (6))

          (lyonesse parsing xml)
          (lyonesse functional))

  (define (list-enums registry)
    (append
      (xml:list registry '(registry) `(enums (group . ,id)))))

  (define (list-ungrouped-enums registry)
      (xml:list registry '(registry) `(enums (group . #f))))

  (define (parse-hex s)
    (let* ((s1 (substring s 1 (string-length s)))
           (s2 (string-append "#" s1)))
      (string->number s2)))

  (define (parse-num s)
    (if (and (< 2 (string-length s)) (eq? (string-ref s 1) #\x))
      (parse-hex s)
      (string->number s)))

  (define (get-enum registry enums)
    (let ([api-check (lambda (api)
                       (or (not api) (equal? api "gl")))])
      (map (lambda (enum)
             (cons (xml:get-attr enum 'name)
                   (parse-num (xml:get-attr enum 'value))))
           (xml:list* registry '(registry ()) enums `(enum ((api . ,api-check)))))))

  (define (get-enum-groups registry)
    (cons
      (cons "ungrouped"
            (apply append (map ($ get-enum registry <>) (list-ungrouped-enums registry))))
      (map (lambda (enums)
             (cons (xml:get-attr (list (car enums) (cdr enums)) 'group)
                   (get-enum registry enums)))
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
