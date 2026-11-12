Extension { #name : 'OPAbstractElementControllerTest' }

{ #category : '*OpenPonk-Spec-Tests' }
OPAbstractElementControllerTest >> testMultiLineFormFieldsProperlyWrapInDiagramShapes [

	| form multiLinePresenters |
	self showInDiagram.

	form := OPPropertiesForm new.
	[
		form viewModel: controller viewModel.

		multiLinePresenters := form focusOrder select: [ :presenter |
			                       (presenter isKindOf: SpTextPresenter) or: [ presenter isKindOf: OPLongTextPresenter ] ].

		multiLinePresenters do: [ :presenter |
				| originalText sentinel labelsWithNewline |
				originalText := presenter text ifNil: [ '' ] ifNotNil: [ :text | text asString ].
				sentinel := 'TEST_L1_' , UUID new asString , String cr , 'TEST_L2'.

				presenter text: sentinel.
				controller modelChanged.

				labelsWithNewline := diagramController canvas allChildren select: [ :shape |
						                     (shape isKindOf: RSLabel) and: [
								                     shape text notNil and: [
										                     (shape text includesSubstring: sentinel) or: [
											                     (shape text includesSubstring: 'TEST_L1_') and: [
												                     (shape text includes: Character cr) or: [ shape text includes: Character lf ] ] ] ] ] ].

				self assert: labelsWithNewline isEmpty description: [
						String streamContents: [ :stream |
								stream
									nextPutAll: 'Inconsistency in controller ';
									nextPutAll: controller className;
									nextPutAll: ': form field (';
									nextPutAll: presenter className;
									nextPutAll: ') propagates multiline text directly to single-line ';
									nextPutAll: labelsWithNewline first className;
									nextPutAll: ' in diagram element ';
									nextPutAll: controller diagramElement className;
									nextPutAll: '. Cairo cannot wrap this text and renders tofu glyphs.' ] ].

				presenter text: originalText.
				controller modelChanged ] ] ensure: [ form viewModel: nil ]
]

{ #category : '*OpenPonk-Spec-Tests' }
OPAbstractElementControllerTest >> testOpenInForm [

	| form |
	self showInDiagram.
	form := OPPropertiesForm new.
	diagramController stub form willReturn: form.
	self assertEmpty: form layout children.
	diagramController openInForm: controller viewModel.
	self denyEmpty: form layout children
]
