(import (rnrs (6))
        (srfi :48)

        (glfw basic)
        (glfw constants)
        (glfw gl GL_VERSION_3_0)
        (glfw gl support)
        (glfw polygons)
        (glfw linmath)

        (lyonesse record-with-context)
        (lyonesse functional)
        (lyonesse match)
        (lyonesse ranges)
        (lyonesse munsch f32array)
        (lyonesse munsch linear-algebra)
        (lyonesse munsch geometry)
        (lyonesse foreign-data)
        (lyonesse strings)

        (pfds queues)
        (pfds psqs)

        (only (chezscheme) box unbox set-box! random))

#|================================================================|
 | Library routines                                               |
 |================================================================|#
(define (spherical->cartesian r u v)
  (g:. (* r (sin u) (cos v))
       (* r (sin u) (sin v))
       (* r (cos u))))

(define (sign x)
  (cond [(< x 0) -1] [(> x 0) +1] [else 0]))

(define (clip x a b)
  (cond
    ((< a x) a)
    ((> x b) b)
    (else    x)))

(define (random-uniform-real)
  (random 1.0))

#|================================================================|
 | Constants                                                      |
 |================================================================|#
(define RADIUS 70.0)
(define M-BANDS 8)
(define N-BANDS 16)
(define DIST-BALL (* 2.1 RADIUS))
(define VIEW-SCENE-DIST (+ 200.0 (* 3 DIST-BALL)))
(define GRID-SIZE (* 4.5 RADIUS))
  
(define BOUNCE-HEIGHT (* 2.1 RADIUS))
(define BOUNCE-WIDTH (* 2.1 RADIUS))
(define SHADOW-OFFSET (list -20.0 10.0 0.0))
(define WALL-L-OFFSET 0.0)
(define WALL-R-OFFSET 5.0)
  
(define ANIMATION-SPEED 50.0)

(define pi 3.1415926539)

#|================================================================|
 | World definition                                               |
 |================================================================|#
(define-record-with-context world
  (fields window window-geometry ball cursor))

(define-record-with-context window-geometry
  (fields width height))

(define-record-with-context ball
  (fields x y x-inc y-inc rot-y rot-y-inc))

(define-record-with-context cursor
  (fields x y))

(define (set-ball-pos world x y)
  (with-world world
    (with-window-geometry window-geometry
      (let ([new-ball (make-ball (- (/ width 2) x)
                                 (- y (/ height 2)))])
        (update-world world (ball new-ball))))))

(define (bounce-ball ball dt)
  (with-ball ball
    (let* ([bounce-right? (> x (+ (* BOUNCE-WIDTH  1/2) WALL-R-OFFSET))]
           [bounce-left?  (< x (- (* BOUNCE-WIDTH -1/2) WALL-L-OFFSET))]
           [bounce-floor? (> y (* BOUNCE-HEIGHT 1/2))]
           [bounce-roof?  (< y (* BOUNCE-HEIGHT -19/40))]

           [x-inc* (cond
                     [bounce-right? (- -1/2 (* 3/4 (random-uniform-real)))]
                     [bounce-left?  (+  1/2 (* 3/4 (random-uniform-real)))]
                     [else          x-inc])]

           [y-inc* (cond
                     [bounce-floor? (- -3/4 (random-uniform-real))]
                     [bounce-roof?  (+  3/4 (random-uniform-real))]
                     [else          y-inc])]

           [rot-y-inc* (if (or bounce-right? bounce-left?)
                         (- rot-y-inc) rot-y-inc)]

           [rot-y* (+ rot-y rot-y-inc*)]

           [deg (clip (* (+ y (* BOUNCE-HEIGHT 1/2)) (/ 90 BOUNCE-HEIGHT))
                      10 80)])
        
      (make-ball (+ x (* x-inc dt ANIMATION-SPEED))
            (+ y (* y-inc dt ANIMATION-SPEED))
            x-inc*
            (* (sign y-inc*) 4 (sin (* deg pi 1/180)))
            rot-y* rot-y-inc*))))

