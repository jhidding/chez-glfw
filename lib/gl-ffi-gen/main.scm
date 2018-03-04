(import (rnrs (6))
        (parsing xml)
        (gl-ffi-gen private utility)
        (gl-ffi-gen private cut)

        (gl-ffi-gen types)
        (gl-ffi-gen enums)
        (gl-ffi-gen commands)
        (gl-ffi-gen features)

        (srfi :48)

        (only (chezscheme) pretty-print pretty-line-length
                           pretty-one-line-limit
                           mkdir file-directory?
                           path-parent))

(define registry
  (document-root (xml:read (cadr (command-line)))))

(define (ensure-directory-exists path)
  (if (not (file-directory? path))
    (begin
      (ensure-directory-exists (path-parent path))
      (mkdir path))))

#| Patch the type definitions. 
 | The XML specs contain this entry for GLhandleARB:
 |   #ifdef __APPLE__
 |       typedef void *GLhandleARB;
 |   #else
 |       typedef unsigned int GLhandleARB;
 |   #endif
 | IMNSHO this is insane. I'm not going to parse C precompiler stuff,
 | especially not for a single entry or shitty Apple.
 |#
(define (patch-types types)
  (cons '("GLhandleARB" . unsigned-int)
        (remp (compose (cut equal? "GLhandleARB" <>) car) types)))

(define (write-lines port . lines)
  (for-each (lambda (l)
    (cond
      [(string? l) (format port "~a~%" l)]
      [(list? l)   (apply write-lines port l)]))
    lines))

(define (raw-type type)
  (case (type-category type)
    [(unit)                             (type-name type)]
    [(pointer) (case (type-name type)
                 [(char integer-8 unsigned-8) 'string]
                 [else                        'uptr])]
    [(pointer-to-pointer array) 'uptr]))

(define (command-typedef command)
  `(define-ftype
    ,(string->symbol (string-append (command-name command) "-ftype"))
    (function ,(map (compose raw-type cdr)
                    (command-arguments command))
              ,(raw-type (command-return-type command)))))

(define (command-definition command)
  (let ([name        (command-name command)]
        [arguments   (command-arguments command)]
        [return-type (command-return-type command)])
    `(define ,(string->symbol name)
       (foreign-procedure ,name
                          ,(map (compose raw-type cdr) arguments)
                          ,(raw-type return-type)))))

(define (feature-version f)
  (let* ([n (feature-number f)]
         [major (exact (floor n))]
         [minor (exact (* 10 (- n major)))])
    (list major minor)))

(define (write-gl-loaders enums commands features)
  (let loop ([features features]
             [command-lst* '()]
             [enum-lst*    '()])

    (unless (null? features)
      (let* ([f           (car features)]
             [name        (feature-name f)]
             [command-lst (extend-commands command-lst* f)]
             [enum-lst    (extend-enums enum-lst* f)]
             [port        (open-file-output-port (format "lib/gl/~a.scm" name)
                                                 (file-options no-fail)
                                                 'line (native-transcoder))])

        (write-lines port
          (format "(library (gl ~a)" name)
          "  (export"
          (map (cut format "    ~a" <>) command-lst)
          (map (cut format "    ~a" <>) enum-lst)
          "  )"
          ""
          "  (import (rnrs base(6))"
          "          (only (chezscheme) foreign-procedure"
          "                             load-shared-object))"
          ""
          "  (define libGL (load-shared-object \"libGL.so.1\"))"
          ""
          (map (lambda (c)
            (let* ([command (hashtable-ref commands c #f)]
                   [definition (command-definition command)])
              (format "  ~s" definition)))
            command-lst)
          ""
          (map (lambda (e)
            (let* ([enum  (hashtable-ref enums e #f)]
                   [name  e] ; (enum-name enum)]
                   [value (and (enum? enum) (enum-value enum))])
              (if value
                (format "  (define ~a #x~x)" name value)
                (format "  (define ~a #f)  ;;; ENUM NOT FOUND" name))))
            enum-lst)
          ")")

        (close-port port)

        (loop (cdr features) command-lst enum-lst)))))

(define nyi
  '("glCreateSyncFromCLeventARB"
    "glDebugMessageCallback"
    "glDebugMessageCallbackAMD"
    "glDebugMessageCallbackARB"
    "glDebugMessageCallbackKHR"))

(let* ([types    (get-types registry)]
       [types*   (patch-types types)]
       [commands (get-commands registry types*)]
       [enums    (get-enums registry)]
       [features (get-features registry)])
 
  (ensure-directory-exists "lib/gl")
  (write-gl-loaders enums commands features)
)
