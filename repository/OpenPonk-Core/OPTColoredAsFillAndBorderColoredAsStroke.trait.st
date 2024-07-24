Trait {
	#name : 'OPTColoredAsFillAndBorderColoredAsStroke',
	#traits : 'OPTColoredAsFill + OPTBorderColoredAsStroke',
	#classTraits : 'OPTColoredAsFill classTrait + OPTBorderColoredAsStroke classTrait',
	#category : 'OpenPonk-Core-Shapes',
	#package : 'OpenPonk-Core',
	#tag : 'Shapes'
}

{ #category : 'initialization' }
OPTColoredAsFillAndBorderColoredAsStroke >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self updateColorFromStyles.
	self updateBorderColorFromStyles.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]
