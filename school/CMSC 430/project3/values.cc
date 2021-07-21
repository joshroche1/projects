// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

int evaluateReduction(Operators operator_, int head, int tail)
{
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}


int evaluateRelational(int left, Operators operator_, int right)
{
	int result;
	switch (operator_)
	{
		case LESS:
			result = left < right;
			break;
		case GREATER:
			result = left > right;
			break;
		case EQUAL:
			result = (left == right);
			break;
		case LESSEQUAL:
			result = (left <= right);
			break;
		case GREATEREQUAL:
			result = (left >= right);
			break;
		case NOTEQUAL:
			result = (left /= right);
			break;
		default:
			result = false;
			break;
	}
	return result;
}

int evaluateArithmetic(int left, Operators operator_, int right)
{
	int result;
	switch (operator_)
	{
		case ADD:
			result = left + right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case EXPONENT:
			double x = left;
			double y = right;
			result = pow(x, y);
			break;
	}
	return result;
}

int evaluateCondtional(Operators operator_, condition_1, condition_2, condition_3)	// FIX THIS
{
	int result;
	
	return result;
}

