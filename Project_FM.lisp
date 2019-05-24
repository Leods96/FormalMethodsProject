;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;											;
; Project FM								;
;											;
;											;
; Matteo Frigerio 928058					;
; Leonardo Romano 920337             		;
;											;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(asdf:operate 'asdf:load-op' eezot)
(use-package :trio-utils)



(defvar state-d '(N Y))		;Y is in the cell, N otherwise
(defvar pos-d  '(1 2 3 4 5 6 7 8 9 10 11 12))

(defvar target-d '(3 9))
(define-item target target-d)

(define-array human pos-d state-d)
(define-array robot pos-d state-d)

;Verify that the human is in one and only one cell in the work's zone
(defvar onePlaceHuman
	(alw
		(&& 
			(-E- x pos-d (human= x 'Y))
			(-A- x pos-d
				(-A- y pos-d
					(->
						(> x y)(!!(&&(human= x 'Y)(human= y 'Y)))))))))


;Verify that the robot is in one and only one cell in the work's zone
(defvar onePlaceRobot
	(alw
		(&& 
			(-E- x pos-d (robot= x 'Y))
			(-A- x pos-d
				(-A- y pos-d
					(->
						(> x y)(!!(&&(robot= x 'Y)(robot= y 'Y)))))))))


(defvar neverInCellFour
	(alw
		(&&
			(human= 4 'N)
			(robot= 4 'N))))

(defvar movementHuman
	(alw
		(&&	
			(-> (human= 1 'Y)(||(next(human= 1 'Y)) ;starting from 1
								(next(human= 2 'Y)) 
								(next(human= 5 'Y)) 
								(next(human= 6 'Y)) )) 

			(-> (human= 2 'Y)(||(next(human= 1 'Y)) ;starting from 2
								(next(human= 2 'Y)) 
								(next(human= 3 'Y)) 
								(next(human= 5 'Y)) 
								(next(human= 6 'Y))
								(next(human= 7 'Y)))) 

			(-> (human= 3 'Y)(||(next(human= 2 'Y)) ;starting from 3
								(next(human= 3 'Y)) 
								(next(human= 6 'Y)) 
								(next(human= 7 'Y)) 
								(next(human= 8 'Y))))

			(-> (human= 5 'Y)(||(next(human= 1 'Y)) ;starting from 5
								(next(human= 2 'Y)) 
								(next(human= 5 'Y)) 
								(next(human= 6 'Y)) 
								(next(human= 9 'Y))
								(next(human= 10 'Y))))

			(-> (human= 6 'Y)(!! (|| (next(human= 8 'Y)) ;starting from 6
									 (next(human= 12 'Y)))))

			(-> (human= 7 'Y)(!! (|| (next(human= 1 'Y)) ;starting from 7
									 (next(human= 5 'Y))
									 (next(human= 5 'Y)))))		


			(-> (human= 8 'Y)(||(next(human= 3 'Y)) ;starting from 8
								(next(human= 7 'Y)) 
								(next(human= 8 'Y)) 
								(next(human= 11 'Y)) 
								(next(human= 12 'Y))))


			(-> (human= 9 'Y)(||(next(human= 5 'Y)) ;starting from 9
								(next(human= 6 'Y)) 
								(next(human= 9 'Y)) 
								(next(human= 10 'Y))))


			(-> (human= 10 'Y)(||(next(human= 5 'Y)) ;starting from 10
								(next(human= 6 'Y)) 
								(next(human= 7 'Y)) 
								(next(human= 9 'Y)) 
								(next(human= 10 'Y))
								(next(human= 11 'Y))))

			
			(-> (human= 11 'Y)(||(next(human= 6 'Y)) ;starting from 11
								(next(human= 7 'Y)) 
								(next(human= 8 'Y)) 
								(next(human= 10 'Y)) 
								(next(human= 11 'Y))
								(next(human= 12 'Y))))

			(-> (human= 12 'Y)(||(next(human= 7 'Y)) ;starting from 12
								(next(human= 8 'Y)) 
								(next(human= 11 'Y)) 
								(next(human= 12 'Y))))

			)))


(defvar movementRobot
	(alw
		(&&	
			(-> (robot= 1 'Y)(||(next(robot= 1 'Y)) ;starting from 1
								(next(robot= 2 'Y)) 
								(next(robot= 5 'Y)) 
								(next(robot= 6 'Y)) )) 

			(-> (robot= 2 'Y)(||(next(robot= 1 'Y)) ;starting from 2
								(next(robot= 2 'Y)) 
								(next(robot= 3 'Y)) 
								(next(robot= 5 'Y)) 
								(next(robot= 6 'Y))
								(next(robot= 7 'Y)))) 

			(-> (robot= 3 'Y)(||(next(robot= 2 'Y)) ;starting from 3
								(next(robot= 3 'Y)) 
								(next(robot= 6 'Y)) 
								(next(robot= 7 'Y)) 
								(next(robot= 8 'Y))))

			(-> (robot= 5 'Y)(||(next(robot= 1 'Y)) ;starting from 5
								(next(robot= 2 'Y)) 
								(next(robot= 5 'Y)) 
								(next(robot= 6 'Y)) 
								(next(robot= 9 'Y))
								(next(robot= 10 'Y))))

			(-> (robot= 6 'Y)(!! (|| (next(robot= 8 'Y)) ;starting from 6
									 (next(robot= 12 'Y)))))

			(-> (robot= 7 'Y)(!! (|| (next(robot= 1 'Y)) ;starting from 7
									 (next(robot= 5 'Y))
									 (next(robot= 5 'Y)))))		


			(-> (robot= 8 'Y)(||(next(robot= 3 'Y)) ;starting from 8
								(next(robot= 7 'Y)) 
								(next(robot= 8 'Y)) 
								(next(robot= 11 'Y)) 
								(next(robot= 12 'Y))))


			(-> (robot= 9 'Y)(||(next(robot= 5 'Y)) ;starting from 9
								(next(robot= 6 'Y)) 
								(next(robot= 9 'Y)) 
								(next(robot= 10 'Y))))


			(-> (robot= 10 'Y)(||(next(robot= 5 'Y)) ;starting from 10
								(next(robot= 6 'Y)) 
								(next(robot= 7 'Y)) 
								(next(robot= 9 'Y)) 
								(next(robot= 10 'Y))
								(next(robot= 11 'Y))))

			
			(-> (robot= 11 'Y)(||(next(robot= 6 'Y)) ;starting from 11
								(next(robot= 7 'Y)) 
								(next(robot= 8 'Y)) 
								(next(robot= 10 'Y)) 
								(next(robot= 11 'Y))
								(next(robot= 12 'Y))))

			(-> (robot= 12 'Y)(||(next(robot= 7 'Y)) ;starting from 12
								(next(robot= 8 'Y)) 
								(next(robot= 11 'Y)) 
								(next(robot= 12 'Y))))

			)))


(defvar deniedMovement
	(alw 
		(-A- h pos-d
			(->(&&(next(human= h 'Y))(robot= h 'N))(next(robot= h 'N))))))


(defvar property
	(alw
		(-A- p pos-d
			(-> (&&(yesterday(robot= p 'N)) (robot= p 'Y)) (human= p 'N)  )
				)))

(defvar switchTarget
	(alw
		(&&
			(-> (next(robot= 3 'Y)) (next (target= 9)))
			(-> (next(robot= 9 'Y)) (next (target= 3)))
			(-> (&&(next(robot= 3 'N))(next(robot= 9 'N))(target= 3)) (next (target= 3)))
			(-> (&&(next(robot= 3 'N))(next(robot= 9 'N))(target= 9)) (next (target= 9))))))


(defvar robotMustMove
	(alw
		(-A- p pos-d
			(->(robot= p 'Y)(next(robot= p 'N)) ))
		))
						

(eezot:zot 20
	(&&
		onePlaceRobot
		onePlaceHuman
		neverInCellFour
		movementHuman
		movementRobot
		deniedMovement
		switchTarget
		;robotMustMove
		;(!! property)
		)
	)