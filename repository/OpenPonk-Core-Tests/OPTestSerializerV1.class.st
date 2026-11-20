"
Test serializer fixture supporting version 1 of a synthetic export format for verifying serializer selection priority.
"
Class {
	#name : 'OPTestSerializerV1',
	#superclass : 'OPModelSerializer',
	#category : 'OpenPonk-Core-Tests-Persistence',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Persistence'
}

{ #category : 'accessing' }
OPTestSerializerV1 class >> exportSubject [

	^ #testSubject
]

{ #category : 'accessing' }
OPTestSerializerV1 class >> exportVersion [

	^ 1
]

{ #category : 'formatting' }
OPTestSerializerV1 class >> formatName [

	^ #testFormat
]

{ #category : 'accessing' }
OPTestSerializerV1 class >> minImportVersion [

	^ 1
]
