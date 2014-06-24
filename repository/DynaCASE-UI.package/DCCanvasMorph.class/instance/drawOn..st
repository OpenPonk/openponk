drawing
drawOn: aCanvas
	surface
		drawDuring: [ :myCanvas | 
			surface clear: Color white.
			content reverseDo: [ :each | each drawOn: myCanvas ] ].
	aCanvas drawImage: surface asForm at: bounds origin