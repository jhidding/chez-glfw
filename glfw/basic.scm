#| Copyright 2016 Johan Hidding
 |
 | Licensed under the Apache License, Version 2.0 (the "License");
 | you may not use this file except in compliance with the License.
 | You may obtain a copy of the License at
 |
 |    http://www.apache.org/licenses/LICENSE-2.0
 |
 | Unless required by applicable law or agreed to in writing, software
 | distributed under the License is distributed on an "AS IS" BASIS,
 | WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 | See the License for the specific language governing permissions and
 | limitations under the License.
 |#

(library (glfw basic)
  (export with-glfw-vid-mode

          glfw-init glfw-terminate glfw-get-version-string
          glfw-create-window
          glfw-set-input-mode glfw-get-input-mode

          glfw-get-framebuffer-size
          glfw-get-time glfw-set-time

          glfw-set-error-callback glfw-set-key-callback
          glfw-set-char-callback
          glfw-set-window-close-callback
          glfw-set-framebuffer-size-callback
          glfw-set-mouse-button-callback
          glfw-set-cursor-pos-callback

          glfw-set-window-aspect-ratio
          glfw-window-hint

          glfw-get-primary-monitor
          glfw-get-video-mode

          glfw-make-context-current
          glfw-window-should-close glfw-set-window-should-close
          glfw-swap-buffers glfw-swap-interval
          glfw-poll-events glfw-wait-events glfw-wait-events-timeout

          glfw-get-proc-address glfw-extension-supported)

  (import (chezscheme)
          (lyonesse foreign-structs))

  (define-syntax callback
    (syntax-rules ()
      ((callback p (<args> ...) <ret>)
       (let ([code (foreign-callable p (<args> ...) <ret>)])
         (lock-object code)
         (foreign-callable-entry-point code)))))

  (define lib (load-shared-object "libglfw.so"))

  #| Types ================================================================= |#
  (define-foreign-struct glfw-vid-mode
    [width        int]
    [height       int]
    [red-bits     int]
    [green-bits   int]
    [blue-bits    int]
    [refresh-rate int])

  #| Library initialisation and tear-down ================================== |#
  (define glfw-init
    (foreign-procedure "glfwInit" () boolean))

  (define glfw-terminate
    (foreign-procedure "glfwTerminate" () void))

  (define glfw-get-version-string
    (foreign-procedure "glfwGetVersionString" () string))

  #|! This function sets an input mode option for the specified window. The
   |  mode must be one of `GLFW_CURSOR`, `GLFW_STICKY_KEYS` or
   |  `GLFW_STICKY_MOUSE_BUTTONS`.
   |
   |  If the mode is GLFW_CURSOR, the value must be one of the following cursor
   |  modes:
   |   * `GLFW_CURSOR_NORMAL` makes the cursor visible and behaving normally.
   |   * `GLFW_CURSOR_HIDDEN` makes the cursor invisible when it is over the
   |     client area of the window but does not restrict the cursor from leaving.
   |   * `GLFW_CURSOR_DISABLED` hides and grabs the cursor, providing virtual
   |     and unlimited cursor movement. This is useful for implementing for
   |     example 3D camera controls.
   |
   |  If the mode is `GLFW_STICKY_KEYS`, the value must be either `GLFW_TRUE`
   |  to enable sticky keys, or `GLFW_FALSE` to disable it. If sticky keys are
   |  enabled, a key press will ensure that `glfw-get-key` returns `GLFW_PRESS`
   |  the next time it is called even if the key had been released before the
   |  call. This is useful when you are only interested in whether keys have
   |  been pressed but not when or in which order.
   |
   |  If the mode is `GLFW_STICKY_MOUSE_BUTTONS`, the value must be either
   |  `GLFW_TRUE` to enable sticky mouse buttons, or `GLFW_FALSE` to disable
   |  it. If sticky mouse buttons are enabled, a mouse button press will
   |  ensure that glfwGetMouseButton returns GLFW_PRESS the next time it is
   |  called even if the mouse button had been released before the call. This
   |  is useful when you are only interested in whether mouse buttons have been
   |  pressed but not when or in which order.
   |
   | window: ptr
   | mode:   int
   | value:  int
   |#
  (define glfw-set-input-mode
    (foreign-procedure "glfwSetInputMode" (uptr int int) void))

  #|! This function returns the value of an input option for the specified
   |  window. The mode must be one of `GLFW_CURSOR`, `GLFW_STICKY_KEYS` or
   |  `GLFW_STICKY_MOUSE_BUTTONS`
   |
   | window: ptr
   | mode:   int
   | -> value: int
   |#
  (define glfw-get-input-mode
    (foreign-procedure "glfwGetInputMode" (uptr int) int))


  #| Callback setters ====================================================== |#
  #|! Set the callback function in case of an error.
   |
   | cb:lambda (err:int msg:string) -> void
   |#
  (define (glfw-set-error-callback cb)
    ((foreign-procedure "glfwSetErrorCallback" (uptr) void)
     (callback cb (int string) void)))

  #|! Set the callback function for window close event. This callback is called
   |  when a user attempts to close the window from the window manager.
   |  If the function is to prevent this from happening it should call
   |  `(set-window-should-close #f)`
   |
   | window: ptr
   | cb:     lambda (window:ptr) -> void
   |#
  (define (glfw-set-window-close-callback window cb)
    ((foreign-procedure "glfwSetWindowCloseCallback" (uptr uptr) uptr)
     window (callback cb (uptr) void)))

  #|! Set the callback function for keyboard events.
   |
   | window: ptr
   | cb:     lambda (window:ptr key:int scancode:int action:int mods:int) -> void
   |#
  (define (glfw-set-key-callback window cb)
    ((foreign-procedure "glfwSetKeyCallback" (uptr uptr) uptr)
     window (callback cb (uptr int int int int) void)))

  #|! This is the function signature for framebuffer resize callback functions.
   |
   | window: ptr
   | cb:     lambda (window:ptr width:int height:int)
   |#
  (define (glfw-set-framebuffer-size-callback window cb)
    ((foreign-procedure "glfwSetFramebufferSizeCallback" (uptr uptr) uptr)
     window (callback cb (uptr int int) void)))

  #|! This function sets the character callback of the specified window, which
   |  is called when a Unicode character is input.
   |
   |  The character callback is intended for Unicode text input. As it deals
   |  with characters, it is keyboard layout dependent, whereas the key
   |  callback is not.  Characters do not map 1:1 to physical keys, as a key
   |  may produce zero, one or more characters. If you want to know whether a
   |  specific physical key was pressed or released, see the key callback
   |  instead.
   |
   |  The character callback behaves as system text input normally does and
   |  will not be called if modifier keys are held down that would prevent
   |  normal text input on that platform, for example a Super (Command) key on
   |  OS X or Alt key on Windows. There is a character with modifiers callback
   |  that receives these events.
   |
   | window: ptr
   | cb:     lambda (window:ptr codepoint:unsigned-32)
   | ->:     ptr
   |     Previous handler, but actually the FFI packed one.
   |#
  (define (glfw-set-char-callback window cb)
    ((foreign-procedure "glfwSetCharCallback" (uptr uptr) uptr)
     window (callback cb (uptr unsigned-32) void)))

  (define (glfw-set-mouse-button-callback window cb)
    ((foreign-procedure "glfwSetMouseButtonCallback" (uptr uptr) uptr)
     window (callback cb (uptr int int int) void)))

  (define (glfw-set-cursor-pos-callback window cb)
    ((foreign-procedure "glfwSetCursorPosCallback" (uptr uptr) uptr)
     window (callback cb (uptr double double) void)))

  #| Timing ================================================================ |#
  #|! This function returns the value of the GLFW timer. Unless the timer has
   |  been set using `glfw-set-time`, the timer measures time elapsed since
   |  GLFW was initialized.
   |
   |  The resolution of the timer is system dependent, but is usually on the
   |  order of a few micro- or nanoseconds. It uses the highest-resolution
   |  monotonic time source on each supported platform.
   |
   | ->: double
   |     Current time in seconds.
   |#
  (define glfw-get-time
    (foreign-procedure "glfwGetTime" () double))

  #|! Set the GLFW time. It then continues to count up from that value.
   |  The value must be a positive finite number less than or equal to
   |  18446744073.0, which is approximately 584.5 years.
   |
   | time: double
   |#
  (define glfw-set-time
    (foreign-procedure "glfwSetTime" (double) void))

  #| Monitors ============================================================== |#
  (define glfw-get-primary-monitor
    (foreign-procedure "glfwGetPrimaryMonitor" () uptr))

  (define glfw-get-video-mode
    (foreign-procedure "glfwGetVideoMode" (uptr) (* glfw-vid-mode)))

  #| Windowing ============================================================= |#
  #|! This function creates a window and its associated OpenGL or OpenGL ES
   |  context. Most of the options controlling how the window and its context
   |  should be created are specified with window hints.
   |
   | width:   int
   | height:  int
   | title:   string
   | monitor: ptr
   |     Monitor to use for full-screen mode, NULL will give windowed mode.
   | window:  ptr
   |     Window to share resources with. Usually just NULL.
   | ->: ptr
   |#
  (define glfw-create-window
    (foreign-procedure "glfwCreateWindow" (int int string uptr uptr) uptr))

  #|! This function destroys the specified window and its context. On calling
   |  this function, no further callbacks will be called for that window.
   |
   |  If the context of the specified window is current on the main thread, it is
   |  detached before being destroyed.
   |
   | window: ptr
   |#
  (define glfw-destroy-window
    (foreign-procedure "glfwDestroyWindow" (uptr) void))

  (define glfw-window-hint
    (foreign-procedure "glfwWindowHint" (int int) void))

  (define glfw-set-window-aspect-ratio
    (foreign-procedure "glfwSetWindowAspectRatio" (uptr int int) void))

  (define glfw-window-should-close
    (foreign-procedure "glfwWindowShouldClose" (uptr) boolean))

  (define glfw-set-window-should-close
    (foreign-procedure "glfwSetWindowShouldClose" (uptr boolean) void))

  (define glfw-get-framebuffer-size
    (let ([get-framebuffer-size (foreign-procedure "glfwGetFramebufferSize"
                                                   (uptr uptr uptr)
                                                   void)])
      (lambda (window)
        (let* ([int-size (foreign-sizeof 'int)]
               [data     (foreign-alloc (* 2 int-size))])
          (get-framebuffer-size window data (+ data int-size))
          (let ([w (foreign-ref 'int data 0)]
                [h (foreign-ref 'int data int-size)])
            (foreign-free data)
            (values w h))))))

  #| Event polling ========================================================= |#
  (define glfw-poll-events
    (foreign-procedure "glfwPollEvents" () void))

  (define glfw-wait-events
    (foreign-procedure "glfwWaitEvents" () void))

  #|! This function puts the calling thread to sleep until at least one event
   |  is available in the event queue, or until the specified timeout is
   |  reached. If one or more events are available, it behaves exactly like
   |  `glfw-poll-events`, i.e. the events in the queue are processed and the
   |  function then returns immediately. Processing events will cause the
   |  window and input callbacks associated with those events to be called.
   |
   | timeout: double
   |     Timeout in seconds.
   |#
  (define glfw-wait-events-timeout
    (foreign-procedure "glfwWaitEventsTimeout" (double) void))

  #| And all the rest ====================================================== |#
  (define glfw-make-context-current
    (foreign-procedure "glfwMakeContextCurrent" (uptr) void))

  (define glfw-swap-buffers
    (foreign-procedure "glfwSwapBuffers" (uptr) void))

  #|! This function sets the swap interval for the current OpenGL or OpenGL ES
   |  context, i.e. the number of screen updates to wait from the time
   |  `glfw-swap-buffers` was called before swapping the buffers and returning.
   |  This is sometimes called vertical synchronization, vertical retrace
   |  synchronization or just vsync.
   |
   | interval: int
   |     The minimum number of screen updates to wait for until the buffers are
   |     swapped by `glfw-swap-buffers`.
   |#
  (define glfw-swap-interval
    (foreign-procedure "glfwSwapInterval" (int) void))

  #| GL loader ============================================================= |#
  #|! This function returns the address of the specified OpenGL or OpenGL ES
   |  core or extension function, if it is supported by the current context.
   |  A context must be current on the calling thread. Calling this function
   |  without a current context will cause a GLFW_NO_CURRENT_CONTEXT error.
   |#
  (define glfw-get-proc-address
    (foreign-procedure "glfwGetProcAddress" (string) uptr))

  (define glfw-extension-supported
    (foreign-procedure "glfwExtensionSupported" (string) int))
)


