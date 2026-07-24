(define (kibs-load-module name)
  (let ((module (kibs-module name)))
    (if module
        (display
          (string-append
            "Loading KIBS module: "
            (symbol->string (car module))
            "\n"))
        (error "KIBS module not found" name))))
