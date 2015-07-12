I am a box with rounded rounded corners.

!! Collaborators

DCTRBoxShape

!! Example

v := RTView new.

e := DCRTBox new
	width: 100;
	height: 50;
	borderRadius: 10;
	borderColor: Color black;
	element.

v add: e.

v