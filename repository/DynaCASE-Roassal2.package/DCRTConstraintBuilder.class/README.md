THIS IS WIP - DO NOT USE.

DCTRConstraintBuilder is an advanced version of TRConstraint with more freedom in position specification.

vertical alignment:
* top, middle, bottom

horizontal alignment:
* left, center, right

box:
* inner, outer

padding:
* padding:, verticalPadding:, horizontalPadding:
Padding is counted from the "attach point". So padding: 10@10 for top;left;inner will do + (10@10) (pushing down and right)
while top;  left; outer will do +(10 @ 10 negated) (pushing up and right).