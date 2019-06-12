;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;											;
; Project FM								;
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
(defvar targetHuman-d '(8 10))
(defvar targetRobot-d '(3 9))

(define-array human pos-d state-d)
(define-array robot pos-d state-d)
(define-item targetHuman targetHuman-d)
(define-item targetRobot targetRobot-d)



;----------------------------------------------------------------- Init -------------------------------------------------------------------

;The initial configuration is human in 10 and robot in 3
(defvar init
	(&&
		(human= 10 'Y)
		(robot= 3 'Y)
		(targetRobot= 9)
		(targetHuman= 8)))



;------------------------------------------------------------ Transition system -----------------------------------------------------------

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
									 (next(human= 9 'Y)))))		

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
									 (next(robot= 9 'Y)))))		

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


; No collision between robot and human
(defvar noCollision
	(alw
		(&&
			(-> (&&(next(human= 1 'Y))(||	(robot= 2 'Y)
											(robot= 5 'Y)
											(robot= 6 'Y))) (||		(next(robot= 2 'Y))
																	(next(robot= 3 'Y))
																	(next(robot= 5 'Y))
																	(next(robot= 6 'Y))
																	(next(robot= 7 'Y))
																	(next(robot= 9 'Y))
																	(next(robot= 10 'Y))
																	(next(robot= 11 'Y))))

			(-> (&&(next(human= 2 'Y))(||	(robot= 1 'Y)
											(robot= 3 'Y)
											(robot= 5 'Y)
											(robot= 6 'Y)
											(robot= 7 'Y))) (||		(next(robot= 1 'Y))
																	(next(robot= 3 'Y))
																	(next(robot= 5 'Y))
																	(next(robot= 6 'Y))
																	(next(robot= 7 'Y))
																	(next(robot= 8 'Y))
																	(next(robot= 9 'Y))
																	(next(robot= 10 'Y))
																	(next(robot= 11 'Y))
																	(next(robot= 12 'Y))))

			(-> (&&(next(human= 3 'Y))(||	(robot= 2 'Y)
											(robot= 6 'Y)
											(robot= 7 'Y)
											(robot= 8 'Y))) (||	(next(robot= 1 'Y))
																	(next(robot= 2 'Y))
																	(next(robot= 5 'Y))
																	(next(robot= 6 'Y))
																	(next(robot= 7 'Y))
																	(next(robot= 8 'Y))
																	(next(robot= 9 'Y))
																	(next(robot= 10 'Y))
																	(next(robot= 11 'Y))
																	(next(robot= 12 'Y))))

			(-> (&&(next(human= 5 'Y))(||	(robot= 1 'Y)
											(robot= 2 'Y)
											(robot= 6 'Y)
											(robot= 9 'Y)
											(robot= 10 'Y))) (||	(next(robot= 1 'Y))
																	(next(robot= 2 'Y))
																	(next(robot= 3 'Y))
																	(next(robot= 6 'Y))
																	(next(robot= 7 'Y))
																	(next(robot= 9 'Y))
																	(next(robot= 10 'Y))
																	(next(robot= 11 'Y))))

			(-> (&&(next(human= 6 'Y))(||	(robot= 1 'Y)
											(robot= 2 'Y)
											(robot= 3 'Y)
											(robot= 5 'Y)
											(robot= 7 'Y)
											(robot= 9 'Y)
											(robot= 10 'Y)
											(robot= 11 'Y))) (||	(next(robot= 1 'Y))
																	(next(robot= 2 'Y))
																	(next(robot= 3 'Y))
																	(next(robot= 5 'Y))
																	(next(robot= 7 'Y))
																	(next(robot= 8 'Y))
																	(next(robot= 9 'Y))
																	(next(robot= 10 'Y))
																	(next(robot= 11 'Y))
																	(next(robot= 12 'Y))))

			(-> (&&(next(human= 7 'Y))(||	(robot= 2 'Y)
											(robot= 3 'Y)
											(robot= 6 'Y)
											(robot= 8 'Y)
											(robot= 10 'Y)
											(robot= 11 'Y)
											(robot= 12 'Y))) (||	(next(robot= 1 'Y))
																	(next(robot= 2 'Y))
																	(next(robot= 3 'Y))
																	(next(robot= 5 'Y))
																	(next(robot= 6 'Y))
																	(next(robot= 8 'Y))
																	(next(robot= 9 'Y))
																	(next(robot= 10 'Y))
																	(next(robot= 11 'Y))
																	(next(robot= 12 'Y))))

			(-> (&&(next(human= 8 'Y))(||	(robot= 3 'Y)
											(robot= 7 'Y)
											(robot= 11 'Y)
											(robot= 12 'Y))) (||	(next(robot= 2 'Y))
																	(next(robot= 3 'Y))
																	(next(robot= 6 'Y))
																	(next(robot= 7 'Y))
																	(next(robot= 10 'Y))
																	(next(robot= 11 'Y))
																	(next(robot= 12 'Y))))

			(-> (&&(next(human= 9 'Y))(||	(robot= 5 'Y)
											(robot= 6 'Y)
											(robot= 10 'Y))) (||	(next(robot= 1 'Y))
																	(next(robot= 2 'Y))
																	(next(robot= 3 'Y))
																	(next(robot= 5 'Y))
																	(next(robot= 6 'Y))
																	(next(robot= 7 'Y))
																	(next(robot= 10 'Y))
																	(next(robot= 11 'Y))))

			(-> (&&(next(human= 10 'Y))(||	(robot= 5 'Y)
											(robot= 6 'Y)
											(robot= 7 'Y)
											(robot= 9 'Y)
											(robot= 11 'Y))) (||	(next(robot= 1 'Y))
																	(next(robot= 2 'Y))
																	(next(robot= 3 'Y))
																	(next(robot= 5 'Y))
																	(next(robot= 6 'Y))
																	(next(robot= 7 'Y))
																	(next(robot= 8 'Y))
																	(next(robot= 9 'Y))
																	(next(robot= 11 'Y))
																	(next(robot= 12 'Y))))

			(-> (&&(next(human= 11 'Y))(||	(robot= 6 'Y)
											(robot= 7 'Y)
											(robot= 8 'Y)
											(robot= 10 'Y)
											(robot= 12 'Y))) (||	(next(robot= 1 'Y))
																	(next(robot= 2 'Y))
																	(next(robot= 3 'Y))
																	(next(robot= 5 'Y))
																	(next(robot= 6 'Y))
																	(next(robot= 7 'Y))
																	(next(robot= 8 'Y))
																	(next(robot= 9 'Y))
																	(next(robot= 10 'Y))
																	(next(robot= 12 'Y))))


			(-> (&&(next(human= 12 'Y))(||	(robot= 7 'Y)
											(robot= 8 'Y)
											(robot= 11 'Y))) (||	(next(robot= 2 'Y))
																	(next(robot= 3 'Y))
																	(next(robot= 6 'Y))
																	(next(robot= 7 'Y))
																	(next(robot= 8 'Y))
																	(next(robot= 10 'Y))
																	(next(robot= 11 'Y)))))))


;When the robot goes to cell 3, the next target of the robot will be 9 and viceversa
;When the human goes to cell 8, the next target of the human will be 10 and viceversa
(defvar switchTarget
	(alw
		(&&
			;Target robot
			(-> (next(robot= 3 'Y)) (next (targetRobot= 9)))
			(-> (next(robot= 9 'Y)) (next (targetRobot= 3)))
			(-> (&&(next(robot= 3 'N))(next(robot= 9 'N))(targetRobot= 3)) (next (targetRobot= 3)))
			(-> (&&(next(robot= 3 'N))(next(robot= 9 'N))(targetRobot= 9)) (next (targetRobot= 9)))

			;Target human
			(-> (next(human= 8 'Y)) (next (targetHuman= 10)))
			(-> (next(human= 10 'Y)) (next (targetHuman= 8)))
			(-> (&&(next(human= 8 'N))(next(human= 10 'N))(targetHuman= 8)) (next (targetHuman= 8)))
			(-> (&&(next(human= 8 'N))(next(human= 10 'N))(targetHuman= 10)) (next (targetHuman= 10))))))



;If the robot is only one area far from its target and the destination is busy, then the robot chooses to stop
(defvar robotNearToTheTarget
	(alw
		(&&
			(-> (&&(next(human= 9 'Y))(targetRobot= 9)(robot= 5 'Y)) (next(robot= 5 'Y)))
			(-> (&&(next(human= 9 'Y))(targetRobot= 9)(robot= 6 'Y)) (next(robot= 6 'Y)))
			(-> (&&(next(human= 9 'Y))(targetRobot= 9)(robot= 10 'Y)) (next(robot= 10 'Y)))
			(-> (&&(next(human= 3 'Y))(targetRobot= 3)(robot= 2 'Y)) (next(robot= 2 'Y)))
			(-> (&&(next(human= 3 'Y))(targetRobot= 3)(robot= 6 'Y)) (next(robot= 6 'Y)))
			(-> (&&(next(human= 3 'Y))(targetRobot= 3)(robot= 7 'Y)) (next(robot= 7 'Y)))
			(-> (&&(next(human= 3 'Y))(targetRobot= 3)(robot= 8 'Y)) (next(robot= 8 'Y))))))


;Robot and human go infinitely often in their work position
(defvar eventuallyWorkPosition
	(alw
		(&&
			(som(human= 8 'Y))
			(som(human= 10 'Y))
			(som(robot= 3 'Y))
			(som(robot= 9 'Y)))))


; Robot and human do not move for two instants of time
(defvar workTime
	(alw
		(&&
			;Human
			(-> (&&(next(human= 8 'Y))(targetHuman= 8)) (&&(next(next(human= 8 'Y)))(next(next(next(human= 8 'Y))))))
			(-> (&&(next(human= 10 'Y))(targetHuman= 10)) (&&(next(next(human= 10 'Y)))(next(next(next(human= 10 'Y))))))
			
			;Robot
			(-> (&&(next(robot= 3 'Y))(targetRobot= 3)) (&&(next(next(robot= 3 'Y)))(next(next(next(robot= 3 'Y))))))
			(-> (&&(next(robot= 9 'Y))(targetRobot= 9)) (&&(next(next(robot= 9 'Y)))(next(next(next(robot= 9 'Y)))))))))


; Transition system
(defvar trans
	(&&
		onePlaceRobot
		onePlaceHuman
		neverInCellFour
		movementHuman
		movementRobot
		noCollision
		switchTarget
		robotNearToTheTarget
		eventuallyWorkPosition
		workTime
		))


;--------------------------------------------------------------- Property ------------------------------------------------------------------

;Human and robot are never in the same place while the robot is moving
(defvar property
	(alw
		(-A- p pos-d
			(-> (&&(yesterday(robot= p 'N)) (robot= p 'Y)) (human= p 'N))
				)))


;------------------------------------------------------------------------------------------------------------------------------------

(eezot:zot 20
	(&&
		(yesterday init)
		(!! property)
		trans
		)
	)