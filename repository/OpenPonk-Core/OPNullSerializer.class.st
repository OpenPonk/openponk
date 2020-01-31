"
I am the default serializer and do nothing at all.
"
Class {
	#name : #OPNullSerializer,
	#superclass : #OPSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

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
