Class {
	#name : #OPGLMCherryPickTreeDataSource,
	#superclass : #GLMCherryPickTreeDataSource,
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #private }
OPGLMCherryPickTreeDataSource >> toggleSelectionOf: item [
	^ super toggleSelectionOf: item
	"	(self isSelected: item data)
		ifTrue: [ self deselectAllChildrenOf: item ]
		ifFalse: [ selection add: item data.
			selection addAll: (self glamourPresentation selectionCascade value: item data) ].
	self glamourPresentation cherryPick: selection.
	self tableRefresh"
]
