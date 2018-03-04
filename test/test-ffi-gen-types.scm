(import (rnrs (6))
        (srfi :48)
        (parsing xml)
        (gl-ffi-gen types)
        (gl-ffi-gen private utility)
        (chez-test assertions))

(define (alist? lst)
  (and (list? lst)
       (all? pair? lst)))

(define-syntax log-do
  (syntax-rules ()
    ((_ expr ...)
     (begin (display '(expr ...)) (newline)
            (expr ...)))))

(define (test-types)
  (let* ((registry (document-root (xml:read "registry/gl.xml")))
         (types    (get-types registry)))
    (assert-predicate alist? types)
    (assert-all (lambda (p)
                  (and (string? (car p))
                       (symbol? (cdr p))))
                types)))