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

  (func $test (param $num i32) (param $address i32) (result i32)
    i32.store8 $num $address
  )
  (export "_reverse" (func $_reverse))



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