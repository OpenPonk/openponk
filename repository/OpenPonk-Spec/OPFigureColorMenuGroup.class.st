Class {
	#name : #OPFigureColorMenuGroup,
	#superclass : #CmdMenuGroup,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPFigureColorMenuGroup class >> colors [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPFigureColorMenuGroup class >> generateAllColorCommands [

	<script>
	self allSubclassesDo: #generateColorCommands
]

{ #category : #'as yet unclassified' }
OPFigureColorMenuGroup class >> generateColorCommands [

	| niceAttributeName superclassName |
	niceAttributeName := self styleAttribute capitalized.
	superclassName := ('OPDiagramFigure' , niceAttributeName , 'Command')
		                  asSymbol.

	self colors do: [ :each |
		| colorName niceColorName className class |
		colorName := each name.
		niceColorName := each name capitalized splitOnCapitals last.
		className := ('OPDiagramFigure' , niceColorName , niceAttributeName
		              , 'Command') asSymbol.

		(Smalltalk at: superclassName asSymbol)
			subclass: className
			instanceVariableNames: ''
			classVariableNames: ''
			package: 'OpenPonk-Spec-Diagram-Figure-Commands'.

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

{ #category : #'as yet unclassified' }
OPFigureColorMenuGroup class >> styleAttribute [

	^ self subclassResponsibility
]
