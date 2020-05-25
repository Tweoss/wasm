(module ;;module start
(import "env" "memory" (memory 1))
(import "env" "log" (func $log (param i32)))

(func $_reverse (param i32) (param i32)
	(i32.store (i32.const 1) (i32.const 256))
)
(export "_reverse" (func $_reverse))

;; (func $strip (param $number i32) (param $bundle i32)
;;   ;; number is the address of the number to be modified
;;   ;; bundle gives which of the 4 bytes should be modified
;;   i32.load8_u (i32.add ($number) (i32.mul $bundle i32.const 4))
;; )  


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
		(local.get $n1)
				(local.get $n1) 
				(local.get $n2)
			(i32.sub)
				(i32.const 31)
					(local.get $n1) 
					(local.get $n2)
				(i32.sub)
			(i32.shr_u)
		(i32.and)
	(i32.sub)
	(local.set $min)

		(local.get $min)
				(local.get $min) 
				(local.get $n3)
			(i32.sub)
				(i32.const 31)
					(local.get $min) 
					(local.get $n3)
				(i32.sub)
			(i32.shr_u)
		(i32.and)
	(i32.sub)
	;; (call $log)
)
;;takes three args and returns the max
(func $max (export "max") (param $n1 i32) (param $n2 i32) (param $n3 i32) (result i32)
	(local $max i32)
		(local.get $n2)
				(local.get $n1) 
				(local.get $n2)
			(i32.sub)
				(i32.const 31)
					(local.get $n1) 
					(local.get $n2)
				(i32.sub)
			(i32.shr_u)
		(i32.and)
	(i32.add)
	(local.set $max)

		(local.get $n3)
				(local.get $max) 
				(local.get $n3)
			(i32.sub)
				(i32.const 31)
					(local.get $max) 
					(local.get $n3)
				(i32.sub)
			(i32.shr_u)
		(i32.and)
	(i32.add)
	;; (call $log)
)

;;takes the 3d coords and pushes to stack the 2d canvas coords 
;;assumes viewer at 0,0,0 and plane at x = 10 and object is in front of plane
(func $proj (param $x f64) (param $yz f64) (result f64)
	(local.get $yz)
	(local.get $x)
	(f64.div)
	(f64.const 10)
	(f64.mul)
)

;;normalizes the canvas coords based on the size (assumes a 1280,720)
(func $normx (param $x f64) (result f64)
	(f64.const 640)
	(local.get $x)
	(f64.sub)
)
(func $normy (param $y f64) (result f64)
	(f64.const 360)
	(local.get $y)
	(f64.sub)
)
;;and the integer version
(func $normix (param $x i32) (result i32)
	(i32.const 640)
	(local.get $x)
	(i32.sub)
)
(func $normiy (param $y i32) (result i32)
	(i32.const 360)
	(local.get $y)
	(i32.sub)
)


;;returns the one dimensional array pointer from 2d canvas coords
;;(assumes 1280,720)
(func $mem (param $x i32) (param $y i32) (result i32)
	(i32.add
			(i32.const 640)
			(local.get $x)
		(i32.sub)
				(i32.const 360)
				(local.get $y)
			(i32.sub)
			(i32.const 1280)
		(i32.mul)
	)
	(i32.const 4)
	(i32.mul)
)

;;shades a pixel (bounds checking)
(func $pshade (export "pshade") (param $x i32) (param $y i32) (param $color i32)
			(i32.ge_s (local.get $x) (i32.const 0	))
			(i32.lt_s (local.get $x) (i32.const 1280))
		(i32.and)
			(i32.ge_s (local.get $y) (i32.const 0	))
			(i32.lt_s (local.get $y) (i32.const 720	))
		(i32.and)
	(i32.and)
	
	(if 
		(then
			(local.get $y)
			(local.get $x)
			(call $mem)
				(local.get $y)
				(local.get $x)
				(call $mem)
			(call $log)
			(local.get $color)

			(i32.store)
		)
	
	)

)

(func $increment (param $x i32) (result i32)
	(local.get $x)
	(i32.const 1)
	(i32.add)
)



;; assumes 1280, 720 
(func (export "main") (param $x f64) (param $y f64) (param $z f64) (param $color i32) 
	(local $row i32)
	(local $col i32)
	(call $proj (local.get $x) (local.get $z)) ;; 2d equiv is y
	(call $normy)
	(local.tee $row (i32.trunc_f64_u))
	(i32.const 1280)
	(i32.mul)
	(call $proj (local.get $x) (local.get $y)) ;; 2d equiv is x
	(call $normx)
	(local.tee $col (i32.trunc_f64_u))
	(i32.add)
	(i32.const 4)
	(i32.mul)

	(local.get $color) ;; color
	(i32.store)

)


;;when passing in, pass triangle with highest x (or y (or z)) then go counterclockwise

