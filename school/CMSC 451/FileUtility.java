/*
 * Joshua A. Roche
 * PROJECT-NAME
 * DD-MMM-YYYY
 * FILENAME
 */
package benchmarksorts;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;
import javax.swing.JOptionPane;

public class FileUtility {
  private String filename;
  private String[][] contents;
  private File file;
  
  public FileUtility(String name) {
    this.filename = name;
  }
  public FileUtility(File file) {
    this.file = file;
    this.contents = new String[10][101];
    this.parseFile();
  }
  
  private void parseFile() {
    try {
      Scanner scnr = new Scanner(this.file);
      scnr.useDelimiter(",\\s*");
      for (int x = 0; x < 10; x++) {
        for (int y = 0; y < 101; y++) {
          while (scnr.hasNext()) {
            this.contents[x][y] = scnr.next();
          }
        }
      }
      scnr.close();
    } catch (IOException iox) {
      JOptionPane.showMessageDialog(null, iox.toString());
    } 
  }
  public boolean writeFile(String name, String text) {
    try {
      File writefile = new File(name);
      if (writefile.createNewFile()) {
        System.out.println("File created: " + name);
      } else {
        System.out.println("Filename already exists");
      }
      FileWriter writer = new FileWriter(name);
      writer.write(text);
      writer.close();
      return true;
    } catch (IOException iox) {
      JOptionPane.showMessageDialog(null, iox.toString());
      return false;
    }
  }
  public String[][] getStringArray() {
    return this.contents;
  }
}
