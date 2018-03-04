(library (gl-ffi-gen private utility)
  (export all? any? compose <<= pipe unique-sorted)
  (import (rnrs (6)))

  (define (compose f . rest)
    (fold-left
      (lambda (f g)
        (lambda a
          (call-with-values (lambda () (apply g a)) f)))
      f rest))

  (define (<<= x)
    (apply values x))

  (define any? find)

  (define (all? f x)
    (not (any? (compose not f) x)))

  (define (pipe x . fs)
    ((apply compose (reverse fs)) x))

  (define (unique-sorted =? lst)
    (fold-right
      (lambda (item lst)
        (if (or (null? lst)
                (not (=? item (car lst))))
          (cons item lst)
          lst))
      '() lst))
)
