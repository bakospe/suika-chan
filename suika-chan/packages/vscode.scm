(define-module (suika-chan packages vscode)
  #:use-module (gnu packages)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (nonguix build-system chromium-binary))
(define-public vscode
  (package
    (name "vscode")
    (version "1.134.0-1787078834")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://vscode.download.prss.microsoft.com/dbazure/download/stable/"
        "110a328ea54b42367b803ec53ee0bf52ef26b419"
        "/code_"
        version
        "_amd64.deb"))
      (sha256 (base32 "06czskw2kngyalvadlrihf9jkdmyzpqjyrl9sff0gpsk5pss5lyw"))))
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
      openssl))
    (home-page "https://code.visualstudio.com/")
    (synopsis "Visual Studio Code - The open source AI code editor")
    (description "Your home for multi-agent development.")
    (license #f)))

