(library (enums)
  (export define-enum define-enum-transformer define-flags-transformer)
  (import (rnrs (6))
          (rename (cut) (cut $))
          (only (srfi srfi-43) vector-index)
          (functional)
          (gen-id))

  (define-syntax define-enum-helper
    (lambda (x)
      (syntax-case x ()
        ((_ <x>) #'(begin))
        ((_ <x> <a> <as> ...)
         (let ((x (syntax->datum #'<x>)))
           #`(begin (define <a> <x>)
                    (define-enum-helper #,(+ x 1) <as> ...)))))))

  (define-syntax define-enum
    (lambda (x)
      (syntax-case x ()
        ((_ <as> ...)
         #'(define-enum-helper 0 <as> ...)))))

  (define-syntax define-enum-transformer
    (lambda (x)
      (syntax-case x ()
        ((y <T> <as> ...)
         (with-syntax ((<T->symbol> (gen-id #'y #'<T> "->symbol"))
                       (<symbol->T> (gen-id #'y "symbol->" #'<T>)))
           #'(begin
               (define (<T->symbol> i)
                 (vector-ref #(<as> ...) i))
               (define (<symbol->T> s)
                 (vector-index (lambda (t) (eq? s t))
                               #(<as> ...)))))))))

  (define-syntax define-flags-transformer
    (lambda (x)
      (syntax-case x ()
        ((y <T> <flags> ...)
         (with-syntax ((<T->symbols> (gen-id #'y #'<T> "->symbols"))
                       (<symbols->T> (gen-id #'y "symbols->" #'<T>)))
           #'(begin
               (define (<T->symbols> value)
                 (let loop ((symbols '(<flags> ...))
                            (i       1)
                            (result  '()))
                   (cond
                     ((null? symbols) result)
                     ((zero? (bitwise-and i value))
                      (loop (cdr symbols) (* 2 i) result))
                     (else
                      (loop (cdr symbols) (* 2 i) (cons (car symbols) result))))))

               (define (<symbols->T> flags)
                 (let loop ((symbols '(<flags> ...))
                            (i       1)
                            (result  0))
                   (cond
                     ((null? symbols) result)
                     ((memq (car symbols) flags)
                      (loop (cdr symbols) (* 2 i) (bitwise-ior result i)))
                     (else
                      (loop (cdr symbols) (* 2 i) result)))))))))))
)
