*OpenPonk-Spec
read: aReadBlock
	^ self new
		readBlock: aReadBlock;
		writeBlock: [ :model :value |  ];
		yourself