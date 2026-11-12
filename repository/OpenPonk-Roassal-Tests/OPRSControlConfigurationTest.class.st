"
Verifies default settings, instance overrides, and validation invariants on OPRSControlConfiguration.
"
Class {
	#name : 'OPRSControlConfigurationTest',
	#superclass : 'TestCase',
	#instVars : [
		'savedKeepCamera',
		'savedComparisons',
		'savedMargin'
	],
	#category : 'OpenPonk-Roassal-Tests-Interactions',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Interactions'
}

{ #category : 'running' }
OPRSControlConfigurationTest >> setUp [
	super setUp.
	savedKeepCamera := OPRSControlConfiguration keepCameraOnContent.
	savedComparisons := OPRSControlConfiguration dragSnapComparisonsAmount.
	savedMargin := OPRSControlConfiguration dragSnapMargin
]

{ #category : 'running' }
OPRSControlConfigurationTest >> tearDown [
	OPRSControlConfiguration keepCameraOnContent: savedKeepCamera.
	OPRSControlConfiguration dragSnapComparisonsAmount: savedComparisons.
	OPRSControlConfiguration dragSnapMargin: savedMargin.
	super tearDown
]

{ #category : 'tests' }
OPRSControlConfigurationTest >> testClassAndInstanceConfigurationAndValidation [
	| config |
	OPRSControlConfiguration keepCameraOnContent: true.
	OPRSControlConfiguration dragSnapComparisonsAmount: 15.
	OPRSControlConfiguration dragSnapMargin: 8.
	config := OPRSControlConfiguration new.
	self
		assert: config keepCameraOnContent
		description: 'Instance should inherit keepCameraOnContent = true from class configuration'.
	self assert: config dragSnapComparisonsAmount equals: 15.
	self assert: config dragSnapMargin equals: 8.
	config
		keepCameraOnContent: false;
		dragSnapComparisonsAmount: 3;
		dragSnapMargin: 2.
	self
		deny: config keepCameraOnContent
		description: 'Instance override should set keepCameraOnContent to false'.
	self assert: config dragSnapComparisonsAmount equals: 3.
	self assert: config dragSnapMargin equals: 2.
	self should: [ OPRSControlConfiguration dragSnapComparisonsAmount: -1 ] raise: AssertionFailure.
	self should: [ OPRSControlConfiguration dragSnapMargin: -5 ] raise: AssertionFailure
]
