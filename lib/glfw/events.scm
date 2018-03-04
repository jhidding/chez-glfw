(library (glfw events)
  (export event? event-type event-time
          mouse-button-event? mouse-button-event-button mouse-button-event-action
          mouse-move-event? mouse-move-event-x mouse-move-event-y
          key-event? key-event-key key-event-scancode key-event-action key-event-mods
          resize-event? resize-event-width resize-event-height

          mouse-button-callback
          cursor-position-callback
          key-callback
          resize-callback)

  (import (rnrs base (6))
          (rnrs records syntactic (6))

          (only (chezscheme) box unbox set-box!)
          (pfds queues))

  #| Event queue ================================================================== |#
  (define-record-type event
    (fields type time))

  (define-record-type mouse-button-event
    (parent event) (fields button action)
    (protocol
      (lambda (new)
        (lambda (time button action)
          ((new 'mouse-button time) button action)))))
          
  (define-record-type mouse-move-event
    (parent event) (fields x y)
    (protocol
      (lambda (new)
        (lambda (time x y)
          ((new 'mouse-move time) x y)))))

  (define-record-type key-event
    (parent event) (fields key scancode action mods)
    (protocol
      (lambda (new)
        (lambda (time key scancode action mods)
          ((new 'key time) key scancode action mods)))))

  (define-record-type resize-event
    (parent event) (fields width height)
    (protocol
      (lambda (new)
        (lambda (time width height)
          ((new 'resize time) width height)))))

  (define (mouse-button-callback event-queue)
    (lambda (window button action mods)
      (let ([action* (case action
                       [(GLFW_PRESS)               'press]
                       [(GLFW_RELEASE)             'release]
                       [else                       'other])]
            [button* (case button
                       [(GLFW_MOUSE_BUTTON_LEFT)   'left]
                       [(GLFW_MOUSE_BUTTON_RIGHT)  'right]
                       [(GLFW_MOUSE_BUTTON_MIDDLE) 'middle]
                       [else                       'other])])
        (set-box! event-queue
          (enqueue (unbox event-queue)
            (make-mouse-button-event (glfw-get-time) button* action*))))))

  (define (cursor-position-callback event-queue)
    (lambda (window x y)
      (set-box! event-queue
        (enqueue (unbox event-queue)
                 (make-mouse-move-event (glfw-get-time) x y)))))

  (define (key-callback event-queue)
    (lambda (window key scancode action mods)
      (set-box! event-queue
        (enqueue (unbox event-queue)
                 (make-key-event (glfw-get-time) key scancode action mods)))))

  (define (resize-callback event-queue)
    (lambda (window width height)
      (set-box! event-queue
        (enqueue (unbox event-queue)
                 (make-resize-event (glfw-get-time) width height)))))
)
