(define-module (suika-chan packages render-latex)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system trivial))
(define-public render-latex
  (package
    (name "render-latex")
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
          (dest (string-append target "/render-latex")))
          (mkdir-p target)
          (call-with-output-file dest
            (lambda (port)
              (display
                "#!/bin/sh
rm -rf /tmp/render-latex
cp -r . /tmp/render-latex
cd /tmp/render-latex
rm -f ./*.pdf
for I in $(seq 1 3); do
    pdflatex \"$@\"
done
cd -
cp /tmp/render-latex/*.pdf .
rm -rf /tmp/render-latex
"
                port)))
          (chmod dest #o555)))))
    (home-page #f)
    (synopsis "LaTeX render script")
    (description "Provides the render-latex command.")
    (license #f)))

