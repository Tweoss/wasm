(module
	(import "env" "memory" (memory 1))

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
	;;returns the one dimensional array pointer from 2d canvas coords (assumes 1280,720)
	(func $memx (param $x i32) (param $y i32)
		(i32.add
			(local.get $x)
			(i32.mul
				(local.get $y)
				(i32.const 1280)
			)
		)
		(i32.const 4)
		(i32.mul)
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


	;;when passing, pass triangle with highest x (or y (or z)) then go counterclockwise

	(func (export "trishade") (param $x0 f64) (param $y0 f64) (param $z0 f64) (param $x1 f64) (param $y1 f64) (param $z1 f64) (param $x2 f64) (param $y2 f64) (param $z2 f64) (param $color i32)
		;; (local $xc0 i32)
		;; (local $yc0 i32)
		;; (local $xc1 i32)
		;; (local $yc1 i32)
		;; (local $xc2 i32)
		;; (local $yc2 i32)
		(local $i i32)
		(local $j i32)
		(call $proj (local.get $x0) (local.get $y0))
		(local.set $i 0)
		(local.set $j 0)
		(local $xr0);;rounded

		(block 
			(loop 

			(block 
				(loop 
				(call $evolveCellToNextGeneration
					(get_local $x)
					(get_local $y)
				)
				(set_local $x (call $increment (get_local $x)))
				(br_if 1 (i32.eq (get_local $x) (i32.const 50)))
				(br 0)
				)
			)
			
			(set_local $y (call $increment (get_local $y)))
			(br_if 1 (i32.eq (get_local $y) (i32.const 50)))
			(br 0)
			)
		)
		(call $proj (local.get $x0) (local.get $z0))
		


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
	

)