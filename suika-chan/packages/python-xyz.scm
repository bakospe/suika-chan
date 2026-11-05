(define-module (suika-chan packages python-xyz)
  #:use-module (gnu packages python-build)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system pyproject))
(define-public python-synchronicity
  (package
    (name "python-synchronicity")
    (version "0.12.5")
    (source (origin
      (method url-fetch)
      (uri (pypi-uri "synchronicity" version))
      (sha256 (base32 "1aihwbpqalzbppx7gn57wj26bbs91663nybap5b313k9hlfnpncl"))))
    (build-system pyproject-build-system)
    (arguments (list #:tests? #f))
    (native-inputs (list
      python-hatchling))
    (propagated-inputs (list
      python-typing-extensions))
    (home-page #f)
    (synopsis "Export blocking and async library versions from a single async implementation")
    (description "Export blocking and async library versions from a single async implementation.")
    (license #f)))
(define-public python-types-certifi
  (package
    (name "python-types-certifi")
    (version "2021.10.8.3")
    (source (origin
      (method url-fetch)
      (uri (pypi-uri "types-certifi" version))
      (sha256 (base32 "0ksaan5yha5r4d2nc7f288y0diwp63md23f1w5v0pg35s6c7gkvj"))))
    (build-system pyproject-build-system)
    (arguments (list #:tests? #f))
    (native-inputs (list
      python-setuptools))
    (home-page "https://github.com/python/typeshed")
    (synopsis "Typing stubs for certifi")
    (description "Typing stubs for certifi.")
    (license #f)))

