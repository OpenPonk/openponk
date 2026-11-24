"
Verifies OpenPonk Spec application backend validation, startup entry point, icon resolution, and project opening convenience helpers.
"
Class {
	#name : 'OPApplicationTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Application',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Application'
}

{ #category : 'tests' }
OPApplicationTest >> testIconProviderResolvesStandardOpenPonkNilAndAbsentIcons [

	| provider standardIcon openPonkIcon absentSentinel |
	provider := OPIconProvider new.
	absentSentinel := Object new.

	self assert: (provider iconNamed: nil ifAbsent: [ absentSentinel ]) identicalTo: absentSentinel.

	standardIcon := provider iconNamed: #glamorousInspect ifAbsent: [ absentSentinel ].
	self deny: standardIcon identicalTo: absentSentinel.

	openPonkIcon := provider iconNamed: #openponkIcon ifAbsent: [ absentSentinel ].
	self assert: openPonkIcon class identicalTo: Form.

	self assert: (provider iconNamed: #nonExistentOpenPonkIconXYZ ifAbsent: [ absentSentinel ]) identicalTo: absentSentinel
]

{ #category : 'tests' }
OPApplicationTest >> testOpenProjectOnModelOpensWorkbenchWithNamedProject [

	| existingWindows model workbench |
	existingWindows := (self currentWorld submorphs select: [ :each | each isSystemWindow ]) asIdentitySet.
	model := OPTestContainerModel new
		         name: 'Sample Model';
		         yourself.
	OPPluginRegistry setDefault: (OPPluginRegistry new
			 add: OPTestPlugin new;
			 yourself).
	[
		workbench := OPProject openOnModel: model.
		self assert: workbench class identicalTo: OPWorkbench.
		self assert: workbench projectController project name equals: 'Sample Model'.
		self assertCollection: workbench projectController project models hasSameElements: { model } ] ensure: [
			OPPluginRegistry resetDefault.
			self currentWorld submorphs do: [ :each |
				(each isSystemWindow and: [ (existingWindows includes: each) not ]) ifTrue: [ each delete ] ] ]
]

{ #category : 'tests' }
OPApplicationTest >> testStartOpensProjectBrowserWindow [

	| existingWindows openedWindows |
	existingWindows := (self currentWorld submorphs select: [ :each | each isSystemWindow ]) asIdentitySet.
	[
		OPApplication new start.
		openedWindows := self currentWorld submorphs select: [ :each |
			                 each isSystemWindow and: [ (existingWindows includes: each) not ] ].
		self denyEmpty: openedWindows ] ensure: [
			self currentWorld submorphs do: [ :each |
				(each isSystemWindow and: [ (existingWindows includes: each) not ]) ifTrue: [ each delete ] ] ]
]

{ #category : 'tests' }
OPApplicationTest >> testUseBackendRejectsNonMorphicBackend [

	self should: [ OPApplication new useBackend: #Gtk with: nil ] raise: Error
]
