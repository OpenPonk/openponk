Class {
	#name : #OPNavigatorAdaptersTest,
	#superclass : #TestCase,
	#instVars : [
		'adapters'
	],
	#category : 'OpenPonk-Spec-Tests'
}

{ #category : #running }
OPNavigatorAdaptersTest >> setUp [
	super setUp.
	adapters := OPNavigatorAdapters new.
	adapters adapters: { OPDefaultNavigatorAdapter new }.
]

{ #category : #running }
OPNavigatorAdaptersTest >> testChildrenForObject [
	self assert: (adapters childrenFor: Object new) equals: #()
]

{ #category : #running }
OPNavigatorAdaptersTest >> testChildrenForProject [
	| project |
	project := OPProject new.
	project addModel: Object new.
	self assert: (adapters childrenFor: project) asArray equals: project models asArray
]

{ #category : #running }
OPNavigatorAdaptersTest >> testDisplayForObject [
	self assert: (adapters displayFor: Object new) equals: 'an Object (Object)'
]

{ #category : #running }
OPNavigatorAdaptersTest >> testDisplayForProject [
	| project |
	project := OPProject new name: 'My Project'.
	self assert: (adapters displayFor: project) equals: 'My Project (Project)'
]

{ #category : #running }
OPNavigatorAdaptersTest >> testIconForObject [
	self assert: (adapters iconFor: Object new) equals: #blank asIcon
]

{ #category : #running }
OPNavigatorAdaptersTest >> testIconForProject [
	self
		assert: (adapters iconFor: OPProject new) bits
		equals: OPIcons current openponkIcon bits
]
