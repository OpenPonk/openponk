adding
addCanvasMenu
	| builder exportMenus callback |
	builder := RTMenuBuilder new view: roassalView.
	builder menu: '' callback: [  ].	"just visual indentiation of menu"
	builder menu: '   - ' background: Color veryLightGray callback: [ self zoom: self zoom * 0.8 ].
	builder
		menu: ' ' , (self zoom * 100) truncated asString , ' %'
		background: Color veryLightGray
		callback: [ self zoom: 1.0001 ].
	builder menu: '   +' background: Color veryLightGray callback: [ self zoom: self zoom * 1.25 ].
	builder menu: ' view all' background: Color veryLightGray callback: [ roassalView canvas focusOnCenterScaled ].
	exportMenus := Array
		with:
			' PNG'
				-> [ 
					self
						exportAs: #png;
						reloadCanvasMenu ]
		with:
			' JPEG'
				-> [ 
					self
						exportAs: #jpeg;
						reloadCanvasMenu ]
		with:
			' BMP'
				-> [ 
					self
						exportAs: #bmp;
						reloadCanvasMenu ]
		with:
			' GIF'
				-> [ 
					self
						exportAs: #gif;
						reloadCanvasMenu ].
	builder menu: ' export as picture...' submenus: exportMenus background: Color veryLightGray.
	self signalUpdate.
	callback := TRCameraScaleCallback new.
	callback
		block: [ 
			self reloadCanvasMenu.
			roassalView canvas camera
				removeCallback: callback
				ifAbsent: [ self error: 'this callback should run only once then delete itself' ] ].
	roassalView canvas camera addCallback: callback