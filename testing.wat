(module ;;module start
(import "env" "memory" (memory 1))
(import "env" "log" (func $log (param i32)))
(import "env" "log" (func $logf (param f64)))

(func $_reverse (param i32) (param i32)
	(i32.store (i32.const 1) (i32.const 256))
)
(export "_reverse" (func $_reverse))

;;takes two numbers and avgs them, f64 encodes with 11 bit exponent and 52 bit mantissa
(func $avg (param $num1 f64) (param $num2 f64) (result f64)
	(f64.add
		(local.get $num1)
		(local.get $num2)
	)
	(f64.const 2)
	(f64.div)
)

;;takes three args and returns the min
(func $min (export "min") (param $n1 i32) (param $n2 i32) (param $n3 i32) (result i32)
	(local $min i32)
		(local.get $n2)
				(local.get $n1)
				(local.get $n2)
			(i32.sub)
					(local.get $n1)
					(local.get $n2)
				(i32.sub)
				(i32.const 31)
			(i32.shr_s)
		(i32.and)
	(i32.add)
	(local.set $min)
		(local.get $n3)
				(local.get $min)
				(local.get $n3)
			(i32.sub)
					(local.get $min)
					(local.get $n3)
				(i32.sub)
				(i32.const 31)
			(i32.shr_s)
		(i32.and)
	(i32.add)
)
;;takes three args and returns the max
(func $max (export "max") (param $n1 i32) (param $n2 i32) (param $n3 i32) (result i32)
	(local $max i32)
		(local.get $n2)
				(local.get $n1)
				(local.get $n2)
			(i32.sub)
					(local.get $n2)
					(local.get $n1)
				(i32.sub)
				(i32.const 31)
			(i32.shr_s)
		(i32.and)
	(i32.add)
	(local.set $max)
		(local.get $n3)
				(local.get $max)
				(local.get $n3)
			(i32.sub)
					(local.get $n3)
					(local.get $max)
				(i32.sub)
				(i32.const 31)
			(i32.shr_s)
		(i32.and)
	(i32.add)
)

;;takes the 3d coords and pushes to stack the 2d canvas coords
;;assumes viewer at 0,0,0 and plane at x = 10 and object is in front of plane
(func $proj (export "proj") (param $x f64) (param $yz f64) (result f64)
	(local.get $yz)
	(local.get $x)
	(f64.div)
	(f64.const 10)
	(f64.mul)
)



;;returns the one dimensional array pointer from 2d canvas coords
;;(assumes 1280,720)
(func $mem (export "mem") (param $x i32) (param $y i32) (result i32)
			(i32.add
						(i32.load (i32.const 1))
						(i32.const 2)
					(i32.div_u)
					(local.get $x)
				(i32.sub)
							(i32.load (i32.const 5))
							(i32.const 2)
						(i32.div_u)
						(local.get $y)
					(i32.sub)
					(i32.load (i32.const 1))
				(i32.mul)
			)
			(i32.const 4)
		(i32.mul)
		(i32.load8_u (i32.const 0))
	(i32.add)
)

;;shades a pixel (bounds checking)
(func $pshade (export "pshade") (param $x i32) (param $y i32) (param $color i32)
			(i32.ge_s (local.get $x) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 1))) (i32.const 2)))
			(i32.lt_s (local.get $x) (i32.div_s (i32.load (i32.const 1)) (i32.const 2)))
		(i32.and)
			(i32.ge_s (local.get $y) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 1))) (i32.const 2)))
			(i32.lt_s (local.get $y) (i32.div_s (i32.load (i32.const 5)) (i32.const 2)))
		(i32.and)
	(i32.and)

	(if
		(then
				(local.get $x)
				(local.get $y)
			(call $mem)
			(local.get $color)
			(i32.store)
		)

	)

)

(func $increment (param $x f64) (result f64)
		(local.get $x)
		(f64.const 1)
	(f64.add)
)



;; assumes 1280, 720
(func (export "main") (param $x f64) (param $y f64) (param $z f64) (param $color i32)

)


;;when passing in, pass triangle vertices in COUNTERCLOCKWISE 
;;(with highest x (or y (or z))) (maybe)

