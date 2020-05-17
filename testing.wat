(module
  (import "env" "memory" (memory 1))

  ;; (func $_reverse (param i32) (param i32)
  ;;   (i32.store (i32.const 1) (i32.const 256))
  ;; )
  ;; (export "_reverse" (func $_reverse))

  ;; (func $strip (param $number i32) (param $bundle i32)
  ;;   ;; number is the address of the number to be modified
  ;;   ;; bundle gives which of the 4 bytes should be modified
  ;;   i32.load8_u (i32.add ($number) (i32.mul $bundle i32.const 4))
  ;; )  

  ;; (func $test (param $num i32) (param $address i32) (result i32)
  ;;   (i32.store8 (local.get $num) (local.get $address))
  ;;   (i32.const 1)
  ;; )
  ;; (export "test" (func $_reverse))

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
  (func $proj (param $x f64) (param $y f64) (param $z f64))

  (func (export "main") 
    f64.store 
  )

meow

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