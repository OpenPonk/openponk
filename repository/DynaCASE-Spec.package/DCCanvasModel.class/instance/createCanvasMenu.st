adding
createCanvasMenu
	| builder exportMenus |
	builder := RTMenuBuilder new view: roassalView.
	builder menu: '' callback: [  ].	"just visual indentiation of menu"
	builder menu: '   - ' background: Color veryLightGray callback: [ RTZoomOutMove on: roassalView ].
	builder menu: '   +' background: Color veryLightGray callback: [ RTZoomInMove on: roassalView ].
	builder
		menu: '    view all'
		background: Color veryLightGray
		callback: [ roassalView canvas camera focusOnCenterScaled ].
	exportMenus := Array
		with: ' PNG' -> [ self exportAs: #PNG ]
		with: ' JPEG' -> [ self exportAs: #JPEG ]
		with: ' BMP' -> [ self exportAs: #BMP ]
		with: ' GIF' -> [ self exportAs: #GIF ].
	builder menu: '    export as picture...' submenus: exportMenus background: Color veryLightGray