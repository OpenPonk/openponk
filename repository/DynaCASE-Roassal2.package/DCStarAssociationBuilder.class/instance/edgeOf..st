accessing
edgeOf: aRTElement
	"gets edge connecting aRTElement and center"

	^ (self elements includes: aRTElement)
		ifFalse: [ nil ]
		ifTrue: [ center connectedEdges detect: [ :any | any from = aRTElement | (any to = aRTElement) ] ]