/*
 * Joshua A. Roche
 * PROJECT-NAME
 * DD-MMM-YYYY
 * FILENAME
 */
package benchmarksorts;

import java.util.Arrays;


public class SelectionSort implements SortInterface {
  private Integer[] array, icountarr, rcountarr;
  private Long[][] itimearr, rtimearr;
  private Integer[][] dataset, idataset, rdataset;
  private int i, j, temp, min, rminval, rminindex, index, icount, rcount;
  private long starttime, finishtime, elapsedtime;

  public SelectionSort(Integer[][] ds) {
    this.dataset = this.idataset = this.rdataset = ds;
    this.icount = this.rcount = min = 0;
    itimearr = new Long[this.dataset.length][3];
    icountarr = new Integer[this.dataset.length];
    rtimearr = new Long[this.dataset.length][3];
    rcountarr = new Integer[this.dataset.length];
  }
  
  public void iterativeSort() {
    for (int x = 0; x < this.idataset.length; x++) {
      starttime = System.currentTimeMillis();
      for (int i = 0; i < this.idataset[x].length; i++) {
        min = i;
        for (int j = i + 1; j < this.idataset[x].length; j++) {
          if (this.idataset[x][j] < this.idataset[x][min]) {
            min = j;
          }
        }
        if (min != i) {  // swap operation
          this.temp = this.idataset[x][i];
          this.idataset[x][i] = this.idataset[x][min];
          this.idataset[x][min] = this.temp;
          this.icount++;
        }
      }
      this.finishtime = System.currentTimeMillis();
      itimearr[x][0] = this.starttime;
      itimearr[x][1] = this.finishtime;
      itimearr[x][2] = this.finishtime - this.starttime;
      icountarr[x] = this.icount;
      this.icount = 0;
    } 
  }
  public void recursiveAlgorithm() {
    for (int x = 0; x < this.rdataset.length; x++) {
      this.starttime = System.currentTimeMillis();
      this.rminval = this.rdataset[x][0];
      this.recursiveSort(this.rdataset[x], index);
      this.finishtime = System.currentTimeMillis();
      this.rtimearr[x][0] = this.starttime;
      this.rtimearr[x][1] = this.finishtime;
      this.rtimearr[x][2] = this.finishtime - this.starttime;
      this.rcountarr[x] = this.rcount;
      this.rcount = 0;
      index = 0;
    }
  }
  public void recursiveSort(Integer[] array, int index) {
    for (int i = 0; i < (array.length-index); i++) {
      if (array[i+index] < this.rminval) {
        this.rminval = array[i+index];
        this.rminindex = i+index;
      }
      if ((array.length-index) < 2) {
        if (array[array.length-1] < array[index]) {
          this.rminindex = array.length-1;
        } else {
          this.rminindex = index;
        }
      }
    }
    if (this.rminindex != index) {
      temp = array[index];
      array[index] = array[this.rminindex];
      array[this.rminindex] = temp;
      this.rcount++;
    }
    if (index < array.length-1) {
      this.recursiveSort(array, index+1);
    }
  }
  
  public Integer[][] getIter() {
    return this.idataset;
  }
  public Integer[][] getRecur() {
    return this.rdataset;
  }
  public long getTime() {
    return 0;
  }
  public long getTime(int x) {
    if (this.itimearr[x][2] != null) {
      return this.itimearr[x][2];
    } else {
      return 0;
    }
  }
  public long getStart(int x) {
    if (this.itimearr[x][0] != null) {
      return this.itimearr[x][0];
    } else {
      return 0;
    }
  }
  public long getFinish(int x) {
    if (this.itimearr[x][1] != null) {
      return this.itimearr[x][1];
    } else {
      return 0;
    }
  }
  public long getRTime(int x) {
    if (this.rtimearr[x][2] != null) {
      return this.rtimearr[x][2];
    } else {
      return 0;
    } 
  }
  public long getRStart(int x) {
    if (this.rtimearr[x][0] != null) {
      return this.rtimearr[x][0];
    } else {
      return 0;
    }    
  }
  public long getRFinish(int x) {
    if (this.rtimearr[x][1] != null) {
      return this.rtimearr[x][1];
    } else {
      return 0;
    }
  }
  public int getCount() {
    return 0;
  }
  public int getICount(int x) {
    if (this.icountarr[x] != null) {
      return this.icountarr[x];
    } else {
      return 0;
    }
  }
  public int getRCount(int x) {
    if (this.rcountarr[x] != null) {
      return this.rcountarr[x];
    } else {
      return 0;
    }
  }
  public Long[][] getitimearr() {
    return this.itimearr;
  }
  public Long[][] getrtimearr() {
    return this.rtimearr;
  }
}
