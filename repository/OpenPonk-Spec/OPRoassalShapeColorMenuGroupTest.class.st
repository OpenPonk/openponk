"
Verifies color palette definitions, custom color name mappings, and command availability in diagram figure color menu groups.
"
Class {
	#name : 'OPRoassalShapeColorMenuGroupTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPRoassalShapeColorMenuGroupTest >> testCustomColorNamesMapping [
	| mapping |
	mapping := OPRoassalShapeColorMenuGroup customColorNames.
	self assert: (mapping at: 'DCE5EC' ifAbsent: [ nil ]) equals: 'Slate'.
	self assert: (mapping at: 'D6FCEB' ifAbsent: [ nil ]) equals: 'Mint'
]

{ #category : 'tests' }
OPRoassalShapeColorMenuGroupTest >> testFillColorMenuGroupIncludesSlateAndMint [
	| colors hexCodes |
	colors := OPRoassalShapeFillColorMenuGroup colors.
	hexCodes := colors collect: [ :each | each asHexString asUppercase ].
	self assert: (hexCodes includes: 'DCE5EC').
	self assert: (hexCodes includes: 'D6FCEB')
]

{ #category : 'tests' }
OPRoassalShapeColorMenuGroupTest >> testSlateAndMintCommandsExist [
	| subclasses colors |
	subclasses := OPDiagramFigureFillColorCommand subclasses.
	colors := subclasses collect: [ :each | each color asHexString asUppercase ].
	self assert: (colors includes: 'DCE5EC').
	self assert: (colors includes: 'D6FCEB')
]
