as yet unclassified
highlight: anElement color: aColor
	^ (self allSubclasses detect: [ :each | each isFor: anElement ]) new
		highlight: anElement
		color: aColor