Class {
	#name : #OPRSMapBuilder,
	#superclass : #RSThemedMapBuilder,
	#classInstVars : [
		'openPonkBaselines'
	],
	#category : #'OpenPonk-Roassal-Meta'
}

{ #category : #'instance creation' }
OPRSMapBuilder class >> open [

	<script>
	| canvas |
	canvas := self new
		          baseline: BaselineOfOpenPonkPlugins;
		          build;
		          canvas.

	^ canvas
		  open;
		  yourself
]

{ #category : #accessing }
OPRSMapBuilder class >> openPonkBaselines [

	^ openPonkBaselines ifNil: [
		  openPonkBaselines := #( OpenPonk OpenPonkPlugins PetriNets
		                          FsmEditor ClassEditor BormEditor
		                          BPMN MarkovChains OpenPonkSimulation
		                          BormModel UMLProfiles UMLBootstrapGenerator
		                          OPUMLXMI UMLMetamodel OPXMI XMLDOMVisitor
		                          SynchronizedLinks OpenPonkModel
		                          OpenPonkModelSimulation
		                          OntoUMLVerificationFramework
		                          OntoUMLModelQuery OntoUMLProfile
		                          OntoUMLPatterns OntoUMLTransformationFramework
		                          OpenPonkGit ) asSet ]
]

{ #category : #accessing }
OPRSMapBuilder class >> resetOpenPonkBaselines [

	<script>
	openPonkBaselines := nil
]

{ #category : #'hooks - model' }
OPRSMapBuilder >> computeModels [

	| verResults |
	verResults := Smalltalk globals
		              at: #VerificationResults
		              ifAbsent: [ ^ super computeModels ].
	[
	Smalltalk globals removeKey: #VerificationResults.
	super computeModels ] ensure: [
		Smalltalk globals at: #VerificationResults put: verResults ]
]

{ #category : #'hooks - model' }
OPRSMapBuilder >> dependenciesFrom: aBMBaselineModel [

	^ aBMBaselineModel baselineClass version projects
		  collect: #constructClassName
		  thenSelect: [ :each |
			  each isNotNil and: [
				  (each includesAnyOf: {
						   $-.
						   Character space }) not ] ]
]

{ #category : #hooks }
OPRSMapBuilder >> layoutOn: aCanvas [

	OPRSBaselineDominanceTreeLayout new
		horizontalGap: 50;
		verticalGap: 5;
		on: aCanvas nodes
]

{ #category : #'instance creation' }
OPRSMapBuilder >> newBorderFor: model [

	| border shortName |
	border := RSBorder new
		color: self theme textColor;
		width: 1;
		yourself.
		
	shortName := model name allButFirst: 10.
	
	(self class openPonkBaselines includes: shortName)
		ifFalse: [ border color: Color gray ].
		
	^ border
]

{ #category : #'instance creation' }
OPRSMapBuilder >> newBox [
	^ super newBox
		color: Color white;
		yourself
]

{ #category : #'instance creation' }
OPRSMapBuilder >> newLabelFor: model [

	| label shortName |
	shortName := model name allButFirst: 10.

	label := RSLabel new
		         text: shortName;
		         color: Color black;
		         yourself.

	(self class openPonkBaselines includes: shortName) ifFalse: [
		label color: Color gray ].

	^ label
]

{ #category : #hooks }
OPRSMapBuilder >> renderLinesOn: aCanvas [

	self newLineBuilder
		canvas: aCanvas;
		connectToAll: [ :model |
			model dependencies collect: [ :depName |
					models detect: [ :each | each name = depName ] ] ].
	aCanvas lines do: [ :each |
		| shortName |
		shortName := each to model name allButFirst: 10.
		(self class openPonkBaselines includes: shortName) ifFalse: [
			each
				color: Color gray;
				signalUpdate ] ].
	aCanvas lines pushBack
]
