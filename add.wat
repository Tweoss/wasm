(module
    (import "env" "log" (func $log (param i32)))
    (memory 1)
    ;; create a array
    (func $arr (param $len i32) (result i32)
        (local $offset i32)                              ;; offset
        (set_local $offset (i32.load (i32.const 0)))     ;; load offset from the first i32

        (i32.store (get_local $offset)                   ;; load the length
                   (get_local $len)
        )

        (i32.store (i32.const 0)                         ;; store offset of available space
                   (i32.add
                       (i32.add
                           (get_local $offset)
                           (i32.mul
                               (get_local $len)
                               (i32.const 4)
                           )
                       )
                       (i32.const 4)                     ;; the first i32 is the length
                   )
        )
        (get_local $offset)                              ;; (return) the beginning offset of the array.
    )
    ;; return the array length
    (func $len (param $arr i32) (result i32)
        (i32.load (get_local $arr))
    )
    ;; convert an element index to the offset of memory
    (func $offset (param $arr i32) (param $i i32) (result i32)
        (i32.add
             (i32.add (get_local $arr) (i32.const 4))    ;; The first i32 is the array length
             (i32.mul (i32.const 4) (get_local $i))      ;; one i32 is 4 bytes
        )
    )
    ;; set a value at the index
    (func $set (param $arr i32) (param $i i32) (param $value i32)
        (i32.store
            (call $offset (get_local $arr) (get_local $i))
            (get_local $value)
        )
    )
    ;; get a value at the index
    (func $get (param $arr i32) (param $i i32) (result i32)
        (i32.load
            (call $offset (get_local $arr) (get_local $i))
        )
    )
    (func $main
        (local $a1 i32)

        ;; The first i32 records the beginning offset of available space
        ;; so the initial offset should be 4 (bytes)
        (i32.store (i32.const 0) (i32.const 4))

        (set_local $a1 (call $arr (i32.const 5)))   ;; create an array with length 0 and assign to $a1

        (call $len (get_local $a1))
        call $log                                   ;; print length 5

        ;; set 10 at the index 1 in $a1
        (call $set (get_local $a1) (i32.const 1) (i32.const 10))

        ;; get 10 at the index 1
        (call $get (get_local $a1) (i32.const 1))
        call $log                                   ;; print the element value 10
    )
    (start $main)
)