(func $trishade (export "trishade") (param $x0 f64) (param $y0 f64) (param $z0 f64) (param $x1 f64) (param $y1 f64) (param $z1 f64) (param $x2 f64) (param $y2 f64) (param $z2 f64) (param $color i32)
	
	(local $xr0 i32);;canvas coords
	(local $yr0 i32);;(rounded)
	(local $xr1 i32)
	(local $yr1 i32)
	(local $xr2 i32)
	(local $yr2 i32)
	(local $xc0 f64);;canvas coords
	(local $yc0 f64);;(not rounded)
	(local $xc1 f64)
	(local $yc1 f64)
	(local $xc2 f64)
	(local $yc2 f64)
	(local $xb0 i32);;bounding box (rounded)
	(local $yb0 i32)
	(local $xb1 i32)
	(local $yb1 i32)
	(local $i	i32);;arbitrary indeces
	(local $j	i32)
	(local.set $xr0 (i32.trunc_f64_s (local.tee $xc0 (call $proj (local.get $x0) (local.get $y0)))))
	(local.set $yr0 (i32.trunc_f64_s (local.tee $yc0 (call $proj (local.get $x0) (local.get $z0)))))
	(local.set $xr1 (i32.trunc_f64_s (local.tee $xc1 (call $proj (local.get $x1) (local.get $y1)))))
	(local.set $yr1 (i32.trunc_f64_s (local.tee $yc1 (call $proj (local.get $x1) (local.get $z1)))))
	(local.set $xr2 (i32.trunc_f64_s (local.tee $xc2 (call $proj (local.get $x2) (local.get $y2)))))
	(local.set $yr2 (i32.trunc_f64_s (local.tee $yc2 (call $proj (local.get $x2) (local.get $z2)))))
	
	;;if at least some of the triangle is inside the canvas bounds
	(local.set $xb0 (call $min (local.get $xr0) (local.get $xr1) (local.get $xr2)))
	(local.set $yb0 (call $min (local.get $yr0) (local.get $yr1) (local.get $yr2)))
	(local.set $xb1 (call $max (local.get $xr0) (local.get $xr1) (local.get $xr2)))
	(local.set $yb1 (call $max (local.get $yr0) (local.get $yr1) (local.get $yr2)))

					(i32.ge_s (local.get $xb0) (i32.const -640))
					(i32.ge_s (local.get $xb1) (i32.const -640))
			(i32.or)
					(i32.ge_s (local.get $yb0) (i32.const -360))
					(i32.ge_s (local.get $yb1) (i32.const -360))
			(i32.or)
		(i32.or)
					(i32.lt_s (local.get $xb0) (i32.const 640))
					(i32.lt_s (local.get $xb1) (i32.const 640))
			(i32.or)
					(i32.lt_s (local.get $yb0) (i32.const 360))
					(i32.lt_s (local.get $yb1) (i32.const 360))
			(i32.or)
		(i32.or)
	(i32.or)


	;;;; ALL COORDS ARE NOT NORMALIZED (yet?)

	(if	  ;;the start of the main
	(then ;;if block
		(local.set $i (local.get $xb0))
		(local.set $j (local.get $yb0))
		
		(block 
			(loop ;;loop through the x bounds of the projected triangle

			(block
				(loop ;;loop through the y bounds of the projected triangle
				;; if the point is either on or in the triangle
				(if   ;;if the point is 
					(f64.convert_i32_s (local.get $i))
					(local.get $xc0)
				(f64.sub)
				(then ;;inside the triangle

	


				
				)
				(else ;;if not inside the triangle
				(if   ;;if the point is
				(then ;;on a valid edge
				
				
				) ;;end of valid edge then block
				) ;;end of valid edge if block

				) ;;end of valid point else block
				) ;;end of valid point if block

				(call $pshade
					(call $normix (local.get $i))
					(call $normiy (local.get $j))
					(local.get $color)
				)
				;;loop logic (increment, break if over)
				(local.set $i (call $increment (local.get $i)))
				(br_if 1 (i32.eq (local.get $i) (local.get $xb1)))
				(br 0)
				)
			)

			;;loop logic (set i to 0, increment j, break if over)
			(local.set $i (i32.const 0))
			(local.set $j (call $increment (local.get $j)))
			(br_if 1 (i32.eq (local.get $j) (local.get $yb1)))
			(br 0)
			)
		)
		;; (call $proj (local.get $x0) (local.get $z0))

	);;the end of the main
	);;if block



	;; (local.set $xc0)
	;; (local $xc2 i32)
	;; (local $yc2 i32)



)





;; (func $average (param $address i32) (param $width i32)
;;   ;; address is mem address of place to average
;;   ;; width is width of canvas in pixels
;;   (local $target i32)
;;   (local.set $target (i32.load (local.get $address)))
;;   (block 
;;     (loop 
;;       (i32.add
;;         (i32.add
;;           (i32.load (i32.add (local.get $target) (i32.mul (local.get $width) i32.const 4)))
;;           (i32.load (i32.add (local.get $target) (i32.mul (local.get $width) i32.const 4)))
;;         )
;;       )
;;       (br_if 1 (i32.eq (get_local $x) (i32.const 50)))
;;       (br 0)
;;     )
;;   )
;; )


) ;;module end 