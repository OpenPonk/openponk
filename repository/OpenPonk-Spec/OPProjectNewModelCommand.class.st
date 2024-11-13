Class {
	#name : 'OPProjectNewModelCommand',
	#superclass : 'OPProjectCommand',
	#category : 'OpenPonk-Spec-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands'
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
			  backgroundColor: GrowlMorph theme dangerBackgroundColor ].
	(OPModelTypeSelector
		 newApplication: SpApplication defaultApplication
		 model: projectController) open
]
