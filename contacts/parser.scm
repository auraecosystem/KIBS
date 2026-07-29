;; ============================================================
;; kibs/contacts/parser.scm
;; vCard Parser
;; ============================================================

(define (parse-vcard-content content)
(let* (
(lines
(vcard-unfold-lines content))

      (records
        (split-vcard-records lines))
    )
(map parse-vcard-record records)))

(define (parse-vcard-record record)
(let (
(fields
(map parse-vcard-field record))
)

`(
  (version . ,(field-value fields "VERSION"))
  (uid . ,(field-value fields "UID"))
  (fn . ,(field-value fields "FN"))
  (n . ,(field-value fields "N"))
  (org . ,(field-value fields "ORG"))
  (title . ,(field-value fields "TITLE"))
  (emails . ,(field-values fields "EMAIL"))
  (phones . ,(field-values fields "TEL"))
  (addresses
    . ,(field-values fields "ADR"))
  (urls
    . ,(field-values fields "URL"))
  (note
    . ,(field-value fields "NOTE"))
  (categories
    . ,(field-values fields "CATEGORIES"))
)))

(define (parse-vcard-field line)
;; Parse:
;; PROPERTY;PARAM=value:value
;;
;; Example:
;; TEL;TYPE=CELL:+234XXXXXXXXXX

(let* (
(parts
(split-property-value line))

      (property
        (car parts))
      (value
        (cdr parts))
    )
`(
  (property . ,property)
  (value . ,value)
)))

(define (vcard-unfold-lines content)
;; RFC-compatible line unfolding.
;; Continuation lines beginning with SPACE or TAB
;; are joined with the previous line.
(unfold-vcard-lines content))

(define (split-vcard-records lines)
;; Extract BEGIN:VCARD … END:VCARD blocks.
(extract-vcard-blocks lines))
