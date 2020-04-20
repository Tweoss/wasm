WebAssembly.instantiateStreaming(fetch('add.wasm'))
.then(results => {
    console.log(results.instance.exports.add(1, 2));
})