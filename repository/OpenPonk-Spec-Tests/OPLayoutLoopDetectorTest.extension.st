Extension { #name : 'OPLayoutLoopDetectorTest' }

{ #category : '*OpenPonk-Spec-Tests' }
OPLayoutLoopDetectorTest >> testLayouterSupportsGridLayoutCommand [
	self
		assert: (OPNoLayouter new supports: OPGridLayoutCommand)
		description: 'OPLayouter should support OPGridLayoutCommand'
]
