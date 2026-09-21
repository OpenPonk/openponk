"
I represent an undoable command that hides a visual element and its connected edges from a diagram while preserving the underlying domain model.
"
Class {
	#name : 'OPHideDiagramElementCommand',
	#superclass : 'OPDiagramElementVisibilityCommand',
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'execution' }
OPHideDiagramElementCommand >> captureStateWith: aDiagramController [
	| targetController affectedControllers queue sortedControllers |
	targetController := aDiagramController controllerForModel: model ifNone: [ ^ self ].
	targetController diagramElement ifNil: [ ^ self ].

	affectedControllers := Set new.
	affectedControllers add: targetController.
	queue := OrderedCollection with: targetController.

	[ queue isNotEmpty ] whileTrue: [
		| currentController currentDiagramElement |
		currentController := queue removeFirst.
		currentDiagramElement := currentController diagramElement.

		currentController dependentControllers do: [ :eachDependentController |
			(affectedControllers includes: eachDependentController) ifFalse: [
				affectedControllers add: eachDependentController.
				queue add: eachDependentController ] ].

		currentDiagramElement ifNotNil: [
			aDiagramController controllers do: [ :eachController |
				| eachDiagramElement |
				eachDiagramElement := eachController diagramElement.
				(eachDiagramElement isNotNil and: [
					eachDiagramElement isEdge and: [
						eachDiagramElement source == currentDiagramElement or: [ eachDiagramElement target == currentDiagramElement ] ] ])
					ifTrue: [
						(affectedControllers includes: eachController) ifFalse: [
							affectedControllers add: eachController.
							queue add: eachController ] ] ] ] ].

	sortedControllers := affectedControllers asArray sorted: [ :firstController :secondController |
		(aDiagramController viewModelRegistry viewModelFor: firstController model) creationPriority
			<= (aDiagramController viewModelRegistry viewModelFor: secondController model) creationPriority ].

	sortedControllers do: [ :eachController |
		eachController diagramElement ifNotNil: [ :eachDiagramElement |
			descriptors add: (self createDescriptorFor: eachDiagramElement) ] ]
]

{ #category : 'executing' }
OPHideDiagramElementCommand >> execute [
	self openDiagramController ifNotNil: [ :openDiagramController |
		openDiagramController hideModelFromDiagram: model ]
]

{ #category : 'initialization' }
OPHideDiagramElementCommand >> setModel: aModel diagramController: aDiagramController [
	super setModel: aModel diagramController: aDiagramController.
	self captureStateWith: aDiagramController
]

{ #category : 'executing' }
OPHideDiagramElementCommand >> undo [
	self restoreDiagramElements.
	self reRenderInDiagram
]
