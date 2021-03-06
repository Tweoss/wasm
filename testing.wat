(module ;;module start
(import "env" "memory" (memory 1))
(import "env" "log" (func $log (param i32)))
(import "env" "log" (func $logf (param f64)))

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
(func $min3 (param $n1 i32) (param $n2 i32) (param $n3 i32) (result i32)
	(local $min3 i32)
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
	(local.set $min3)
		(local.get $n3)
				(local.get $min3)
				(local.get $n3)
			(i32.sub)
					(local.get $min3)
					(local.get $n3)
				(i32.sub)
				(i32.const 31)
			(i32.shr_s)
		(i32.and)
	(i32.add)
)
(func $min2 (export "min2") (param $n1 i32) (param $n2 i32) (result i32)
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
)
;;takes three args and returns the max
(func $max3 (param $n1 i32) (param $n2 i32) (param $n3 i32) (result i32)
	(local $max3 i32)
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
	(local.set $max3)
		(local.get $n3)
				(local.get $max3)
				(local.get $n3)
			(i32.sub)
					(local.get $n3)
					(local.get $max3)
				(i32.sub)
				(i32.const 31)
			(i32.shr_s)
		(i32.and)
	(i32.add)
)
(func $max2 (export "max2") (param $n1 i32) (param $n2 i32) (result i32)
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
)

(func $loadflag (export "loadflag") (param $byteaddress i32) (param $bitaddress i32) (result i32)
			(i32.load (local.get $byteaddress))
				(local.get $bitaddress)
				(i32.const 1)
			(i32.add)
		(i32.rotr)
	(i32.and (i32.const 1))
)

(func $storeflag (export "storeflag") (param $byteaddress i32) (param $bitaddress i32) (param $flag i32)
			(i32.load (local.get $byteaddress))
				(i32.const 1)
					(local.get $bitaddress)
					(i32.const 1)
				(i32.add)
			(i32.rotr)
		(i32.or)
	(i32.store (local.get $byteaddress))
			
			(i32.load (local.get $byteaddress))
				(local.get $flag)
					(local.get $bitaddress)
					(i32.const 1)
				(i32.add)
			(i32.rotr)
		(i32.and)
	(i32.store (local.get $byteaddress))
)

(func $projx (export "projx") (param $x f64) (param $y f64) (param $z f64) (param $viewx f64) (param $viewy f64) (param $viewz f64) (param $viewdirx f64) (param $viewdiry f64) (param $viewdirz f64) (param $viewrightx f64) (param $viewrighty f64) (param $viewrightz f64) (result f64)
	(local $c f64)
	(local $temp f64);;check if behind viewpoint
	
	;;solve for c
	;;viewdir dotted with (viewdir-c*(xyz-view)) = 0
	;;c * (viewdir dot (xyz-view)) = mag(viewdir)^2
	;;c = mag(viewdir)^2/(viewdir dot (xyz-view))
						(local.get $viewdirx)
						(local.get $viewdirx)
					(f64.mul)
							(local.get $viewdiry)
							(local.get $viewdiry)
						(f64.mul)
							(local.get $viewdirz)
							(local.get $viewdirz)
						(f64.mul)
					(f64.add)
				(f64.add)
						(local.get $viewdirx)
							(local.get $x)
							(local.get $viewx)
						(f64.sub)
					(f64.mul)
							(local.get $viewdiry)
								(local.get $y)
								(local.get $viewy)
							(f64.sub)
						(f64.mul)
							(local.get $viewdirz)
								(local.get $z)
								(local.get $viewz)
							(f64.sub)
						(f64.mul)
					(f64.add)
				(f64.add)
			(local.tee $temp)
				(if (f64.le (local.get $temp) (f64.const 0))
				(then
					(return (f64.const 0))
				)
				)
		(f64.div)
	(local.set $c)
	(f64.store (i32.const 105) (local.get $c))
	;;to get the x value of canvas
	;;project of c*(xyz-view) onto (viewright)/mag(viewright)

						(local.get $x)
						(local.get $viewx)
					(f64.sub)
					(local.get $viewrightx)
				(f64.mul)
							(local.get $y)
							(local.get $viewy)
						(f64.sub)
						(local.get $viewrighty)
					(f64.mul)
							(local.get $z)
							(local.get $viewz)
						(f64.sub)
						(local.get $viewrightz)
					(f64.mul)
				(f64.add)
			(f64.add)
			(local.get $c)
		(f64.mul)
				(local.get $viewrightx)
				(local.get $viewrightx)
			(f64.mul)
					(local.get $viewrighty)
					(local.get $viewrighty)
				(f64.mul)
					(local.get $viewrightz)
					(local.get $viewrightz)
				(f64.mul)
			(f64.add)
		(f64.add)
	(f64.div)
)

(func $projy (export "projy") (param $x f64) (param $y f64) (param $z f64) (param $viewx f64) (param $viewy f64) (param $viewz f64) (param $viewdirx f64) (param $viewdiry f64) (param $viewdirz f64) (param $viewupx f64) (param $viewupy f64) (param $viewupz f64) (result f64)
	(local $c f64)
	;;solve for c
	;;viewdir dotted with (viewdir-c*(xyz-view)) = 0
	;;c * (viewdir dot (xyz-view)) = mag(viewdir)^2
	;;c = mag(viewdir)^2/(viewdir dot (xyz-view))
	(local.set $c (f64.load (i32.const 105)))

	;;project c*(xyz-view) onto viewup to get the y value of canvas
	;;so we want (c*(xyz-view) dot viewup)/mag(viewup)
			
						(local.get $x)
						(local.get $viewx)
					(f64.sub)
					(local.get $viewupx)
				(f64.mul)
							(local.get $y)
							(local.get $viewy)
						(f64.sub)
						(local.get $viewupy)
					(f64.mul)
							(local.get $z)
							(local.get $viewz)
						(f64.sub)
						(local.get $viewupz)
					(f64.mul)
				(f64.add)
			(f64.add)
			(local.get $c)
		(f64.mul)
				(local.get $viewupx)
				(local.get $viewupx)
			(f64.mul)
					(local.get $viewupy)
					(local.get $viewupy)
				(f64.mul)
					(local.get $viewupz)
					(local.get $viewupz)
				(f64.mul)
			(f64.add)
		(f64.add)
	(f64.div)
)


;;returns the one dimensional array pointer from 2d canvas coords
;;(assumes 1280,720)
(func $mem (param $x i32) (param $y i32) (result i32)
	(local $testing i32)
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
			(i32.add)
			(i32.const 12) ;;however many bytes is taken by each pixel
		(i32.mul)
		(i32.load8_u (i32.const 0))
	(i32.add)

	(local.tee $testing)
		;; (i32.const 0)
		
)


(func $increment (param $x f64) (result f64)
		(local.get $x)
		(f64.const 1)
	(f64.add)
)

(func (export "storef") (param $number f64) (param $offset i32)
	(f64.store (local.get $offset) (local.get $number))
)
(func (export "storei") (param $number i32) (param $offset i32)
	(i32.store (local.get $offset) (local.get $number))
)

;; assumes 1280, 720
(func (export "main") (param $x f64) (param $y f64) (param $z f64) (param $color i32)

)

;;shades a pixel (bounds checking)
(func $pshade (param $x i32) (param $y i32) (param $bari0 f64) (param $bari1 f64) (param $bari2 f64) (param $dist0 f64) (param $dist1 f64) (param $dist2 f64) (param $color i32)
	(local $memloc i32)
	(local $zdepth f64)

		(f64.const 1)
					(f64.const 1)
					(local.get $dist0)
				(f64.div)
				(local.get $bari0)
			(f64.mul)
						(f64.const 1)
						(local.get $dist1)
					(f64.div)
					(local.get $bari1)
				(f64.mul)
						(f64.const 1)
						(local.get $dist2)
					(f64.div)
					(local.get $bari2)
				(f64.mul)
			(f64.add)
		(f64.add)
	(f64.div)
	(local.set $zdepth)
			(i32.ge_s (local.get $x) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 1))) (i32.const 2)))
			(i32.lt_s (local.get $x) (i32.div_s (i32.load (i32.const 1)) (i32.const 2)))
		(i32.and)
			(i32.ge_s (local.get $y) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 5))) (i32.const 2)))
			(i32.lt_s (local.get $y) (i32.div_s (i32.load (i32.const 5)) (i32.const 2)))
		(i32.and)
	(i32.and)

	(if
	(then
								(local.get $x)
								(local.get $y)
							(call $mem)
						(local.tee $memloc)
							;; (local.get $x)
							;; (call $log)
							;; (local.get $y)
							;; (call $log)
							;; (local.get $memloc)
							;; (call $log)
						(i32.const 4)
					(i32.add)
				(f64.load)
				(local.get $zdepth)
			(f64.lt)
						(local.get $memloc)
						(i32.const 4)
					(i32.add)
				(f64.load)
				(f64.const 0)
			(f64.eq)
		(i32.or)
		(if
		(then

							;; 	(local.get $x)
							;; 	(local.get $y)
							;; (call $mem)
							;; (local.get $color)
							;; (i32.store)


				(local.get $memloc)
				(local.get $color)
			(i32.store)
					(local.get $memloc)
					(i32.const 4)
				(i32.add)
				(local.get $zdepth)
			(f64.store)
		)
		)
	)
	)
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
		(local $yb0 i32);;	(signed)
		(local $xb1 i32)
		(local $yb1 i32)
		(local $tri f64);;	area of the triangle
		(local $dt0 f64);;	distance to vertices
		(local $dt1 f64)
		(local $dt2 f64)
		(local $var f64);;	temporary var preventing reevaluation for squaring
		(local $e01 f64);;	validity of edges (top left rule)
		(local $e12 f64);;	+/- determines location of pixel
		(local $e20 f64)
		(local $i01 f64);;	if the point is on the 
		(local $i12 f64);;	edge (used for barycentric)
		(local $i20 f64)
		(local $i	f64);;	arbitrary indeces
		(local $j	f64);;	(signed)
		(local $ks	i32);;	early loop end
		(local $ke	i32)
	;;END	LOCAL DECLARATION

	;;START	PROJECTION EVALUATION
		(local.set $xr0 (i32.trunc_f64_s (local.tee $xc0 (f64.mul (f64.const -1) 	(call $projx (local.get $x0) (local.get $y0) (local.get $z0) (f64.load (i32.const 9)) (f64.load (i32.const 17)) (f64.load (i32.const 25)) (f64.load (i32.const 33)) (f64.load (i32.const 41)) (f64.load (i32.const 49)) (f64.load (i32.const 81)) (f64.load (i32.const 89)) (f64.load (i32.const 97)) )))))
		;; (call $log)
		(local.set $yr0 (i32.trunc_f64_s (local.tee $yc0							(call $projy (local.get $x0) (local.get $y0) (local.get $z0) (f64.load (i32.const 9)) (f64.load (i32.const 17)) (f64.load (i32.const 25)) (f64.load (i32.const 33)) (f64.load (i32.const 41)) (f64.load (i32.const 49)) (f64.load (i32.const 57)) (f64.load (i32.const 65)) (f64.load (i32.const 73)) ))))
		;; (call $log)
		(local.set $xr1 (i32.trunc_f64_s (local.tee $xc1 (f64.mul (f64.const -1) 	(call $projx (local.get $x1) (local.get $y1) (local.get $z1) (f64.load (i32.const 9)) (f64.load (i32.const 17)) (f64.load (i32.const 25)) (f64.load (i32.const 33)) (f64.load (i32.const 41)) (f64.load (i32.const 49)) (f64.load (i32.const 81)) (f64.load (i32.const 89)) (f64.load (i32.const 97)) )))))
		;; (call $log)
		(local.set $yr1 (i32.trunc_f64_s (local.tee $yc1							(call $projy (local.get $x1) (local.get $y1) (local.get $z1) (f64.load (i32.const 9)) (f64.load (i32.const 17)) (f64.load (i32.const 25)) (f64.load (i32.const 33)) (f64.load (i32.const 41)) (f64.load (i32.const 49)) (f64.load (i32.const 57)) (f64.load (i32.const 65)) (f64.load (i32.const 73)) ))))
		;; (call $log)
		(local.set $xr2 (i32.trunc_f64_s (local.tee $xc2 (f64.mul (f64.const -1) 	(call $projx (local.get $x2) (local.get $y2) (local.get $z2) (f64.load (i32.const 9)) (f64.load (i32.const 17)) (f64.load (i32.const 25)) (f64.load (i32.const 33)) (f64.load (i32.const 41)) (f64.load (i32.const 49)) (f64.load (i32.const 81)) (f64.load (i32.const 89)) (f64.load (i32.const 97)) )))))
		;; (call $log)
		(local.set $yr2 (i32.trunc_f64_s (local.tee $yc2							(call $projy (local.get $x2) (local.get $y2) (local.get $z2) (f64.load (i32.const 9)) (f64.load (i32.const 17)) (f64.load (i32.const 25)) (f64.load (i32.const 33)) (f64.load (i32.const 41)) (f64.load (i32.const 49)) (f64.load (i32.const 57)) (f64.load (i32.const 65)) (f64.load (i32.const 73)) ))))
		;; (call $log)
	;;END	PROJECTION EVALUATION

