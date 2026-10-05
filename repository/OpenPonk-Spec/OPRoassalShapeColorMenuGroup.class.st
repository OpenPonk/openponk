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

{ #category : 'accessing' }
OPRoassalShapeColorMenuGroup class >> colorNameFor: aColor [
	aColor name = #unnamed ifFalse: [
		^ aColor name capitalized splitCamelCase last ].
	^ self customColorNames
		at: aColor asHexString asUppercase
		ifAbsent: [ self error: 'No color name defined for: #' , aColor asHexString ]
]

{ #category : 'hooks' }
OPRoassalShapeColorMenuGroup class >> colors [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPRoassalShapeColorMenuGroup class >> commandSuperclass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPRoassalShapeColorMenuGroup class >> customColorNames [
	^ Dictionary new
		at: 'DCE5EC' put: 'Slate';
		at: 'D6FCEB' put: 'Mint';
		yourself
]

{ #category : 'actions' }
OPRoassalShapeColorMenuGroup class >> generateAllColorCommands [

	<script>
	self allSubclassesDo: #generateColorCommands
]

{ #category : 'generation' }
OPRoassalShapeColorMenuGroup class >> generateColorCommands [
	| niceAttributeName |
	niceAttributeName := self styleAttribute capitalized.

	self colors do: [ :each |
		| niceColorName className commandClass |
		niceColorName := self colorNameFor: each.
		className := ('OPDiagramFigure' , niceColorName , niceAttributeName , 'Command') asSymbol.

		commandClass := (self commandSuperclass << className)
			slots: {};
			package: 'OpenPonk-Spec';
			tag: 'Commands-RoassalShape';
			install.

		commandClass comment: 'A canvas command for applying ' , niceColorName asLowercase , ' ' , self styleAttribute , ' to selected diagram elements.'.

		commandClass class compile: (String streamContents: [ :stream |
			stream << 'color'; cr; cr.
			stream << '	^ '.
			each name = #unnamed
				ifTrue: [ stream << '(Color fromHexString: ''' << each asHexString asUppercase << ''')' ]
				ifFalse: [ stream << 'Color ' << each name ] ])
			classified: 'accessing'.

		each name = #unnamed ifTrue: [
			commandClass compile: (String streamContents: [ :stream |
				stream << 'colorName'; cr; cr.
				stream << '	^ ''' << niceColorName << '''' ])
				classified: 'accessing' ].

		each = Color transparent ifTrue: [
			commandClass compile: 'defaultMenuIcon
	^ Morph new
		color: Color white;
		asFormOfSize: 30@20'
				classified: 'accessing' ] ]
]

{ #category : 'hooks' }
OPRoassalShapeColorMenuGroup class >> styleAttribute [

	^ self subclassResponsibility
]
