Project 3

The third project involves modifying the attached interpreter so that it interprets programs for the complete language.
You may convert all values to double values, although you can maintain their individual types if you wish.
When the program is run on the command line, the parameters to the function should be supplied as command line arguments. For example, for the following function header of a program in the file text.txt:

function main a: integer, b: integer returns integer;

One would execute the program as follows:

$ ./compile < test.txt 2 4

In this case, the parameter a would be initialized to 2 and the parameter b to 4.
An example of a program execution is shown below:

$ ./compile < test.txt 2 4 

1 function main a: integer, b: integer returns integer; 
2 c: integer is 
3 if a > b then 
4 a rem b; 
5 else 
6 a ** 2; 
7 endif; 
8 begin 
9 case a is 
10 when 1 => c; 
11 when 2 => (a + b / 2 - 4) * 3; 
12 others => 4; 
13 endcase; 
14 end; 

Compiled Successfully Result = 0

After the compilation listing is output, the value of the expression which comprises the body of the function should be displayed as shown above.
The existing code evaluates some of the arithmetic, relational and logical operators together with the reduction statement and integer literals only. You are to add the necessary code to include all of the following:

- Real and Boolean literals
- All additional arithmetic operators
- All additional relational and logical operators
- Both if and case statements
- Functions with multiple variables
- Functions with parameters

This project requires modification to the bison input file, so that it defines the additional the necessary computations for the above added features. You will need to add functions to the library of evaluation functions already provided in values.
