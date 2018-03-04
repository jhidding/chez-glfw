(import (rnrs (6))
        (srfi :48)
        (parsing xml)
        (gl-ffi-gen types)
        (gl-ffi-gen enums)
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

(define registry
  (document-root (xml:read "registry/gl.xml")))

(define (test-types)
  (let* ((types    (get-types registry)))
    (assert-predicate alist? types)
    (assert-all (lambda (p)
                  (and (string? (car p))
                       (symbol? (cdr p))))
                types)))

(define (test-enums)
  (let* ((enums    (get-enums registry)))
    (assert-predicate hashtable? enums)
    (assert-equal (enum-value (hashtable-ref enums "GL_FALSE" #f)) 0)
    (assert-equal (enum-value (hashtable-ref enums "GL_TRUE" #f)) 1)))
