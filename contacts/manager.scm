;; ============================================================
;; kibs/contacts/manager.scm
;; Contact Management
;; ============================================================

(define (contact-list)
(contact-storage-list))

(define (contact-get id)
(contact-storage-get id))

(define (contact-create contact)
(let (
(normalized
(normalize-contact contact))
)

(contact-storage-create normalized)))

(define (contact-update id contact)
(let (
(existing
(contact-get id))
)

(if existing
    (contact-storage-update
      id
      (normalize-contact contact))
    (error "Contact not found" id))))

(define (contact-delete id)
(if (contact-get id)
(contact-storage-delete id)
(error “Contact not found” id)))

(define (contact-find-duplicate contact)
(or
(contact-find-by-uid
(assoc-ref contact ’uid))

(contact-find-by-email
  (assoc-ref contact 'emails))
(contact-find-by-phone
  (assoc-ref contact 'phones))))

(define (contact-merge old new)
(let (
(merged
(merge-contact-records old new))
)

(contact-storage-update
  (assoc-ref old 'id)
  merged)))
