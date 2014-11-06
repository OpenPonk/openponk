adding
addCanvasMenu
	| builder exportMenus |
	builder := RTMenuBuilder new view: roassalView.
	builder menu: '' callback: [  ].	"just visual indentiation of menu"
	builder menu: '   - ' background: Color veryLightGray callback: [ self zoom: self zoom * 0.8 ].
	builder
		menu: ' ' , (self zoom * 100) truncated asString , ' %'
		background: Color veryLightGray
		callback: [ self zoom: 1.0001 ].
	builder menu: '   +' background: Color veryLightGray callback: [ self zoom: self zoom * 1.25 ].
	roassalView canvas
		when: TRMouseWheelEvent
		do: [ 
			roassalView canvas announcer unsubscribe: self.
			self reloadCanvasMenu ].
	builder
		menu: ' view all'
		background: Color veryLightGray
		callback: [ 
			roassalView canvas focusOnCenterScaled.
			self reloadCanvasMenu ].
	exportMenus := Array
		with: ' PNG' -> [ self exportAs: #PNG ]
		with: ' JPEG' -> [ self exportAs: #JPEG ]
		with: ' BMP' -> [ self exportAs: #BMP ]
		with: ' GIF' -> [ self exportAs: #GIF ].
	builder menu: '    export as picture...' submenus: exportMenus background: Color veryLightGray.
	self signalUpdate