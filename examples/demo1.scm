
(import (rnrs (6))
        (srfi :48)

        (glfw basic)
        (glfw constants)
        (glfw gl GL_VERSION_3_0)
        (glfw gl support)

        (lyonesse functional)
        (lyonesse munsch array)
        (lyonesse munsch linear-algebra)
        (lyonesse foreign-data)
        (lyonesse strings)
        
        (only (chezscheme) foreign-alloc foreign-ref foreign-free
                           foreign-sizeof unbox
                           define-ftype ftype-ref ftype-&ref ftype-set! ftype-sizeof
                           ftype-pointer-address make-ftype-pointer))

(unless (glfw-init)
  (exit))

(format #t "Initialised GLFW: ~a\n" (glfw-get-version-string))

(glfw-set-error-callback (lambda (errc msg)
  (format #t "ERROR ~a: ~a" errc msg)))

(define (key-event window key scancode action mods)
  (cond
    [(= key GLFW_KEY_ESCAPE) (glfw-set-window-should-close window #t)]))

(define (text . lines) (string-join "\n" lines))

(define vertex-shader-text
  (text
    "uniform mat4 MVP;"
    "attribute vec3 vCol;"
    "attribute vec2 vPos;"
    "varying vec3 color;"
    "void main()"
    "{"
    "    gl_Position = MVP * vec4(vPos, 0.0, 1.0);"
    "    color = vCol;"
    "}"))

(define fragment-shader-text
  (text
    "varying vec3 color;"
    "void main()"
    "{"
    "    gl_FragColor = vec4(color, 1.0);"
    "}"))

(define vertices
  (vector->array 'float
    '#(#(-0.6 -0.4 1.0 0.0 0.0)
       #( 0.6 -0.4 0.0 1.0 0.0)
       #( 0.0  0.6 0.0 0.0 1.0))))

(define l:4x4:I
  (l:eye 4))

(define (l:4x4:ortho l r b t n f)
  (l:m ((/ 2 (- r l))        0                   0                  0)
       ( 0                  (/ 2 (- t b))        0                  0)
       ( 0                   0                  (/ 2 (- f n))       0)
       ((/ (+ r l) (- l r)) (/ (+ t b) (- b t)) (/ (+ f n) (- n f)) 1)))

(define (l:4x4:rotate-z M alpha)
  (let* ([c (cos alpha)]
         [s (sin alpha)]
         [R (l:m (   c  s 0 0)
                 ((- s) c 0 0)
                 (   0  0 1 0)
                 (   0  0 0 1))])
    (l:* M R)))

(define (program-loop window program mvp-location)
  (let-values ([(width height) (glfw-get-framebuffer-size window)])
    (unless (glfw-window-should-close window)
      (let* ([ratio (/ width height)]
             [time  (glfw-get-time)]
             [mvp   (l:* (l:4x4:ortho (- ratio) ratio -1 1 1 -1)
                         (l:4x4:rotate-z l:4x4:I time))])

        (glViewport 0 0 width height)
        (glClear GL_COLOR_BUFFER_BIT)

        (gl:check glUseProgram program)
        (gl:check glUniformMatrix4fv mvp-location 1 GL_FALSE (l:matrix-data mvp))
        (gl:check glDrawArrays GL_TRIANGLES 0 3)

        (glfw-swap-buffers window)
        (glfw-poll-events)
        (program-loop window program mvp-location)))))

(let ((window (glfw-create-window 640 480 "Hello World" 0 0)))
  (unless window
    (glfw-terminate)
    (exit))

  (glfw-set-window-close-callback window 
    (lambda (w) (format #t "Goodbye!\n")))

  (glfw-set-key-callback window key-event)

  (format #t "Initialised OpenGL context.\n")
  (glfw-set-input-mode window GLFW_STICKY_KEYS GLFW_FALSE)
  (glfw-make-context-current window)
  (glfw-swap-interval 1)

  (let* ([vertex-shader-src   (string->char* vertex-shader-text)]
         [vertex-shader-ptr   (deref 'uptr vertex-shader-src)]
         [fragment-shader-src (string->char* fragment-shader-text)]
         [fragment-shader-ptr (deref 'uptr fragment-shader-src)]
         
         [vertex-buffer   (get-value-by-ref 'unsigned-int ($ glGenBuffers 1 <>))]
         [vertex-shader   (glCreateShader GL_VERTEX_SHADER)]
         [fragment-shader (glCreateShader GL_FRAGMENT_SHADER)])

    (glBindBuffer GL_ARRAY_BUFFER vertex-buffer)
    (glBufferData GL_ARRAY_BUFFER 
                  (array-byte-size vertices) (array-data-ptr vertices)
                  GL_STATIC_DRAW)

    (glShaderSource vertex-shader 1 (unbox vertex-shader-ptr) 0)
    (glCompileShader vertex-shader)
    (gl:check-compile-error "vertex shader" vertex-shader)

    (glShaderSource fragment-shader 1 (unbox fragment-shader-ptr) 0)
    (glCompileShader fragment-shader)
    (gl:check-compile-error "fragment shader" fragment-shader)

    (let* ([program (glCreateProgram)])
      (glAttachShader program vertex-shader)
      (glAttachShader program fragment-shader)
      (gl:check glLinkProgram  program)

      (let* ([mvp-location  (gl:check glGetUniformLocation program "MVP")]
             [vpos-location (gl:check glGetAttribLocation program "vPos")]
             [vcol-location (gl:check glGetAttribLocation program "vCol")])

        (gl:check glEnableVertexAttribArray vpos-location)
        (gl:check glVertexAttribPointer vpos-location 2 GL_FLOAT GL_FALSE 20 0)

        (gl:check glEnableVertexAttribArray vcol-location)
        (gl:check glVertexAttribPointer vcol-location 3 GL_FLOAT GL_FALSE 20 8)

        (program-loop window program mvp-location)))

  (glfw-terminate)))
  
