(module
    (import "env" "memory" (memory 1))

    (func $_reverse (param i32) (param i32)
		(i32.store (i32.const 1) (i32.const 256))
    )
    (export "_reverse" (func $_reverse))

)