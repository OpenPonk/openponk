Extension { #name : #MAPluggableAccessor }

{ #category : #'*OpenPonk-Spec' }
MAPluggableAccessor class >> read: aReadBlock [
	^ self new
		readBlock: aReadBlock;
		writeBlock: [ :model :value |  ];
		yourself
]
