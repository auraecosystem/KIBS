;; ============================================================
;; KIBS CONTACT TASK EXECUTOR
;; kibs/contacts/importer.scm
;; ============================================================

(define (import-vcard-task payload)

(let* (
;; 1. Get file path
(path payload)

      ;; 2. Read vCard
      (raw-data
        (vcard-read-file path))
      ;; 3. Parse vCard
      (cards
        (vcard-parse raw-data))
      ;; 4. Validate
      (validation
        (vcard-validate-all cards))
    )
;; 5. Stop if invalid
(if (not (validation-success? validation))
    `(
      (status . "failed")
      (reason . "validation-error")
      (errors . ,validation)
    )
    ;; 6. Import valid contacts
    (let (
          (result
            (contact-import
              cards
              vcard-config))
         )
      `(
        (status . "success")
        (task . "vcard-import")
        (imported . ,result)
      )))))
