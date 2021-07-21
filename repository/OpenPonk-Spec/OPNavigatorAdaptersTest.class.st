Class {
	#name : #OPNavigatorAdaptersTest,
	#superclass : #TestCase,
	#instVars : [
		'adapters'
	],
	#category : #'OpenPonk-Spec-Tests'
}

{ #category : #running }
OPNavigatorAdaptersTest >> setUp [
	super setUp.
	adapters := OPNavigatorAdapters new.
	adapters adapters: { OPDefaultNavigatorAdapter new }.
]

{ #category : #running }
OPNavigatorAdaptersTest >> testChildrenForProject [
	| project |
	project := OPProject new.
	project addModel: Object new.
	self assert: (adapters childrenFor: project) asArray equals: project models asArray
]

{ #category : #running }
OPNavigatorAdaptersTest >> testDisplayForProject [
	| project |
	project := OPProject new name: 'My Project'.
	self assert: (adapters displayFor: project) equals: 'My Project (Project)'
]

{ #category : #running }
OPNavigatorAdaptersTest >> testIconForProject [
	self
		assert: (adapters iconFor: OPProject new) bits
		equals: OPIcons current openponkIcon bits
]
