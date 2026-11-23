"
I represent an undoable command that restores or adds a visual element for an existing domain model into a diagram.
"
Class {
	#name : 'OPShowDiagramElementCommand',
	#superclass : 'OPDiagramElementVisibilityCommand',
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'executing' }
OPShowDiagramElementCommand >> execute [

	descriptors
		ifEmpty: [
				self openDiagramController ifNotNil: [ :openDiagramController |
						| createdController |
						createdController := openDiagramController showWithoutDependentInDiagramModel: model.
						createdController ifNotNil: [
								createdController diagramElement ifExists: [ :createdDiagramElement |
									descriptors add: (self createDescriptorFor: createdDiagramElement) ] ].
						openDiagramController updateCanvas ] ]
		ifNotEmpty: [
				self restoreDiagramElements.
				self reRenderInDiagram ]
]

{ #category : 'executing' }
OPShowDiagramElementCommand >> undo [
	self openDiagramController ifNotNil: [ :openDiagramController |
		openDiagramController hideModelFromDiagram: model ]
]
