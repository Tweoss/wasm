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
ctx.imageSmoothingEnabled = false;
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

	window.addEventListener('resize', resized);

	function resized(e){
		var canvas = document.getElementById('myCanvas');
		canvas.width = window.innerWidth;
		canvas.height = window.innerHeight;	
		if (canvas.width > 1280/720*canvas.height){
			canvas.width = 1280/720*canvas.height;
		}
		else if (canvas.width < 1280/720*canvas.height){
			canvas.height = 720/1280*canvas.width;
		}
		heap[1] = (canvas.width&255);
		heap[2] = (canvas.width>>>8)&255;
		heap[3] = (canvas.width>>>16)&255;
		heap[4] = (canvas.width>>>24)&255;
		heap[5] = (canvas.height&255);
		heap[6] = (canvas.height>>>8)&255;
		heap[7] = (canvas.height>>>16)&255;
		heap[8] = (canvas.height>>>24)&255;
	}


	var color;
	color = parseInt("F7F711FF",16);


	//HEAP INFORMATION
	//	0 		- size of offset
	//	1 		- canvas width least sig
	//	2-4		- canvas width
	//	5-8		- canvas height
	//	9-25	- intermediate calcs
	
	//	offset	- triangle
	//	0 -31	- little endian
	//	32-95	- z buffer

	//	offset is the largest number from heap information + 1
	//	offset is one byte, so max is 255
	var offset = 26;
	heap[0] = offset;
	resized();
	heap[1] = canvas.width&255;
	heap[2] = canvas.width>>>8&255;
	heap[3] = canvas.width>>>16&255;
	heap[4] = canvas.width>>>24&255;
	heap[5] = canvas.height&255;
	heap[6] = canvas.height>>>8&255;
	heap[7] = canvas.height>>>16&255;
	heap[8] = canvas.height>>>24&255;
	
	results.instance.exports.trishade(21,-10,0,21,0,321,21,321,0,color);
	results.instance.exports.trishade(21,321,21,21,321,0,21,0,321,color);

	for (var i = 0+offset; i < data.length+offset; i += 4) {
		data[i		- offset] = heap[i + 3]; //9   - data[i];     // red
		data[i + 1 	- offset] = heap[i + 2]; //255 - data[i + 1]; // green
		data[i + 2 	- offset] = heap[i + 1]; //255 - data[i + 2]; // blue
		data[i + 3 	- offset] = heap[i]    ; //255;               //alpha
		}
	ctx.putImageData(imageData, 0, 0);
	// results.instance.exports.trishade(21,350,0,21,0,321,21,321,0,color);
	// console.log(heap);
	let colori;
	function redraw(){
		ctx.clearRect(0,0,canvas.width,canvas.height);
		heap.fill(0,offset);
		results.instance.exports.trishade(21,0,0,21,0,321,21,321,0,color);
		// results.instance.exports.trishade(21,321,0,21,0,321,21,321,321,color);


		let j = 0;
		let memfail = 0;
		for (var i = 0+offset; i < data.length+offset; i += 4) {
			data[i		- offset] = heap[i + 3]; //9   - data[i];     // red
			data[i + 1 	- offset] = heap[i + 2]; //255 - data[i + 1]; // green
			data[i + 2 	- offset] = heap[i + 1]; //255 - data[i + 2]; // blue
			data[i + 3 	- offset] = heap[i];     //255;               //alpha
			if (heap[i+2] != 0){
				j++;
				memfail = i;
			}
		}
		ctx.putImageData(imageData, 0, 0);
		requestAnimationFrame(redraw);	
	}
// redraw();



	// console.log("PLACED");
	const numbers = [14, 3, 77];
	// console.log(numbers, 'becomes', reverse(numbers));
	
});




// WebAssembly.instantiateStreaming(fetch('testing.wasm'),imports)
// .then(results => {
// 	function reverse(arr) {
// 		for (let i = 0; i < arr.length; ++i) {
// 			heap[i] = arr[i];
// 		}
// 		results.instance.exports._reverse(0, arr.length);
		
// 		const result = [];
// 		for (let i = 0; i < arr.length; ++i) {
// 			result.push(heap[i]);
// 		}
// 		return result;
// 	}
// 	function testfunc(x,y,z,color){
// 		return results.instance.exports.main(x,y,z,color);
// 	}
// 	results.instance.exports.max(2,5,0);

// 	// for(i = 3; i<1003;i++){
// 	// 	testfunc(i,10,3);
// 	// }
// 	var i, j, k;
// 	var color
// 	// // x = 1
// 	// color = parseInt("FFFFF0F0",16);
// 	// for (j = 21; j<321; j++){
// 	// 	for (k = 21; k<321; k++){
// 	// 		testfunc(21,j,k,color);
// 	// 	}
// 	// }
// 	// // y = 1
// 	// color = parseInt("FCBA03F0",16);
// 	// for(i = 21; i<321; i+= .01){
// 	// 	for (j = 21; j<321; j++){
// 	// 		testfunc(i,21,j,color);
// 	// 	}
// 	// }
// 	// // z = 1
// 	// color = parseInt("00FFFFF0",16);
// 	// for(i = 21; i<321; i+= .01){
// 	// 	for (j = 21; j<321; j++){
// 	// 		testfunc(i,j,21,color);
// 	// 	}
// 	// }
// 	// // x = 301
// 	// color = parseInt("FFFF00F0",16);
// 	// for (j = 21; j<321; j++){
// 	// 	for (k = 21; k<321; k++){
// 	// 		testfunc(321,j,k,color);
// 	// 	}
// 	// }
	
// 	// // y = 301
// 	// color = parseInt("F00FFFF0",16);
// 	// for(i = 21; i<321; i+= .01){
// 	// 	for (k = 21; k<321; k++){
// 	// 		testfunc(i,321,k,color);
// 	// 	}
// 	// }
// 	// // z = 301
// 	// color = parseInt("F0F0F0F0",16);
// 	// for(i = 21; i<321; i+= .01){
// 	// 	for (j = 21; j<321; j++){
// 	// 		testfunc(i,j,321,color);
// 	// 	}
// 	// }
// 	color = parseInt("FFFFF0F0",16);
// 	results.instance.exports.trishade(21,0,0,21,0,321,21,321,0,color);
// 	results.instance.exports.trishade(21,321,321,21,321,0,21,0,321,color);
	
	

// 	for (var i = 0; i < data.length; i += 4) {
// 		data[i]     = heap[i]     //9   - data[i];     // red
// 		data[i + 1] = heap[i + 1] //255 - data[i + 1]; // green
// 		data[i + 2] = heap[i + 2] //255 - data[i + 2]; // blue
// 		data[i + 3] = heap[i + 3] //255;               //alpha
// 	}
	
// 	ctx.putImageData(imageData, 0, 0);
// 	// console.log("PLACED");
// 	const numbers = [14, 3, 77];
// 	// console.log(numbers, 'becomes', reverse(numbers));
	
// })


