as yet unclassified
layoutFor: aChoice
	^ ('RT' , ((self layoutOptions at: aChoice) copyWithoutAll: ' '), 'Layout') asClass