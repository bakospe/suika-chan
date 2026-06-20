(define-module (suika-chan packages provide-virtual-touchpad)
  #:use-module (gnu packages)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages python)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system trivial))
(define-public provide-virtual-touchpad
  (package
    (name "provide-virtual-touchpad")
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
          (dest (string-append target "/provide-virtual-touchpad")))
          (mkdir-p target)
          (call-with-output-file dest
            (lambda (port)
              (display
                "#!/usr/bin/env python3
import os
from contextlib import suppress
from evdev import InputDevice,UInput,ecodes
src=InputDevice('/dev/input/touchpad')
fwd={
    ecodes.EV_KEY:[ecodes.BTN_TOUCH],
}
ui=UInput(
    {
        ecodes.EV_REL:[ecodes.REL_X,ecodes.REL_Y],
        **fwd,
    },
    name='virtual-touchpad',
)
with suppress(FileExistsError):
    os.symlink(os.path.basename(ui.device),'/dev/input/virtual-touchpad')
x=y=0
pending=[]
src.grab()
for z in src.read_loop():
    if z.type==ecodes.EV_SYN:
        sx,sy=x,y
        for e in pending:
            if e.type!=ecodes.EV_ABS:
                continue
            match e.code:
                case ecodes.ABS_X:
                    x=e.value
                case ecodes.ABS_Y:
                    y=e.value
        for e in pending:
            if e.type==ecodes.EV_KEY and e.code==ecodes.BTN_TOUCH and e.value:
                sx,sy=x,y
        for e in pending:
            if e.type in fwd and e.code in fwd[e.type]:
                ui.write(e.type,e.code,e.value)
        ui.write(ecodes.EV_REL,ecodes.REL_X,x-sx)
        ui.write(ecodes.EV_REL,ecodes.REL_Y,y-sy)
        ui.syn()
        pending=[]
    else:
        pending.append(z)
"
                port)))
          (chmod dest #o555)))))
    (propagated-inputs (list
      python
      python-evdev))
    (home-page #f)
    (synopsis "Provide Virtual TouchPad")
    (description "Makes the touchpad behave like a touchpad rather than a drawing tablet after an evdev passthrough.")
    (license #f)))

