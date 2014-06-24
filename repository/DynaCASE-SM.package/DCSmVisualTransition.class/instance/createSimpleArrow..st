as yet unclassified
createSimpleArrow:aCanvas
|path|
path:=aCanvas createPath:[
	:builder|
	builder absolute;
	moveTo: -5@ -3;
	lineTo: 0@ 0 ;
	lineTo: -5@ 3.
	].
^path
