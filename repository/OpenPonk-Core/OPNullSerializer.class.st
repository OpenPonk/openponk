"
I am the default serializer and do nothing at all.
"
Class {
	#name : #OPNullSerializer,
	#superclass : #OPAbstractSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPNullSerializer >> diagramExtension [
	^ ''
]

{ #category : #loading }
OPNullSerializer >> loadMementoFrom: aFolder [
	^ nil
]

{ #category : #'serialize/materialize' }
OPNullSerializer >> materializeDiagramFrom: aString [
	self shouldNotImplement
]

{ #category : #'serialize/materialize' }
OPNullSerializer >> materializeModelFrom: aString [
	self shouldNotImplement
]

{ #category : #accessing }
OPNullSerializer >> modelExtension [
	^ ''
]

{ #category : #saving }
OPNullSerializer >> saveMemento: aMemento to: aFolder [
	"do nothing"
]

{ #category : #'serialize/materialize' }
OPNullSerializer >> serializeDiagram: aDiagramMemento [
]

{ #category : #'serialize/materialize' }
OPNullSerializer >> serializeModel: aModel [
]
