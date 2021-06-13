/*
 * Joshua A. Roche
 * PROJECT-NAME
 * DD-MMM-YYYY
 * FILENAME
 */
package benchmarksorts;

import java.io.File;
import java.math.*;


public class GenerateReport {
  private String[][] contents;
  private Integer[] countarr, sizearr;
  private Long[] timearr;
  private Integer[][] carr;
  private Long[][] tarr;
  private int size, avgcount;
  private long avgtime;
  private double coefcount, coeftime;
  private String[][] report;
  
  public GenerateReport(Integer[] sizes, Integer[][] counts, Long[][] times) {
    this.sizearr = sizes;
    this.carr = counts;
    this.tarr = times;
    this.report = new String[11][5];
    this.report[0][0] = "Set Size";
    this.report[0][1] = "Avg. Count";
    this.report[0][2] = "Coefficient";
    this.report[0][3] = "Avg. Time";
    this.report[0][4] = "Coefficient";
    this.parse();
  }
  public GenerateReport(String[][] contents) {
    this.contents = contents;
    this.parseStringArray();
  }
  
  private void parseStringArray() {
    if (this.contents == null) {
      return;
    }
    int tempint = 0;
    long templong = 0;
    System.out.println("parseStringArray()");
    System.out.println("this.contents.length=" + this.contents.length);
    System.out.println("this.contents[0].length=" + this.contents[0].length);
    this.sizearr = new Integer[this.contents.length];
    this.carr = new Integer[this.contents.length][this.contents[0].length];
    this.tarr = new Long[this.contents.length][this.contents[0].length];
    for (int x = 0; x < this.contents.length; x++) {
      System.out.println(this.contents[x][0] + "");
      tempint = Integer.getInteger(this.contents[x][0]);
      this.sizearr[x] = tempint;
      for (int y = 0; y < 50; y++) {
        tempint = Integer.getInteger(this.contents[x][(y*2)+1]);
        this.carr[x][(y*2)+1] = tempint;
        System.out.println("this.carr[" + x + "][" + ((y*2)+1) + "]=" + tempint);
        templong = Long.getLong(this.contents[x][(y*2)+2]);
        this.tarr[x][(y*2)+2] = templong;
        System.out.println("this.tarr[" + x + "][" + ((y*2)+2) + "]=" + templong);
      }
    }
    this.report = new String[11][5];
    this.report[0][0] = "Set Size";
    this.report[0][1] = "Avg. Count";
    this.report[0][2] = "Coefficient";
    this.report[0][3] = "Avg. Time";
    this.report[0][4] = "Coefficient";
    this.parse();
  }
  private void parse() {
    String strtemp;
    for (int i = 0; i < this.sizearr.length; i++) {
      this.report[i+1][0] = this.sizearr[i] + "";
      int sum = 0;
      for (int x = 0; x < this.carr[i].length; x++) {
        sum += this.carr[i][x];
      }
      this.avgcount = sum / this.carr[i].length;
      this.report[i+1][1] = this.avgcount + "";
      double dev = 0;
      for (int x = 0; x < this.carr[i].length; x++) {
        dev += Math.pow((this.carr[i][x] - this.avgcount), 2);
      }
      dev = Math.sqrt(dev / this.carr[i].length);
      this.coefcount = dev*100 / this.avgcount;
      strtemp = this.coefcount + "     ";
      this.report[i+1][2] = strtemp.substring(0, 5) + " %";
      long timesum = 0;
      for (int x = 0; x < this.tarr[i].length; x++) {
        timesum += this.tarr[i][x];
      }
      this.avgtime = timesum / this.tarr[i].length;
      this.report[i+1][3] = this.avgtime + "";
      double timedev = 0;
      for (int x = 0; x < this.tarr[i].length; x++) {
        timedev += Math.pow((this.tarr[i][x] - this.avgtime), 2);
      }
      timedev = Math.sqrt(timedev / this.tarr[i].length);
      if (this.avgtime == 0) {
        this.coeftime = 0;
      } else {
        this.coeftime = timedev*100 / this.avgtime;
      }
      strtemp = this.coeftime + "     ";
      this.report[i+1][4] = strtemp.substring(0, 5) + " %";
      String msg = "";
      for (int x = 0; x < this.report.length; x++) {
        for (int y = 0; y < this.report[x].length; y++) {
          msg += "[" + this.report[x][y] + "]";
        }
        msg += "\n";
      }
    }
  }
  
  public String[][] getReport() {
    return this.report;
  }
}
