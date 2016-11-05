(library (glfw linmath)
  (export l:4x4:I
          
          l:4x4:affine l:4x4:affine-deformation l:4x4:affine-translation
          
          l:4x4:look-at l:4x4:ortho l:4x4:perspective
          l:4x4:rotate-x l:4x4:rotate-y l:4x4:rotate-z)

  (import (rnrs base (6))

          (lyonesse munsch f32array)
          (lyonesse munsch linear-algebra)
          (lyonesse munsch geometry))

  (define l:4x4:I
    (l:eye 4))

  (define (l:4x4:ortho l r b t n f)
    (l:m ((/ 2 (- r l))        0                   0                  0)
         ( 0                  (/ 2 (- t b))        0                  0)
         ( 0                   0                  (/ 2 (- f n))       0)
         ((/ (+ r l) (- l r)) (/ (+ t b) (- b t)) (/ (+ f n) (- n f)) 1)))

  (define (l:4x4:affine M v)
    (let ([M* (l:matrix->f32array M)]
          [v* (l:vector->f32array v)]
          [A* (make-f32array '(4 4))])
      (f32array-copy! M*             (f32array-cut A* (0 3) (0 3)))
      (f32array-copy! v*             (f32array-cut A* 3 (0 3)))
      (f32array-copy! (f32a 0 0 0 1) (f32array-cut A* () 3))
      (f32array->l:matrix A*)))

  (define (l:4x4:affine-deformation M)
    (let ([M* (l:matrix->f32array M)])
      (f32array->l:matrix (f32array-cut M* (0 3) (0 3)))))

  (define (l:4x4:affine-translation M)
    (let ([M* (l:matrix->f32array M)])
      (f32array->l:vector (f32array-cut M* (0 3) 3))))

  (define (l:4x4:look-at eye center up)
    (let* ([f (g:normalize (g:- center eye))]
           [s (g:normalize (g:cross f up))]
           [t (g:cross s f)]
           [M (l:m ((g:v-x s) (g:v-x t) (- (g:v-x f)))
                   ((g:v-y s) (g:v-y t) (- (g:v-y f)))
                   ((g:v-z s) (g:v-z t) (- (g:v-z f))))])
      (l:4x4:affine M (l:* M (g:- g:origin eye)))))

  (define (l:4x4:perspective fov aspect n f)
    (let ([a (/ 1 (tan (/ fov 2)))])
      (l:m ((/ a aspect) 0  0                    0)
           ( 0           a  0                    0)
           ( 0           0 (/ (+ f n) (- n f))  -1)
           ( 0           0 (/ (* 2 f n) (- n f)) 0))))

  (define (l:4x4:rotate-z M alpha)
    (let* ([c (cos alpha)]
           [s (sin alpha)]
           [R (l:m (   c  s 0 0)
                   ((- s) c 0 0)
                   (   0  0 1 0)
                   (   0  0 0 1))])
      (l:* M R)))

  (define (l:4x4:rotate-x M alpha)
    (let* ([c (cos alpha)]
           [s (sin alpha)]
           [R (l:m (1    0  0 0)
                   (0    c  s 0)
                   (0 (- s) c 0)
                   (0    0  0 1))])
      (l:* M R)))

  (define (l:4x4:rotate-y M alpha)
    (let* ([c (cos alpha)]
           [s (sin alpha)]
           [R (l:m (   c  0 s 0)
                   (   0  1 0 0)
                   ((- s) 0 c 0)
                   (   0  0 0 1))])
      (l:* M R)))
)
