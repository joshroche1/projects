CMSC 451 Project 1
The first project involves benchmarking the behavior of Java implementations of one of the
following sorting algorithms, bubble sort, selection sort, insertion sort, Shell sort, merge sort,
quick sort or heap sort. You must post your selection in the "Ask the Professor" conference. No
more than five students may select any one algorithm.
You must write the code to perform the benchmarking of the algorithm you selected. Your
program must include both an iterative and recursive version of the algorithm. You do not have
to write the sorting algorithms yourself, you may take them from some source, but you must
reference your source.
You must identify some critical operation to count that reflects the overall performance and
modify each version so that it counts that operation. In addition to counting critical operations
you must measure the actual run time in nanoseconds.
In addition, you should examine the result of each call to verify that the data has been properly
sorted to verify the correctness of the algorithm. If the array is not sorted, an exception should be
thrown.
It should also randomly generate data to pass to the sorting methods. It should produce 50 data
sets for each value of n, the size of the data set and average the result of those 50 runs. The exact
same data must be used for the iterative and the recursive algorithms. It should also create 10
different sizes of data sets. Choose sizes that will clearly demonstrate the trend as n becomes
large. Be sure that the data set sizes are evenly spaced so this data can be used to generate graphs
in project 2
This project should consist of two separate programs. The first of those programs should perform
the benchmarking described above and generate two data files, one containing the results from
the iterative algorithm and the one containing the results of the recursive algorithm.
The benchmarking program must be written to conform to the following design:
+recursiveSort(inout int[] list)
+iterativeSort(inout int[] list)
+getCount() : int
+getTime() : long
«interface»
SortInterface
YourSort
+main(in String[] args)
BenchmarkSorts UnsortedException
Exception

The output files should contain 10 lines that correspond to the 10 data set sizes. The first value on each line should be the data set size followed by 50 pairs of values. Each pair represents the critical element count and the time in nanoseconds for each of the 50 runs of that data set size.
The second program should produce the report. It should allow the user to select the input file using JFileChooser. The report should contain one line for each data set size and five columns and should be displayed using a JTable. The first column should contain the data set size the second the average of the critical counts for the 50 runs and the third the coefficient of variance of those 50 values expressed as a percentage. The fourth and fifth column should contain similar data for the times. The coefficient of variance of the critical operation counts and time measurement for the 50 runs of each data set size provide a way to gauge the data sensitivity of the algorithm.
Shown below is an example of how the report should look:

| Size | Avg Count | Coeff Count | Avg Time | Coeff Time |
| 100  |  234.56   |    6.78 %   |  3589.00 |   60.84 %  | 

avgcount(mean) = sum() / numitems
coeff = stddev/mean
stddev = sqrt[ sum(x-mean)^2 / numitems ]

On the due date for project 1, you are to submit a .zip file that includes the source code for both programs. All the classes should be in the default package.
You must research the issue of JVM warm-up necessary for properly benchmarking Java programs and ensure that your code performs the necessary warm-up so the time measurements are accurate.
