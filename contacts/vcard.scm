;; ============================================================
;; kibs/contacts/vcard.scm
;; KIBS vCard Interface
;; ============================================================

(define (vcard-read-file path)
(if (file-exists? path)
(read-file path)
(error “vCard file does not exist” path)))

(define (vcard-parse content)
;; Delegate parsing to parser.scm
(parse-vcard-content content))

(define (vcard-validate card)
;; Delegate validation
(validate-vcard card))

(define (vcard-validate-all cards)
(map vcard-validate cards))

(define (vcard-to-contact card)
’(
(name . …)
(first-name . …)
(last-name . …)
(organization . …)
(emails . …)
(phones . …)
(addresses . …)
(urls . …)
(notes . …)
))
