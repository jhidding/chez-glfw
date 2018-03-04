(library (glfw polygons)
  (export make-polygon polygon? polygon-vertices polygon-normal polygon-info
          with-polygon update-polygon
          
          gl:draw-polygon)

  (import (rnrs base (6))
          (rnrs control (6))
          (rnrs records syntactic (6))
         
          (lyonesse match)
          (lyonesse munsch geometry)
          (lyonesse record-with-context)
          
          (glfw basic)
          (glfw gl GL_VERSION_3_0)
          (glfw gl support))

  #|================================================================|
   | Polygons                                                       |
   |================================================================|#
  (define-record-with-context polygon
    (fields vertices normal info)
    (protocol
      (lambda (new)
        (case-lambda
          [(vertices) (make-polygon vertices #f)]
          [(vertices info)
           (let* ([normal (match vertices
                            [(,a ,b ,c ,rest ...)
                             (g:cross (g:- b a) (g:- c a))])])
             (new vertices normal info))]))))

  (define (gl:draw-polygon p)
    (with-polygon p
      (glBegin GL_POLYGON)
      (glNormal3fv (g:data normal))
      (for-each (lambda (vertex)
        (glVertex3fv (g:data vertex)))
        vertices)
      (gl:check glEnd)))
)
