(library (gl-ffi-gen features)

  (export get-features
          feature? feature-name feature-number
          feature-require-enums feature-require-commands
          feature-remove-enums feature-remove-commands
          extend-commands extend-enums)

  (import (rnrs base (6))
          (rnrs lists (6))
          (rnrs sorting (6))
          (rnrs records syntactic (6))

          (parsing xml)

          (gl-ffi-gen private cut)
          (gl-ffi-gen private utility))

  (define-record-type feature
    (fields name number require-enums require-commands
            remove-enums remove-commands)

    (protocol
      (lambda (new)
        (lambda (f)
          (let ([name         (xml:get-attr f 'name)]
                [number       (string->number (xml:get-attr f 'number))]
                [req-enums    (map (cut xml:get-attr <> 'name)
                                   (xml:get-all-path f '(require) '(enum)))]
                [req-commands (map (cut xml:get-attr <> 'name)
                                   (xml:get-all-path f '(require) '(command)))]
                [rem-enums    (map (cut xml:get-attr <> 'name)
                                   (xml:get-all-path f '(remove) '(enum)))]
                [rem-commands (map (cut xml:get-attr <> 'name)
                                   (xml:get-all-path f '(remove) '(command)))])
            (new name number req-enums req-commands rem-enums rem-commands))))))

  (define (unique lst)
    (unique-sorted
      string=?
      (list-sort string<? lst)))

  (define (extend-commands commands feature)
    (unique
      (append
        (remp (cut member <> (feature-remove-commands feature)) commands)
        (feature-require-commands feature))))

  (define (extend-enums enums feature)
    (unique
      (append
        (remp (cut member <> (feature-remove-enums feature)) enums)
        (feature-require-enums feature))))

  (define (list-features features n)
    (let* ([check-version (lambda (f) (<= (feature-number f) n))]
           [commands (fold-left extend-commands '()
                                 (filter check-version features))]
           [enums    (fold-left extend-enums '()
                                 (filter check-version features))])
      (values commands enums)))

  (define (get-features registry)
    (let ([features (xml:get-all registry 'feature '(api . "gl"))])
      (map make-feature features)))
)

