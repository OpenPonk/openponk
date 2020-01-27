Class {
	#name : #OPGLMCherryPickTreeDataSource,
	#superclass : #GLMCherryPickTreeDataSource,
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #'as yet unclassified' }
OPGLMCherryPickTreeDataSource >> itemsDataWithChildData: itemData [
	^ self rootItem children
		flatCollectAsSet: [ :each | self itemsDataWithChildData: itemData startingAt: each ]
]

{ #category : #'as yet unclassified' }
OPGLMCherryPickTreeDataSource >> itemsDataWithChildData: itemData startingAt: item [
	| parentsOfItem |
	item data = itemData
		ifTrue: [ ^ {item data} ].
	parentsOfItem := item children
		flatCollect: [ :each | self itemsDataWithChildData: itemData startingAt: each ].
	^ parentsOfItem ifNotEmpty: [ parentsOfItem , {item data} ]
]

{ #category : #private }
OPGLMCherryPickTreeDataSource >> toggleSelectionOf: item [
	(self isSelected: item data)
		ifTrue: [ self deselectAllChildrenOf: item ]
		ifFalse: [ selection add: item data.
			selection addAll: (self itemsDataWithChildData: item data) ].
	self glamourPresentation cherryPick: selection.
	self tableRefresh
]
