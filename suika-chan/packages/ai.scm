(define-module (suika-chan packages ai)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:))
(define-public opencode
  (package
    (name "opencode")
    (version "2.2.5")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://github.com/anomalyco/opencode/releases/download/v"
        version
        "/opencode-linux-x64.tar.gz"))
      (sha256 (base32 "0kk1g4mbx6zwkmzijjgn0vflbpzmmv8izj2r5y8kdl0gq4147x09"))))
    (supported-systems '("x86_64-linux"))
    (build-system trivial-build-system)
    (arguments (list
      #:modules '((guix build utils))
      #:builder #~(begin
        (use-modules (guix build utils))
        (let* (
          (target (string-append (assoc-ref %outputs "out") "/bin"))
          (dest (string-append target "/opencode"))
          (source (assoc-ref %build-inputs "source"))
          (loader (search-input-file %build-inputs "lib/ld-linux-x86-64.so.2"))
          (tar (string-append (assoc-ref %build-inputs "tar") "/bin/tar"))
          (pigz (string-append (assoc-ref %build-inputs "pigz") "/bin/pigz"))
          (patchelf (string-append (assoc-ref %build-inputs "patchelf") "/bin/patchelf")))
          (mkdir-p target)
          (invoke tar "-xvf" source "-C" target "-I" pigz)
          (invoke patchelf "--set-interpreter" loader dest)))))
    (native-inputs (list
      patchelf
      pigz
      tar))
    (inputs (list
      glibc))
    (home-page "https://opencode.ai/")
    (synopsis "OpenCode: The open source AI coding agent")
    (description "Free models included or connect any model from any provider, including Claude, GPT, Gemini and more.")
    (license license:expat)))
(define-public claude-code
  (package
    (name "claude-code")
    (version "2.1.331")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://downloads.claude.ai/claude-code-releases/"
        version
        "/linux-x64/claude"))
      (sha256 (base32 "1c968swwljxpk5i66v743wrgkxrqspr0a09ixhw2psvbyjf8602c"))))
    (supported-systems '("x86_64-linux"))
    (build-system trivial-build-system)
    (arguments (list
      #:modules '((guix build utils))
      #:builder #~(begin
        (use-modules (guix build utils))
        (let* (
          (target (string-append (assoc-ref %outputs "out") "/bin"))
          (dest (string-append target "/claude"))
          (source (assoc-ref %build-inputs "source"))
          (loader (search-input-file %build-inputs "lib/ld-linux-x86-64.so.2"))
          (patchelf (string-append (assoc-ref %build-inputs "patchelf") "/bin/patchelf")))
          (mkdir-p target)
          (copy-file source dest)
          (chmod dest #o755)
          (invoke patchelf "--set-interpreter" loader dest)))))
    (native-inputs (list
      patchelf))
    (inputs (list
      glibc))
    (home-page "https://code.claude.com/")
    (synopsis "Claude Code: Anthropic's agentic coding tool")
    (description "Claude Code is an agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster.")
    (license #f)))

