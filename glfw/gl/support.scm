(library (glfw gl support)
  (export gl:check gl:check-error gl:check-compile-error
          gl:get-shader-info-log)

  (import (rnrs base (6))
          (rnrs control (6))
          (rnrs io simple (6))
          (rnrs bytevectors (6))

          (lyonesse foreign-data)

          (only (glfw gl GL_VERSION_2_0) glGetError GL_NO_ERROR glGetShaderInfoLog))

  (define-syntax gl:check
    (syntax-rules ()
      [(_ <func> <args> ...)
       (let ([value (<func> <args> ...)])
         (gl:check-error '<func>)
         value)]))

  (define (gl:check-error symb)
    (let ([errc (glGetError)])
      (unless (= GL_NO_ERROR errc)
        (error symb "ERROR!" errc))))

  (define (gl:check-compile-error name handle) 
    (let ([errc (glGetError)])
      (cond
        [(not (= GL_NO_ERROR errc))
           (error 'glCompileShader "ERROR!" name errc)]
        [(gl:get-shader-info-log handle)
           => (lambda (msg)
                (display msg)
                (error 'glCompileShader "compile error." name))])))

  (define (gl:get-shader-info-log shader-handle)
    (let ([info-buffer (make-bytevector 1024)]
          [len-buffer  (make-bytevector 4)])
      (glGetShaderInfoLog shader-handle 1024 len-buffer info-buffer)
      (let ([len (bytevector-u32-native-ref len-buffer 0)])
        (if (zero? len)
          #f
          (let ([new-buffer (make-bytevector len)])
            (bytevector-copy! info-buffer 0 new-buffer 0 len)
            (utf8->string new-buffer))))))
)
