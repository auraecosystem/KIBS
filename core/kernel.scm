;; ============================================================
;; KIBS CORE KERNEL
;; kibs/core/kernel.scm
;; ============================================================

(define kibs-task-handlers ’())

;; ————————————————————
;; Register a Task Handler
;; ————————————————————

(define (register-task task-name handler)
(set!
kibs-task-handlers
(cons
(cons task-name handler)
kibs-task-handlers)))

;; ————————————————————
;; Find Task Handler
;; ————————————————————

(define (find-task-handler task-name)
(let ((entry
(assoc task-name kibs-task-handlers)))
(if entry
(cdr entry)
#f)))

;; ————————————————————
;; Execute Task
;; ————————————————————

(define (kibs-execute-task task)
(let* (
(task-name
(assoc-ref task ’type))

      (payload
        (assoc-ref task 'payload))
      (handler
        (find-task-handler task-name))
    )
(if handler
    (handler payload)
    (error
      "KIBS: No handler registered for task"
      task-name))))

;; ————————————————————
;; Task Registration
;; ————————————————————

(define (initialize-kernel)
(display “Initializing KIBS Kernel…\n”)

;; Web tasks
(register-task
’http-request
handle-http-request)

;; Agent tasks
(register-task
’agent-execute
execute-agent)

;; Service tasks
(register-task
’service-execute
execute-service)

;; Contact tasks
(register-task
’vcard-import
import-vcard-task)

(display “KIBS Kernel ready.\n”))
