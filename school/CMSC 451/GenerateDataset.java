/*
 * Joshua A. Roche
 * PROJECT-NAME
 * DD-MMM-YYYY
 * FILENAME
 */
package benchmarksorts;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class GenerateDataset {
  private Integer[] array;
  private Integer[][] dataset;
  
  public GenerateDataset(int length) {
    this.array = new Integer[length];
    this.dataset = new Integer[50][length];
    generate();
  }
  
  private void generate() {
    for (int i = 0; i < 50; i++) {
      for (int j = 0; j < this.array.length; j++) {
        this.array[j] = j + 1;
      }
      List<Integer> list = Arrays.asList(this.array);
      Collections.shuffle(list);
      list.toArray(this.array);
      for (int k = 0; k < this.array.length; k++) {
        this.dataset[i][k] = this.array[k];
      }
    }
  }
  
  public Integer[][] getDataset() {
    return this.dataset;
  }
}
