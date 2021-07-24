#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

int evaluateReduction(Operators operator_, int head, int tail) {
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}


int evaluateRelational(int left, Operators operator_, int right) {
	int result;
	switch (operator_)
	{
		case EQUAL:
			result = left == right;
			break;
		case LESS:
			result = left < right;
			break;
		case GREATER:
			result = left > right;
			break;
		case LESSEQUAL:
			result = left <= right;
			break;
		case GREATEREQUAL:
			result = left >= right;
			break;
		case NOTEQUAL:
			result = left != right;
			break;
	}
	return result;
}

int evaluateArithmetic(int left, Operators operator_, int right) {
	int result;
	switch (operator_)
	{
		case ADD:
			result = left + right;
			break;
		case SUBTRACT:
			result = left - right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case DIVIDE:
			result = left / right;
			break;
		case REMAINDER:
			result = remainder(left, right);
			break;
		case EXPONENT:
			result = pow(left, right);
			break;
	}
	return result;
}

int evaluateIf(int exp, int stmt1, int stmt2) {
	int result;
	if (exp) {
		result = stmt1;
	} else {
		result = stmt2;
	}
	return result;
}

int evaluateCase(int exp, int cases[50][2], int other) {
	int result;
	for (int i = 0; i < 50; i++) {
		if (exp == cases[i][0]) {
			result = cases[i][1];
			break;
		} else {
			result = other;
		}
	}
	return result;
}
