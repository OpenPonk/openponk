Extension { #name : 'RSMarker' }

{ #category : '*OpenPonk-Roassal' }
RSMarker >> asEmptyMarker [

	self shape color: Color white.
	^ OPRSEmptyMarker new
		  shape: self shape;
		  offset: self offset;
		  offsetRatio: self offsetRatio;
		  yourself
]
