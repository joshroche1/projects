/*
 * Joshua A. Roche
 * PROJECT-NAME
 * DD-MMM-YYYY
 * FILENAME
 */
package benchmarksorts;

import java.util.Arrays;
import java.lang.Runnable;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextArea;

public class BenchmarkSorts implements Runnable {
  private Integer[][] dataset, sortset, carr, rcarr;
  private Long[][] tarr, rtarr, itimes, rtimes;
  private Integer[] countarr, sizes = {10,25,50,100,250,500,1000,2500,5000,10000};
  private Long[] timearr;
  private String[] results, rresults;
  private SelectionSort iter, recur;
  private GenerateDataset gendata;
  private FileUtility logfile;
  private JFrame frame;
  private JPanel midPanel, statusPanel;
  private JButton runsortButton, fileButton, reportButton;
  private JLabel statusLabel;
  private JFileChooser fc;
  private JTextArea textArea;
  
  public BenchmarkSorts() {
    prepareGUI();
  }
  
  private void prepareGUI() {
    frame = new JFrame("Benchmark Selection Sort");
    frame.setSize(600, 400);
    frame.setLayout(new BorderLayout());
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    midPanel = new JPanel();
    midPanel.setLayout(new GridLayout(2,1));
    statusPanel = new JPanel();
    frame.add(midPanel, BorderLayout.CENTER);
    frame.add(statusPanel, BorderLayout.SOUTH);
    frame.setVisible(true);
  }
  public void displayGUI() {
    statusLabel = new JLabel("");
    statusPanel.add(statusLabel);
    fc = new JFileChooser();
    runsortButton = new JButton("Run Algorithm");
    runsortButton.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        generateDataset();
      }
    });
    fileButton = new JButton("Select Report");
    fileButton.addActionListener(new ActionListener() { 
      public void actionPerformed(ActionEvent e) {
        int retval = fc.showOpenDialog(frame);
        if (retval == JFileChooser.APPROVE_OPTION) {
          File file = fc.getSelectedFile();
          FileUtility futil = new FileUtility(file);
          GenerateReport rprt = new GenerateReport(futil.getStringArray());
          System.out.println("File selected: " + file.getName());
          statusLabel.setText("File Selected: " + file.getName());
        } else {
          System.out.println("File selection cancelled");
          statusLabel.setText("File selection cancelled");
        }
      }
    });
    reportButton = new JButton("Generate Report");
    reportButton.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        getReport();
      }
    });
    textArea = new JTextArea(5, 20);
    JScrollPane scrollPane = new JScrollPane(textArea); 
    textArea.setEditable(false);
    textArea.setWrapStyleWord(true);
    textArea.setLineWrap(true);
    String text = "This program generates sets of 50 shuffled integer counts of 10 different sizes "
            + "which are fed into 2 different Selection Sort algorithms, one written iteratively, "
            + "recursively. It saves the average count of array swaps and runtimes to a file."
            + "\n\nYou can then generate a report showing the average counts and times and their "
            + "coefficients based on the sizes of the datasets.";
    textArea.setText(text);
    midPanel.add(textArea);
    JPanel lowerPanel = new JPanel();
    lowerPanel.add(runsortButton);
    lowerPanel.add(fileButton);
    lowerPanel.add(reportButton);
    midPanel.add(lowerPanel);
    frame.setVisible(true);
  }
  private void generateDataset() {
    System.out.println("generateDataset()");
    this.warmup();
    this.results = new String[10];
    this.rresults = new String[10];
    this.carr = new Integer[10][50];
    this.tarr = new Long[10][50];
    this.rcarr = new Integer[10][50];
    this.rtarr = new Long[10][50];
    this.itimes = new Long[10][100];
    this.rtimes = new Long[10][100];
    for (int i = 0; i < sizes.length; i++) {
      this.gendata = new GenerateDataset(sizes[i]);
      this.dataset = this.gendata.getDataset();
      this.init();
      this.sort(i);
    }
    this.writeLog();
  }
  private void init() {
    this.iter = new SelectionSort(this.dataset);
    this.recur = new SelectionSort(this.dataset);
  }
  private void warmup() {
    System.out.println("warmup()");
    GenerateDataset gd = new GenerateDataset(100);
    Integer[][] ds = gd.getDataset();
    SelectionSort ss = new SelectionSort(ds);
    ss.iterativeSort();
    ss.recursiveAlgorithm();
  }
  private void sort(int x) {
    if (this.dataset == null) {
      return;
    }
    this.iter.iterativeSort();
    this.sortset = this.iter.getIter();
    this.recur.recursiveAlgorithm();
    getResult(this.iter, this.recur, x);
  }
  public void getResult(SelectionSort ss, SelectionSort rs, int x) {
    String msg = "";
    msg += ss.getIter()[x].length;
    for (int i = 0; i < ss.getIter().length; i++) {  
      carr[x][i] = ss.getICount(i);
      msg += ","+ ss.getICount(i);
      tarr[x][i] = ss.getTime(i);
      msg += "," + ss.getTime(i);
      this.itimes[x][i*2] = ss.getStart(i);
      this.itimes[x][(i*2)+1] = ss.getFinish(i);
    }
    this.results[x] = msg + "";
    msg = "";
    msg += rs.getRecur()[x].length;
    for (int i = 0; i < rs.getRecur().length; i++) {  
      rcarr[x][i] = rs.getRCount(i);
      msg += ","+ rs.getRCount(i);
      rtarr[x][i] = rs.getRTime(i);
      msg += "," + rs.getRTime(i);
      this.rtimes[x][i*2] = rs.getRStart(i);
      this.rtimes[x][(i*2)+1] = rs.getRFinish(i);
    }
    this.rresults[x] = msg + "";
  }
  private void writeLog() {
    System.out.println("writeLog()");
    String msg = "";
    for (int i = 0; i < this.results.length; i++) {
      msg += this.results[i] + "\n";
    }
    String filename = "iterative-";
    Date date = new Date();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd-hh-mm-ss");
    filename += format.format(date) + ".csv";
    logfile = new FileUtility(filename);
    logfile.writeFile(filename, msg);
    msg = "";
    for (int i = 0; i < this.results.length; i++) {
      msg += this.rresults[i] + "\n";
    }
    String filename2 = "recursive-";
    filename2 += format.format(date) + ".csv";
    logfile = new FileUtility(filename2);
    logfile.writeFile(filename2, msg);
    //
    String temp1 = "";
    String temp2 = "";
    for (int x = 0; x < this.itimes.length; x++) {
      for (int y = 0; y < this.itimes[x].length; y++) {
        temp1 += this.itimes[x][y] + ",";
      }
      temp1 += "\n";
    }
    for (int x = 0; x < this.rtimes.length; x++) {
      for (int y = 0; y < this.rtimes[x].length; y++) {
        temp2 += this.rtimes[x][y] + ",";
      }
      temp2 += "\n";
    }
    String filename3 = "itimes-";
    filename3 += format.format(date) + ".csv";
    logfile = new FileUtility(filename3);
    logfile.writeFile(filename3, temp1);
    String filename4 = "rtimes-";
    filename4 += format.format(date) + ".csv";
    logfile = new FileUtility(filename4);
    logfile.writeFile(filename4, temp2);
    //
    statusLabel.setText("Results written to logs: " + filename + ", " + filename2);
  }
  private void getReport() {
    if (this.sortset == null) {
      return;
    }
    GenerateReport report = new GenerateReport(this.sizes, this.carr, this.tarr);
    GenerateReport rreport = new GenerateReport(this.sizes, this.rcarr, this.rtarr);
    String[][] strarr = report.getReport();
    String[][] rstrarr = rreport.getReport();
    String[] cols = {"Size","Avg Count","Coef Count","Avg Time","Coef Time"};
    JTable table = new JTable(strarr, cols);
    JTable rtable = new JTable(rstrarr, cols);
    JPanel panel = new JPanel();
    panel.setSize(800, 500);
    panel.add(table);
    panel.add(rtable);
    JOptionPane.showMessageDialog(null, panel);
  }
  
  public void run() {
    System.out.println("run()");
  }
  
  public static void main(String[] args) {
    BenchmarkSorts bench = new BenchmarkSorts();
    bench.displayGUI();
    
    Thread thread = new Thread(bench);
    thread.start();
  }
}
