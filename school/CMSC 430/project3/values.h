// CMSC 430
// Duane J. Jarc

// This file contains function definitions for the evaluation functions

typedef char* CharPtr;
enum Operators {EQUAL, LESS, GREATER, LESSEQUAL, GREATEREQUAL, NOTEQUAL,
	ADD, SUBTRACT, MULTIPLY, DIVIDE, REMAINDER, EXPONENT};

int evaluateReduction(Operators operator_, int head, int tail);
int evaluateRelational(int left, Operators operator_, int right);
int evaluateArithmetic(int left, Operators operator_, int right);
int evaluateIf(int exp, int stmt1, int stmt2);
int evaluateCase(int exp, int cases[50][2], int other);
