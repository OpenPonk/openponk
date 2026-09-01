"
Workbench toolbar command that initializes a new, empty domain model (of a user-selected metamodel or notation) within the current project.
"
Class {
	#name : 'OPProjectNewModelCommand',
	#superclass : 'OPProjectCommand',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'activation' }
OPProjectNewModelCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectModelsMenuGroup order: 20 for: OPWorkbenchToolbar
]

{ #category : 'accessing' }
OPProjectNewModelCommand >> defaultMenuIconName [

	^ #glamorousAdd
]

{ #category : 'accessing' }
OPProjectNewModelCommand >> defaultMenuItemName [
	^ 'New model...'
]

{ #category : 'execution' }
OPProjectNewModelCommand >> execute [

	OPPluginRegistry default plugins ifEmpty: [
			^ GrowlMorph
				  openWithLabel: 'OpenPonk: No plugins'
				  contents:
				  'Cannot add a model unless there is at least one OpenPonk plugin loaded'
				  backgroundColor: GrowlMorph theme dangerBackgroundColor
				  labelColor: GrowlMorph theme textColorForNonStandardBackground ].
	(OPModelTypeSelector
		 newApplication: SpApplication defaultApplication
		 model: projectController) open
]
