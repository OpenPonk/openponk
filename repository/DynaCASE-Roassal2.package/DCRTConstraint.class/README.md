I am iteratively buildable constraint for moving and positioning an element on top of another one.

!! Usage

The order of configuration message sends is irrelevant, only the last of a group will be used.

Note: ==move== and ==stick== will execute the movement on the configured object (so if you ==stick== shapes and then change configuration, it will honor the new configuration.

[ [ [
(DCRTConstraint child: childShape parent: parentShape)
	top | middle | bottom; "vertical position"
	left | center | right; "horizontal position"
	inner | border | outer; "inside the parent, on border, outside"
	move; "execute movement"
	padding: aNumber; "shortcut for vertical + horizontal padding"
	verticalPadding: aNumber;
	horizontalPadding: aNumber;
	stick "add callbacks that will continuously execute the movement"
]]]

See ==self default== for default configuration.