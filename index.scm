;; ============================================================
;; KIBS Root Index
;; Kubu Intelligent Build/System
;; ============================================================

(define-module (kibs index)
  #:export (
    kibs-manifest
    kibs-modules
    kibs-agents
    kibs-plugins
    kibs-packages
    kibs-build-targets
  ))

;; ------------------------------------------------------------
;; Project Identity
;; ------------------------------------------------------------

(define kibs-manifest
  '(
    (name . "kibs")
    (display-name . "Kubu Intelligent Build/System")
    (version . "0.1.0")
    (codename . "genesis")

    (author . "Kubu Lee")
    (license . "MIT")

    (runtime . "scheme")
    (architecture . "modular")
    (protocol . "kibs/1")

    (description .
      "A modular intelligent build, package, agent,
       and execution system.")
  ))

;; ------------------------------------------------------------
;; Core Modules
;; ------------------------------------------------------------

(define kibs-modules
  '(
    (core
      (path . "kibs/core/index.scm")
      (type . "runtime")
      (enabled . #t))

    (compiler
      (path . "kibs/compiler/index.scm")
      (type . "compiler")
      (enabled . #t))

    (build
      (path . "kibs/build/index.scm")
      (type . "build-system")
      (enabled . #t))

    (package
      (path . "kibs/package/index.scm")
      (type . "package-manager")
      (enabled . #t))

    (agents
      (path . "kibs/agents/index.scm")
      (type . "agent-runtime")
      (enabled . #t))

    (plugins
      (path . "kibs/plugins/index.scm")
      (type . "plugin-system")
      (enabled . #t))

    (ai
      (path . "kibs/ai/index.scm")
      (type . "ai-runtime")
      (enabled . #t))

    (cli
      (path . "kibs/cli/index.scm")
      (type . "cli")
      (enabled . #t))
  ))

;; ------------------------------------------------------------
;; AI / Agent Registry
;; ------------------------------------------------------------

(define kibs-agents
  '(
    (codex
      (provider . "openai")
      (runtime . "acp")
      (backend . "acpx")
      (mode . "persistent")
      (enabled . #t))

    (claude
      (provider . "anthropic")
      (runtime . "acp")
      (backend . "acpx")
      (mode . "persistent")
      (enabled . #t))

    (gemini
      (provider . "google")
      (runtime . "api")
      (mode . "persistent")
      (enabled . #t))

    (local
      (provider . "local")
      (runtime . "native")
      (mode . "persistent")
      (enabled . #t))
  ))

;; ------------------------------------------------------------
;; Plugin Registry
;; ------------------------------------------------------------

(define kibs-plugins
  '(
    (name . "default")
    (path . "plugins/index.scm")
    (autoload . #t)
  ))

;; ------------------------------------------------------------
;; Package Registry
;; ------------------------------------------------------------

(define kibs-packages
  '(
    (registry . "packages/index.scm")
    (sources
      ("local")
      ("workspace")
      ("remote"))
    (resolution . "semver")
  ))

;; ------------------------------------------------------------
;; Build Targets
;; ------------------------------------------------------------

(define kibs-build-targets
  '(
    (default
      (command . "kibs build"))

    (development
      (command . "kibs build --profile development"))

    (production
      (command . "kibs build --profile production"))

    (test
      (command . "kibs test"))

    (clean
      (command . "kibs clean"))
  ))
