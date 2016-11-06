
(import (rnrs (6))
        (glfw basic)
        (glfw constants)
        (glfw gl GL_VERSION_3_0)
        (srfi :48)

        (only (chezscheme) foreign-alloc foreign-ref foreign-free
                           foreign-sizeof))

(unless (glfw-init)
  (exit))

(format #t "Initialised GLFW: ~a\n" (glfw-get-version-string))

(glfw-set-error-callback (lambda (errc msg)
  (format #t "ERROR ~a: ~a" errc msg)))

(define-syntax using
  (syntax-rules (do)
    [(_ <env> do <expr1> ...)
     (eval '(begin <expr1> ...) <env>)]))

(define (key-event window key scancode action mods)
  (let ([action-str (cond
                      [(= action GLFW_PRESS) "press"]
                      [(= action GLFW_REPEAT) "repeat"]
                      [(= action GLFW_RELEASE) "release"]
                      [else "<unknown>"])])
    (format #t "~a: ~a ~a ~a\n" action-str key scancode mods)
    (cond
      [(= key GLFW_KEY_ESCAPE) (glfw-set-window-should-close window #t)])))


(define (char-event window codepoint)
  (format #t "input: ~a\n" (integer->char codepoint)))

(define (program-loop window)
  (unless (glfw-window-should-close window)
    (glClearColor 0.8 0.1 0.4 1.0)
    (glClear GL_COLOR_BUFFER_BIT)
    (glfw-swap-buffers window)
    (glfw-poll-events)
    (program-loop window)))

(let ((window (glfw-create-window 640 480 "Hello World" 0 0)))
  (unless window
    (glfw-terminate)
    (exit))

  (glfw-set-window-close-callback window
    (lambda (w) (format #t "Goodbye!\n")))

  (glfw-set-key-callback window key-event)
  (glfw-set-char-callback window char-event)

  (format #t "Initialised OpenGL context.\n")
  (glfw-set-input-mode window GLFW_STICKY_KEYS GLFW_FALSE)
  (glfw-make-context-current window)
  (glfw-swap-interval 1)

  (display (glGetString GL_VERSION)) (newline)

  (program-loop window)
  (glfw-terminate))

