(in-package :vis)

(defparameter *bck-color* sdl:*black*)
(defparameter *width* nil)
(defparameter *height* nil)
(defparameter *title* nil)
(defparameter *scale* nil)
(defparameter *framerate* nil)
(defparameter *font* nil)



(defun init-vis (&optional (height 300) (width 300) (title "output") (scale 1) (rate 0))
  (setf *width* (* scale width) 
        *height* (* scale height) 
        *title* title 
        *scale* scale 
        *framerate* rate 
        *font*  (sdl:initialise-default-font sdl:*font-10x20*))
  t)


(defun end ()
  (sdl:push-quit-event))

(defun push-draw-event ()
  (sdl:push-user-event :code 0 :data1 (sb-sys:int-sap 0) :data2 (sb-sys:int-sap 0)))

(defun clear (&optional (color sdl:*black*))
  (sdl:clear-display color))

(defun put-pixel (x y)
  (sdl:draw-pixel-* (* *scale* x) (* *scale* y)
                    :color sdl:*red*
                    :surface sdl:*default-display*))

(defun put-glyph (x y &optional (color sdl:*red*))
  (let ((scaledx (* *scale* x))
        (scaledy (* *scale* y)))
  (sdl:draw-box
    (sdl:rectangle-from-edges
      (sdl:point :x scaledx :y scaledy)
      (sdl:point :x (+ -1 scaledx *scale*):y (+ -1 scaledy *scale*)))
    :color color)))

(defun put-text (x y msg &key (val "") (j :right)) 
  (sdl:draw-string-solid-* (with-output-to-string (s) (format s "~a~a" msg val))
                           x y
                           :justify j
                           :color sdl:*white* :font *font*))


(defmacro with-vis (&body body)
  `(sdl:with-init ()
                  (sdl:window *width* *height* :title-caption *title* :double-buffer t)
                  (setf (sdl:frame-rate) *framerate*)
                  (sdl:with-events ()
                                   (:quit-event () t)
                                   (:idle ()
                                          ,@body
                                          (sdl:update-display)))))

(defmacro with-threaded-vis (&body body)
  `(sb-thread:make-thread (lambda () (sdl:with-init ()
                                                    (sdl:window *width* *height* :title-caption *title* :double-buffer t)
                                                    (setf (sdl:frame-rate) 0)
                                                    (sdl:with-events (:wait)
                                                                     (:quit-event () t)
                                                                     (:user-event ()
                                                                                  ,@body
                                                                                  (sdl:update-display)))))))


