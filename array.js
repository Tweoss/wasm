var memory = new WebAssembly.Memory({ initial : 1 });

      function consoleLogString(length, offset) {
        // var bytes = new Uint8Array(memory.buffer, length, offset);
        // var string = new TextDecoder('utf8').decode(bytes);
        console.log(new Uint8Array(memory.buffer, length, offset));
      }
      function consoleLogOne(log) {
        console.log(log);
      }

      var importObject = {
        env: {
          log: consoleLogString
        },
        js: {
          mem: memory,
          log: consoleLogOne
        }
      };

WebAssembly.instantiateStreaming(fetch('array.wasm'), importObject)
.then(results => {
  results.instance.exports.main;
  // consoleLogString(0,9);
  console.log(new Uint32Array(results.instance.memo,0,9))
  // var array = new Uint8Array(memory,100,0);
  console.log(memory);
  exports('array.wasm')
  
})

  // consoleLogString(9,0);
//ROARINGLY BORING CHANGE




