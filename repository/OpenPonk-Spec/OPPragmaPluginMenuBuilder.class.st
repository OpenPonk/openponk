Class {
	#name : #OPPragmaPluginMenuBuilder,
	#superclass : #PragmaMenuBuilder,
	#instVars : [
		'testBlock'
	],
	#category : #'OpenPonk-Spec-Utils'
}

{ #category : #'registrations handling' }
OPPragmaPluginMenuBuilder >> collectRegistrations [

	"Retrieve all pragma methods and evaluate them by passing the 
	MenuRegistration class as argument. The result is a list of trees
	stored in my itemList inst var"

	| menu |
	menu := PragmaMenuAndShortcutRegistration model: self model.
	self pragmas
		select: [ :each | self hasCorrectArguments: each ]
		thenDo: [ :prg | 
			self
				currentRoot: self
				while: [ 
				prg methodClass instanceSide
					perform: prg methodSelector
					with: menu ] ].
	self interpretRegistration: menu
]

{ #category : #testing }
OPPragmaPluginMenuBuilder >> hasCorrectArguments: aPragma [
	^ aPragma numArgs = 0 or: [ testBlock value: aPragma ]
]

{ #category : #accessing }
OPPragmaPluginMenuBuilder >> model: anObject [

	super model: anObject.
	testBlock := self testBlockFor: anObject
]

{ #category : #accessing }
OPPragmaPluginMenuBuilder >> testBlockFor: aModel [

	| blocks |
	blocks := Dictionary
		          with: OPCanvasPresenter -> [ :prg | 
			          aModel editor plugin class withAllSuperclasses 
				          anySatisfy: [ :any | any name = prg arguments first ] ]
		          with: OPEditor -> [ :prg | 
			          aModel plugin class withAllSuperclasses anySatisfy: [ 
				          :any | any name = prg arguments first ] ]
		          with: OPWorkbenchToolbar -> [ :prg | 
			          prg arguments first
			          = aModel projectController project className ]
		          with: OPProjectNavigator -> [ :prg | 
			          prg arguments first
			          = aModel projectController project className ].
	^ blocks at: aModel class
]
