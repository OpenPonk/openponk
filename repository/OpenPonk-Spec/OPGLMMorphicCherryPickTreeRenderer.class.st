Class {
	#name : #OPGLMMorphicCherryPickTreeRenderer,
	#superclass : #GLMMorphicCherryPickTreeRenderer,
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #initialization }
OPGLMMorphicCherryPickTreeRenderer >> createDataSourceFrom: aPresentation [
	^ OPGLMCherryPickTreeDataSource new
]

{ #category : #initialization }
OPGLMMorphicCherryPickTreeRenderer >> specificTableMorphInitializiation [
	super specificTableMorphInitializiation.
	tableModel glamourPresentation initialPick
		ifNotEmpty: [ :pick | tableModel selected: pick ]
]
