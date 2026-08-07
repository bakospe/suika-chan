(define-module (suika-chan packages cursor)
  #:use-module (gnu packages)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages version-control)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (nonguix build-system chromium-binary)
  #:use-module (suika-chan packages xdg-open-hack))
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

