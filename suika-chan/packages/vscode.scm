(define-module (suika-chan packages vscode)
  #:use-module (gnu packages)
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
    (version "1.136.2-1788561671")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://vscode.download.prss.microsoft.com/dbazure/download/stable/"
        "88e44fa0e00b08f7758b4f6d05632e4fd5e4df6f"
        "/code_"
        version
        "_amd64.deb"))
      (sha256 (base32 "1h5h8aaqi21xl3m53khy70zw9p43pqznx04x7glchrizf9pj54r4"))))
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
      git
      nss-certs
      openssh
      openssl))
    (home-page "https://code.visualstudio.com/")
    (synopsis "Visual Studio Code - The open source AI code editor")
    (description "Your home for multi-agent development.")
    (license #f)))

