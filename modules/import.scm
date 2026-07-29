;; ============================================================
;; kibs/contacts/importer.scm
;; vCard Import Engine
;; ============================================================

(define (contact-import cards config)
(map
(lambda (card)
(let (
(contact
(vcard-to-contact card))
)

    (contact-import-one
      contact
      config)))
cards))

(define (contact-import-one contact config)
(let (
(existing
(contact-find-duplicate contact))
)

(cond
  ;; Existing contact found
  ((and existing
        (equal?
          (assoc-ref config 'duplicate-policy)
          "merge"))
   (contact-merge
     existing
     contact))
  ;; Existing contact, skip
  ((and existing
        (equal?
          (assoc-ref config 'duplicate-policy)
          "skip"))
   existing)
  ;; New contact
  (else
    (contact-create contact)))))
