"
I represent a graphical feature in the layout.
"
Class {
	#name : 'DCRTLFeatureNode',
	#superclass : 'DCRTLNode',
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels',
	#package : 'DynaCASE-Layouting',
	#tag : 'GlobalEdgeLabels'
}

{ #category : 'testing' }
DCRTLFeatureNode >> isFeature [
	^ true
]

{ #category : 'accessing' }
DCRTLFeatureNode >> label [
	^ 'F(' , self model from model asString , self model to model asString , ')'
]
