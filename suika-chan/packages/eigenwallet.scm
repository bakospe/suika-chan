(define-module (suika-chan packages eigenwallet)
  #:use-module (gnu packages)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages webkit)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (nonguix build-system binary))
(define-public eigenwallet
  (package
    (name "eigenwallet")
    (version "4.11.4")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://github.com/eigenwallet/core/releases/download/"
        version
        "/eigenwallet_"
        version
        "_amd64.deb"))
      (sha256 (base32 "1nfpp1mhsymrd6m346prfbhrv5ibnj4z4y8iba2v7ad08hfcsrji"))))
    (build-system binary-build-system)
    (arguments (list
      #:validate-runpath? #f
      #:phases #~(modify-phases %standard-phases
        (add-after 'install 'verify-and-symlink-bin
          (lambda _
            (let* (
              (source (assoc-ref %build-inputs "source"))
              (gnupg (assoc-ref %build-inputs "gnupg"))
              (pubkey (assoc-ref %build-inputs "pubkey"))
              (sig (assoc-ref %build-inputs "sig"))
              (gpg (string-append gnupg "/bin/gpg")))
              (setenv "GNUPGHOME" "/tmp")
              (invoke gpg "--import" pubkey)
              (invoke gpg "--keyring" pubkey "--verify" sig source)
              (symlink
                (string-append #$output "/usr/bin")
                (string-append #$output "/bin"))))))))
    (native-inputs (list
      gnupg
      (origin
        (method url-fetch)
        (uri "https://raw.githubusercontent.com/eigenwallet/core/master/utils/gpg_keys/binarybaron_and_einliterflasche.asc")
        (file-name "pubkey")
        (sha256 (base32 "0zrvv6inc1p0s779j1pqniadpc65fpqh6jy03qy8c8kd7807k6ci")))
      (origin
        (method url-fetch)
        (uri (string-append
          "https://github.com/eigenwallet/core/releases/download/"
          version
          "/eigenwallet_"
          version
          "_amd64.deb.asc"))
        (file-name "sig")
        (sha256 (base32 "1v9r7fk0sv0j9c3qgjq6icz57mvrdrgpxba1bibjgnhxrnf11bj5")))))
    (propagated-inputs (list
      gcc-toolchain
      gtk+
      webkitgtk-for-gtk3))
    (home-page "https://eigenwallet.org/")
    (synopsis "Swap BTC->XMR with protocol guaranteed safety")
    (description "eigenwallet is a battle-tested Monero-Bitcoin DEX based on Atomic Swaps.")
    (license license:gpl3)))

