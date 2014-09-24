#!/usr/bin/sbcl --script

(load "algorithmen.lisp")


(format t "OCC:    ~A~%" *occ*)
(format t "Border: ~A~%" *border*)
(format t "Border: ~A~%" *strong-border*)

(timing (format t "Schiebe:~%~5TErgebnis: ~A~%~%" (schiebe *alphabet* *such*)))
(format t "~%Anzahl = ~A~%" (get-Anzahl))

(timing (format t "Schiebe last-occ:~%~5TErgebnis: ~A~%~%" (schiebe-last-occ *alphabet* *such* *occ*)))
(format t "~%Anzahl = ~A~%" (get-Anzahl))

(timing (format t "Morris Pratt Positiv:~%~5TErgebnis: ~A~%~%" (morris-pratt *alphabet* *such* *border*)))
(format t "~%Anzahl = ~A~%" (get-Anzahl))
(timing (format t "Knuth Morris Pratt Positiv:~%~5TErgebnis: ~A~%~%" (morris-pratt *alphabet* *such* *strong-border*)))
(format t "~%Anzahl = ~A~%" (get-Anzahl))
