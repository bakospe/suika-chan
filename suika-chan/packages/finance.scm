(define-module (suika-chan packages finance)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages webkit)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (nonguix build-system binary))
(define-public eigenwallet
  (package
    (name "eigenwallet")
    (version "5.0.4")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://github.com/eigenwallet/core/releases/download/"
        version
        "/eigenwallet_"
        version
        "_amd64.deb"))
      (sha256 (base32 "0xah2vw7dhwsyj0sbv7lqq2c8l8jyxs7fbwdri9gkslv36yyn7xk"))))
    (build-system binary-build-system)
    (arguments (list
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
              (invoke gpg "--verify" sig source)
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
        (sha256 (base32 "1df8xma445f8vdx896mgz7ynfxf43jry0ykqy0f2abzwcaz9i2jk")))))
    (propagated-inputs (list
      gcc-toolchain
      gsettings-desktop-schemas
      gtk+
      nss-certs
      webkitgtk-for-gtk3))
    (home-page "https://eigenwallet.org/")
    (synopsis "Swap BTC->XMR with protocol guaranteed safety")
    (description "eigenwallet is a battle-tested Monero-Bitcoin DEX based on Atomic Swaps.")
    (license license:gpl3)))

