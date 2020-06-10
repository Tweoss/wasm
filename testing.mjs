/*  INFO  *//*
Proper projections
Bezier curve generating mesh or straight to canvas

/*        *///


function consoleLogOne(log) {
	console.log(log);
}


const memory = new WebAssembly.Memory({
	initial: 676,//for my monitor
	maximum: 1024
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

// canvas.requestPointerLock = canvas.requestPointerLock;
// canvas.requestPointerLock();

WebAssembly.instantiateStreaming(fetch('testing.wasm'),imports)
.then(results => {
	
	//VARIABLES
	var viewpoint 	= {x: 0, y: 0, z:201};
	var viewup 		= {x: 0, y: 0, z: 1};
	var viewdir 	= {x:20, y: 0, z: 0};
	var viewright	= {x: 0, y:-1, z: 0};
	var offset = 114;
	var period = 12;
	var keyDownFlags = [0,0,0,0,0,0];
	
	canvas.addEventListener('click', function(event) {
			canvas.requestPointerLock = canvas.requestPointerLock ||
					 canvas.mozRequestPointerLock ||
					 canvas.webkitRequestPointerLock;
			// Ask the browser to lock the pointer
			canvas.requestPointerLock();
	})
	
	window.addEventListener('keydown', function(event) {
		if (event.key === 'Shift') {
			keyDownFlags[0] = 1;
			// viewpoint.x -= viewup.x
			// viewpoint.y -= viewup.y
			// viewpoint.z -= viewup.z
		}
		else if (event.key === ' ') {
			keyDownFlags[1] = 1;
			viewpoint.x += viewup.x
			viewpoint.y += viewup.y
			viewpoint.z += viewup.z
		}
		else if (event.key === 'w') {
			keyDownFlags[2] = 1;
			viewpoint.y--;
		}
		else if (event.key === 'a') {
			keyDownFlags[3] = 1;
			viewpoint.y--;
		}
		else if (event.key === 's') {
			keyDownFlags[4] = 1;
			viewpoint.y--;
		}
		else if (event.key === 'd') {
			keyDownFlags[5] = 1;
			viewpoint.y--;
		}
		reView();
	});
	
	window.addEventListener('keyup', function(event) {
		if (event.key === 'Shift') {
			keyDownFlags[0] = 0;
		}
		else if (event.key === ' ') {
			keyDownFlags[1] = 0;
		}
		else if (event.key === 'w') {
			keyDownFlags[2] = 0;
		}
		else if (event.key === 'a') {
			keyDownFlags[3] = 0;
		}
		else if (event.key === 's') {
			keyDownFlags[4] = 0;
		}
		else if (event.key === 'd') {
			keyDownFlags[5] = 0;
		}
	});



	function store(num, sizeInBytes, location, heap) {
		var i;
		for (i=0;i<sizeInBytes;i++){
			heap[location+i] = num>>>(i*8) & 255;
		}
		if (sizeInBytes == 8) {
			if (num < 0){

			}
		}
	}
	
	


	//HEAP INFORMATION
	//	0 		- size of offset	
	//	1-4		- canvas width
	//	5-8		- canvas height
	//	9-32	- viewpointx,y,z
	//	33-56	- viewupx,y,z
	//	57-80	- viewdirx,y,z
	//	81-104	- viewrightx,y,z
	//	105-113	- intermediate calcs

	//	offset	- triangle
	//	0-3	- little endian
	//	4-11	- z buffer

	//	offset is the largest number from heap information + 1
	//	offset is one byte, so max offset is 255
	heap[0] = offset;
	results.instance.exports.storei(canvas.width,1);
	results.instance.exports.storei(canvas.height,5);
	function reView(){
		results.instance.exports.storef(viewpoint.x,9);
		results.instance.exports.storef(viewpoint.y,17);
		results.instance.exports.storef(viewpoint.z,25);
		results.instance.exports.storef(viewdir.x,33);
		results.instance.exports.storef(viewdir.y,41);
		results.instance.exports.storef(viewdir.z,49);
		results.instance.exports.storef(viewup.x,57);
		results.instance.exports.storef(viewup.y,65);
		results.instance.exports.storef(viewup.z,73);
		results.instance.exports.storef(viewright.x,81);
		results.instance.exports.storef(viewright.y,89);
		results.instance.exports.storef(viewright.z,97);
	}
	reView();

	var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
	var data=imageData.data;
	var dataLength = data.length;
	var color;
	// color = parseInt("D62A26FF",16);
	// results.instance.exports.trishade(05,10,10, 05,10,90, 05,90,90,color);
	// results.instance.exports.trishade(05,10,10, 05,90,90, 05,90,10,color);
	// color = parseInt("0F03E8FF",16);
	// results.instance.exports.trishade(90,10,10, 90,10,90, 90,90,90,color);
	// results.instance.exports.trishade(90,10,10, 90,90,90, 90,90,10,color);
	// color = parseInt("FF9800FF",16);
	// results.instance.exports.trishade(05,10,10, 90,10,10, 05,10,90,color);
	// results.instance.exports.trishade(05,10,90, 90,10,10, 90,10,90,color);


	for (var i = 0; i < length; i += 4){
		data[i]		= heap[i*period/4+offset+3];
		data[i + 1]	= heap[i*period/4+offset+1];
		data[i + 2]	= heap[i*period/4+offset+2];
		data[i + 3]	= 255;
	}
	// for (var i = 0+offset; i < data.length+offset; i += 4) {
	// 	data[i		- offset] = heap[i + 3]; //9   - data[i];     // red
	// 	data[i + 1 	- offset] = heap[i + 2]; //255 - data[i + 1]; // green
	// 	data[i + 2 	- offset] = heap[i + 1]; //255 - data[i + 2]; // blue
	// 	data[i + 3 	- offset] = heap[i]    ; //255;               //alpha
	// }
	ctx.putImageData(imageData, 0, 0);

	function redraw(){
		heap.fill(0,offset);
		color = parseInt("D62A26FF",16);
		results.instance.exports.trishade(05,10,10, 05,10,90, 05,90,90,color);
		results.instance.exports.trishade(05,10,10, 05,90,90, 05,90,10,color);
		color = parseInt("0F03E8FF",16);
		results.instance.exports.trishade(90,10,10, 90,10,90, 90,90,90,color);
		results.instance.exports.trishade(90,10,10, 90,90,90, 90,90,10,color);
		color = parseInt("FF9800FF",16);
		results.instance.exports.trishade(05,10,10, 90,10,10, 05,10,90,color);
		results.instance.exports.trishade(05,10,90, 90,10,10, 90,10,90,color);

		for (var i = 0; i < data.length; i += 4){
			data[i]		= heap[i*period/4+offset+3];
			data[i + 1]	= heap[i*period/4+offset+1];
			data[i + 2]	= heap[i*period/4+offset+2];
			data[i + 3]	= 255;
		}

		if (keyDownFlags[0] == 1) {
			viewpoint.x -= viewup.x
			viewpoint.y -= viewup.y
			viewpoint.z -= viewup.z
		}
		if (keyDownFlags[1] == 1) {
			viewpoint.x += viewup.x
			viewpoint.y += viewup.y
			viewpoint.z += viewup.z
		}
		if (keyDownFlags[2] == 1) {

		}
		if (keyDownFlags[3] == 1) {

		}
		if (keyDownFlags[4] == 1) {

		}
		if (keyDownFlags[5] == 1) {

		}
		reView();

		// for (var i = offset; i < data.length*3+offset; i += period) {
		// 	data[(i			- offset)/3] = heap[i + 3]; //9   - data[i];     // red
		// 	data[(i + 1 	- offset)/3] = heap[i + 2]; //255 - data[i + 1]; // green
		// 	data[(i + 2 	- offset)/3] = heap[i + 1]; //255 - data[i + 2]; // blue
		// 	data[(i + 3 	- offset)/3] = heap[i];     //255;               //alpha
		// }
		ctx.putImageData(imageData, 0, 0);
		// ctx.drawImage(imageData, 0, 0);
		requestAnimationFrame(redraw);	
	}
	redraw();

	
});

