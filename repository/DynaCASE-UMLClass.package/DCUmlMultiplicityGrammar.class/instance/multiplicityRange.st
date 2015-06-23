grammar
multiplicityRange
	^ ((lower , '..' asParser) ==> [ :n | n first ]) optional , upper