#|================================================================|
 | Event queue                                                    |
 |================================================================|#
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
                 
(define (reshape-callback event-queue)
  (lambda (window w h)
    (let* ([projection (l:4x4:perspective (* 2 (atan RADIUS 200))
                                          (/ w h) 1 VIEW-SCENE-DIST)]
           [eye        (g:. 0  0 VIEW-SCENE-DIST)]
           [center     (g:. 0  0 0)]
           [up         (g:> 0 -1 0)]
           [view       (l:4x4:look-at eye center up)])
      (gl:check glViewport 0 0 w h)
      (gl:check glMatrixMode GL_PROJECTION)
      (gl:check glLoadMatrixf (l:matrix-data projection))
      (gl:check glMatrixMode GL_MODELVIEW)
      (gl:check glLoadMatrixf (l:matrix-data view)))))

(define (key-callback event-queue)
  (lambda (window key scancode action mods)
    (when (= action GLFW_PRESS)
      (cond
        [(and (= key GLFW_KEY_ESCAPE) (zero? mods))
         (glfw-set-window-should-close window GLFW_TRUE)]
        [(or (and (= key GLFW_KEY_ENTER) (= mods GLFW_MOD_ALT))
             (and (= key GLFW_KEY_F11)   (= mods GLFW_MOD_ALT)))
         (format #t "Full-screen mode is not yet implemented.")]))))

#|================================================================|
 | Drawing the ball                                               |
 |================================================================|#
(define (generate-uv-sphere r m n)
  (let ([v (lambda (i j)
             (spherical->cartesian
               r (* (/ i m) pi) (* (/ j n) 2 pi)))])

    (apply append
           (map-range (lambda (i)
             (map-range (lambda (j)
               (let ([c (odd? (+ i j))])
                 (make-polygon
                   (list (v i j)             (v i (inc j)) 
                         (v (inc i) (inc j)) (v (inc i) j)) c)))
               n))
             m))))

(define (draw-boing-ball ball layer)
  (gl:check glPushMatrix)
  (gl:check glMatrixMode GL_MODELVIEW)
  (gl:check glTranslatef 0.0 0.0 DIST-BALL)
  (with-ball ball
    (gl:check glTranslatef x y 0.0))
  
  (when (eq? layer 'shadow)
    (apply glTranslatef SHADOW-OFFSET))

  (with-ball ball
    (gl:check glRotatef -20.0 0.0 0.0 1.0)
    (gl:check glRotatef rot-y 0.0 1.0 0.0))

  (gl:check glCullFace GL_FRONT)
  (gl:check glEnable GL_CULL_FACE)
  (gl:check glEnable GL_NORMALIZE)

  (let ([sphere (generate-uv-sphere RADIUS M-BANDS N-BANDS)])
    (if (eq? layer 'shadow)
      (begin
        (gl:check glColor3f 0.35 0.35 0.35)
        (for-each gl:draw-polygon sphere))

      (for-each 
        (lambda (p)
          (if (polygon-info p)
            (gl:check glColor3f 0.80 0.10 0.10)
            (gl:check glColor3f 0.95 0.95 0.95))
          (gl:draw-polygon p))
        sphere)))

  (gl:check glPopMatrix))

#|================================================================|
 | Draw grid                                                      |
 |================================================================|#
(define (demo:draw-grid)
  (gl:check glPushMatrix)
  (gl:check glDisable GL_CULL_FACE)
  (gl:check glTranslatef 0.0 0.0 DIST-BALL)

  (for-range (lambda (col)
    (let* ([xl (* (- (/ col 12) 1/2) GRID-SIZE)]
           [xr (+ xl 2)]
           [yt (* 1/2 GRID-SIZE)]
           [yb (- (* -1/2 GRID-SIZE) 2)]
           [z  -40])
      (glColor3f 0.6 0.1 0.6)
      (gl:draw-polygon
        (make-polygon (list (g:. xr yt z) (g:. xl yt z)
                            (g:. xl yb z) (g:. xr yb z))))))
    13)
              
  (for-range (lambda (row)
    (let* ([yt (* (- 1/2 (/ row 12)) GRID-SIZE)]
           [yb (- yt 2)]
           [xl (* -1/2 GRID-SIZE)]
           [xr (+ (* 1/2 GRID-SIZE) 2)]
           [z  -40])
      (glColor3f 0.6 0.1 0.6)
      (gl:draw-polygon
        (make-polygon (list (g:. xr yt z) (g:. xl yt z)
                            (g:. xl yb z) (g:. xr yb z))))))
    13)

  (gl:check glPopMatrix))

#|================================================================|
 | Main program                                                   |
 |================================================================|#

(define (demo:init)
  (glClearColor 0.55 0.55 0.55 0.0)
  (glShadeModel GL_FLAT))

(define (demo:display world)
  (gl:check glClear (bitwise-ior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
  (gl:check glPushMatrix)
  (with-world world
    (draw-boing-ball ball 'shadow)
    (demo:draw-grid)
    (draw-boing-ball ball 'ball))
  (gl:check glPopMatrix)
  (gl:check glFlush))

(define (demo:handle-events event-queue*)
  (let loop ([event-queue (unbox event-queue*)]
             [code         id])
    (if (queue-empty? event-queue)
      (begin (set-box! event-queue* event-queue)
             code)
      (receive (value event-queue) (dequeue event-queue)
        (loop event-queue code)))))

(define (demo:main-loop program world event-queue)
  (display "Entering main loop.") (newline)
  (let loop ([program  program]
             [world    world])

    (with-world world
      (when (glfw-window-should-close window)
        (display "Ordered to close.") (newline)
        (exit))

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
              (loop (code program) world))))))))

(define (schedule code moment time)
  (lambda (program)
    (code (psq-set program moment time))))

(define (demo:moment world due)
  (with-world world
    (demo:display world)
    (glfw-swap-buffers window)
    (values
      (schedule id demo:moment (+ due 1/25))
      (update-world world (ball (bounce-ball ball 1/25))))))

(define (demo:setup init main-loop)
  (unless (glfw-init)
    (exit))

  (format #t "Initialised GLFW: ~a\n" (glfw-get-version-string))
  (glfw-set-error-callback (lambda (errc msg)
    (format #t "ERROR ~a: ~a" errc msg)))

  (let ((window      (glfw-create-window
                       400 400 "Boing (classic Amiga demo)" 0 0))
        (event-queue (box (make-queue))))
    (unless window
      (glfw-terminate)
      (exit))

    (glfw-set-window-aspect-ratio window 1 1)

    ;;; Set callback functions
    (glfw-set-window-close-callback window
      (lambda (w) (format #t "Goodbye!\n")))
    (glfw-set-framebuffer-size-callback
      window (reshape-callback event-queue))
    (glfw-set-key-callback
      window (key-callback event-queue))
    (glfw-set-mouse-button-callback
      window (mouse-button-callback event-queue))
    (glfw-set-cursor-pos-callback
      window (cursor-position-callback event-queue))

    (format #t "Initialised OpenGL context.\n")
    (glfw-set-input-mode window GLFW_STICKY_KEYS GLFW_FALSE)
    (glfw-make-context-current window)
    (glfw-swap-interval 1)

    (receive (width height) (glfw-get-framebuffer-size window)
      ((reshape-callback event-queue) window width height))
   
    (glfw-set-time 0.0)

    (init)
    (main-loop
      ((schedule id demo:moment 0.0) (make-psq (on < equal-hash) <))
      (make-world
        window
        (make-window-geometry 400 400)
        (make-ball (- RADIUS) (- RADIUS) 1.0 2.0 0.0 5.0)
        (make-cursor 0 0))
      event-queue)

    (glfw-terminate)))

(demo:setup demo:init demo:main-loop)

