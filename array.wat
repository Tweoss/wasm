(module
	(import "env" "log" (func $log (param i32) (param i32)))
	(import "js"  "log" (func $lon (param i32)))
	(memory (export "memo") 1);;(import "js" "mem") 1)
	;; create an array (i32 is 4 bytes)
	(func $arr (param $len i32) (result i32)
		(local $offset i32)                             ;; offset
		(local.set $offset (i32.load (i32.const 0)))    ;; load offset from the first i32 (begins at 0)

		(i32.store (local.get $offset)                  ;; store the length of the new array at the offset
				   (local.get $len)                     ;; load the length (param)
		)   

		(i32.store (i32.const 0)                        ;; store new offset of available space (at first i32)
				   (i32.add                             ;; add offset and length*4 and 4<--length of new array
					   (i32.add                         ;; add offset and length*4 
						   (local.get $offset)          ;; load offset
						   (i32.mul                     ;; multiply length by 4 (bc each i32 is 4 bytes)
							   (local.get $len)         ;; load length 
							   (i32.const 4)            ;; load 4
						   )
					   )
					   (i32.const 4)                    ;; the first i32 is the length
				   )
		)
		(local.get $offset)                             ;; (return) the beginning offset of the new array.
	)
	;; return the array length
	(func $len (param $arr i32) (result i32)
		(i32.load (local.get $arr))
	)
	;; convert an element index to the offset of memory
	(func $offset (param $arr i32) (param $i i32) (result i32)
		(i32.add
			 (i32.add (local.get $arr) (i32.const 4))   ;; The first i32 is the array length
			 (i32.mul (i32.const 4) (local.get $i))     ;; one i32 is 4 bytes
		)
	)
	;; set a value at the index
	(func $set (param $arr i32) (param $i i32) (param $value i32)
		(i32.store
			(call $offset (local.get $arr) (local.get $i))
			(local.get $value)
		)
	)
	;; get a value at the index
	(func $get (param $arr i32) (param $i i32) (result i32)
		(i32.load
			(call $offset (local.get $arr) (local.get $i))
		)
	)
	(func $main
		(local $a1 i32)

		;; The first i32 records the beginning offset of available space
		;; so the initial offset should be 4 (bytes)
		(i32.store (i32.const 0) (i32.const 4))

		(local.set $a1 (call $arr (i32.const 5)))   ;; create an array with length 5 and assign to $a1

		(call $len (local.get $a1))
		call $lon                                   ;; print length 5

		;; set 10 at the index 1 in $a1
		(call $set (local.get $a1) (i32.const 1) (i32.const 10))

		;; get 10 at the index 1
		 
		 
		(call $lon (call $get (local.get $a1) (i32.const 1)))          ;; print the element value 10

		(i32.store (i32.const 0) (i32.const 9))
		(i32.store (i32.const 1) (i32.const 8))
		(i32.store (i32.const 2) (i32.const 7))
		(i32.store (i32.const 3) (i32.const 6))
		(i32.store (i32.const 4) (i32.const 5))
		(i32.store (i32.const 5) (i32.const 4))
		(i32.store (i32.const 6) (i32.const 3))
		(i32.store (i32.const 7) (i32.const 2))
		(i32.store (i32.const 8) (i32.const 1))


		(i32.const 0) (i32.const 9)
		call $log
		(i32.const 1) (i32.const 9)
		call $log
	)
	;; (start $main)
	(export "main" (func $main))
	;; (export "memo" (memory $memo))
) 