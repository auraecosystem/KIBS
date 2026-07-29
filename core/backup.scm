;; ============================================================
;; KIBS BACKUP & RECOVERY
;; kibs/core/backup.scm
;; ============================================================

(define kibs-index “index.scm”)
(define kibs-backup “index.bak”)

;; ————————————————————
;; Check if a file exists
;; ————————————————————

(define (kibs-file-exists? path)
(file-exists? path))

;; ————————————————————
;; Create Backup
;; ————————————————————

(define (kibs-create-backup)

(if (kibs-file-exists? kibs-index)

  (begin
    (copy-file
      kibs-index
      kibs-backup)
    (display
      "KIBS: index.scm backed up successfully.\n"))
  (display
    "KIBS: index.scm not found. Backup skipped.\n")))

;; ————————————————————
;; Restore Backup
;; ————————————————————

(define (kibs-restore-backup)

(if (kibs-file-exists? kibs-backup)

  (begin
    (copy-file
      kibs-backup
      kibs-index)
    (display
      "KIBS: index.bak restored to index.scm.\n")
    #t)
  (begin
    (display
      "KIBS: No backup available.\n")
    #f)))

;; ————————————————————
;; Validate Index
;; ————————————————————

(define (kibs-index-valid?)

(and
(kibs-file-exists? kibs-index)

;; Replace this with your actual
;; Scheme syntax/runtime validation.
#t))

;; ————————————————————
;; Safe Startup
;; ————————————————————

(define (kibs-safe-start)

(display “KIBS: Starting safe startup…\n”)

;; Create backup of current index
(kibs-create-backup)

;; Validate current index
(if (kibs-index-valid?)

  (begin
    (display
      "KIBS: index.scm is valid.\n")
    (display
      "KIBS: Continuing startup.\n")
    #t)
  (begin
    (display
      "KIBS: index.scm validation failed.\n")
    (display
      "KIBS: Attempting recovery...\n")
    (kibs-restore-backup))))
