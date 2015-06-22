grammar
property
	^ visibility optional , propName , (($: asParser , propType) ==> [ :n | n second ]) optional , multiplicity