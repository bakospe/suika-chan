(define-module (suika-chan packages vscode)
  #:use-module (gnu packages)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (nonguix build-system chromium-binary))
(define-public vscode
  (package
    (name "vscode")
    (version "1.141.0-1791276758")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://vscode.download.prss.microsoft.com/dbazure/download/stable/"
        "2a59476c9bfcb90b3ddc372c36762471b7dfad1c"
        "/code_"
        version
        "_amd64.deb"))
      (sha256 (base32 "0xv2f9pyb441xhxxwfc3vz2m10m08a6nz5865ryqjzcm09vlzzyh"))))
    (supported-systems '("x86_64-linux"))
    (build-system chromium-binary-build-system)
    (arguments (list
      #:validate-runpath? #f
      #:phases #~(modify-phases %standard-phases
        (add-after 'install 'symlink-binary-file
          (lambda _
            (mkdir-p (string-append #$output "/bin"))
            (symlink
              (string-append #$output "/usr/share/code/bin/code")
              (string-append #$output "/bin/code")))))))
    (propagated-inputs (list
      adwaita-icon-theme
      git
      nss-certs
      openssh
      openssl))
    (home-page "https://code.visualstudio.com/")
    (synopsis "Visual Studio Code - The open source AI code editor")
    (description "Your home for multi-agent development.")
    (license #f)))

