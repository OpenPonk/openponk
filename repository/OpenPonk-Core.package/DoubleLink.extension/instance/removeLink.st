*OpenPonk-Core-accessing
removeLink
	| predecessor successor |
	predecessor := self previousLink.
	successor := self nextLink.
	predecessor nextLink: successor.
	successor previousLink: predecessor.
	self clearLinks