(library (glfw gl GL_VERSION_1_0)
  (export
    glAccum
    glAlphaFunc
    glBegin
    glBitmap
    glBlendFunc
    glCallList
    glCallLists
    glClear
    glClearAccum
    glClearColor
    glClearDepth
    glClearIndex
    glClearStencil
    glClipPlane
    glColor3b
    glColor3bv
    glColor3d
    glColor3dv
    glColor3f
    glColor3fv
    glColor3i
    glColor3iv
    glColor3s
    glColor3sv
    glColor3ub
    glColor3ubv
    glColor3ui
    glColor3uiv
    glColor3us
    glColor3usv
    glColor4b
    glColor4bv
    glColor4d
    glColor4dv
    glColor4f
    glColor4fv
    glColor4i
    glColor4iv
    glColor4s
    glColor4sv
    glColor4ub
    glColor4ubv
    glColor4ui
    glColor4uiv
    glColor4us
    glColor4usv
    glColorMask
    glColorMaterial
    glCopyPixels
    glCullFace
    glDeleteLists
    glDepthFunc
    glDepthMask
    glDepthRange
    glDisable
    glDrawBuffer
    glDrawPixels
    glEdgeFlag
    glEdgeFlagv
    glEnable
    glEnd
    glEndList
    glEvalCoord1d
    glEvalCoord1dv
    glEvalCoord1f
    glEvalCoord1fv
    glEvalCoord2d
    glEvalCoord2dv
    glEvalCoord2f
    glEvalCoord2fv
    glEvalMesh1
    glEvalMesh2
    glEvalPoint1
    glEvalPoint2
    glFeedbackBuffer
    glFinish
    glFlush
    glFogf
    glFogfv
    glFogi
    glFogiv
    glFrontFace
    glFrustum
    glGenLists
    glGetBooleanv
    glGetClipPlane
    glGetDoublev
    glGetError
    glGetFloatv
    glGetIntegerv
    glGetLightfv
    glGetLightiv
    glGetMapdv
    glGetMapfv
    glGetMapiv
    glGetMaterialfv
    glGetMaterialiv
    glGetPixelMapfv
    glGetPixelMapuiv
    glGetPixelMapusv
    glGetPolygonStipple
    glGetString
    glGetTexEnvfv
    glGetTexEnviv
    glGetTexGendv
    glGetTexGenfv
    glGetTexGeniv
    glGetTexImage
    glGetTexLevelParameterfv
    glGetTexLevelParameteriv
    glGetTexParameterfv
    glGetTexParameteriv
    glHint
    glIndexMask
    glIndexd
    glIndexdv
    glIndexf
    glIndexfv
    glIndexi
    glIndexiv
    glIndexs
    glIndexsv
    glInitNames
    glIsEnabled
    glIsList
    glLightModelf
    glLightModelfv
    glLightModeli
    glLightModeliv
    glLightf
    glLightfv
    glLighti
    glLightiv
    glLineStipple
    glLineWidth
    glListBase
    glLoadIdentity
    glLoadMatrixd
    glLoadMatrixf
    glLoadName
    glLogicOp
    glMap1d
    glMap1f
    glMap2d
    glMap2f
    glMapGrid1d
    glMapGrid1f
    glMapGrid2d
    glMapGrid2f
    glMaterialf
    glMaterialfv
    glMateriali
    glMaterialiv
    glMatrixMode
    glMultMatrixd
    glMultMatrixf
    glNewList
    glNormal3b
    glNormal3bv
    glNormal3d
    glNormal3dv
    glNormal3f
    glNormal3fv
    glNormal3i
    glNormal3iv
    glNormal3s
    glNormal3sv
    glOrtho
    glPassThrough
    glPixelMapfv
    glPixelMapuiv
    glPixelMapusv
    glPixelStoref
    glPixelStorei
    glPixelTransferf
    glPixelTransferi
    glPixelZoom
    glPointSize
    glPolygonMode
    glPolygonStipple
    glPopAttrib
    glPopMatrix
    glPopName
    glPushAttrib
    glPushMatrix
    glPushName
    glRasterPos2d
    glRasterPos2dv
    glRasterPos2f
    glRasterPos2fv
    glRasterPos2i
    glRasterPos2iv
    glRasterPos2s
    glRasterPos2sv
    glRasterPos3d
    glRasterPos3dv
    glRasterPos3f
    glRasterPos3fv
    glRasterPos3i
    glRasterPos3iv
    glRasterPos3s
    glRasterPos3sv
    glRasterPos4d
    glRasterPos4dv
    glRasterPos4f
    glRasterPos4fv
    glRasterPos4i
    glRasterPos4iv
    glRasterPos4s
    glRasterPos4sv
    glReadBuffer
    glReadPixels
    glRectd
    glRectdv
    glRectf
    glRectfv
    glRecti
    glRectiv
    glRects
    glRectsv
    glRenderMode
    glRotated
    glRotatef
    glScaled
    glScalef
    glScissor
    glSelectBuffer
    glShadeModel
    glStencilFunc
    glStencilMask
    glStencilOp
    glTexCoord1d
    glTexCoord1dv
    glTexCoord1f
    glTexCoord1fv
    glTexCoord1i
    glTexCoord1iv
    glTexCoord1s
    glTexCoord1sv
    glTexCoord2d
    glTexCoord2dv
    glTexCoord2f
    glTexCoord2fv
    glTexCoord2i
    glTexCoord2iv
    glTexCoord2s
    glTexCoord2sv
    glTexCoord3d
    glTexCoord3dv
    glTexCoord3f
    glTexCoord3fv
    glTexCoord3i
    glTexCoord3iv
    glTexCoord3s
    glTexCoord3sv
    glTexCoord4d
    glTexCoord4dv
    glTexCoord4f
    glTexCoord4fv
    glTexCoord4i
    glTexCoord4iv
    glTexCoord4s
    glTexCoord4sv
    glTexEnvf
    glTexEnvfv
    glTexEnvi
    glTexEnviv
    glTexGend
    glTexGendv
    glTexGenf
    glTexGenfv
    glTexGeni
    glTexGeniv
    glTexImage1D
    glTexImage2D
    glTexParameterf
    glTexParameterfv
    glTexParameteri
    glTexParameteriv
    glTranslated
    glTranslatef
    glVertex2d
    glVertex2dv
    glVertex2f
    glVertex2fv
    glVertex2i
    glVertex2iv
    glVertex2s
    glVertex2sv
    glVertex3d
    glVertex3dv
    glVertex3f
    glVertex3fv
    glVertex3i
    glVertex3iv
    glVertex3s
    glVertex3sv
    glVertex4d
    glVertex4dv
    glVertex4f
    glVertex4fv
    glVertex4i
    glVertex4iv
    glVertex4s
    glVertex4sv
    glViewport
  )

  (import (rnrs base(6))
          (only (chezscheme) foreign-procedure
                             load-shared-object))

  (define libGL (load-shared-object "libGL.so.1"))

  (define glAccum (foreign-procedure "glAccum" (unsigned-int float) void))
  (define glAlphaFunc (foreign-procedure "glAlphaFunc" (unsigned-int float) void))
  (define glBegin (foreign-procedure "glBegin" (unsigned-int) void))
  (define glBitmap (foreign-procedure "glBitmap" (int int float float float float string) void))
  (define glBlendFunc (foreign-procedure "glBlendFunc" (unsigned-int unsigned-int) void))
  (define glCallList (foreign-procedure "glCallList" (unsigned-int) void))
  (define glCallLists (foreign-procedure "glCallLists" (int unsigned-int uptr) void))
  (define glClear (foreign-procedure "glClear" (unsigned-int) void))
  (define glClearAccum (foreign-procedure "glClearAccum" (float float float float) void))
  (define glClearColor (foreign-procedure "glClearColor" (float float float float) void))
  (define glClearDepth (foreign-procedure "glClearDepth" (double) void))
  (define glClearIndex (foreign-procedure "glClearIndex" (float) void))
  (define glClearStencil (foreign-procedure "glClearStencil" (int) void))
  (define glClipPlane (foreign-procedure "glClipPlane" (unsigned-int uptr) void))
  (define glColor3b (foreign-procedure "glColor3b" (integer-8 integer-8 integer-8) void))
  (define glColor3bv (foreign-procedure "glColor3bv" (string) void))
  (define glColor3d (foreign-procedure "glColor3d" (double double double) void))
  (define glColor3dv (foreign-procedure "glColor3dv" (uptr) void))
  (define glColor3f (foreign-procedure "glColor3f" (float float float) void))
  (define glColor3fv (foreign-procedure "glColor3fv" (uptr) void))
  (define glColor3i (foreign-procedure "glColor3i" (int int int) void))
  (define glColor3iv (foreign-procedure "glColor3iv" (uptr) void))
  (define glColor3s (foreign-procedure "glColor3s" (short short short) void))
  (define glColor3sv (foreign-procedure "glColor3sv" (uptr) void))
  (define glColor3ub (foreign-procedure "glColor3ub" (unsigned-8 unsigned-8 unsigned-8) void))
  (define glColor3ubv (foreign-procedure "glColor3ubv" (string) void))
  (define glColor3ui (foreign-procedure "glColor3ui" (unsigned-int unsigned-int unsigned-int) void))
  (define glColor3uiv (foreign-procedure "glColor3uiv" (uptr) void))
  (define glColor3us (foreign-procedure "glColor3us" (unsigned-short unsigned-short unsigned-short) void))
  (define glColor3usv (foreign-procedure "glColor3usv" (uptr) void))
  (define glColor4b (foreign-procedure "glColor4b" (integer-8 integer-8 integer-8 integer-8) void))
  (define glColor4bv (foreign-procedure "glColor4bv" (string) void))
  (define glColor4d (foreign-procedure "glColor4d" (double double double double) void))
  (define glColor4dv (foreign-procedure "glColor4dv" (uptr) void))
  (define glColor4f (foreign-procedure "glColor4f" (float float float float) void))
  (define glColor4fv (foreign-procedure "glColor4fv" (uptr) void))
  (define glColor4i (foreign-procedure "glColor4i" (int int int int) void))
  (define glColor4iv (foreign-procedure "glColor4iv" (uptr) void))
  (define glColor4s (foreign-procedure "glColor4s" (short short short short) void))
  (define glColor4sv (foreign-procedure "glColor4sv" (uptr) void))
  (define glColor4ub (foreign-procedure "glColor4ub" (unsigned-8 unsigned-8 unsigned-8 unsigned-8) void))
  (define glColor4ubv (foreign-procedure "glColor4ubv" (string) void))
  (define glColor4ui (foreign-procedure "glColor4ui" (unsigned-int unsigned-int unsigned-int unsigned-int) void))
  (define glColor4uiv (foreign-procedure "glColor4uiv" (uptr) void))
  (define glColor4us (foreign-procedure "glColor4us" (unsigned-short unsigned-short unsigned-short unsigned-short) void))
  (define glColor4usv (foreign-procedure "glColor4usv" (uptr) void))
  (define glColorMask (foreign-procedure "glColorMask" (unsigned-8 unsigned-8 unsigned-8 unsigned-8) void))
  (define glColorMaterial (foreign-procedure "glColorMaterial" (unsigned-int unsigned-int) void))
  (define glCopyPixels (foreign-procedure "glCopyPixels" (int int int int unsigned-int) void))
  (define glCullFace (foreign-procedure "glCullFace" (unsigned-int) void))
  (define glDeleteLists (foreign-procedure "glDeleteLists" (unsigned-int int) void))
  (define glDepthFunc (foreign-procedure "glDepthFunc" (unsigned-int) void))
  (define glDepthMask (foreign-procedure "glDepthMask" (unsigned-8) void))
  (define glDepthRange (foreign-procedure "glDepthRange" (double double) void))
  (define glDisable (foreign-procedure "glDisable" (unsigned-int) void))
  (define glDrawBuffer (foreign-procedure "glDrawBuffer" (unsigned-int) void))
  (define glDrawPixels (foreign-procedure "glDrawPixels" (int int unsigned-int unsigned-int uptr) void))
  (define glEdgeFlag (foreign-procedure "glEdgeFlag" (unsigned-8) void))
  (define glEdgeFlagv (foreign-procedure "glEdgeFlagv" (string) void))
  (define glEnable (foreign-procedure "glEnable" (unsigned-int) void))
  (define glEnd (foreign-procedure "glEnd" () void))
  (define glEndList (foreign-procedure "glEndList" () void))
  (define glEvalCoord1d (foreign-procedure "glEvalCoord1d" (double) void))
  (define glEvalCoord1dv (foreign-procedure "glEvalCoord1dv" (uptr) void))
  (define glEvalCoord1f (foreign-procedure "glEvalCoord1f" (float) void))
  (define glEvalCoord1fv (foreign-procedure "glEvalCoord1fv" (uptr) void))
  (define glEvalCoord2d (foreign-procedure "glEvalCoord2d" (double double) void))
  (define glEvalCoord2dv (foreign-procedure "glEvalCoord2dv" (uptr) void))
  (define glEvalCoord2f (foreign-procedure "glEvalCoord2f" (float float) void))
  (define glEvalCoord2fv (foreign-procedure "glEvalCoord2fv" (uptr) void))
  (define glEvalMesh1 (foreign-procedure "glEvalMesh1" (unsigned-int int int) void))
  (define glEvalMesh2 (foreign-procedure "glEvalMesh2" (unsigned-int int int int int) void))
  (define glEvalPoint1 (foreign-procedure "glEvalPoint1" (int) void))
  (define glEvalPoint2 (foreign-procedure "glEvalPoint2" (int int) void))
  (define glFeedbackBuffer (foreign-procedure "glFeedbackBuffer" (int unsigned-int uptr) void))
  (define glFinish (foreign-procedure "glFinish" () void))
  (define glFlush (foreign-procedure "glFlush" () void))
  (define glFogf (foreign-procedure "glFogf" (unsigned-int float) void))
  (define glFogfv (foreign-procedure "glFogfv" (unsigned-int uptr) void))
  (define glFogi (foreign-procedure "glFogi" (unsigned-int int) void))
  (define glFogiv (foreign-procedure "glFogiv" (unsigned-int uptr) void))
  (define glFrontFace (foreign-procedure "glFrontFace" (unsigned-int) void))
  (define glFrustum (foreign-procedure "glFrustum" (double double double double double double) void))
  (define glGenLists (foreign-procedure "glGenLists" (int) unsigned-int))
  (define glGetBooleanv (foreign-procedure "glGetBooleanv" (unsigned-int string) void))
  (define glGetClipPlane (foreign-procedure "glGetClipPlane" (unsigned-int uptr) void))
  (define glGetDoublev (foreign-procedure "glGetDoublev" (unsigned-int uptr) void))
  (define glGetError (foreign-procedure "glGetError" () unsigned-int))
  (define glGetFloatv (foreign-procedure "glGetFloatv" (unsigned-int uptr) void))
  (define glGetIntegerv (foreign-procedure "glGetIntegerv" (unsigned-int uptr) void))
  (define glGetLightfv (foreign-procedure "glGetLightfv" (unsigned-int unsigned-int uptr) void))
  (define glGetLightiv (foreign-procedure "glGetLightiv" (unsigned-int unsigned-int uptr) void))
  (define glGetMapdv (foreign-procedure "glGetMapdv" (unsigned-int unsigned-int uptr) void))
  (define glGetMapfv (foreign-procedure "glGetMapfv" (unsigned-int unsigned-int uptr) void))
  (define glGetMapiv (foreign-procedure "glGetMapiv" (unsigned-int unsigned-int uptr) void))
  (define glGetMaterialfv (foreign-procedure "glGetMaterialfv" (unsigned-int unsigned-int uptr) void))
  (define glGetMaterialiv (foreign-procedure "glGetMaterialiv" (unsigned-int unsigned-int uptr) void))
  (define glGetPixelMapfv (foreign-procedure "glGetPixelMapfv" (unsigned-int uptr) void))
  (define glGetPixelMapuiv (foreign-procedure "glGetPixelMapuiv" (unsigned-int uptr) void))
  (define glGetPixelMapusv (foreign-procedure "glGetPixelMapusv" (unsigned-int uptr) void))
  (define glGetPolygonStipple (foreign-procedure "glGetPolygonStipple" (string) void))
  (define glGetString (foreign-procedure "glGetString" (unsigned-int) string))
  (define glGetTexEnvfv (foreign-procedure "glGetTexEnvfv" (unsigned-int unsigned-int uptr) void))
  (define glGetTexEnviv (foreign-procedure "glGetTexEnviv" (unsigned-int unsigned-int uptr) void))
  (define glGetTexGendv (foreign-procedure "glGetTexGendv" (unsigned-int unsigned-int uptr) void))
  (define glGetTexGenfv (foreign-procedure "glGetTexGenfv" (unsigned-int unsigned-int uptr) void))
  (define glGetTexGeniv (foreign-procedure "glGetTexGeniv" (unsigned-int unsigned-int uptr) void))
  (define glGetTexImage (foreign-procedure "glGetTexImage" (unsigned-int int unsigned-int unsigned-int uptr) void))
  (define glGetTexLevelParameterfv (foreign-procedure "glGetTexLevelParameterfv" (unsigned-int int unsigned-int uptr) void))
  (define glGetTexLevelParameteriv (foreign-procedure "glGetTexLevelParameteriv" (unsigned-int int unsigned-int uptr) void))
  (define glGetTexParameterfv (foreign-procedure "glGetTexParameterfv" (unsigned-int unsigned-int uptr) void))
  (define glGetTexParameteriv (foreign-procedure "glGetTexParameteriv" (unsigned-int unsigned-int uptr) void))
  (define glHint (foreign-procedure "glHint" (unsigned-int unsigned-int) void))
  (define glIndexMask (foreign-procedure "glIndexMask" (unsigned-int) void))
  (define glIndexd (foreign-procedure "glIndexd" (double) void))
  (define glIndexdv (foreign-procedure "glIndexdv" (uptr) void))
  (define glIndexf (foreign-procedure "glIndexf" (float) void))
  (define glIndexfv (foreign-procedure "glIndexfv" (uptr) void))
  (define glIndexi (foreign-procedure "glIndexi" (int) void))
  (define glIndexiv (foreign-procedure "glIndexiv" (uptr) void))
  (define glIndexs (foreign-procedure "glIndexs" (short) void))
  (define glIndexsv (foreign-procedure "glIndexsv" (uptr) void))
  (define glInitNames (foreign-procedure "glInitNames" () void))
  (define glIsEnabled (foreign-procedure "glIsEnabled" (unsigned-int) unsigned-8))
  (define glIsList (foreign-procedure "glIsList" (unsigned-int) unsigned-8))
  (define glLightModelf (foreign-procedure "glLightModelf" (unsigned-int float) void))
  (define glLightModelfv (foreign-procedure "glLightModelfv" (unsigned-int uptr) void))
  (define glLightModeli (foreign-procedure "glLightModeli" (unsigned-int int) void))
  (define glLightModeliv (foreign-procedure "glLightModeliv" (unsigned-int uptr) void))
  (define glLightf (foreign-procedure "glLightf" (unsigned-int unsigned-int float) void))
  (define glLightfv (foreign-procedure "glLightfv" (unsigned-int unsigned-int uptr) void))
  (define glLighti (foreign-procedure "glLighti" (unsigned-int unsigned-int int) void))
  (define glLightiv (foreign-procedure "glLightiv" (unsigned-int unsigned-int uptr) void))
  (define glLineStipple (foreign-procedure "glLineStipple" (int unsigned-short) void))
  (define glLineWidth (foreign-procedure "glLineWidth" (float) void))
  (define glListBase (foreign-procedure "glListBase" (unsigned-int) void))
  (define glLoadIdentity (foreign-procedure "glLoadIdentity" () void))
  (define glLoadMatrixd (foreign-procedure "glLoadMatrixd" (uptr) void))
  (define glLoadMatrixf (foreign-procedure "glLoadMatrixf" (uptr) void))
  (define glLoadName (foreign-procedure "glLoadName" (unsigned-int) void))
  (define glLogicOp (foreign-procedure "glLogicOp" (unsigned-int) void))
  (define glMap1d (foreign-procedure "glMap1d" (unsigned-int double double int int uptr) void))
  (define glMap1f (foreign-procedure "glMap1f" (unsigned-int float float int int uptr) void))
  (define glMap2d (foreign-procedure "glMap2d" (unsigned-int double double int int double double int int uptr) void))
  (define glMap2f (foreign-procedure "glMap2f" (unsigned-int float float int int float float int int uptr) void))
  (define glMapGrid1d (foreign-procedure "glMapGrid1d" (int double double) void))
  (define glMapGrid1f (foreign-procedure "glMapGrid1f" (int float float) void))
  (define glMapGrid2d (foreign-procedure "glMapGrid2d" (int double double int double double) void))
  (define glMapGrid2f (foreign-procedure "glMapGrid2f" (int float float int float float) void))
  (define glMaterialf (foreign-procedure "glMaterialf" (unsigned-int unsigned-int float) void))
  (define glMaterialfv (foreign-procedure "glMaterialfv" (unsigned-int unsigned-int uptr) void))
  (define glMateriali (foreign-procedure "glMateriali" (unsigned-int unsigned-int int) void))
  (define glMaterialiv (foreign-procedure "glMaterialiv" (unsigned-int unsigned-int uptr) void))
  (define glMatrixMode (foreign-procedure "glMatrixMode" (unsigned-int) void))
  (define glMultMatrixd (foreign-procedure "glMultMatrixd" (uptr) void))
  (define glMultMatrixf (foreign-procedure "glMultMatrixf" (uptr) void))
  (define glNewList (foreign-procedure "glNewList" (unsigned-int unsigned-int) void))
  (define glNormal3b (foreign-procedure "glNormal3b" (integer-8 integer-8 integer-8) void))
  (define glNormal3bv (foreign-procedure "glNormal3bv" (string) void))
  (define glNormal3d (foreign-procedure "glNormal3d" (double double double) void))
  (define glNormal3dv (foreign-procedure "glNormal3dv" (uptr) void))
  (define glNormal3f (foreign-procedure "glNormal3f" (float float float) void))
  (define glNormal3fv (foreign-procedure "glNormal3fv" (uptr) void))
  (define glNormal3i (foreign-procedure "glNormal3i" (int int int) void))
  (define glNormal3iv (foreign-procedure "glNormal3iv" (uptr) void))
  (define glNormal3s (foreign-procedure "glNormal3s" (short short short) void))
  (define glNormal3sv (foreign-procedure "glNormal3sv" (uptr) void))
  (define glOrtho (foreign-procedure "glOrtho" (double double double double double double) void))
  (define glPassThrough (foreign-procedure "glPassThrough" (float) void))
  (define glPixelMapfv (foreign-procedure "glPixelMapfv" (unsigned-int int uptr) void))
  (define glPixelMapuiv (foreign-procedure "glPixelMapuiv" (unsigned-int int uptr) void))
  (define glPixelMapusv (foreign-procedure "glPixelMapusv" (unsigned-int int uptr) void))
  (define glPixelStoref (foreign-procedure "glPixelStoref" (unsigned-int float) void))
  (define glPixelStorei (foreign-procedure "glPixelStorei" (unsigned-int int) void))
  (define glPixelTransferf (foreign-procedure "glPixelTransferf" (unsigned-int float) void))
  (define glPixelTransferi (foreign-procedure "glPixelTransferi" (unsigned-int int) void))
  (define glPixelZoom (foreign-procedure "glPixelZoom" (float float) void))
  (define glPointSize (foreign-procedure "glPointSize" (float) void))
  (define glPolygonMode (foreign-procedure "glPolygonMode" (unsigned-int unsigned-int) void))
  (define glPolygonStipple (foreign-procedure "glPolygonStipple" (string) void))
  (define glPopAttrib (foreign-procedure "glPopAttrib" () void))
  (define glPopMatrix (foreign-procedure "glPopMatrix" () void))
  (define glPopName (foreign-procedure "glPopName" () void))
  (define glPushAttrib (foreign-procedure "glPushAttrib" (unsigned-int) void))
  (define glPushMatrix (foreign-procedure "glPushMatrix" () void))
  (define glPushName (foreign-procedure "glPushName" (unsigned-int) void))
  (define glRasterPos2d (foreign-procedure "glRasterPos2d" (double double) void))
  (define glRasterPos2dv (foreign-procedure "glRasterPos2dv" (uptr) void))
  (define glRasterPos2f (foreign-procedure "glRasterPos2f" (float float) void))
  (define glRasterPos2fv (foreign-procedure "glRasterPos2fv" (uptr) void))
  (define glRasterPos2i (foreign-procedure "glRasterPos2i" (int int) void))
  (define glRasterPos2iv (foreign-procedure "glRasterPos2iv" (uptr) void))
  (define glRasterPos2s (foreign-procedure "glRasterPos2s" (short short) void))
  (define glRasterPos2sv (foreign-procedure "glRasterPos2sv" (uptr) void))
  (define glRasterPos3d (foreign-procedure "glRasterPos3d" (double double double) void))
  (define glRasterPos3dv (foreign-procedure "glRasterPos3dv" (uptr) void))
  (define glRasterPos3f (foreign-procedure "glRasterPos3f" (float float float) void))
  (define glRasterPos3fv (foreign-procedure "glRasterPos3fv" (uptr) void))
  (define glRasterPos3i (foreign-procedure "glRasterPos3i" (int int int) void))
  (define glRasterPos3iv (foreign-procedure "glRasterPos3iv" (uptr) void))
  (define glRasterPos3s (foreign-procedure "glRasterPos3s" (short short short) void))
  (define glRasterPos3sv (foreign-procedure "glRasterPos3sv" (uptr) void))
  (define glRasterPos4d (foreign-procedure "glRasterPos4d" (double double double double) void))
  (define glRasterPos4dv (foreign-procedure "glRasterPos4dv" (uptr) void))
  (define glRasterPos4f (foreign-procedure "glRasterPos4f" (float float float float) void))
  (define glRasterPos4fv (foreign-procedure "glRasterPos4fv" (uptr) void))
  (define glRasterPos4i (foreign-procedure "glRasterPos4i" (int int int int) void))
  (define glRasterPos4iv (foreign-procedure "glRasterPos4iv" (uptr) void))
  (define glRasterPos4s (foreign-procedure "glRasterPos4s" (short short short short) void))
  (define glRasterPos4sv (foreign-procedure "glRasterPos4sv" (uptr) void))
  (define glReadBuffer (foreign-procedure "glReadBuffer" (unsigned-int) void))
  (define glReadPixels (foreign-procedure "glReadPixels" (int int int int unsigned-int unsigned-int uptr) void))
  (define glRectd (foreign-procedure "glRectd" (double double double double) void))
  (define glRectdv (foreign-procedure "glRectdv" (uptr uptr) void))
  (define glRectf (foreign-procedure "glRectf" (float float float float) void))
  (define glRectfv (foreign-procedure "glRectfv" (uptr uptr) void))
  (define glRecti (foreign-procedure "glRecti" (int int int int) void))
  (define glRectiv (foreign-procedure "glRectiv" (uptr uptr) void))
  (define glRects (foreign-procedure "glRects" (short short short short) void))
  (define glRectsv (foreign-procedure "glRectsv" (uptr uptr) void))
  (define glRenderMode (foreign-procedure "glRenderMode" (unsigned-int) int))
  (define glRotated (foreign-procedure "glRotated" (double double double double) void))
  (define glRotatef (foreign-procedure "glRotatef" (float float float float) void))
  (define glScaled (foreign-procedure "glScaled" (double double double) void))
  (define glScalef (foreign-procedure "glScalef" (float float float) void))
  (define glScissor (foreign-procedure "glScissor" (int int int int) void))
  (define glSelectBuffer (foreign-procedure "glSelectBuffer" (int uptr) void))
  (define glShadeModel (foreign-procedure "glShadeModel" (unsigned-int) void))
  (define glStencilFunc (foreign-procedure "glStencilFunc" (unsigned-int int unsigned-int) void))
  (define glStencilMask (foreign-procedure "glStencilMask" (unsigned-int) void))
  (define glStencilOp (foreign-procedure "glStencilOp" (unsigned-int unsigned-int unsigned-int) void))
  (define glTexCoord1d (foreign-procedure "glTexCoord1d" (double) void))
  (define glTexCoord1dv (foreign-procedure "glTexCoord1dv" (uptr) void))
  (define glTexCoord1f (foreign-procedure "glTexCoord1f" (float) void))
  (define glTexCoord1fv (foreign-procedure "glTexCoord1fv" (uptr) void))
  (define glTexCoord1i (foreign-procedure "glTexCoord1i" (int) void))
  (define glTexCoord1iv (foreign-procedure "glTexCoord1iv" (uptr) void))
  (define glTexCoord1s (foreign-procedure "glTexCoord1s" (short) void))
  (define glTexCoord1sv (foreign-procedure "glTexCoord1sv" (uptr) void))
  (define glTexCoord2d (foreign-procedure "glTexCoord2d" (double double) void))
  (define glTexCoord2dv (foreign-procedure "glTexCoord2dv" (uptr) void))
  (define glTexCoord2f (foreign-procedure "glTexCoord2f" (float float) void))
  (define glTexCoord2fv (foreign-procedure "glTexCoord2fv" (uptr) void))
  (define glTexCoord2i (foreign-procedure "glTexCoord2i" (int int) void))
  (define glTexCoord2iv (foreign-procedure "glTexCoord2iv" (uptr) void))
  (define glTexCoord2s (foreign-procedure "glTexCoord2s" (short short) void))
  (define glTexCoord2sv (foreign-procedure "glTexCoord2sv" (uptr) void))
  (define glTexCoord3d (foreign-procedure "glTexCoord3d" (double double double) void))
  (define glTexCoord3dv (foreign-procedure "glTexCoord3dv" (uptr) void))
  (define glTexCoord3f (foreign-procedure "glTexCoord3f" (float float float) void))
  (define glTexCoord3fv (foreign-procedure "glTexCoord3fv" (uptr) void))
  (define glTexCoord3i (foreign-procedure "glTexCoord3i" (int int int) void))
  (define glTexCoord3iv (foreign-procedure "glTexCoord3iv" (uptr) void))
  (define glTexCoord3s (foreign-procedure "glTexCoord3s" (short short short) void))
  (define glTexCoord3sv (foreign-procedure "glTexCoord3sv" (uptr) void))
  (define glTexCoord4d (foreign-procedure "glTexCoord4d" (double double double double) void))
  (define glTexCoord4dv (foreign-procedure "glTexCoord4dv" (uptr) void))
  (define glTexCoord4f (foreign-procedure "glTexCoord4f" (float float float float) void))
  (define glTexCoord4fv (foreign-procedure "glTexCoord4fv" (uptr) void))
  (define glTexCoord4i (foreign-procedure "glTexCoord4i" (int int int int) void))
  (define glTexCoord4iv (foreign-procedure "glTexCoord4iv" (uptr) void))
  (define glTexCoord4s (foreign-procedure "glTexCoord4s" (short short short short) void))
  (define glTexCoord4sv (foreign-procedure "glTexCoord4sv" (uptr) void))
  (define glTexEnvf (foreign-procedure "glTexEnvf" (unsigned-int unsigned-int float) void))
  (define glTexEnvfv (foreign-procedure "glTexEnvfv" (unsigned-int unsigned-int uptr) void))
  (define glTexEnvi (foreign-procedure "glTexEnvi" (unsigned-int unsigned-int int) void))
  (define glTexEnviv (foreign-procedure "glTexEnviv" (unsigned-int unsigned-int uptr) void))
  (define glTexGend (foreign-procedure "glTexGend" (unsigned-int unsigned-int double) void))
  (define glTexGendv (foreign-procedure "glTexGendv" (unsigned-int unsigned-int uptr) void))
  (define glTexGenf (foreign-procedure "glTexGenf" (unsigned-int unsigned-int float) void))
  (define glTexGenfv (foreign-procedure "glTexGenfv" (unsigned-int unsigned-int uptr) void))
  (define glTexGeni (foreign-procedure "glTexGeni" (unsigned-int unsigned-int int) void))
  (define glTexGeniv (foreign-procedure "glTexGeniv" (unsigned-int unsigned-int uptr) void))
  (define glTexImage1D (foreign-procedure "glTexImage1D" (unsigned-int int int int int unsigned-int unsigned-int uptr) void))
  (define glTexImage2D (foreign-procedure "glTexImage2D" (unsigned-int int int int int int unsigned-int unsigned-int uptr) void))
  (define glTexParameterf (foreign-procedure "glTexParameterf" (unsigned-int unsigned-int float) void))
  (define glTexParameterfv (foreign-procedure "glTexParameterfv" (unsigned-int unsigned-int uptr) void))
  (define glTexParameteri (foreign-procedure "glTexParameteri" (unsigned-int unsigned-int int) void))
  (define glTexParameteriv (foreign-procedure "glTexParameteriv" (unsigned-int unsigned-int uptr) void))
  (define glTranslated (foreign-procedure "glTranslated" (double double double) void))
  (define glTranslatef (foreign-procedure "glTranslatef" (float float float) void))
  (define glVertex2d (foreign-procedure "glVertex2d" (double double) void))
  (define glVertex2dv (foreign-procedure "glVertex2dv" (uptr) void))
  (define glVertex2f (foreign-procedure "glVertex2f" (float float) void))
  (define glVertex2fv (foreign-procedure "glVertex2fv" (uptr) void))
  (define glVertex2i (foreign-procedure "glVertex2i" (int int) void))
  (define glVertex2iv (foreign-procedure "glVertex2iv" (uptr) void))
  (define glVertex2s (foreign-procedure "glVertex2s" (short short) void))
  (define glVertex2sv (foreign-procedure "glVertex2sv" (uptr) void))
  (define glVertex3d (foreign-procedure "glVertex3d" (double double double) void))
  (define glVertex3dv (foreign-procedure "glVertex3dv" (uptr) void))
  (define glVertex3f (foreign-procedure "glVertex3f" (float float float) void))
  (define glVertex3fv (foreign-procedure "glVertex3fv" (uptr) void))
  (define glVertex3i (foreign-procedure "glVertex3i" (int int int) void))
  (define glVertex3iv (foreign-procedure "glVertex3iv" (uptr) void))
  (define glVertex3s (foreign-procedure "glVertex3s" (short short short) void))
  (define glVertex3sv (foreign-procedure "glVertex3sv" (uptr) void))
  (define glVertex4d (foreign-procedure "glVertex4d" (double double double double) void))
  (define glVertex4dv (foreign-procedure "glVertex4dv" (uptr) void))
  (define glVertex4f (foreign-procedure "glVertex4f" (float float float float) void))
  (define glVertex4fv (foreign-procedure "glVertex4fv" (uptr) void))
  (define glVertex4i (foreign-procedure "glVertex4i" (int int int int) void))
  (define glVertex4iv (foreign-procedure "glVertex4iv" (uptr) void))
  (define glVertex4s (foreign-procedure "glVertex4s" (short short short short) void))
  (define glVertex4sv (foreign-procedure "glVertex4sv" (uptr) void))
  (define glViewport (foreign-procedure "glViewport" (int int int int) void))

)
