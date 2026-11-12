"
Tests project template instantiation, factory evaluation, and initial diagram generation.
"
Class {
	#name : 'OPProjectTemplateTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-Templates',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Templates'
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
	| icon factory template |
	icon := Smalltalk ui icons iconNamed: #testRunner.
	factory := [ OPTestContainerModel new ].
	template := OPProjectTemplate
		named: 'test template'
		icon: icon
		modelFactory: factory.
	self assert: template name equals: 'test template'.
	self assert: template icon identicalTo: icon.
	self assert: template modelFactory identicalTo: factory.
	self
		deny: template isExample
		description: 'Template created without isExample: should default to false'.
	self
		assert: (template printString includesSubstring: 'test template')
		description: 'printOn: should include the template name'
]

{ #category : 'tests' }
OPProjectTemplateTest >> testDefaultIsExample [
	| template |
	template := OPProjectTemplate new.
	self
		deny: template isExample
		description: 'New project template should not be marked as example by default'
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
	OPPluginRegistry default plugins do: [ :plugin |
		| templates |
		templates := plugin projectTemplates.
		self
			assert: templates isCollection
			description: 'projectTemplates must return a collection'.
		templates
			select: [ :each | each isExample ]
			thenDo: [ :template |
				| createdModel |
				self
					assert: template name isNotEmpty
					description: 'Each example template must have a non-empty name'.
				createdModel := template createModel.
				self
					assert: (self isModelNonEmpty: createdModel)
					description: 'Example template must instantiate a non-empty domain model' ] ]
]

{ #category : 'tests' }
OPProjectTemplateTest >> testPluginProjectTemplates [
	| templates |
	templates := OPTestPlugin new projectTemplates.
	self
		deny: templates isEmpty
		description: 'OPTestPlugin should provide at least the default blank project template'
]
