/*  INFO  *//*
Proper projections
Bezier curve generating mesh or straight to canvas

/*        *///

function consoleLogOne(log) {
	console.log(log);
  }


const memory = new WebAssembly.Memory({
	initial: 203,//for my monitor
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



WebAssembly.instantiateStreaming(fetch('testing.wasm'),imports)
.then(results => {
	
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
		results.instance.exports.storei(canvas.width,1);
		results.instance.exports.storei(canvas.height,5);
}

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
	
	//VARIABLES
	var viewpoint 	= {x: 0, y: 0, z: 0};
	var viewup 		= {x: 0, y: 0, z: 1};
	var viewdir 	= {x:10, y: 0, z: 0};
	var offset = 90;
	var period = 12;


	//HEAP INFORMATION
	//	0 		- size of offset	
	//	1-4		- canvas width
	//	5-8		- canvas height
	//	9-32	- viewpointx,y,z
	//	33-56	- viewupx,y,z
	//	57-80	- viewdirx,y,z
	//	81-89	- intermediate calcs

	//	offset	- triangle
	//	0-3	- little endian
	//	4-11	- z buffer

	//	offset is the largest number from heap information + 1
	//	offset is one byte, so max offset is 255
	heap[0] = offset;
	resized();
	results.instance.exports.storei(canvas.width,1);
	results.instance.exports.storei(canvas.height,5);
	results.instance.exports.storef(viewpoint.x,9);
	results.instance.exports.storef(viewpoint.y,17);
	results.instance.exports.storef(viewpoint.z,25);
	results.instance.exports.storef(viewdir.x,33);
	results.instance.exports.storef(viewdir.y,41);
	results.instance.exports.storef(viewdir.z,49);
	results.instance.exports.storef(viewup.x,57);
	results.instance.exports.storef(viewup.y,65);
	results.instance.exports.storef(viewup.z,73);

	var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
	var data=imageData.data;
	var color;
	color = parseInt("D62A26FF",16);
	results.instance.exports.trishade(10,10,10, 10,10,90, 10,90,90,color);
	results.instance.exports.trishade(10,10,10, 10,90,90, 10,90,10,color);
	color = parseInt("0F03E8FF",16);
	results.instance.exports.trishade(90,10,10, 90,10,90, 90,90,90,color);
	results.instance.exports.trishade(90,10,10, 90,90,90, 90,90,10,color);
	color = parseInt("FF9800FF",16);
	results.instance.exports.trishade(10,10,10, 10,10,90, 90,10,10,color);
	results.instance.exports.trishade(10,10,90, 10,90,90, 90,10,10,color);


	for (var i = 0; i < data.length; i += 4){
		data[i]		= heap[i*period/4+offset+3];
		data[i + 1]	= heap[i*period/4+offset+1];
		data[i + 2]	= heap[i*period/4+offset+2];
		data[i + 3]	= heap[i*period/4+offset];
	}
	// for (var i = 0+offset; i < data.length+offset; i += 4) {
	// 	data[i		- offset] = heap[i + 3]; //9   - data[i];     // red
	// 	data[i + 1 	- offset] = heap[i + 2]; //255 - data[i + 1]; // green
	// 	data[i + 2 	- offset] = heap[i + 1]; //255 - data[i + 2]; // blue
	// 	data[i + 3 	- offset] = heap[i]    ; //255;               //alpha
	// }
	ctx.putImageData(imageData, 0, 0);

	function redraw(){
		ctx.clearRect(0,0,canvas.width,canvas.height);
		heap.fill(0,offset);
		results.instance.exports.trishade(21,0,0,21,0,321,21,321,0,color);
		// results.instance.exports.trishade(21,321,0,21,0,321,21,321,321,color);

		for (var i = 0; i < data.length; i += 4){
			data[i]		= heap[i*period/4+offset+3];
			data[i + 1]	= heap[i*period/4+offset+1];
			data[i + 2]	= heap[i*period/4+offset+2];
			data[i + 3]	= heap[i*period/4+offset];
		}

		// for (var i = offset; i < data.length*3+offset; i += period) {
		// 	data[(i			- offset)/3] = heap[i + 3]; //9   - data[i];     // red
		// 	data[(i + 1 	- offset)/3] = heap[i + 2]; //255 - data[i + 1]; // green
		// 	data[(i + 2 	- offset)/3] = heap[i + 1]; //255 - data[i + 2]; // blue
		// 	data[(i + 3 	- offset)/3] = heap[i];     //255;               //alpha
		// }
		ctx.putImageData(imageData, 0, 0);
		requestAnimationFrame(redraw);	
	}
	// redraw();

	
});

