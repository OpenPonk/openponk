"
Test serializer fixture supporting versions 1 through 2 of a synthetic export format for verifying serializer selection priority.
"
Class {
	#name : 'OPTestSerializerV2Wide',
	#superclass : 'OPModelSerializer',
	#category : 'OpenPonk-Core-Tests-Persistence',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Persistence'
}

{ #category : 'accessing' }
OPTestSerializerV2Wide class >> exportSubject [

	^ #testSubject
]

{ #category : 'accessing' }
OPTestSerializerV2Wide class >> exportVersion [

	^ 2
]

{ #category : 'formatting' }
OPTestSerializerV2Wide class >> formatName [

	^ #testFormat
]

{ #category : 'accessing' }
OPTestSerializerV2Wide class >> minImportVersion [

	^ 1
]
