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


; Variable
(defvar state-d '(N Y))		;Y is in the cell, N otherwise
(defvar pos-d  '(1 2 3 4 5 6 7 8 9 10 11 12))
(defvar target-d '(3 9))

(define-array human pos-d state-d)
(define-array robot pos-d state-d)
(define-item target target-d)


;The initial configuration is human in 10 and robot in 3
(defvar init
	(&&
		(human= 10 'Y)
		(robot= 3 'Y)
		(target= 9)))


;Human is in one and only one workcell
(defvar onePlaceHuman
	(alw
		(&& 
			(-E- x pos-d (human= x 'Y))
			(-A- x pos-d
				(-A- y pos-d
					(->
						(> x y)(!!(&&(human= x 'Y)(human= y 'Y)))))))))


;Robot is in one and only one workcell
(defvar onePlaceRobot
	(alw
		(&& 
			(-E- x pos-d (robot= x 'Y))
			(-A- x pos-d
				(-A- y pos-d
					(->
						(> x y)(!!(&&(robot= x 'Y)(robot= y 'Y)))))))))


;Robot and human never go in the workcell 4
(defvar neverInCellFour
	(alw
		(&&
			(human= 4 'N)
			(robot= 4 'N))))


; All possible human movements:
(defvar movementHuman
	(alw
		(&&	
			(-> (human= 1 'Y)(||(next(human= 1 'Y)) ;Starting from 1
								(next(human= 2 'Y)) 
								(next(human= 5 'Y)) 
								(next(human= 6 'Y)) )) 

			(-> (human= 2 'Y)(||(next(human= 1 'Y)) ;Starting from 2
								(next(human= 2 'Y)) 
								(next(human= 3 'Y)) 
								(next(human= 5 'Y)) 
								(next(human= 6 'Y))
								(next(human= 7 'Y)))) 

			(-> (human= 3 'Y)(||(next(human= 2 'Y)) ;Starting from 3
								(next(human= 3 'Y)) 
								(next(human= 6 'Y)) 
								(next(human= 7 'Y)) 
								(next(human= 8 'Y))))

			(-> (human= 5 'Y)(||(next(human= 1 'Y)) ;Starting from 5
								(next(human= 2 'Y)) 
								(next(human= 5 'Y)) 
								(next(human= 6 'Y)) 
								(next(human= 9 'Y))
								(next(human= 10 'Y))))

			(-> (human= 6 'Y)(!! (|| (next(human= 8 'Y)) ;Starting from 6
									 (next(human= 12 'Y)))))

			(-> (human= 7 'Y)(!! (|| (next(human= 1 'Y)) ;Starting from 7
									 (next(human= 5 'Y))
									 (next(human= 5 'Y)))))		

			(-> (human= 8 'Y)(||(next(human= 3 'Y)) ;Starting from 8
								(next(human= 7 'Y)) 
								(next(human= 8 'Y)) 
								(next(human= 11 'Y)) 
								(next(human= 12 'Y))))

			(-> (human= 9 'Y)(||(next(human= 5 'Y)) ;Starting from 9
								(next(human= 6 'Y)) 
								(next(human= 9 'Y)) 
								(next(human= 10 'Y))))


			(-> (human= 10 'Y)(||(next(human= 5 'Y)) ;Starting from 10
								(next(human= 6 'Y)) 
								(next(human= 7 'Y)) 
								(next(human= 9 'Y)) 
								(next(human= 10 'Y))
								(next(human= 11 'Y))))
			
			(-> (human= 11 'Y)(||(next(human= 6 'Y)) ;Starting from 11
								(next(human= 7 'Y)) 
								(next(human= 8 'Y)) 
								(next(human= 10 'Y)) 
								(next(human= 11 'Y))
								(next(human= 12 'Y))))

			(-> (human= 12 'Y)(||(next(human= 7 'Y)) ;Starting from 12
								(next(human= 8 'Y)) 
								(next(human= 11 'Y)) 
								(next(human= 12 'Y)))))))


; All possible robot movements
(defvar movementRobot
	(alw
		(&&	
			(-> (robot= 1 'Y)(||(next(robot= 1 'Y)) ;Starting from 1
								(next(robot= 2 'Y)) 
								(next(robot= 5 'Y)) 
								(next(robot= 6 'Y)) )) 

			(-> (robot= 2 'Y)(||(next(robot= 1 'Y)) ;Starting from 2
								(next(robot= 2 'Y)) 
								(next(robot= 3 'Y)) 
								(next(robot= 5 'Y)) 
								(next(robot= 6 'Y))
								(next(robot= 7 'Y)))) 

			(-> (robot= 3 'Y)(||(next(robot= 2 'Y)) ;Starting from 3
								(next(robot= 3 'Y)) 
								(next(robot= 6 'Y)) 
								(next(robot= 7 'Y)) 
								(next(robot= 8 'Y))))

			(-> (robot= 5 'Y)(||(next(robot= 1 'Y)) ;Starting from 5
								(next(robot= 2 'Y)) 
								(next(robot= 5 'Y)) 
								(next(robot= 6 'Y)) 
								(next(robot= 9 'Y))
								(next(robot= 10 'Y))))

			(-> (robot= 6 'Y)(!! (|| (next(robot= 8 'Y)) ;Starting from 6
									 (next(robot= 12 'Y)))))

			(-> (robot= 7 'Y)(!! (|| (next(robot= 1 'Y)) ;Starting from 7
									 (next(robot= 5 'Y))
									 (next(robot= 5 'Y)))))		

			(-> (robot= 8 'Y)(||(next(robot= 3 'Y)) ;Starting from 8
								(next(robot= 7 'Y)) 
								(next(robot= 8 'Y)) 
								(next(robot= 11 'Y)) 
								(next(robot= 12 'Y))))

			(-> (robot= 9 'Y)(||(next(robot= 5 'Y)) ;Starting from 9
								(next(robot= 6 'Y)) 
								(next(robot= 9 'Y)) 
								(next(robot= 10 'Y))))

			(-> (robot= 10 'Y)(||(next(robot= 5 'Y)) ;Starting from 10
								(next(robot= 6 'Y)) 
								(next(robot= 7 'Y)) 
								(next(robot= 9 'Y)) 
								(next(robot= 10 'Y))
								(next(robot= 11 'Y))))
		
			(-> (robot= 11 'Y)(||(next(robot= 6 'Y)) ;Starting from 11
								(next(robot= 7 'Y)) 
								(next(robot= 8 'Y)) 
								(next(robot= 10 'Y)) 
								(next(robot= 11 'Y))
								(next(robot= 12 'Y))))

			(-> (robot= 12 'Y)(||(next(robot= 7 'Y)) ;Starting from 12
								(next(robot= 8 'Y)) 
								(next(robot= 11 'Y)) 
								(next(robot= 12 'Y)))))))


; Prohibited movements to the robot: the robot should avoid any obstacle
(defvar deniedMovement
	(alw 
		(-A- h pos-d
			(->(&&(next(human= h 'Y))(robot= h 'N))(next(robot= h 'N))))))


;When the robot goes to cell 3, the next target of the robot will be 9 and viceversa 
(defvar switchTarget
	(alw
		(&&
			(-> (next(robot= 3 'Y)) (next (target= 9)))
			(-> (next(robot= 9 'Y)) (next (target= 3)))
			(-> (&&(next(robot= 3 'N))(next(robot= 9 'N))(target= 3)) (next (target= 3)))
			(-> (&&(next(robot= 3 'N))(next(robot= 9 'N))(target= 9)) (next (target= 9))))))


;If the robot is only one area far from its target and the destination is busy, then the robot chooses to stop
(defvar robotNearToTheTarget
	(alw
		(&&
			(->(&&(next(human= 9 'Y))(target= 9)(robot= 5 'Y))(next(robot= 5 'Y)))
			(->(&&(next(human= 9 'Y))(target= 9)(robot= 6 'Y))(next(robot= 6 'Y)))
			(->(&&(next(human= 9 'Y))(target= 9)(robot= 10 'Y))(next(robot= 10 'Y)))
			(->(&&(next(human= 3 'Y))(target= 3)(robot= 2 'Y))(next(robot= 2 'Y)))
			(->(&&(next(human= 3 'Y))(target= 3)(robot= 6 'Y))(next(robot= 6 'Y)))
			(->(&&(next(human= 3 'Y))(target= 3)(robot= 7 'Y))(next(robot= 7 'Y)))
			(->(&&(next(human= 3 'Y))(target= 3)(robot= 8 'Y))(next(robot= 8 'Y))))))


;Human and robot are never in the same place while the robot is moving
(defvar property
	(alw
		(-A- p pos-d
			(-> (&&(yesterday(robot= p 'N)) (robot= p 'Y)) (human= p 'N)  )
				)))



; Helper property to verify the correctness of the system
(defvar helperRobotMustMove
	(alw
		(-A- p pos-d
			(->(robot= p 'Y)(next(robot= p 'N)) ))
))


; Helper property to verify the correctness of the system
(defvar helperHumanDoesNotMove
	(alw
		(-A- p pos-d
			(->(human= p 'Y)(next(human= p 'Y)) ))
))




(eezot:zot 20
	(&&
		(yesterday init)
		onePlaceRobot
		onePlaceHuman
		neverInCellFour
		movementHuman
		movementRobot
		deniedMovement
		switchTarget
		robotNearToTheTarget
		;(!! property)
		)
	)