package del.alstrudat;

import java.util.Scanner;

public class App {
  public static void main(String[] args) {
    Scanner scanner = new Scanner(System.in);

    // Input name and age from the user
    String name = scanner.nextLine();
    String age = scanner.nextLine();

    Program.printInfo(name, Integer.parseInt(age));
    scanner.close();
  }
}
