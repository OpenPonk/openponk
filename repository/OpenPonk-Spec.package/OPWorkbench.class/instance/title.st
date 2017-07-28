protocol
title
	^ project ifNil: [ 'OpenPonk' ] ifNotNil: [ project name , ' - ' , 'OpenPonk' ]