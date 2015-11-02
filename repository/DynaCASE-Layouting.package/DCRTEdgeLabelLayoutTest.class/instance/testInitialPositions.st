tests
testInitialPositions
	| positions |
	layout spacing: 50.
	positions := layout initialPositionsFor: label.
	self
		assertCollection: positions
		hasSameElements:  {(35.5@ -10.5). (34.5@ -10.5) .(34.5@10.5) .(35.5@10.5) .(114.5@10.5) .(114.5@ -10.5) .(84.5@10.5) .(-14.5@ -10.5). (65.5@ -10.5) .(65.5@10.5). (-14.5@10.5) .(84.5@ -10.5)}