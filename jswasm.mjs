var memory = new WebAssembly.Memory({ initial : 1 });

      function consoleLogString(length, offset) {
         var bytes = new Uint8Array(memory.buffer, length, offset);
        // var string = new TextDecoder('utf8').decode(bytes);
        console.log(bytes);
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

WebAssembly.instantiateStreaming(fetch('array.wasm'),importObject)
.then(results => {
  // results.instance.exports.main;
})
//ROARINGLY BORING CHANGE