Class {
	#name : 'OPProjectMergeModelsCommand',
	#superclass : 'OPProjectCommand',
	#category : 'OpenPonk-Spec-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands'
}

{ #category : 'testing' }
OPProjectMergeModelsCommand class >> canBeExecutedInContext: aToolContext [

	| workbench pluginRegistry |
	workbench := aToolContext workbench.
	workbench ifNil: [ ^ false ].
	pluginRegistry := workbench pluginRegistry.
	pluginRegistry ifNil: [ ^ false ].
	^ pluginRegistry plugins anySatisfy: [ :any | 
		  any supportsMergingModels ]
]

{ #category : 'activation' }
OPProjectMergeModelsCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectModelsMenuGroup order: 40 for: OPWorkbenchToolbar
]

{ #category : 'accessing' }
OPProjectMergeModelsCommand >> defaultMenuIconName [

	^ #hierarchy
]

{ #category : 'accessing' }
OPProjectMergeModelsCommand >> defaultMenuItemName [
	^ 'Merge all models/diagrams'
]

{ #category : 'execution' }
OPProjectMergeModelsCommand >> execute [

	projectController mergeModelsAndDiagramsIntoOne
]
