I keep element "on a rail" defined by the connection. If the connection is moved, so is the element.

[[[
self example
]]]

!! Public Attributes

- initialPosition - the +initial+ position along the connection.
This can be either a fraction (0 <=  x <= 1) of connection's length,
or absolute distance (x > 1 ||  x < 0), with negative distance starting from the connection's end.
Note that dragging the element will always revert to relative position.
	
- distance - the distance that should be maintained between the element and the connection.