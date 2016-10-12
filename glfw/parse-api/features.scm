(library (glfw parse-api features)

  (export get-features
          feature? feature-name feature-number
          feature-require-enums feature-require-commands
          feature-remove-enums feature-remove-commands
          extend-commands extend-enums)

  (import (rnrs base (6))
          (rnrs lists (6))
          (rnrs sorting (6))
          (rnrs records syntactic (6))
          (lyonesse parsing xml)
          (lyonesse functional))

  (define-record-type feature
    (fields name number require-enums require-commands
            remove-enums remove-commands)

    (protocol
      (lambda (new)
        (lambda (registry f)
          (let ([name         (xml:get-attr f 'name)]
                [number       (string->number (xml:get-attr f 'number))]
                [req-enums    (map ($ xml:get-attr <> 'name)
                                   (xml:list* registry '(registry) f '(require) '(enum)))]
                [req-commands (map ($ xml:get-attr <> 'name)
                                   (xml:list* registry '(registry) f '(require) '(command)))]
                [rem-enums    (map ($ xml:get-attr <> 'name)
                                   (xml:list* registry '(registry) f '(remove) '(enum)))]
                [rem-commands (map ($ xml:get-attr <> 'name)
                                   (xml:list* registry '(registry) f '(remove) '(command)))])
            (new name number req-enums req-commands rem-enums rem-commands))))))

  (define (extend-commands commands feature)
    ((compose ($ unique-sorted string=? <>) ($ list-sort string<? <>) append)
     (remp ($ member <> (feature-remove-commands feature)) commands)
     (feature-require-commands feature)))

  (define (extend-enums enums feature)
    ((compose ($ unique-sorted string=? <>) ($ list-sort string<? <>) append)
     (remp ($ member <> (feature-remove-enums feature)) enums)
     (feature-require-enums feature)))

  (define (list-features features n)
    (let* ([check-version (lambda (f) (<= (feature-number f) n))]
           [commands (fold-left extend-commands '()
                                 (filter check-version features))]
           [enums    (fold-left extend-enums '()
                                 (filter check-version features))])
      (values commands enums)))

  (define (get-features registry)
    (let ([features (xml:list registry '(registry) '(feature (api . "gl")))])
      (map ($ make-feature registry <>) features)))
)

