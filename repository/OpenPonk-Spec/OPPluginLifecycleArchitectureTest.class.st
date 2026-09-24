Class {
	#name : 'OPPluginLifecycleArchitectureTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPPluginLifecycleArchitectureTest >> testAllInstalledPluginsHaveLifecycleTestCase [
	| nonTestingPlugins concreteTestClasses missingPlugins |
	nonTestingPlugins := OPPluginRegistry default plugins reject: [ :eachPlugin |
		eachPlugin class isTestingOnly ].
	nonTestingPlugins ifEmpty: [ ^ self ].
	concreteTestClasses := OPAbstractPluginExampleLifecycleTest allSubclasses reject: [ :eachClass |
		eachClass isAbstract ].
	missingPlugins := nonTestingPlugins reject: [ :eachPlugin |
		concreteTestClasses anySatisfy: [ :eachTestClass |
			(eachTestClass class includesSelector: #pluginClass)
				and: [ eachTestClass pluginClass = eachPlugin class ] ] ].
	self
		assert: missingPlugins isEmpty
		description: (String streamContents: [ :stream |
			stream << 'The following installed plugins are missing an OPAbstractPluginExampleLifecycleTest subclass: '.
			missingPlugins
				do: [ :eachMissingPlugin | stream << eachMissingPlugin name ]
				separatedBy: [ stream << ', ' ] ])
]
