WebAssembly.instantiateStreaming(fetch('add.wasm'), importObject)
.then(results => {
    console.log(obj.instance.exports.add(1, 2));
})