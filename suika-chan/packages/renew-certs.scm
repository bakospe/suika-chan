(define-module (suika-chan packages renew-certs)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system trivial))
(define-public renew-certs
  (package
    (name "renew-certs")
    (version "0.0.1")
    (source #f)
    (build-system trivial-build-system)
    (arguments (list
      #:modules '((guix build utils))
      #:builder #~(begin
        (use-modules (guix build utils))
        (let* (
          (out (assoc-ref %outputs "out"))
          (target (string-append out "/bin"))
          (dest (string-append target "/renew-certs")))
          (mkdir-p target)
          (call-with-output-file dest
            (lambda (port)
              (display
                "#!/usr/bin/env bash
sudo mkdir -p \
    /etc/letsencrypt \\
    /var/lib/letsencrypt \\
    /var/log/letsencrypt
sudo guix shell \\
    --container \\
    --emulate-fhs \\
    --no-cwd \\
    --network \\
    --share=/etc/letsencrypt \\
    --share=/var/lib/letsencrypt \\
    --share=/var/log/letsencrypt \\
    certbot \\
    nss-certs \\
    -- \\
    certbot certonly --standalone
"
                port)))
          (chmod dest #o555)))))
    (home-page #f)
    (synopsis "Renew Certs")
    (description "Script to securely renew SSL certificates without having to run a web server with full root permissions (unsecure).")
    (license #f)))

