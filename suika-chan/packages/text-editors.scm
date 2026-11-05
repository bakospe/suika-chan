(define-module (suika-chan packages text-editors)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (nonguix build-system chromium-binary)
  #:use-module (suika-chan packages freedesktop))
(define-public cursor
  (package
    (name "cursor")
    (version "3.15.6")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://downloads.cursor.com/production/"
        "a1f686545fd0ce8917bbd2449f733551a9bce420"
        "/linux/x64/deb/amd64/deb/cursor_"
        version
        "_amd64.deb"))
      (sha256 (base32 "1rz9gas5lgcbayj4613wx65sqwb4ir38apcrxpgvbxw7dk89f7sv"))))
    (supported-systems '("x86_64-linux"))
    (build-system chromium-binary-build-system)
    (arguments (list
      #:validate-runpath? #f
      #:phases #~(modify-phases %standard-phases
        (add-after 'install 'symlink-binary-file
          (lambda _
            (mkdir-p (string-append #$output "/bin"))
            (symlink
              (string-append #$output "/usr/share/cursor/cursor")
              (string-append #$output "/bin/cursor")))))))
    (propagated-inputs (list
      adwaita-icon-theme
      git
      xdg-open-hack))
    (home-page "https://cursor.com/")
    (synopsis "Cursor: The best coding agent")
    (description "Built to make you extraordinarily productive, Cursor is the best coding agent.")
    (license #f)))
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

