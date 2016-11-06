(import (rnrs (6))

        (lyonesse functional)

        (glfw basic)
        (glfw support)
        (glfw polygons)
        (glfw events)

        (glfw gl GL_VERSION_3_0))


#| Game engine =========================================================== |#
(define (game:main-loop program world event-queue)
  (display "Entering main loop.") (newline)
  (let loop ([program  program]
             [world    world])

    (when (psq-empty? program)
      (display "Reached end of program.") (newline) (exit))

    ;;; find the scheduled time of the next event in the queue
    (let* ([time (glfw-get-time)]
           [due  (psq-min-priority program)]
           [wait (- due time)])

      ;;; if the wait is long enough, wait for an external event, loop
      (if (> wait 1e-4)
        (begin
          (glfw-wait-events-timeout wait)
          (loop ((demo:handle-events event-queue) program) world))

        ;;; else handle the event, loop
        (receive (moment program) (psq-pop program)
          (receive (code world) (moment world due)
            (loop (code program) world)))))))

(define (game:schedule code moment time)
  (lambda (program)
    (code (psq-set program moment time))))

(define (demo:moment world due)
  (with-world world
    (when (glfw-window-should-close window)
      (display "Ordered to close.") (newline)
      (exit))

    (demo:display world)
    (glfw-swap-buffers window)
    (values
      (game:schedule id demo:moment (+ due 1/25))
      (update-world world (ball (bounce-ball ball 1/25))))))

(define (demo:main)
  (unless (glfw-init)
    (exit))

  (format #t "Initialised GLFW: ~a\n" (glfw-get-version-string))
  (glfw-set-error-callback (lambda (errc msg)
    (format #t "ERROR ~a: ~a" errc msg)))

  (let*-values
    (((monitor)      (glfw-get-primary-monitor))
     ((width height) (if (zero? monitor)
                       (values 640 480)
                       (let ((mode (glfw-get-video-mode monitor)))
                         (with-glfw-vid-mode mode
                           (glfw-window-hint GLFW_RED_BITS red-bits)
                           (glfw-window-hint GLFW_GREEN_BITS green-bits)
                           (glfw-window-hint GLFW_BLUE_BITS blue-bits)
                           (glfw-window-hint GLFW_REFRESH_RATE refresh-rate)
                           (values width height)))))
     ((window)       (glfw-create-window
                       width height "Particle Engine" monitor 0))
     ((event-queue)  (box (make-queue))))

    (unless window
      (display "Failed to create GLFW window.\n")
      (glfw-terminate)
      (exit))

    (unless (zero? monitor)
      (glfw-set-input-mode window GLFW_CURSOR GLFW_CURSOR_DISABLED))

    (glfw-make-context-current window)
    (glfw-swap-interval 1)

    (glfw-set-framebuffer-size-callback window
      (resize-callback event-queue))
    (glfw-set-key-callback window
      (key-callback event-queue))

    (receive (width height) (glfw-get-framebuffer-size window)
      ((resize-callback event-queue) width height))
))

