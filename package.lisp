; vim: set filetype=lisp autoindent:

(defpackage :vis
  (:use :cl :sb-thread)
  (:export :with-vis
           :with-threaded-vis
           :init-vis
           :put-pixel
           :put-glyph
           :clear
           :end
           :push-draw-event
           :put-text))
 
