(library (glfw parse-api commands)
  (export get-commands print-command
          type? type-name type-category type-len type-group
          command? command-name command-return-type command-arguments)

  (import (rnrs base (6))
          (rnrs io simple (6))
          (rnrs lists (6))
          (rnrs records syntactic (6))
          (rnrs hashtables (6))

          (srfi :48)
          (only (srfi :13) string-tokenize)

          (match)
          (parsing xml)

          (glfw parse-api types))

  (define-record-type command
    (fields name return-type arguments))

  (define-record-type type
    (fields name category len group))

  (define (print-command c)
    (format #t "~a:~%" (command-name c))
    (for-each (lambda (arg)
      (format #t "    ~a: " (car arg)) (print-type (cdr arg)))
      (command-arguments c))
    (format #t "    -> ") (print-type (command-return-type c)))

  (define (print-type t)
    (format #t "~s" (type-name t))
    (case (type-category t)
      [(unit)               (format #t "")]
      [(pointer)            (format #t "*")]
      [(pointer-to-pointer) (format #t "**")]
      [(array)              (format #t "[]")])
    (if (type-len t)
      (format #t " [~s]" (type-len t)))
    (if (type-group t)
      (format #t " (~a)" (type-group t)))
    (newline))

  (define (split-strings lst)
    (apply append
           (map (lambda (i)
                  (if (string? i)
                    (string-tokenize i)
                    (list i)))
                lst)))

  (define (parse-type x type-reg)
    (filter id
      (map (lambda (y)
        (cond
          [(and (pair? y) (eq? (car y) 'ptype))
           (type-reg (caddr y))]
          [(not (string? y))
           (error 'parse-type "Can't handle type description." x)]
          [(equal? y "const") #f]
          [(equal? y "*") '*]
          [(equal? y "**") '**]
          [(equal? y "*const*") '**]
          [(translate-ctype (list y)) => id]
          [else (error 'parse-type "Didn't recognize type name." y x)]))
        x)))

  (define (make-composite-type x len group type-reg p)
    (match (parse-type x type-reg)
      [(,name) (make-type name 'unit len group)]
      [(,name *) (make-type name 'pointer len group)]
      [(,name **) (make-type name 'pointer-to-pointer len group)]
      [,x (error 'make-composite-type "Don't understand." x p)]))

  (define (make-array-type x a group type-reg)
    (let ([len (if (and (string? a) (> (string-length a) 2))
                 (string->number (substring a 1 (- (string-length a) 1))) #f)])
      (match (parse-type x type-reg)
        [(,name) (make-type name 'array len group)]
        [else (error 'make-array-type "Don't understand." x a)])))

  (define (match-param param type-reg)
    (let* ([group (xml:get-attr param 'group)]
           [len*  (xml:get-attr param 'len)]
           [len   (or (and (string? len*) (string->number len*)) len*)])
      (match param
        [(param ,attrs (ptype () ,x) (name () ,name)) (guard (string? x))
         (values name (make-type (type-reg x) 'unit len group))]
        [(param ,attrs ,x ... (name () ,name))
         (values name (make-composite-type (split-strings x) len group type-reg param))]
        [(param ,attrs ,x ... (name () ,name) ,a)
         (values name (make-array-type (split-strings x) a group type-reg))]
        [,x (error 'match-param "Couldn't match param." param)])))

  (define (match-proto p type-reg)
    (let ([group (xml:get-attr p 'group)])
      (match p
        [(proto ,attrs (ptype () ,x) (name () ,name))
         (values name (make-type (type-reg x) 'unit #f group))]
        [(proto ,attrs ,x ... (name () ,name))
         (values name (make-composite-type x #f #f type-reg p))]
        [,x
         (error 'match-proto "Couldn't match proto." p)])))

  (define (command->rec command type-reg)
    (let* ([safe-car (lambda (p) (and (pair? p) (car p)))]
           [proto (safe-car (xml:get-all command 'proto))]
           [param (xml:get-all command 'param)])
      (let-values ([(name type) (match-proto proto type-reg)])
        (make-command
          name type
          (map (compose cons (cut match-param <> type-reg)) param)))))

  (define (get-commands registry type-reg)
    (let* ([command-lst (xml:get-all-path registry '(registry) '(commands (namespace . "GL")))]
           [commands (make-hashtable string-hash equal? (length command-lst))])
      (for-each (lambda (c)
        (hashtable-set! commands (command-name c) c))
        (map (cut command->rec <> type-reg) command-lst))
      commands))
)
