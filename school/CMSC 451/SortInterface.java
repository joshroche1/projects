/*
 * Joshua A. Roche
 * PROJECT-NAME
 * DD-MMM-YYYY
 * FILENAME
 */
package benchmarksorts;


public interface SortInterface {
  /*
  +recursiveSort(inout int[] list)
  +iterativeSort(inout int[] list)
  +getCount(): int
  +getTime(): long
  */
  public int getCount();
  public long getTime();
  public void recursiveSort(Integer[] array, int index);
  public void iterativeSort();
}
