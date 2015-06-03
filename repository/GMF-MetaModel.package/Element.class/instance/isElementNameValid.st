validating
isElementNameValid
	| allowed |
	
	allowed := ($0 to: $9), {$_}, ($A to: $Z), ($a to: $z).

	^ (name allSatisfy: [ :character | allowed includes: character ])