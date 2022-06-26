Class {
	#name : #OPProjectNewModelCommand,
	#superclass : #OPProjectCommand,
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #activation }
OPProjectNewModelCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectModelsMenuGroup order: 20 for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPProjectNewModelCommand >> defaultMenuIcon [
	^ self iconNamed: #glamorousAdd
]

{ #category : #accessing }
OPProjectNewModelCommand >> defaultMenuItemName [
	^ 'New model...'
]

{ #category : #execution }
OPProjectNewModelCommand >> execute [

	OPPluginRegistry default plugins ifEmpty: [ 
		^ GrowlMorph
			  openWithLabel: 'OpenPonk: No plugins'
			  contents:
			  'Cannot add a model unless there is at least one OpenPonk plugin loaded'
			  backgroundColor: GrowlMorph theme warningBackgroundColor
			  labelColor: GrowlMorph theme textColor ].
	(OPModelTypeSelector
		 newApplication: SpApplication defaultApplication
		 model: projectController) open
]
