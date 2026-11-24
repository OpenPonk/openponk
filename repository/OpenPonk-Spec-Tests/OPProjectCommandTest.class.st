"
Verifies workbench project commands, Commander menu activations, and Commander-to-Spec root menu building.
"
Class {
	#name : 'OPProjectCommandTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Commands-Workbench',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Commands-Workbench'
}

{ #category : 'tests' }
OPProjectCommandTest >> testCommanderRootMenuGroupBuildSpecMenuWithDirectCommandItems [

	| menu rootGroup activeActivator inactiveActivator activeItem inactiveItem |
	menu := SpMenuPresenter new.
	self should: [ CmdMenuItem new buildSpecMenuOn: menu ] raise: SubclassResponsibility.

	activeActivator := Mock new.
	activeActivator stub canExecuteCommand willReturn: true.
	(activeActivator stub buildSpecMenuOn: Any) will: [ :group | group addItem: [ :item | item name: 'Direct Action' ] ].
	inactiveActivator := Mock new.
	inactiveActivator stub canExecuteCommand willReturn: false.

	activeItem := CmdCommandMenuItem new
		              activator: activeActivator;
		              yourself.
	inactiveItem := CmdCommandMenuItem new
		                activator: inactiveActivator;
		                yourself.

	rootGroup := CmdRootMenuGroup new.
	rootGroup addItem: activeItem.
	rootGroup addItem: inactiveItem.
	rootGroup buildSpecMenuOn: menu.

	self assert: menu menuGroups size equals: 1.
	self assert: menu menuGroups first menuItems size equals: 1.
	self assert: menu menuGroups first menuItems first name equals: 'Direct Action'
]

{ #category : 'tests' }
OPProjectCommandTest >> testProjectCommandActivations [

	self assert: OPProjectCommand toolbarMenuActivation class identicalTo: OPWorkbenchActivation.
	self assert: OPProjectExitCommand toolbarMenuActivation class identicalTo: OPWorkbenchActivation.
	self assert: OPProjectMergeCommand toolbarMenuActivation class identicalTo: OPWorkbenchActivation.
	self assert: OPProjectMergeModelsCommand toolbarMenuActivation class identicalTo: OPWorkbenchActivation.
	self assert: OPProjectNewModelCommand toolbarMenuActivation class identicalTo: OPWorkbenchActivation.
	self assert: OPProjectOpenCommand toolbarMenuActivation class identicalTo: OPWorkbenchActivation.
	self assert: OPProjectRenameCommand toolbarMenuActivation class identicalTo: OPWorkbenchActivation.
	self assert: OPProjectSaveAsCommand toolbarMenuActivation class identicalTo: OPWorkbenchActivation.
	self assert: OPProjectSaveCommand toolbarMenuActivation class identicalTo: OPWorkbenchActivation.
	self assert: OPProjectSaveCommand toolbarShortcutActivation keyCombination equals: $s meta
]

{ #category : 'tests' }
OPProjectCommandTest >> testProjectCommandsExecuteDelegations [

	| projectControllerStub workbenchStub toolbarStub exitCommand mergeCommand mergeModelsCommand renameCommand saveAsCommand saveCommand |
	projectControllerStub := Mock new.
	projectControllerStub stub mergeFromFile willReturn: nil.
	projectControllerStub stub mergeModelsAndDiagramsIntoOne willReturn: nil.
	projectControllerStub stub saveProject willReturn: nil.
	projectControllerStub stub saveProjectAs willReturn: nil.

	workbenchStub := Mock new.
	workbenchStub stub close willReturn: nil.
	workbenchStub stub renameProject willReturn: nil.

	toolbarStub := Mock new.
	toolbarStub stub projectController willReturn: projectControllerStub.
	toolbarStub stub workbench willReturn: workbenchStub.

	exitCommand := OPProjectExitCommand new.
	exitCommand prepareFullExecutionInContext: toolbarStub.
	exitCommand execute.
	workbenchStub should receive close.

	mergeCommand := OPProjectMergeCommand new.
	mergeCommand prepareFullExecutionInContext: toolbarStub.
	mergeCommand execute.
	projectControllerStub should receive mergeFromFile.

	mergeModelsCommand := OPProjectMergeModelsCommand new.
	mergeModelsCommand prepareFullExecutionInContext: toolbarStub.
	mergeModelsCommand execute.
	projectControllerStub should receive mergeModelsAndDiagramsIntoOne.

	renameCommand := OPProjectRenameCommand new.
	renameCommand prepareFullExecutionInContext: toolbarStub.
	renameCommand execute.
	workbenchStub should receive renameProject.

	saveAsCommand := OPProjectSaveAsCommand new.
	saveAsCommand prepareFullExecutionInContext: toolbarStub.
	saveAsCommand execute.
	projectControllerStub should receive saveProjectAs.

	saveCommand := OPProjectSaveCommand new.
	saveCommand prepareFullExecutionInContext: toolbarStub.
	saveCommand execute.
	projectControllerStub should receive saveProject.

	OPProjectController stub openFromFile willReturn: nil.
	[
		OPProjectOpenCommand new execute.
		OPProjectController should receive openFromFile ] ensure: [ OPProjectController recoverFromGHMutation ]
]

{ #category : 'tests' }
OPProjectCommandTest >> testProjectMergeModelsCommandCanBeExecutedInContext [

	| toolbarStub workbenchStub pluginRegistryStub pluginStub |
	toolbarStub := Mock new.
	toolbarStub stub workbench willReturn: nil.
	self
		deny: (OPProjectMergeModelsCommand canBeExecutedInContext: toolbarStub)
		description: 'Merge models command must not be executable when workbench is nil'.

	workbenchStub := Mock new.
	workbenchStub stub pluginRegistry willReturn: nil.
	toolbarStub stub workbench willReturn: workbenchStub.
	self
		deny: (OPProjectMergeModelsCommand canBeExecutedInContext: toolbarStub)
		description: 'Merge models command must not be executable when pluginRegistry is nil'.

	pluginStub := Mock new.
	pluginStub stub supportsMergingModels willReturn: false.
	pluginRegistryStub := Mock new.
	pluginRegistryStub stub plugins willReturn: { pluginStub }.
	workbenchStub stub pluginRegistry willReturn: pluginRegistryStub.
	self
		deny: (OPProjectMergeModelsCommand canBeExecutedInContext: toolbarStub)
		description: 'Merge models command must not be executable when no plugin supports merging models'.

	pluginStub stub supportsMergingModels willReturn: true.
	self
		assert: (OPProjectMergeModelsCommand canBeExecutedInContext: toolbarStub)
		description: 'Merge models command should be executable when a plugin supports merging models'
]

{ #category : 'tests' }
OPProjectCommandTest >> testProjectNewModelCommandExecuteWithEmptyPluginRegistryShowsGrowl [

	| existingGrowls toolbarStub command openedGrowls |
	existingGrowls := (self currentWorld submorphs select: [ :each | each isKindOf: GrowlMorph ]) asIdentitySet.
	toolbarStub := Mock new.
	toolbarStub stub projectController willReturn: nil.
	toolbarStub stub workbench willReturn: nil.
	command := OPProjectNewModelCommand new.
	command prepareFullExecutionInContext: toolbarStub.

	[
		OPPluginRegistry setDefault: OPPluginRegistry new.
		command execute.
		openedGrowls := self currentWorld submorphs select: [ :each |
			                (each isKindOf: GrowlMorph) and: [ (existingGrowls includes: each) not ] ].
		self denyEmpty: openedGrowls ] ensure: [
			OPPluginRegistry resetDefault.
			self currentWorld submorphs do: [ :each |
				((each isKindOf: GrowlMorph) and: [ (existingGrowls includes: each) not ]) ifTrue: [ each delete ] ] ]
]

{ #category : 'tests' }
OPProjectCommandTest >> testProjectNewModelCommandExecuteWithLoadedPluginOpensSelector [

	| existingWindows projectController toolbarStub command openedWindows |
	existingWindows := (self currentWorld submorphs select: [ :each | each isSystemWindow ]) asIdentitySet.
	projectController := OPProjectController forProject: (OPProject named: 'Test Project').
	toolbarStub := Mock new.
	toolbarStub stub projectController willReturn: projectController.
	toolbarStub stub workbench willReturn: nil.
	command := OPProjectNewModelCommand new.
	command prepareFullExecutionInContext: toolbarStub.

	[
		OPPluginRegistry setDefault: (OPPluginRegistry new
				 add: OPTestPlugin new;
				 yourself).
		command execute.
		openedWindows := self currentWorld submorphs select: [ :each |
			                 each isSystemWindow and: [ (existingWindows includes: each) not ] ].
		self denyEmpty: openedWindows ] ensure: [
			OPPluginRegistry resetDefault.
			self currentWorld submorphs do: [ :each |
				(each isSystemWindow and: [ (existingWindows includes: each) not ]) ifTrue: [ each delete ] ] ]
]
