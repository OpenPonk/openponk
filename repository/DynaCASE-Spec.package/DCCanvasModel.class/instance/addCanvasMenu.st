adding
addCanvasMenu
	| builder callback |
	builder := RTMenuBuilder new view: roassalView.
	builder menu: '' callback: [  ].	"just visual indentiation of menu"
	builder
		menu: ' ' , (self zoom * 100) truncated asString , ' % '
		background: Color veryLightGray
		callback: [ self zoom: 1.0001 ].
	self signalUpdate.
	callback := TRCameraScaleCallback new.
	callback
		block: [ 
			self reloadCanvasMenu.
			roassalView canvas camera
				removeCallback: callback
				ifAbsent: [ self error: 'this callback should run only once then delete itself' ] ].
	roassalView canvas camera addCallback: callback