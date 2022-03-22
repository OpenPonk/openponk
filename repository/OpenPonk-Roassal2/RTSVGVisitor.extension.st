Extension { #name : #RTSVGVisitor }

{ #category : #'*OpenPonk-Roassal2' }
RTSVGVisitor >> visitDoubleArrowHeadShape: arrowHeadShape onStart: aBoolean [

	self
		visitLineDecorationShape: arrowHeadShape
		using: OPRTSVGDoubleArrowHeadMarker
		onStart: aBoolean
]
