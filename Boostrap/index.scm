;; ============================================================
;; KIBS MASTER BOOTSTRAP
;; index.scm
;; ============================================================

;; Core
(load “kibs/core/config.scm”)
(load “kibs/core/state.scm”)
(load “kibs/core/events.scm”)
(load “kibs/core/kernel.scm”)
(load “kibs/core/scheduler.scm”)

;; Web
(load “kibs/web/server.scm”)
(load “kibs/web/router.scm”)
(load “kibs/web/api.scm”)

;; Agents
(load “kibs/agents/agent.scm”)
(load “kibs/agents/registry.scm”)
(load “kibs/agents/orchestrator.scm”)

;; Services
(load “kibs/services/database.scm”)
(load “kibs/services/storage.scm”)
(load “kibs/services/blockchain.scm”)
(load “kibs/services/external.scm”)

;; Contacts
(load “kibs/contacts/vcard.scm”)
(load “kibs/contacts/parser.scm”)
(load “kibs/contacts/validator.scm”)
(load “kibs/contacts/importer.scm”)
(load “kibs/contacts/manager.scm”)
(load “kibs/contacts/storage.scm”)

;; ============================================================
;; KIBS STARTUP
;; ============================================================

(define (kibs-start)

(display “=================================\n”)
(display “          KIBS STARTING           \n”)
(display “=================================\n”)

;; Initialize core
(initialize-state)
(initialize-kernel)
(initialize-scheduler)
(initialize-events)

;; Initialize services
(initialize-database)
(initialize-storage)
(initialize-blockchain)

;; Initialize agents
(initialize-agent-registry)
(initialize-agent-orchestrator)

;; Register HTTP routes
(initialize-router)

;; Start HTTP runtime
(start-kibs-server)

(display “KIBS is operational.\n”))

;; ============================================================
;; START KIBS
;; ============================================================

(kibs-start)
