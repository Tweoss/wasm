var memory = new WebAssembly.Memory({ initial : 1 });

      function consoleLogString(offset, length) {
        // var bytes = new Uint8Array(memory.buffer, offset, length);
        // var string = new TextDecoder('utf8').decode(bytes);
        console.log(string);
      }

      var importObject = {
        env: {
          log: consoleLogString
        },
        js: {
          mem: memory
        }
      };

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
//ROARINGLY BORING CHANGE