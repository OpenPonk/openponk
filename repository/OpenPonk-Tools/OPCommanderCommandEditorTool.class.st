Class {
	#name : #OPCommanderCommandEditorTool,
	#superclass : #ClyBrowserTool,
	#instVars : [
		'commandClass'
	],
	#category : #'OpenPonk-Tools'
}

{ #category : #testing }
OPCommanderCommandEditorTool class >> classTabActivation [
	<classAnnotation>
	
	^ClyTabActivationStrategy for: ClyClass asCalypsoItemContext
]

{ #category : #asserting }
OPCommanderCommandEditorTool class >> shouldBeActivatedInContext: aBrowserContext [
	| item |
	aBrowserContext isClassSelected
		ifFalse: [ ^ false ].
	item := aBrowserContext selectedClassItems anyOne browserItem actualObject.
	^ item isKindOf: CmdCommand class
]

{ #category : #accessing }
OPCommanderCommandEditorTool class >> tabOrder [
	^ 11
]

{ #category : #initialization }
OPCommanderCommandEditorTool >> build [
	| composite presentation morph desc |
	composite := GLMCompositePresentation new.
	desc := OPCommanderCommandDescription new commandClass: commandClass.
	presentation := composite magritte
		display: [ desc ];
		yourself.
	morph := GLMMorphicRenderer new render: presentation.
	morph hResizing: #spaceFill.
	morph vResizing: #spaceFill.
	self addMorph: morph
]

{ #category : #accessing }
OPCommanderCommandEditorTool >> commandClass [
	^ commandClass
]

{ #category : #initialization }
OPCommanderCommandEditorTool >> defaultIconName [
	^ #glamorousTable
]

{ #category : #initialization }
OPCommanderCommandEditorTool >> defaultTitle [
	^ 'Command Info'
]

{ #category : #testing }
OPCommanderCommandEditorTool >> isSimilarTo: anotherBrowserTool [
	(super isSimilarTo: anotherBrowserTool)
		ifFalse: [ ^ false ].
	^ commandClass = anotherBrowserTool commandClass
]

{ #category : #initialization }
OPCommanderCommandEditorTool >> setUpModelFromContext [
	super setUpModelFromContext.

	commandClass := context lastSelectedClass
]
