Extension { #name : 'OPAbstractElementControllerTest' }

{ #category : '*OpenPonk-Spec-Tests' }
OPAbstractElementControllerTest >> labelsLeakingMultiLineSentinel: aSentinel [

	^ diagramController canvas allChildren select: [ :shape | self shape: shape leaksMultiLineSentinel: aSentinel ]
]

{ #category : '*OpenPonk-Spec-Tests' }
OPAbstractElementControllerTest >> multiLineLeakDescriptionForPresenter: aPresenter labels: aCollection [

	^ String streamContents: [ :stream |
			  stream << 'Inconsistency in controller '.
			  stream << controller className.
			  stream << ': form field ('.
			  stream << aPresenter className.
			  stream << ') propagates multiline text directly to single-line '.
			  stream << aCollection first className.
			  stream << ' in diagram element '.
			  stream << controller diagramElement className.
			  stream << '. Cairo cannot wrap this text and renders tofu glyphs.' ]
]

{ #category : '*OpenPonk-Spec-Tests' }
OPAbstractElementControllerTest >> shape: aShape leaksMultiLineSentinel: aSentinel [

	| text |
	(aShape isKindOf: RSLabel) ifFalse: [ ^ false ].
	text := aShape text.
	text ifNil: [ ^ false ].
	(text includesSubstring: aSentinel) ifTrue: [ ^ true ].
	(text includesSubstring: 'TEST_L1_') ifFalse: [ ^ false ].
	^ (text includes: Character cr) or: [ text includes: Character lf ]
]

{ #category : '*OpenPonk-Spec-Tests' }
OPAbstractElementControllerTest >> testMultiLineFormFieldsProperlyWrapInDiagramShapes [

	| form multiLinePresenters |
	self showInDiagram.

	form := OPPropertiesForm new.
	[
		form viewModel: controller viewModel.
		multiLinePresenters := form focusOrder select: [ :presenter | presenter isKindOf: SpTextPresenter ].
		multiLinePresenters do: [ :presenter | self verifyMultiLineWrapForFormPresenter: presenter ] ] ensure: [ form viewModel: nil ]
]

{ #category : '*OpenPonk-Spec-Tests' }
OPAbstractElementControllerTest >> verifyMultiLineWrapForFormPresenter: aPresenter [

	| originalText sentinel labelsWithNewline |
	originalText := aPresenter text ifNil: [ '' ] ifNotNil: [ :text | text asString ].
	sentinel := String streamContents: [ :stream |
			            stream << 'TEST_L1_'.
			            stream << UUID new asString.
			            stream cr.
			            stream << 'TEST_L2' ].

	aPresenter text: sentinel.
	controller modelChanged.

	labelsWithNewline := self labelsLeakingMultiLineSentinel: sentinel.
	self
		assert: labelsWithNewline isEmpty
		description: [ self multiLineLeakDescriptionForPresenter: aPresenter labels: labelsWithNewline ].

	aPresenter text: originalText.
	controller modelChanged
]
