Extension { #name : 'RSAbstractControlCanvasInteraction' }

{ #category : '*OpenPonk-Roassal' }
RSAbstractControlCanvasInteraction >> correctRectangle: rectangle camera: camera [

	| visibleRectangle correctX correctY |
	self configuration keepCameraOnContent ifFalse: [ ^ rectangle ].
	visibleRectangle := camera visibleRectangle.
	correctX := self correctValues: {
			            rectangle origin x.
			            rectangle corner x.
			            visibleRectangle origin x.
			            visibleRectangle corner x }.
	correctY := self correctValues: {
			            rectangle origin y.
			            rectangle corner y.
			            visibleRectangle origin y.
			            visibleRectangle corner y }.
	^ correctX @ correctY extent: rectangle extent
]
