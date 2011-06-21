; vim: set filetype=lisp autoindent:

(in-package :cl-user)

(asdf:defsystem :vis
                :serial t
                :components ((:file "package")
                             (:file "vis"))
                :depends-on (:lispbuilder-sdl))

