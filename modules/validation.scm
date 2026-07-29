;; ============================================================
;; kibs/contacts/validator.scm
;; vCard Validation
;; ============================================================

(define supported-vcard-versions
’(“3.0” “4.0”))

(define (validate-vcard card)
(let (
(errors ’())
)

(if (not (member
           (assoc-ref card 'version)
           supported-vcard-versions))
    (set! errors
          (cons "Unsupported vCard VERSION" errors)))
(if (empty?
      (assoc-ref card 'fn))
    (set! errors
          (cons "Missing required FN field" errors)))
(if (and
      (empty? (assoc-ref card 'emails))
      (empty? (assoc-ref card 'phones)))
    (set! errors
          (cons "Contact must contain EMAIL or TEL" errors)))
(if (valid-email-list?
      (assoc-ref card 'emails))
    #t
    (set! errors
          (cons "Invalid email address" errors)))
(if (null? errors)
    '(
      (valid . #t)
      (errors . ())
    )
    '(
      (valid . #f)
      (errors . errors)
    ))))

(define (validation-success? results)
(every
(lambda (result)
(assoc-ref result ’valid))
results))
