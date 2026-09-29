"
Commander menu group that dynamically generates color selection commands for context menus based on predefined palettes or current shape styles.
"
Class {
	#name : 'OPRoassalShapeColorMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'hooks' }
OPRoassalShapeColorMenuGroup class >> colors [

	^ self subclassResponsibility
]

{ #category : 'actions' }
OPRoassalShapeColorMenuGroup class >> generateAllColorCommands [

	<script>
	self allSubclassesDo: #generateColorCommands
]

{ #category : 'actions' }
OPRoassalShapeColorMenuGroup class >> generateColorCommands [

	| niceAttributeName superclassName |
	niceAttributeName := self styleAttribute capitalized.
	superclassName := ('OPDiagramFigure' , niceAttributeName , 'Command')
		                  asSymbol.

	self colors do: [ :each |
			| colorName niceColorName className class |
			colorName := each name.
			niceColorName := each name capitalized splitCamelCase last.
			className := ('OPDiagramFigure' , niceColorName , niceAttributeName
			              , 'Command') asSymbol.

			((Smalltalk at: superclassName asSymbol) << #className)
				package: 'OpenPonk-Spec';
				tag: 'Diagram-Figure-Commands';
				install.

			class := Smalltalk at: className.

			class compile: 'color

	^ Color ' , colorName.

			class compile: 'defaultMenuItemName

	^ ''' , niceColorName , ''''.

			each = Color transparent ifTrue: [
					class compile: 'defaultMenuIcon

	^ Morph new 
				color: Color white;
				asFormOfSize: 30@20' ] ]
]

{ #category : 'hooks' }
OPRoassalShapeColorMenuGroup class >> styleAttribute [

	^ self subclassResponsibility
]
