Extension { #name : 'GraphViz' }

{ #category : '*DynaCASE-Layouting' }
GraphViz >> asGml [

	^ self generator createGMLDocument
]