;;;;
;;
;;;;
;;
;;;;
;;



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
			(local.set $e01 (f64.const 1))
				(local.get $yc2) ;;next vertex
				(local.get $yc1) ;;prev vertex
			(f64.gt)
			(if
			(then
				(local.set $e12 (f64.const 1))
				(local.set $e20 (f64.const 0))
			)
			(else
				(local.set $e12 (f64.const 0))
					(local.get $yc1) ;;next vertex
					(local.get $yc0) ;;prev vertex
				(f64.gt)
				(if
				(then
					(local.set $e20 (f64.const 1))
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
						(local.set $e20 (f64.const 1))
					)
					(else
						(local.set $e20 (f64.const 0))
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
				(local.set $e01 (f64.const 1))
				(local.set $e12 (f64.const 1))
				(local.set $e20 (f64.const 0))
			)
			(else
				(local.set $e01 (f64.const 0))
						(local.get $yc2) ;;next
						(local.get $yc1) ;;prev
					(f64.eq)
						(local.get $xc2) ;;next
						(local.get $xc1) ;;prev
					(f64.gt)
				(i32.and)
				(if
				(then
					(local.set $e12 (f64.const 1))
							(local.get $yc0) ;;next
							(local.get $yc2) ;;prev
						(f64.eq)
							(local.get $xc0) ;;next
							(local.get $xc2) ;;prev
						(f64.gt)
					(i32.and)
					(if
					(then
						(local.set $e20 (f64.const 1))
					)
					(else
						(local.set $e20 (f64.const 0))
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
						(local.set $e12 (f64.const 1))
						(local.set $e20 (f64.const 1))
					)
					(else
						(local.set $e12 (f64.const 0))
						(local.set $e20 (f64.const 1))
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
		(local.set $xb0 (call $min3 (local.get $xr0) (local.get $xr1) (local.get $xr2)))
		(local.set $yb0 (call $min3 (local.get $yr0) (local.get $yr1) (local.get $yr2)))
		(local.set $xb1 (call $max3 (local.get $xr0) (local.get $xr1) (local.get $xr2)))
		(local.set $yb1 (call $max3 (local.get $yr0) (local.get $yr1) (local.get $yr2)))
				;; 		(i32.ge_s (local.get $xb0) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 1))) (i32.const 2)));;(i32.const -640))
				;; 		(i32.ge_s (local.get $yb0) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 5))) (i32.const 2)));;(i32.const -360)
				;; (i32.and)
						(i32.lt_s (local.get $xb1) (i32.div_s (i32.load (i32.const 1)) (i32.const 2)));;i32.const 640
						(i32.lt_s (local.get $yb1) (i32.div_s (i32.load (i32.const 5)) (i32.const 2)));;i32.const 360
				(i32.and)
			;; (i32.or)
						(i32.ge_s (local.get $xb0) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 1))) (i32.const 2)))
						(i32.ge_s (local.get $yb0) (i32.div_s (i32.mul (i32.const -1) (i32.load (i32.const 5))) (i32.const 2)))
				(i32.and)
			;; 			(i32.lt_s (local.get $xb1) (i32.div_s (i32.load (i32.const 1)) (i32.const 2)));;2560,1440 1280, 720
			;; 			(i32.lt_s (local.get $yb1) (i32.div_s (i32.load (i32.const 5)) (i32.const 2)))
			;; 	(i32.and)
			;; (i32.or)
		(i32.or)


		;;;; ALL COORDS ARE NORMALIZED THROUGH $MEM AND PROJECTION

		(if	  ;;the start of the main
		(then ;;if block

			;; (local.get $xb0 )
			;; (local.get $yb0 )
			;; (local.get $xb1 )
			;; (local.get $yb1 )
			;; (call $log)
			;; (call $log)
			;; (call $log)
			;; (call $log)
			(local.set $xb0 (call $max2 (local.get $xb0) (i32.div_s (i32.mul (i32.const -1) 	(i32.load (i32.const 1))) (i32.const 2))))
			(local.set $yb0 (call $max2 (local.get $yb0) (i32.div_s (i32.mul (i32.const -1) 	(i32.load (i32.const 5))) (i32.const 2))))
			(local.set $xb1 (call $min2 (local.get $xb1) (i32.div_s 							(i32.load (i32.const 1)) (i32.const 2))))
			(local.set $yb1 (call $min2 (local.get $yb1) (i32.div_s 							(i32.load (i32.const 5)) (i32.const 2))))
			;; (call $log)
			;; (call $log)
			;; (call $log)
			;; (call $log)

			;;START evaluate area of triangle * 2
				;;		i		j		k
				;;	xc1-xc0	yc1-yc0		0
				;;	xc2-xc0	yc2-yc0		0

				;; (xc1-xc0)*(yc2-yc0)-(xc2-xc0)*(yc1-yc0)
					
								(local.get $xc1)
								(local.get $xc0)
							(f64.sub)
								(local.get $yc2)
								(local.get $yc0)
							(f64.sub)
						(f64.mul)
								(local.get $xc2)
								(local.get $xc0)
							(f64.sub)
								(local.get $yc1)
								(local.get $yc0)
							(f64.sub)
						(f64.mul)
					(f64.sub)
				(local.set $tri)
			;;END evaluate area of triangle * 2

			;;START evaluate dist to each vertex
									(local.get $x0)
									(f64.load (i32.const 9))
								(f64.sub)
							(local.tee $var)
							(local.get $var)
						(f64.mul)
										(local.get $y0)
										(f64.load (i32.const 17))
									(f64.sub)
								(local.tee $var)
								(local.get $var)
							(f64.mul)
										(local.get $z0)
										(f64.load (i32.const 25))
									(f64.sub)
								(local.tee $var)
								(local.get $var)
							(f64.mul)
						(f64.add)
					(f64.add)
				(local.set $dt0)
									(local.get $x1)
									(f64.load (i32.const 9))
								(f64.sub)
							(local.tee $var)
							(local.get $var)
						(f64.mul)
										(local.get $y1)
										(f64.load (i32.const 17))
									(f64.sub)
								(local.tee $var)
								(local.get $var)
							(f64.mul)
										(local.get $z1)
										(f64.load (i32.const 25))
									(f64.sub)
								(local.tee $var)
								(local.get $var)
							(f64.mul)
						(f64.add)
					(f64.add)
				(local.set $dt1)
									(local.get $x2)
									(f64.load (i32.const 9))
								(f64.sub)
							(local.tee $var)
							(local.get $var)
						(f64.mul)
										(local.get $y2)
										(f64.load (i32.const 17))
									(f64.sub)
								(local.tee $var)
								(local.get $var)
							(f64.mul)
										(local.get $z2)
										(f64.load (i32.const 25))
									(f64.sub)
								(local.tee $var)
								(local.get $var)
							(f64.mul)
						(f64.add)
					(f64.add)
				(local.set $dt2)
			;;END	evaluate dist to each vertex


			;; (local.get $xr0) (local.get $xr1) (local.get $xr2)
			;; (call $log )
			;; (call $log )
			;; (call $log )

			(local.set $j (f64.convert_i32_s (local.get $yb0)))
			(block
			(loop ;;loop through the x bounds of the projected triangle

				;;loop logic (set i to 0, increment j, break if over)
				(br_if 1 (i32.ge_s (i32.trunc_f64_s (local.get $j)) (local.get $yb1)))
				(local.set $i  (f64.convert_i32_s (local.get $xb0)))
				(local.set $j  (call $increment (local.get $j)))
				;; (local.set $ke (i32.const 0))
				;; (local.set $ks (i32.const 0))

				(block
				(loop ;;loop through the y bounds of the projected triangle
					;;FOLD HERE if the point is in the triangle or on a valide edge or vertex	
					
					;;loop logic (end part) (increment, break if over)
					(br_if 1 (i32.ge_s (i32.trunc_f64_s (local.get $i)) (local.get $xb1)))
					;; (br_if 1 (i32.or (i32.ge_s (i32.trunc_f64_s (local.get $i)) (local.get $xb1)) (local.get $ke)))



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
							(local.tee $i01)
							(f64.const 0)
						(f64.gt)
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
								(local.tee $i12)
								(f64.const 0)
							(f64.gt)
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
									(local.tee $i20)
									(f64.const 0)
								(f64.gt)
								(if		;;if the point is in
								(then	;;the v2-v0 boundary			
									(call $pshade
										(i32.trunc_f64_s (local.get $i))
										(i32.trunc_f64_s (local.get $j))
										(f64.div (local.get $i12) (local.get $tri))
										(f64.div (local.get $i20) (local.get $tri))
										(f64.div (local.get $i01) (local.get $tri))
										(local.get $dt0)
										(local.get $dt1)
										(local.get $dt2)
										(local.get $color)
									)
								)
								(else	;;if the point is not inside any boundary
									(if (f64.eq (f64.const 0) (local.get $i01))
									(then
										(if (i32.trunc_f64_s (local.get $e01))
										(then
											(if (f64.eq (f64.const 0) (local.get $i12))
											(then
												(if (i32.trunc_f64_s (local.get $e12))
													(call $pshade
														(i32.trunc_f64_s (local.get $i))
														(i32.trunc_f64_s (local.get $j))
														(f64.div (local.get $i12) (local.get $tri))
														(f64.div (local.get $i20) (local.get $tri))
														(f64.div (local.get $i01) (local.get $tri))
														(local.get $dt0)
														(local.get $dt1)
														(local.get $dt2)
														(local.get $color)
													)
												)
											)
											(else
												(if (f64.eq (f64.const 0) (local.get $i20))
												(then
													(if (i32.trunc_f64_s (local.get $e20))
														(call $pshade
															(i32.trunc_f64_s (local.get $i))
															(i32.trunc_f64_s (local.get $j))
															(f64.div (local.get $i12) (local.get $tri))
															(f64.div (local.get $i20) (local.get $tri))
															(f64.div (local.get $i01) (local.get $tri))
															(local.get $dt0)
															(local.get $dt1)
															(local.get $dt2)
															(local.get $color)
														)
													)
												)
												(else
													(call $pshade
														(i32.trunc_f64_s (local.get $i))
														(i32.trunc_f64_s (local.get $j))
														(f64.div (local.get $i12) (local.get $tri))
														(f64.div (local.get $i20) (local.get $tri))
														(f64.div (local.get $i01) (local.get $tri))
														(local.get $dt0)
														(local.get $dt1)
														(local.get $dt2)
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
										(if (f64.eq (f64.const 0) (local.get $i12))
										(then
											(if (i32.trunc_f64_s (local.get $e12))
											(then
												(if (f64.eq (f64.const 0) (local.get $i20))
												(then
													(if (i32.trunc_f64_s (local.get $e20))
													(then
														(call $pshade
															(i32.trunc_f64_s (local.get $i))
															(i32.trunc_f64_s (local.get $j))
															(f64.div (local.get $i12) (local.get $tri))
															(f64.div (local.get $i20) (local.get $tri))
															(f64.div (local.get $i01) (local.get $tri))
															(local.get $dt0)
															(local.get $dt1)
															(local.get $dt2)
															(local.get $color)
														)
													)
													)
												)
												(else
													(call $pshade
														(i32.trunc_f64_s (local.get $i))
														(i32.trunc_f64_s (local.get $j))
														(f64.div (local.get $i12) (local.get $tri))
														(f64.div (local.get $i20) (local.get $tri))
														(f64.div (local.get $i01) (local.get $tri))
														(local.get $dt0)
														(local.get $dt1)
														(local.get $dt2)
														(local.get $color)
													)
												)
												)
											)
											)
										)
										(else
											(if (f64.eq (f64.const 0) (local.get $i20))
											(then
												(if (i32.trunc_f64_s (local.get $e20))
												(then
													(call $pshade
														(i32.trunc_f64_s (local.get $i))
														(i32.trunc_f64_s (local.get $j))
														(f64.div (local.get $i12) (local.get $tri))
														(f64.div (local.get $i20) (local.get $tri))
														(f64.div (local.get $i01) (local.get $tri))
														(local.get $dt0)
														(local.get $dt1)
														(local.get $dt2)
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