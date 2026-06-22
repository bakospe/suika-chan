(define-module (suika-chan packages xdg-open-hack)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system trivial))
(define-public xdg-open-hack
  (package
    (name "xdg-open-hack")
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
          (dest (string-append target "/xdg-open")))
          (mkdir-p target)
          (call-with-output-file dest
            (lambda (port)
              (display
                "#!/bin/sh
echo \"$1\"
echo \"$1\" >&2
echo \"$1\" >> /tmp/link.txt
"
                port)))
          (chmod dest #o555)
          (symlink dest (string-append target "/firefox"))
          (symlink dest (string-append target "/chromium"))))))
    (home-page #f)
    (synopsis "XDG Open Hack")
    (description "Adding this package into guix shell will result in links programs wish to open in a browser being logged to /tmp/link.txt (which then in turn can be shared with the host).")
    (license #f)))

