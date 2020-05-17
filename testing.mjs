// const fs = require('fs');

const memory = new WebAssembly.Memory({
	initial: 256,
	maximum: 256
});
const heap = new Uint8Array(memory.buffer);
const imports = {
	env: {
		memory: memory
	}
};

// const wasmSource = new Uint8Array(fs.readFileSync("testing.wasm"));
// const wasmModule = new WebAssembly.Module(wasmSource);
// const wasmInstance = new WebAssembly.Instance(wasmModule, imports);

/*
WebAssembly.instantiateStreaming(fetch('testing.wasm'),imports)
.then(results => {
	function reverse(arr) {
		for (let i = 0; i < arr.length; ++i) {
			heap[i] = arr[i];
		}
		results.instance.exports._reverse(0, arr.length);
	
		const result = [];
		for (let i = 0; i < arr.length; ++i) {
			result.push(heap[i]);
		}
		return result;
	}
	function testfunc(x,y){
		return results.instance.exports.test(x,y);
	}
	console.log(testfunc(3,3));
	const numbers = [14, 3, 77];
	console.log(numbers, 'becomes', reverse(numbers));
  
})
*/


var canvas = document.getElementById('myCanvas');
canvas.width = window.innerWidth;
canvas.height = window.innerHeight;
var ctx = canvas.getContext('2d');
var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
var data = imageData.data;

for (var i = 0; i < data.length; i += 4) {
	data[i]     = 9   - data[i];     // red
	data[i + 1] = 255 - data[i + 1]; // green
	data[i + 2] = 255 - data[i + 2]; // blue
	data[i + 3] = 255;               //alpha
}
ctx.putImageData(imageData, 0, 0);
