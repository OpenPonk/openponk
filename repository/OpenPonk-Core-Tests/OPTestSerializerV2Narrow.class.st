"
Test serializer fixture supporting version 2 only of a synthetic export format for verifying serializer tie-breaking by minimum import version.
"
Class {
	#name : 'OPTestSerializerV2Narrow',
	#superclass : 'OPModelSerializer',
	#category : 'OpenPonk-Core-Tests-Persistence',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Persistence'
}

{ #category : 'accessing' }
OPTestSerializerV2Narrow class >> exportSubject [

	^ #testSubject
]

{ #category : 'accessing' }
OPTestSerializerV2Narrow class >> exportVersion [

	^ 2
]

{ #category : 'formatting' }
OPTestSerializerV2Narrow class >> formatName [

	^ #testFormat
]

{ #category : 'accessing' }
OPTestSerializerV2Narrow class >> minImportVersion [

	^ 2
]
