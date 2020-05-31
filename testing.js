/*  INFO  *//*
Proper projections
Bezier curve generating mesh or straight to canvas

/*        *///

function consoleLogOne(log) {
	console.log(log);
  }


const memory = new WebAssembly.Memory({
	initial: 100,
	maximum: 256
});
const heap = new Uint8Array(memory.buffer);
const imports = {
	env: {
		memory: memory,
		log: consoleLogOne
	}
};

var canvas = document.getElementById('myCanvas');
canvas.width = window.innerWidth;
canvas.height = window.innerHeight;
var ctx = canvas.getContext('2d');
var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
var data = imageData.data;


// const wasmSource = new Uint8Array(fs.readFileSync("testing.wasm"));
// const wasmModule = new WebAssembly.Module(wasmSource);
// const wasmInstance = new WebAssembly.Instance(wasmModule, imports);


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
	function testfunc(x,y,z,color){
		return results.instance.exports.main(x,y,z,color);
	}
	results.instance.exports.max(2,5,0);

	// for(i = 3; i<1003;i++){
	// 	testfunc(i,10,3);
	// }
	var i, j, k;
	var color
	// // x = 1
	// color = parseInt("FFFFF0F0",16);
	// for (j = 21; j<321; j++){
	// 	for (k = 21; k<321; k++){
	// 		testfunc(21,j,k,color);
	// 	}
	// }
	// // y = 1
	// color = parseInt("FCBA03F0",16);
	// for(i = 21; i<321; i+= .01){
	// 	for (j = 21; j<321; j++){
	// 		testfunc(i,21,j,color);
	// 	}
	// }
	// // z = 1
	// color = parseInt("00FFFFF0",16);
	// for(i = 21; i<321; i+= .01){
	// 	for (j = 21; j<321; j++){
	// 		testfunc(i,j,21,color);
	// 	}
	// }
	// // x = 301
	// color = parseInt("FFFF00F0",16);
	// for (j = 21; j<321; j++){
	// 	for (k = 21; k<321; k++){
	// 		testfunc(321,j,k,color);
	// 	}
	// }
	
	// // y = 301
	// color = parseInt("F00FFFF0",16);
	// for(i = 21; i<321; i+= .01){
	// 	for (k = 21; k<321; k++){
	// 		testfunc(i,321,k,color);
	// 	}
	// }
	// // z = 301
	// color = parseInt("F0F0F0F0",16);
	// for(i = 21; i<321; i+= .01){
	// 	for (j = 21; j<321; j++){
	// 		testfunc(i,j,321,color);
	// 	}
	// }
	color = parseInt("FFFFF0F0",16);
	results.instance.exports.trishade(21,0,0,21,0,321,21,321,0,color);
	results.instance.exports.trishade(21,321,321,21,321,0,21,0,321,color);
	
	

	for (var i = 0; i < data.length; i += 4) {
		data[i]     = heap[i]     //9   - data[i];     // red
		data[i + 1] = heap[i + 1] //255 - data[i + 1]; // green
		data[i + 2] = heap[i + 2] //255 - data[i + 2]; // blue
		data[i + 3] = heap[i + 3] //255;               //alpha
	}
	
	ctx.putImageData(imageData, 0, 0);
	// console.log("PLACED");
	const numbers = [14, 3, 77];
	// console.log(numbers, 'becomes', reverse(numbers));
	
})


