(define-module (suika-chan packages python-web)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages tls)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system pyproject)
  #:use-module (suika-chan packages rpc)
  #:use-module (suika-chan packages python-xyz))
(define-public python-modal
  (package
    (name "python-modal")
    (version "1.5.2")
    (source (origin
      (method url-fetch)
      (uri (pypi-uri "modal" version))
      (sha256 (base32 "12h0q19pikbl15slqdzia4vpmwvm9m00cn9qah6bib6cxj1jj3dc"))))
    (build-system pyproject-build-system)
    (arguments (list #:tests? #f))
    (native-inputs (list
      python-setuptools))
    (propagated-inputs (list
      nss-certs
      openssl
      python-aiohttp
      python-cbor2
      python-certifi
      python-click
      python-grpclib
      python-protobuf
      python-rich
      python-synchronicity
      python-toml
      python-types-certifi
      python-types-toml
      python-typing-extensions
      python-watchfiles))
    (home-page "https://modal.com")
    (synopsis "Python client library for Modal")
    (description "Python client library for Modal.")
    (license #f)))

