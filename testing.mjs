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
		store(canvas.width,4,1,heap);	
		store(canvas.height,4,5,heap);	
}

	function store(num, sizeInBytes, location, heap) {
		var i;
		for (i=0;i<sizeInBytes;i++){
			heap[location+i] = num>>>(i*8) & 255;
		}
	}
	
	var color;
	color = parseInt("D62A26FF",16);
	var viewpoint 	= {x: 0, y: 0, z: 0};
	var viewup 		= {x: 0, y: 0, z: 1};
	var viewdir 	= {x:10, y: 0, z: 0};


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
	var offset = 90;
	heap[0] = offset;
	resized();
	store(canvas.width,4,1,heap);
	store(canvas.height,4,5,heap);
	store(viewpoint.x,8,9,heap);
	store(viewpoint.y,8,17,heap);
	store(viewpoint.z,8,25,heap);
	store(viewup.x,8,33,heap);
	store(viewup.y,8,41,heap);
	store(viewup.z,8,49,heap);
	store(viewdir.x,8,57,heap);
	store(viewdir.y,8,65,heap);
	store(viewdir.z,8,73,heap);

	var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
	var data=imageData.data;
	
	results.instance.exports.trishade(21,-10,0,21,0,321,21,321,0,color);
	results.instance.exports.trishade(11,-20,21,-10,321,-30,21,0,321,color);

	for (var i = 0+offset; i < data.length+offset; i += 4) {
		data[i		- offset] = heap[i + 3]; //9   - data[i];     // red
		data[i + 1 	- offset] = heap[i + 2]; //255 - data[i + 1]; // green
		data[i + 2 	- offset] = heap[i + 1]; //255 - data[i + 2]; // blue
		data[i + 3 	- offset] = heap[i]    ; //255;               //alpha
		}
	ctx.putImageData(imageData, 0, 0);

	function redraw(){
		ctx.clearRect(0,0,canvas.width,canvas.height);
		heap.fill(0,offset);
		results.instance.exports.trishade(21,0,0,21,0,321,21,321,0,color);
		// results.instance.exports.trishade(21,321,0,21,0,321,21,321,321,color);

		let memfail = 0;
		for (var i = 0+offset; i < data.length+offset; i += 4) {
			data[i		- offset] = heap[i + 3]; //9   - data[i];     // red
			data[i + 1 	- offset] = heap[i + 2]; //255 - data[i + 1]; // green
			data[i + 2 	- offset] = heap[i + 1]; //255 - data[i + 2]; // blue
			data[i + 3 	- offset] = heap[i];     //255;               //alpha
		}
		console.log(i);
		ctx.putImageData(imageData, 0, 0);
		requestAnimationFrame(redraw);	
	}
	redraw();

	
});

