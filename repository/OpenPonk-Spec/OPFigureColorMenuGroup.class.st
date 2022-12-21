Class {
	#name : #OPFigureColorMenuGroup,
	#superclass : #CmdMenuGroup,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPFigureColorMenuGroup class >> generateColorCommands [

	<script>
	| colors |
	colors := { 
		          Color transparent.
		          Color veryVeryLightGray.
		          Color white } , ({ 
		           Color paleYellow.
		           Color paleBlue.
		           Color paleRed.
		           Color paleOrange.
		           Color paleGreen.
		           Color paleMagenta } sortedAs: #hue).



	colors do: [ :each | 
		| colorName className class niceColorName |
		colorName := each name.
		niceColorName := String streamContents: [ :s | 
			                 colorName capitalized splitOnCapitals
				                 asStringOn: s
				                 delimiter: ' ' ].
		className := ('OPDiagramFigure' , colorName capitalized
		              , 'ColorCommand') asSymbol.

		OPDiagramFigureColorCommand
			subclass: className
			instanceVariableNames: ''
			classVariableNames: ''
			package: 'OpenPonk-Spec-Diagram-Figure-Commands'.

		class := Smalltalk at: className.

		class compile: 'defaultMenuIcon

	^ Morph new 
				color: Color ' , colorName , ';
				asFormOfSize: 30@20'.

		class compile: 'defaultMenuItemName

	^ ''' , niceColorName , ''''.

		class compile: 'execute
	
	controllers do: [ :each | each diagramElement stylePropertyNamed: #fillColor
		put: Color ' , colorName , ' ]' ].

	(Smalltalk at: #OPDiagramFigureTransparentColorCommand) compile:
		'defaultMenuIcon

	^ Morph new 
				color: Color white;
				asFormOfSize: 30@20'
]

{ #category : #accessing }
OPFigureColorMenuGroup >> name [
	^ 'Color'
]
