"
Verifies color palette definitions, custom color name mappings, and command availability in diagram figure color menu groups.
"
Class {
	#name : 'OPRoassalShapeColorMenuGroupTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Commands-RoassalShape',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Commands-RoassalShape'
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
	self assertCollection: hexCodes includesAll: { 'DCE5EC' }.
	self assertCollection: hexCodes includesAll: { 'D6FCEB' }
]

{ #category : 'tests' }
OPRoassalShapeColorMenuGroupTest >> testMenuGroupSuperclassesAttributesAndErrorOnUnknownHex [
	self assert: OPRoassalShapeFillColorMenuGroup commandSuperclass identicalTo: OPDiagramFigureFillColorCommand.
	self assert: OPRoassalShapeFillColorMenuGroup styleAttribute equals: #fillColor.
	self assert: OPRoassalShapeStrokeColorMenuGroup commandSuperclass identicalTo: OPDiagramFigureStrokeColorCommand.
	self assert: OPRoassalShapeStrokeColorMenuGroup styleAttribute equals: #strokeColor.
	self assert: OPRoassalShapeFontColorMenuGroup commandSuperclass identicalTo: OPDiagramFigureFontColorCommand.
	self assert: OPRoassalShapeFontColorMenuGroup styleAttribute equals: #fontColor.
	self assert: (OPRoassalShapeColorMenuGroup colorNameFor: Color red) equals: 'Red'.
	self should: [ OPRoassalShapeColorMenuGroup colorNameFor: (Color fromHexString: '123456') ] raise: Error
]

{ #category : 'tests' }
OPRoassalShapeColorMenuGroupTest >> testSlateAndMintCommandsExist [

	| subclasses colors |
	subclasses := OPDiagramFigureFillColorCommand subclasses.
	colors := subclasses collect: [ :each | each color asHexString asUppercase ].
	self assertCollection: colors includesAll: { 'DCE5EC' }.
	self assertCollection: colors includesAll: { 'D6FCEB' }
]
