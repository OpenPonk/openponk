Class {
	#name : 'OPProjectTemplateTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'helpers' }
OPProjectTemplateTest >> isModelNonEmpty: aModel [
	"Polymorphic check for non-empty OpenPonk model domain elements."

	(aModel respondsTo: #packagedElements) ifTrue: [ 
		^ aModel packagedElements isNotEmpty ].
	(aModel respondsTo: #allElements) ifTrue: [ 
		^ aModel allElements isNotEmpty ].
	(aModel respondsTo: #elements) ifTrue: [ 
		^ aModel elements isNotEmpty ].
	(aModel respondsTo: #objects) ifTrue: [ 
		^ aModel objects isNotEmpty ].
	^ false
]

{ #category : 'tests' }
OPProjectTemplateTest >> testCreateModel [
	| template model |
	template := OPProjectTemplate
		named: 'Model Template'
		icon: (Smalltalk ui icons iconNamed: #testRunner)
		modelFactory: [ OPTestEntityModel new ].
	model := template createModel.
	self assert: model class equals: OPTestEntityModel
]

{ #category : 'tests' }
OPProjectTemplateTest >> testCreation [
	| template |
	template := OPProjectTemplate
		named: 'Test Template'
		icon: (Smalltalk ui icons iconNamed: #testRunner)
		modelFactory: [ OPTestEntityModel new ]
		isExample: true.
	self assert: template name equals: 'Test Template'.
	self assert: template icon equals: (Smalltalk ui icons iconNamed: #testRunner).
	self assert: template isExample
]

{ #category : 'tests' }
OPProjectTemplateTest >> testDefaultIsExample [
	| template |
	template := OPProjectTemplate
		named: 'Default Template'
		icon: (Smalltalk ui icons iconNamed: #testRunner)
		modelFactory: [ OPTestEntityModel new ].
	self deny: template isExample
]

{ #category : 'tests' }
OPProjectTemplateTest >> testEquality [
	| templateA templateB templateDifferent |
	templateA := OPProjectTemplate
		named: 'A'
		icon: (Smalltalk ui icons iconNamed: #package)
		modelFactory: [ nil ]
		isExample: false.
	templateB := OPProjectTemplate
		named: 'A'
		icon: (Smalltalk ui icons iconNamed: #package)
		modelFactory: [ nil ]
		isExample: false.
	templateDifferent := OPProjectTemplate
		named: 'B'
		icon: (Smalltalk ui icons iconNamed: #package)
		modelFactory: [ nil ]
		isExample: false.
	self assert: templateA equals: templateB.
	self assert: templateA hash equals: templateB hash.
	self deny: templateA equals: templateDifferent
]

{ #category : 'tests' }
OPProjectTemplateTest >> testInstalledPluginsProvideExamples [
	| nonTestingPlugins |
	nonTestingPlugins := OPPluginRegistry default plugins reject: [ :pluginItem | 
		pluginItem class isTestingOnly ].
	nonTestingPlugins ifEmpty: [ 
		self skip: 'No domain plugins installed in core image'.
		^ self ].
	nonTestingPlugins do: [ :pluginItem | 
		| templates |
		templates := pluginItem exampleProjectTemplates.
		self assert: templates isNotEmpty description: ('Plugin ' , pluginItem name , ' must provide at least one example template').
		templates do: [ :templateItem | 
			| modelItem |
			self assert: templateItem isExample.
			self assert: templateItem name isNotEmpty.
			self assert: templateItem icon isNotNil.
			modelItem := templateItem createModel.
			self assert: modelItem isNotNil.
			self assert: (self isModelNonEmpty: modelItem) description: ('Template ' , templateItem name , ' created an empty model') ] ]
]

{ #category : 'tests' }
OPProjectTemplateTest >> testPluginProjectTemplates [
	| plugin templates template model |
	plugin := OPTestPlugin new.
	templates := plugin projectTemplates.
	self assert: templates size equals: 1.
	template := templates first.
	self assert: template name equals: 'Empty Test Plugin'.
	self deny: template isExample.
	model := template createModel.
	self assert: model class equals: OPTestContainerModel
]
