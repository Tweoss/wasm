WebAssembly.instantiateStreaming(fetch('add.wasm'))
.then(results => {
    var i = 0;
    do {
        //wait(4000);
        if (i%9999 == 1){
            setTimeout(console.log(results.instance.exports.add(i, 2)),10000000);
        }
        i++;
    } while (i<9999999);
})