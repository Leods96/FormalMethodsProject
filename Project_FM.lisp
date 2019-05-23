;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;											;
; Project FM								;
;											;
;											;
; Matteo Frigerio 928058					;
; Leonardo Romano ...matricola leo...		;
;											;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(asdf:operate 'asdf:load-op' eezot)
(use-package :trio-utils)



(defvar state-d '(N Y))		;Y is in the cell, N otherwise
(defvar pos-d  '(1 2 3 4 5 6 7 8 9 10 11))

(define-array human pos-d state-d)
(define-array robot pos-d state-d)


(defvar movement-human
	(alw
		(&& 
			(-E- x pos-d (human= x 'Y))
			(-A- x pos-d
				(-A- y pos-d
					(->
						(> x y)(!!(&&(human= x 'Y)(human= y 'Y)))))))))

(defvar movement-robot
	(alw
		(&& 
			(-E- x pos-d (robot= x 'Y))
			(-A- x pos-d
				(-A- y pos-d
					(->
						(> x y)(!!(&&(robot= x 'Y)(robot= y 'Y)))))))))



(eezot:zot 20
	(&&
		movement-human
		movement-robot
		)
	)