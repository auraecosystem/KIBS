;; ============================================================
;; KIBS — Main Runtime Entry Point
;; vCard Contact Integration
;; ============================================================

(define kibs
’(
(name . “KIBS”)
(version . “1.0.0”)
(runtime . “scheme”)
(web-entrypoint . “index.html”)
(vcard-enabled . #t)
))

;; ————————————————————
;; Core Runtime
;; ————————————————————

(load “kibs/core/config.scm”)
(load “kibs/core/kernel.scm”)
(load “kibs/core/lifecycle.scm”)

;; ————————————————————
;; vCard Contact System
;; ————————————————————

(load “kibs/contacts/vcard.scm”)
(load “kibs/contacts/parser.scm”)
(load “kibs/contacts/validator.scm”)
(load “kibs/contacts/importer.scm”)
(load “kibs/contacts/storage.scm”)
(load “kibs/contacts/manager.scm”)

;; ————————————————————
;; Web Layer
;; ————————————————————

(load “kibs/web/router.scm”)
(load “kibs/web/api.scm”)

;; ————————————————————
;; Contact Configuration
;; ————————————————————

(define vcard-config
’(
(inbox . “assets/vcard/inbox.vcf”)
(storage . “data/contacts/contacts.db”)
(encoding . “UTF-8”)
(duplicate-policy . “merge”)
(validation . “strict”)
))

;; ————————————————————
;; Contact System Initialization
;; ————————————————————

(define (initialize-contacts)
(display “Initializing KIBS Contact System…\n”)

(contact-storage-init
(assoc-ref vcard-config ’storage))

(display “Contact storage initialized.\n”))

;; ————————————————————
;; Import vCard File
;; ————————————————————

(define (kibs-import-vcard path)
(let* (
(raw-data
(vcard-read-file path))

      (cards
        (vcard-parse raw-data))
      (validation
        (vcard-validate-all cards))
    )
(if (validation-success? validation)
    (begin
      (contact-import
        cards
        vcard-config)
      '(
        (status . "success")
        (imported . #t)
        (count . (length cards))
      ))
    '(
      (status . "error")
      (imported . #f)
      (errors . validation)
    ))))

;; ————————————————————
;; Contact Management API
;; ————————————————————

(define (kibs-list-contacts)
(contact-list))

(define (kibs-get-contact id)
(contact-get id))

(define (kibs-create-contact contact)
(contact-create contact))

(define (kibs-update-contact id contact)
(contact-update id contact))

(define (kibs-delete-contact id)
(contact-delete id))

;; ————————————————————
;; HTTP Routes
;; ————————————————————

(define contact-routes
’(
(GET  “/api/contacts”          kibs-list-contacts)
(GET  “/api/contacts/:id”      kibs-get-contact)
(POST “/api/contacts”          kibs-create-contact)
(PUT  “/api/contacts/:id”      kibs-update-contact)
(DELETE “/api/contacts/:id”    kibs-delete-contact)

(POST "/api/contacts/import"   kibs-import-vcard)

))

;; ————————————————————
;; Runtime Bootstrap
;; ————————————————————

(define (kibs-start)
(display “Starting KIBS…\n”)

(initialize-config)
(initialize-kernel)
(initialize-contacts)

(register-routes contact-routes)

(display “KIBS Contact System ready.\n”))

(kibs-start)
