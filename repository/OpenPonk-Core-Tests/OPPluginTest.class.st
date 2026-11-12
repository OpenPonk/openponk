Class {
	#name : 'OPPluginTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-Plugin',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Plugin'
}

{ #category : 'tests' }
OPPluginTest >> testAbstractHooksAndDefaultsOnBasePlugin [
	| basePlugin expectedIcon |
	self
		deny: OPPlugin isTestingOnly
		description: 'Base OPPlugin class must not be marked as testing only'.
	self
		assert: OPTestPlugin isTestingOnly
		description: 'OPTestPlugin class must be marked as testing only'.
	self assert: OPPlugin repositoryName equals: nil.
	self assert: OPPlugin requiredPluginClasses equals: #().

	basePlugin := OPPlugin new.
	self should: [ basePlugin name ] raise: SubclassResponsibility.
	self should: [ basePlugin modelClass ] raise: SubclassResponsibility.
	self should: [ basePlugin diagramControllerClass ] raise: SubclassResponsibility.
	self should: [ basePlugin layouterClass ] raise: SubclassResponsibility.
	self should: [ basePlugin modelSerializerClass ] raise: SubclassResponsibility.
	self should: [ basePlugin mergeModels: #() ] raise: NotYetImplemented.

	self assert: basePlugin version equals: '0.0.0+unknown'.
	expectedIcon := OPCoreIcons openponkIcon.
	self assert: basePlugin icon class identicalTo: Form.
	self assert: basePlugin icon bits equals: expectedIcon bits.
	self
		deny: basePlugin supportsHidingElements
		description: 'Base OPPlugin should not support hiding elements by default'.
	self
		deny: basePlugin supportsMergingModels
		description: 'Base OPPlugin should not support merging models by default'.
	self assert: basePlugin exampleProjectTemplates equals: #().
	self assert: basePlugin defaultStyleSheet class identicalTo: OPStyleSheet
]

{ #category : 'tests' }
OPPluginTest >> testPluginComparisonTemplatesSerializerAndStyleSheet [
	| pluginA pluginB templates template sheet |
	pluginA := OPTestPlugin new.
	pluginB := OPTestSecondaryPlugin new.

	self assert: pluginA equals: OPTestPlugin new.
	self assert: pluginA hash equals: OPTestPlugin new hash.
	self deny: pluginA equals: pluginB.
	self
		assert: pluginB < pluginA
		description: 'Secondary Test Plugin should sort alphabetically before Test Plugin'.
	self
		assert: pluginB <= pluginA
		description: 'pluginB should be <= pluginA'.
	self
		assert: pluginA > pluginB
		description: 'pluginA should be > pluginB'.
	self
		assert: pluginA >= pluginB
		description: 'pluginA should be >= pluginB'.
	self assert: (pluginB min: pluginA max: pluginA) equals: pluginA.
	self assert: (pluginA min: pluginB max: pluginA) equals: pluginA.

	self assert: pluginA defaultModelName equals: 'Test Plugin'.
	templates := pluginA projectTemplates.
	self assert: templates size equals: 1.
	template := templates first.
	self assert: template name equals: 'Empty Test Plugin'.
	self
		deny: template isExample
		description: 'Default project template must not be marked as an example'.
	self assert: template createModel class identicalTo: OPTestContainerModel.
	self assert: pluginA serializer class identicalTo: OPMementoDirectorySerializer.
	self
		assert: (pluginA isPluginFor: OPTestContainerModel new)
		description: 'OPTestPlugin should be plugin for OPTestContainerModel'.

	[
		OPNotationStyleRegistry resetDefault.
		OPNotationStyleRegistry default
			atPlugin: pluginA
			type: 'Entity'
			set: #fontSize
			to: 18.
		sheet := pluginA styleSheet.
		self assert: ((sheet ruleForType: 'Entity') at: #fontSize) equals: 18
	] ensure: [
		OPNotationStyleRegistry resetDefault ]
]