(func $trishade (export "trishade") (param $x0 f64) (param $y0 f64) (param $z0 f64) (param $x1 f64) (param $y1 f64) (param $z1 f64) (param $x2 f64) (param $y2 f64) (param $z2 f64) (param $color i32)

	;;START	LOCAL DECLARATION
		(local $xr0 i32);;	canvas coords
		(local $yr0 i32);;	(rounded)
		(local $xr1 i32);;	(signed)
		(local $yr1 i32)
		(local $xr2 i32)
		(local $yr2 i32)
		(local $xc0 f64);;	canvas coords
		(local $yc0 f64);;	(not rounded)
		(local $xc1 f64);;	(signed)
		(local $yc1 f64)
		(local $xc2 f64)
		(local $yc2 f64)
		(local $xb0 i32);;	bounding box (rounded)
		(local $yb0 i32);; (signed)
		(local $xb1 i32)
		(local $yb1 i32)
		(local $tri f64);;	area of the triangle
		(local $var f64);;	temporary var preventing reevaluation for squaring
		(local $e01 i32);;	validity t/f of edges (top left rule)
		(local $e12 i32);;	(binary)
		(local $e20 i32)
		(local $i01 i32);;	t/f the point is on the 
		(local $i12 i32);;	edge
		(local $i20 i32)
		(local $i	f64);;	arbitrary indeces
		(local $j	f64);;	(signed)
	;;END	LOCAL DECLARATION

	;;START	PROJECTION EVALUATION
		(local.set $xr0 (i32.trunc_f64_s (local.tee $xc0 (call $proj (local.get $x0) (local.get $y0)))))
		(local.set $yr0 (i32.trunc_f64_s (local.tee $yc0 (call $proj (local.get $x0) (local.get $z0)))))
		(local.set $xr1 (i32.trunc_f64_s (local.tee $xc1 (call $proj (local.get $x1) (local.get $y1)))))
		(local.set $yr1 (i32.trunc_f64_s (local.tee $yc1 (call $proj (local.get $x1) (local.get $z1)))))
		(local.set $xr2 (i32.trunc_f64_s (local.tee $xc2 (call $proj (local.get $x2) (local.get $y2)))))
		(local.set $yr2 (i32.trunc_f64_s (local.tee $yc2 (call $proj (local.get $x2) (local.get $z2)))))
	;;END	PROJECTION EVALUATION

	;;START Counterclockwise EDGE TRUTH EVALUATION
		;; 	(local.get $yc1) ;;next vertex
		;; 	(local.get $yc0) ;;prev vertex
		;; (f64.gt)
		;; ;;left
		;; 		(local.get $yc2) ;;next
		;; 		(local.get $yc1) ;;prev
		;; 	(f64.eq)
		;; 		(local.get $xc2) ;;next
		;; 		(local.get $xc1) ;;prev
		;; 	(f64.gt)
		;; (i32.and)
		;; ;;top

			(local.get $yc1) ;;next vertex
			(local.get $yc0) ;;prev vertex
		(f64.gt)
		(if
		(then
			(local.set $e01 (i32.const 1))
				(local.get $yc2) ;;next vertex
				(local.get $yc1) ;;prev vertex
			(f64.gt)
			(if
			(then
				(local.set $e12 (i32.const 1))
				(local.set $e20 (i32.const 0))
			)
			(else
				(local.set $e12 (i32.const 0))
					(local.get $yc1) ;;next vertex
					(local.get $yc0) ;;prev vertex
				(f64.gt)
				(if
				(then
					(local.set $e20 (i32.const 1))
				)
				(else
							(local.get $yc0) ;;next
							(local.get $yc2) ;;prev
						(f64.eq)
							(local.get $xc0) ;;next
							(local.get $xc2) ;;prev
						(f64.gt)
					(i32.and)
					(if
					(then
						(local.set $e20 (i32.const 1))
					)
					(else
						(local.set $e20 (i32.const 0))
					)
					)
				)
				)
			)
			)
		)
		(else
					(local.get $yc1) ;;next
					(local.get $yc0) ;;prev
				(f64.eq)
					(local.get $xc1) ;;next
					(local.get $xc0) ;;prev
				(f64.gt)
			(i32.and)
			(if
			(then
				(local.set $e01 (i32.const 1))
				(local.set $e12 (i32.const 1))
				(local.set $e20 (i32.const 0))
			)
			(else
				(local.set $e01 (i32.const 0))
						(local.get $yc2) ;;next
						(local.get $yc1) ;;prev
					(f64.eq)
						(local.get $xc2) ;;next
						(local.get $xc1) ;;prev
					(f64.gt)
				(i32.and)
				(if
				(then
					(local.set $e12 (i32.const 1))
							(local.get $yc0) ;;next
							(local.get $yc2) ;;prev
						(f64.eq)
							(local.get $xc0) ;;next
							(local.get $xc2) ;;prev
						(f64.gt)
					(i32.and)
					(if
					(then
						(local.set $e20 (i32.const 1))
					)
					(else
						(local.set $e20 (i32.const 0))
					)
					)
				)
				(else
							(local.get $yc2) ;;next
							(local.get $yc1) ;;prev
						(f64.eq)
							(local.get $xc2) ;;next
							(local.get $xc1) ;;prev
						(f64.gt)
					(i32.and)
					(if
					(then
						(local.set $e12 (i32.const 1))
						(local.set $e20 (i32.const 1))
					)
					(else
						(local.set $e12 (i32.const 0))
						(local.set $e20 (i32.const 1))
					)
					)
				)
				)

			)
			)
		)
		)



	;;END	Counterclockwise EDGE TRUTH EVALUATION


	;;START	MAIN IF BLOCK (IF SOME OF TRI IS IN CANVAS BOUNDS)
	;;if at least some of the triangle is inside the canvas bounds
		(local.set $xb0 (call $min (local.get $xr0) (local.get $xr1) (local.get $xr2)))
		(local.set $yb0 (call $min (local.get $yr0) (local.get $yr1) (local.get $yr2)))
		(local.set $xb1 (call $max (local.get $xr0) (local.get $xr1) (local.get $xr2)))
		(local.set $yb1 (call $max (local.get $yr0) (local.get $yr1) (local.get $yr2)))
						(i32.ge_s (local.get $xb0) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 1))) (i32.const 2)));;(i32.const -640))
						(i32.ge_s (local.get $xb1) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 1))) (i32.const 2)))
				(i32.or)
						(i32.ge_s (local.get $yb0) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 5))) (i32.const 2)));;(i32.const -360)
						(i32.ge_s (local.get $yb1) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 5))) (i32.const 2)))
				(i32.or)
			(i32.or)
						(i32.lt_s (local.get $xb0) (i32.div_s (i32.load (i32.const 1)) (i32.const 2)));;i32.const 640
						(i32.lt_s (local.get $xb1) (i32.div_s (i32.load (i32.const 1)) (i32.const 2)))
				(i32.or)
						(i32.lt_s (local.get $yb0) (i32.div_s (i32.load (i32.const 5)) (i32.const 2)));;i32.const 360
						(i32.lt_s (local.get $yb1) (i32.div_s (i32.load (i32.const 5)) (i32.const 2)))
				(i32.or)
			(i32.or)
		(i32.or)


		;;;; ALL COORDS ARE NOT NORMALIZED (yet?)

		(if	  ;;the start of the main
		(then ;;if block

			;;START evaluate area of triangle
				;;magnitude((vector0->1) cross (vector0->2))
					
					

				;; 	(f64.mul)
				;; 		(f64.mul)
				;; 		(f64.mul)
				;; 	(f64.add)
				;; (f64.add)
			;;END evaluate area of triangle

			(local.set $j (f64.convert_i32_s (local.get $yb0)))
			(block
			(loop ;;loop through the x bounds of the projected triangle

				;;loop logic (set i to 0, increment j, break if over)
				(br_if 1 (i32.ge_s (i32.trunc_f64_s (local.get $j)) (local.get $yb1)))
				(local.set $i (f64.convert_i32_s (local.get $xb0)))
				(local.set $j (call $increment (local.get $j)))

				(block
				(loop ;;loop through the y bounds of the projected triangle
					;;FOLD HERE if the point is in the triangle or on a valide edge or vertex	
					
					;;loop logic (end part) (increment, break if over)
					(br_if 1 (i32.ge_s (i32.trunc_f64_s (local.get $i)) (local.get $xb1)))

						;; if the point is in the triangle v0-v1 edge
										(local.get $i) ;;P.x
										(local.get $xc0) ;;V0.x
									(f64.sub)
										(local.get $yc1) ;;V1.y
										(local.get $yc0) ;;V0.y
									(f64.sub)
								(f64.mul)
										(local.get $j) ;;P.y
										(local.get $yc0) ;;V0.y 
									(f64.sub)
										(local.get $xc1) ;;V1.x
										(local.get $xc0) ;;V0.x
									(f64.sub)
								(f64.mul)
							(f64.sub)
							(i32.trunc_f64_s)
							(local.tee $i01)
							(i32.const 0)
						(i32.gt_s)
						(if		;;if the point is in
						(then	;;the v0-v1 boundary
											(local.get $i) ;;P.x
											(local.get $xc1) ;;V0.x
										(f64.sub)
											(local.get $yc2) ;;V1.y
											(local.get $yc1) ;;V0.y
										(f64.sub)
									(f64.mul)
											(local.get $j) ;;P.y
											(local.get $yc1) ;;V0.y 
										(f64.sub)
											(local.get $xc2) ;;V1.x
											(local.get $xc1) ;;V0.x
										(f64.sub)
									(f64.mul)
								(f64.sub)
								(i32.trunc_f64_s)
								(local.tee $e12)
								(i32.const 0)
							(i32.gt_s)
							(if		;;if the point is in
							(then	;;the v1-v2 boundary
												(local.get $i) ;;P.x
												(local.get $xc2) ;;V2.x
											(f64.sub)
												(local.get $yc0) ;;V0.y
												(local.get $yc2) ;;V2.y
											(f64.sub)
										(f64.mul)
												(local.get $j) ;;P.y
												(local.get $yc2) ;;V2.y 
											(f64.sub)
												(local.get $xc0) ;;V0.x
												(local.get $xc2) ;;V2.x
											(f64.sub)
										(f64.mul)
									(f64.sub)
									(i32.trunc_f64_s)
									(local.tee $e20)
									(i32.const 0)
								(i32.gt_s)
								(if		;;if the point is in
								(then	;;the v2-v0 boundary			
									(call $pshade
										;; (i32.trunc_f64_s (call $normx (local.get $i)))
										(i32.trunc_f64_s (local.get $i))
										;; (i32.trunc_f64_s (call $normy (local.get $j)))
										(i32.trunc_f64_s (local.get $j))
										(local.get $color)
									)
								)
								(else	;;if the point is not inside any boundary
									(if (i32.eqz (local.get $i01))
									(then
										(if (local.get $e01)
										(then
											(if (i32.eqz (local.get $i12))
											(then
												(if (local.get $e12)
													(call $pshade
														;; (i32.trunc_f64_s (call $normx (local.get $i)))
														;; (i32.trunc_f64_s (call $normy (local.get $j)))
														(i32.trunc_f64_s (local.get $i))
														(i32.trunc_f64_s (local.get $j))
														(local.get $color)
													)
												)
											)
											(else
												(if (i32.eqz (local.get $i20))
												(then
													(if (local.get $e20)
														(call $pshade
															;; (i32.trunc_f64_s (call $normx (local.get $i)))
															;; (i32.trunc_f64_s (call $normy (local.get $j)))
															(i32.trunc_f64_s (local.get $i))
															(i32.trunc_f64_s (local.get $j))
															(local.get $color)
														)
													)
												)
												(else
													(call $pshade
														;; (i32.trunc_f64_s (call $normx (local.get $i)))
														;; (i32.trunc_f64_s (call $normy (local.get $j)))
														(i32.trunc_f64_s (local.get $i))
														(i32.trunc_f64_s (local.get $j))
														(local.get $color)
													)
												)
												)
											)
											)
										)
										)
									
									)
									(else
										(if (i32.eqz (local.get $i12))
										(then
											(if (local.get $e12)
											(then
												(if (i32.eqz (local.get $i20))
												(then
													(if (local.get $e20)
													(then
														(call $pshade
															;; (i32.trunc_f64_s (call $normx (local.get $i)))
															;; (i32.trunc_f64_s (call $normy (local.get $j)))
															(i32.trunc_f64_s (local.get $i))
															(i32.trunc_f64_s (local.get $j))
															(local.get $color)
														)
													)
													)
												)
												(else
													(call $pshade
														;; (i32.trunc_f64_s (call $normx (local.get $i)))
														;; (i32.trunc_f64_s (call $normy (local.get $j)))
														(i32.trunc_f64_s (local.get $i))
														(i32.trunc_f64_s (local.get $j))
														(local.get $color)
													)
												)
												)
											)
											)
										)
										(else
											(if (i32.eqz (local.get $i20))
											(then
												(if (local.get $e20)
												(then
													(call $pshade
														;; (i32.trunc_f64_s (call $normx (local.get $i)))
														;; (i32.trunc_f64_s (call $normy (local.get $j)))
														(i32.trunc_f64_s (local.get $i))
														(i32.trunc_f64_s (local.get $j))
														(local.get $color)
													)
												)
												)
											)
											)
										)
										)
									)
									)
								)
								)
							)
							)
						)
						)

					;;loop logic (end part) (increment, break if over)
					(local.tee $i (call $increment (local.get $i)))
					(br 0)
				)
				)

				;;loop logic (set i to 0, increment j, break if over)
				(br 0)
			)
			)

		);;the end of the main
		);;if block
	;;END	MAIN IF BLOCK (IF SOME OF TRI IS IN CANVAS BOUNDS)

)



(func $test (export "test") (param $num i32) (param $num2 i32)

)

) ;;module end