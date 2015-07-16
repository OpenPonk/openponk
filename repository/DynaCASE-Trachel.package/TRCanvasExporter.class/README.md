A TRCanvasExporter is exporter of Trachel canvas into image.
	
Supported formats: png, jpg (jpeg), bmp, gif.

There are 3 types of settings
	- immediate - makes change immediately
	- before export - makes change once right before first export occurs, only last value provided to method is used
	- in time of export - setting applied in time of each export, last provided value before the export is used
	
See example on class side or look into methods in settings protocol.
