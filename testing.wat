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
  ;;assumes viewer at 0,0,0 and plane at x = 1 and object is in front of plane
  (func $proj (param $x f64) (param $yz f64) (result f64)
    (local.get $yz)
    (local.get $x)
    (f64.div)
  )

  ;;normalizes the canvas coords based on the size (assumes a 1280,720)
  (func $normx (param $x f64) (result f64)
    (local.get $x)
    (f64.const 640)
    (f64.add)
  )
  (func $normy (param $y f64) (result f64)
    (local.get $y)
    (f64.const 360)
    (f64.add)
  )


  ;; assumes 1280, 720
  (func (export "main") (param $x f64) (param $y f64) (param $z f64) (param $color f64) 
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

    (i32.const 4278255615) ;; color
    (i32.store)
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