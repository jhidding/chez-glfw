(import (rnrs (6))

        (lyonesse functional)
        (lyonesse munsch)

        (glfw basic)
        (glfw support)
        (glfw polygons)
        (glfw events)

        (glfw gl GL_VERSION_3_0))

(define (random-uniform-real)
  (random 1.0))

(define π 3.1415926539)

#| Vertex definition ======================================================= |#
(define-struct vertex
  (texture (array f32 2))
  (color   (struct u8 u8 u8 u8))
  (point   (array f32 3)))

#| Textures ================================================================ |#
(define P_TEX_WIDTH  8)  ;  // Particle texture dimensions
(define P_TEX_HEIGHT 8)
(define F_TEX_WIDTH  16) ;  // Floor texture dimensions
(define F_TEX_HEIGHT 16)


; // Particle texture (a simple spot)
; const unsigned char particle_texture[ P_TEX_WIDTH * P_TEX_HEIGHT ] = {
(define particle-texture (bytearray u8
  #x00 #x00 #x00 #x00 #x00 #x00 #x00 #x00
  #x00 #x00 #x11 #x22 #x22 #x11 #x00 #x00
  #x00 #x11 #x33 #x88 #x77 #x33 #x11 #x00
  #x00 #x22 #x88 #xff #xee #x77 #x22 #x00
  #x00 #x22 #x77 #xee #xff #x88 #x22 #x00
  #x00 #x11 #x33 #x77 #x88 #x33 #x11 #x00
  #x00 #x00 #x11 #x33 #x22 #x11 #x00 #x00
  #x00 #x00 #x00 #x00 #x00 #x00 #x00 #x00)


; // Floor texture (your basic checkered floor)
; const unsigned char floor_texture[ F_TEX_WIDTH * F_TEX_HEIGHT ] = {
(define floor-texture (bytearray u8
  #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #x30 #x30 #x30 #x30 #x30 #x30 #x30 #x30
  #xff #xf0 #xcc #xf0 #xf0 #xf0 #xff #xf0 #x30 #x30 #x30 #x30 #x30 #x30 #x30 #x30
  #xf0 #xcc #xee #xff #xf0 #xf0 #xf0 #xf0 #x30 #x66 #x30 #x30 #x30 #x20 #x30 #x30
  #xf0 #xf0 #xf0 #xf0 #xf0 #xee #xf0 #xf0 #x30 #x30 #x30 #x30 #x30 #x30 #x30 #x30
  #xf0 #xf0 #xf0 #xf0 #xcc #xf0 #xf0 #xf0 #x30 #x30 #x55 #x30 #x30 #x44 #x30 #x30
  #xf0 #xdd #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #x33 #x30 #x30 #x30 #x30 #x30 #x30 #x30
  #xf0 #xf0 #xf0 #xf0 #xf0 #xff #xf0 #xf0 #x30 #x30 #x30 #x30 #x30 #x30 #x60 #x30
  #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #x33 #x33 #x30 #x30 #x30 #x30 #x30 #x30
  #x30 #x30 #x30 #x30 #x30 #x30 #x33 #x30 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0
  #x30 #x30 #x30 #x30 #x30 #x20 #x30 #x30 #xf0 #xff #xf0 #xf0 #xdd #xf0 #xf0 #xff
  #x30 #x30 #x30 #x30 #x30 #x30 #x55 #x33 #xf0 #xf0 #xf0 #xf0 #xf0 #xff #xf0 #xf0
  #x30 #x44 #x66 #x30 #x30 #x30 #x30 #x30 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0
  #x30 #x30 #x30 #x30 #x30 #x30 #x30 #x30 #xf0 #xf0 #xf0 #xaa #xf0 #xf0 #xcc #xf0
  #x30 #x30 #x30 #x30 #x30 #x30 #x30 #x30 #xff #xf0 #xf0 #xf0 #xff #xf0 #xdd #xf0
  #x30 #x30 #x30 #x77 #x30 #x30 #x30 #x30 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0
  #x30 #x30 #x30 #x30 #x30 #x30 #x30 #x30 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0 #xf0)

#| Demo variables ========================================================== |#
;; Maximum number of particles
(define MAX_PARTICLES   3000

;; Life span of a particle (in seconds)
(define LIFE_SPAN       8.)

;; A new particle is born every [BIRTH_INTERVAL] second
(define BIRTH_INTERVAL (/ LIFE_SPAN MAX_PARTICLES))

;; Particle size (meters)
(define PARTICLE_SIZE   0.7)

;; Gravitational constant (m/s^2)
(define GRAVITY         9.8)

;; Base initial velocity (m/s)
(define VELOCITY        8.)

;; Bounce friction (1.0 = no friction, 0.0 = maximum friction)
(define FRICTION        0.75)

;; "Fountain" height (m)
(define FOUNTAIN_HEIGHT 3.)

;; Fountain radius (m)
(define FOUNTAIN_RADIUS 1.6)

;; Minimum delta-time for particle phisics (s)
(define MIN_DELTA_T     (* BIRTH_INTERVAL 0.5))

#| Data structures ========================================================= |#
(define-struct color
  (red f32) (green f32) (blue f32))

(define-struct particle
  (position (array f32 3))
  (velocity (array f32 3))
  (color    (struct f32 f32 f32))
  (mana     f32)
  (active   u32)
  (padding  u32))  ;; adds to 12*4=48 byte structure

(define particles
  (let ((data (struct-data (make-particle MAX_PARTICLES))))
    (make-array particle-type data 0 MAX_PARTICLES)))

(define-record-with-context world
  (fields window aspect-ratio
          wireframe 
          fountain-list 
          floor-tex-id floor-list
          glow-color glow-pos))

#| Materials =============================================================== |#
(define fountain_diffuse   '(0.7 1.  1.  1.))
(define fountain_specular  '(1.  1.  1.  1.))
(define fountain_shininess 12.)
(define floor_diffuse      '(1.  0.6 0.6 1.))
(define floor_specular     '(0.6 0.6 0.6 1.))
(define floor_shininess    18.)
(define fog_color          '(0.1 0.1 0.1 1.))


(define (demo:update-glow world)
  (with-world world
    (let ((r (+ 0.7 (* 0.3 (sin (+ (* 0.34 t) 0.1)))))
          (g (+ 0.6 (* 0.4 (sin (+ (* 0.63 t) 1.1)))))
          (b (+ 0.6 (* 0.4 (sin (+ (* 0.91 t) 2.1)))))

          (x (* 0.4 (sin (* 1.34 t))))
          (y (* 0.4 (sin (* 3.11 t))))
          (z (+ 1.0 FOUNTAIN_HEIGHT)))

      (update-world world
        (glow-color (l:v r g b 1.0))
        (glow-pos   (l:v x y z 1.0))))))

(define (demo:initialize-particle! world p)
  (with-world world
    (let* ((θ (* 2 π (random-uniform-real)))
           (v (* VELOCITY (+ 0.8 (* 0.1 (+ (sin (/ t 2)) (sin (* 1.31 t))))))))

      (particle-position-set! p '(0 0 FOUNTAIN_HEIGHT))

      (particle-velocity-set! p
        '((* v 0.4 (cos θ))
          (* v 0.4 (sin θ))
          (+ v 0.7 (* 0.3 (random-uniform-real)))))

      (particle-color-set! p glow-color)
      (particle-mana-set! p 1.0)
      (particle-active-set p 1))))

(define FOUNTAIN_R2
  (expt (+ FOUNTAIN_RADIUS (/ PARTICLE_SIZE 2)) 2))

(define (demo:update-particle! p dt)
  (call/cc (lambda (break)
    (with-particle p
      (unless active (break))

      ;;; do we need to keep this particle alive?
      (let ((dmana (/ dt LIFE_SPAN)))
        (if (<= mana dmana)
          (begin
            (particle-active-set! p 0)
            (break))
          (particle-mana-set! (- mana dmana))))

      ;;; do the physics
      (let* ((v* (l:- velocity (* (l:> 0 0 GRAVITY) dt)))
             (x* (l:+ position (* v* dt))))
        (particle-velocity-set! p v*)
        (particle-position-set! p x*)

        ;;; collision detection
        (cond
          ((< (l:z v*) 0.0) (break))

          ((and (< (+ (* (l:x x*) (l:x x*)) (* (l:y x*) (l:y x*)))
                   FOUNTAIN_R2)
                (< (l:z x*) (+ FOUNTAIN_HEIGHT (/ PARTICLE_SIZE 2))))
           (array-set! velocity 2 (* (- FRICTION) (l:z v*)))
           (array-set! position 2 (+ FOUNTAIN_HEIGHT (/ PARTICLE_SIZE 2))))

          ((< (l:z x*) (/ PARTICLE_SIZE 2))
           (array-set! velocity 2 (* (- FRICTION) (l:z v*)))
           (array-set! position 2 (/ PARTICLE_SIZE 2)))))))))

(define (demo:update-particles dt)
  (let loop ((ps particles))
    (unless (array-empty? ps)
      (demo:update-particle! (array-head ps) dt)
      (loop (array-tail ps)))))

(define (demo:create-new-particle world due)
  (call/cc (lambda (break)
    (let loop ((ps particles))
      (unless (array-empty? ps)
        (let ((p (array-head ps)))
          (with-particle p
            (when (zero? active)
              (demo:initialize-particle! p due)
              (break))))
        (loop (array-tail ps))))))

  (values
    (schedule id demo:create-new-particle (+ due BIRTH_INTERVAL))
    world))

(define BATCH_PARTICLES 70)
(define PARTICLE_VERTS 4)

(define demo:draw-particles
  (let* ((vertices (make-vertex (* BATCH_PARTICLES PARTICLE_VERTS)))
         (vertex-array (make-array vertex-type (vertex-data vertices) 0
                                   (* BATCH_PARTICLES PARTICLE_VERTS)))
         (mat          (l:make-matrix 4 4)))
    (lambda (world)
      (with-world world
        (glGetFloatv GL_MODELVIEW_MATRIX (l:matrix-data mat))
        (let ((quad_lower_left  (l:> (* -1/2 PARTICLE_SIZE (+ (l:matrix-ref mat 0 0)
                                                              (l:matrix-ref mat 0 1)))
                                     (* -1/2 PARTICLE_SIZE (+ (l:matrix-ref mat 1 0)
                                                              (l:matrix-ref mat 1 1)))
                                     (* -1/2 PARTICLE_SIZE (+ (l:matrix-ref mat 2 0)
                                                              (l:matrix-ref mat 2 1)))))
              (quad_lower_right (l:> (*  1/2 PARTICLE_SIZE (- (l:matrix-ref mat 0 0)
                                                              (l:matrix-ref mat 0 1)))
                                     (*  1/2 PARTICLE_SIZE (- (l:matrix-ref mat 1 0)
                                                              (l:matrix-ref mat 1 1)))
                                     (*  1/2 PARTICLE_SIZE (- (l:matrix-ref mat 2 0)
                                                              (l:matrix-ref mat 2 1))))))
          (glDepthMask GL_FALSE)
          (glEnable GL_BLEND)
          (glBlendFunc GL_SRC_ALPHA GL_ONE)
          (unless wireframe
            (glEnable GL_TEXTURE_2D)
            (glBindTexture GL_TEXTURE_2D particle_tex_id))

          (glInterleavedArrays GL_T2F_C4UB_V3F 0 (array-data vertex-array))

          (let loop ((ps particles)
                     (vx vertex-array)
                     (n  0))
            (cond
              ((array-empty? ps)
               (glDrawArrays GL_QUADS 0 (* PARTICLE_VERTS n)))

              ((array-empty? vx)
               (glDrawArrays GL_QUADS 0 (* PARTICLE_VERTS n))
               (loop (array-tail ps) vertex-array 0))

              (else
               (with-particle (array-head ps)
                 (let* ((v (array-head vx))
                        (alpha (if (> mana 1/4) 1.0 (* 4 mana)))
                        (color-bits (list (exact (floor (* red 255)))
                                          (exact (floor (* green 255)))
                                          (exact (floor (* blue 255)))
                                          (exact (floor (* alpha 255)))))
                        (v-bl (array-ref vx 0))
                        (v-br (array-ref vx 1))
                        (v-tr (array-ref vx 2))
                        (v-tl (array-ref vx 3)))

                   (vertex-texture-set! v-bl (l:. 0 0))
                   (vertex-color-set! v-bl color-bits)
                   (vertex-point-set! v-bl (l:+ position quad_lower_left))

                   (vertex-texture-set! v-br (l:. 1 0))
                   (vertex-color-set! v-br color-bits)
                   (vertex-point-set! v-br (l:+ position quad_lower_right))

                   (vertex-texture-set! v-tr (l:. 1 1))
                   (vertex-color-set! v-tr color-bits)
                   (vertex-point-set! v-tr (l:- position quad_lower_left))

                   (vertex-texture-set! v-tl (l:. 0 1))
                   (vertex-color-set! v-tl color-bits)
                   (vertex-point-set! v-tl (l:- position quad_lower_right))))

               (loop (array-tail ps) (array-tail vx 4) (+ 1 n)))))

          (glDisableClientState GL_VERTEX_ARRAY)
          (glDisableClientState GL_TEXTURE_COORD_ARRAY)
          (glDisableClientState GL_COLOR_ARRAY)
          (glDisable GL_TEXTURE_2D)
          (glDisable GL_BLEND)
          (glDepthMask GL_TRUE)
        )))))

#| Fountain data =========================================================== |#
(define FOUNTAIN_SIDE_POINTS 14)
(define FOUNTAIN_SWEEP_STEPS 32)

(define fountain_side (bytearray f32
  1.2  0.0    1.0  0.2    0.41 0.3    0.4  0.35
  0.4  1.95   0.41 2.0    0.8  2.2    1.2  2.4
  1.5  2.7    1.55 2.95   1.6  3.0    1.0  3.0
  0.5  3.0    0.0  3.0))

(define fountain_normal (bytearray f32
  1.0000   0.0000    0.6428   0.7660    0.3420   0.9397    1.0000   0.0000
  1.0000   0.0000    0.3420  -0.9397    0.4226  -0.9063    0.5000  -0.8660
  0.7660  -0.6428    0.9063  -0.4226    0.0000   1.0000    0.0000   1.0000
  0.0000   1.0000    0.0000   1.0000))

(define (demo:make-fountain-list)
  (let ((fountain-list (glGenLists 1)))
    (glNewList fountain-list* GL_COMPILE)

    (glMaterialfv GL_FRONT GL_DIFFUSE fountain_diffuse)
    (glMaterialfv GL_FRONT GL_SPECULAR fountain_specular)
    (glMaterialf  GL_FRONT GL_SHININESS fountain_shininess)

    (for-range (lambda (n)
      (glBegin GL_TRIANGLE_STRIP)

      (for-range (lambda (m)
        (let* ((θ (/ (* m 2 π) FOUNTAIN_SWEEP_STEPS))
               (x (cos θ))
               (y (sin θ)))

          (glNormal3f (* x (array-ref fountain_normal (+ (* n 2) 2)))
                      (* y (array-ref fountain_normal (+ (* n 2) 2)))
                      (array-ref fountain_normal (+ (* n 2) 3)))
          (glVertex3f (* x (array-ref fountain_side (+ (* n 2) 2)))
                      (* y (array-ref fountain_side (+ (* n 2) 2)))
                      (array-ref fountain_side (+ (* n 2) 3)))
          (glNormal3f (* x (array-ref fountain_normal (* n 2)))
                      (* y (array-ref fountain_normal (* n 2)))
                      (array-ref fountain_normal (+ (* n 2) 1)))
          (glVertex3f (* x (array-ref fountain_side (* n 2)))
                      (* y (array-ref fountain_side (* n 2)))
                      (array-ref fountain_side (+ (* n 2) 1))))

        (+ FOUNTAIN_SWEEP_STEPS 1)))
      (glEnd))

      (- FOUNTAIN_SIDE_POINTS 1))

    (glEndList)
    fountain-list))

(define (demo:draw-fountain world)
  (with-world world
    (glCallList fountain-list)))

#| Floor =================================================================== |#
(define (demo:tessellate-floor x1 y1 x2 y2 depth)
  (let ((delta (if (>= depth 5)
                 +inf.0
                 (let ((x (min (abs x1) (abs x2)))
                       (y (min (abs y1) (abs y2))))
                   (+ (* x x) (* y y))))))
    (if (< delta 0.1)
      (let ((x (/ (+ x1 x2) 2))
            (y (/ (+ y1 y2) 2)))
        (demo:tessellate-floor x1 y1 x y (inc depth))
        (demo:tessellate-floor x y1 x2 y (inc depth))
        (demo:tessellate-floor x1 y x y2 (inc depth))
        (demo:tessellate-floor x y x2 y2 (inc depth)))
      (begin
        (glTexCoord2f (* x1 30.0) (* y1 30.0))
        (glVertex3f   (* x1 80.0) (* y1 80.0) 0.0)
        (glTexCoord2f (* x2 30.0) (* y1 30.0))
        (glVertex3f   (* x2 80.0) (* y1 80.0) 0.0)
        (glTexCoord2f (* x2 30.0) (* y2 30.0))
        (glVertex3f   (* x2 80.0) (* y2 80.0) 0.0)
        (glTexCoord2f (* x1 30.0) (* y2 30.0))
        (glVertex3f   (* x1 80.0) (* y2 80.0) 0.0)))))

(define (demo:make-floor-list)
  (let ((floor-list (glGenLists 1)))
    (glNewList floor-list GL_COMPILE)
    (glMaterialfv GL_FRONT GL_DIFFUSE floor_diffuse)
    (glMaterialfv GL_FRONT GL_SPECULAR floor_specular)
    (glMaterialf  GL_FRONT GL_SHININESS floor_shininess)

    (glNormal3f 0.0 0.0 1.0)
    (glBegin GL_QUADS)
    (demo:tessellate-floor -1.0 -1.0 0.0 0.0 0)
    (demo:tessellate-floor  0.0 -1.0 1.0 0.0 0)
    (demo:tessellate-floor  0.0  0.0 1.0 1.0 0)
    (demo:tessellate-floor -1.0  0.0 0.0 1.0 0)
    (gl:check glEnd)
    (gl:check glEndList)
    
    floor-list))

(define (demo:draw-floor world)
  (with-world world
    (unless wireframe
      (glEnable GL_TEXTURE_2D)
      (glBindTexture GL_TEXTURE_2D floor-tex-id))

    (glCallList floor-list)
    (glDisable GL_TEXTURE_2D)))

#| Lights ================================================================== |#
(define (demo:setup-lights world)
  (let ((l1pos  (l:v 0.0 -9.0 8.0 1.0))
        (l1amb  (l:v 0.2  0.2 0.2 1.0))
        (l1dif  (l:v 0.8  0.4 0.2 1.0))
        (l1spec (l:v 1.0  0.6 0.2 0.0))

        (l2pos  (l:v -15.0 12.0 1.5 1.0))
        (l2amb  (l:v   0.0  0.0 0.0 1.0))
        (l2dif  (l:v   0.2  0.4 0.8 1.0))
        (l2spec (l:v   0.2  0.6 1.0 0.0)))

    (glLightfv GL_LIGHT1 GL_POSITION l1pos)
    (glLightfv GL_LIGHT1 GL_AMBIENT  l1amb)
    (glLightfv GL_LIGHT1 GL_DIFFUSE  l1dif)
    (glLightfv GL_LIGHT1 GL_SPECULAR l1spec)

    (glLightfv GL_LIGHT2 GL_POSITION l2pos)
    (glLightfv GL_LIGHT2 GL_AMBIENT  l2amb)
    (glLightfv GL_LIGHT2 GL_DIFFUSE  l2dif)
    (glLightfv GL_LIGHT2 GL_SPECULAR l2spec)

    (with-world world
      (glLightfv GL_LIGHT3 GL_POSITION glow-pos)
      (glLightfv GL_LIGHT3 GL_DIFFUSE  glow-color)
      (glLightfv GL_LIGHT3 GL_SPECULAR glow-color))

    (glEnable GL_LIGHT1)
    (glEnable GL_LIGHT2)
    (glEnable GL_LIGHT3)))

#| Draw everything ========================================================= |#
(define (demo:draw-scene world)
  (with-world world
    (let ((projection (l:4x4:perspective (* 65/180 π) aspect-ratio 1.0 60.0)))
      (glClearColor 0.1 0.1 0.1 1.0)
      (glClear (bitwise-ior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
      (glMatrixMode GL_PROJECTION)
      (glLoadMatrixf (l:matrix-data projection))
      (glMatrixMode GL_MODELVIEW)
      (glLoadIdentity))

    (let ((α (- 90.0 10.0))
          (β (* 10.0 (sin (* 0.3 t))))
          (γ (* 10.0 t)))

      (glRotated (- α) 1.0 0.0 0.0)
      (glRotated (- β) 0.0 1.0 0.0)
      (glRotated (- γ) 0.0 0.0 1.0)

      (glTranslated (+ (* -15.0 (sin (* π 1/180 γ)))
                       (*  -2.0 (sin (* π 1/180 3.1 t))))
                    (+ (*  15.0 (cos (* π 1/180 γ)))
                       (*  -2.0 (cos (* π 1/180 2.9 t))))
                    (+ (*  -2.0 (cos (* π 1/180 4.9 t))) -4.0)))

    (glFrontFace GL_CCW)
    (glCullFace GL_BACK)
    (glEnable GL_CULL_FACE)

    (demo:setup-lights world)
    (glEnable GL_LIGHTING)

    (glEnable GL_FOG)
    (glFogi GL_FOG_MODE GL_EXP)
    (glFogf GL_FOG_DENSITY 0.05)
    (glFogfv GL_FOG_COLOR fog-color)

    (demo:draw-floor world)
    
    (glEnable GL_DEPTH_TEST)
    (glDepthFunc GL_LEQUAL)
    (glDepthMask GL_TRUE)

    (demo:draw-fountain world)

    (glDisable GL_LIGHTING)
    (glDisable GL_FOG)

    (demo:draw-particles world)
    (glDisable GL_DEPTH_TEST)))

#| Game engine ============================================================= |#
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

