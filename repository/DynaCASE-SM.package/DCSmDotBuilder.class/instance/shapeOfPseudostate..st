private
shapeOfPseudostate: aPseudostate
	| shape supportedShapes |
	shape := nil.
	supportedShapes := Dictionary new.
	supportedShapes at: DCSmPseudostateKind initial put: 'point'.
	supportedShapes at: aPseudostate kind ifPresent: [ :s | shape := s ].
	^ shape