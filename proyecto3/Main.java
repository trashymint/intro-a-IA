import java.nio.file.Paths;

public class Main {
    public static void main(String[] args) {
        try {
            RedBayesiana bn = new RedBayesiana();

            bn.loadStructure(Paths.get("estructura.txt"));
            bn.printStructure();

            bn.loadCPTs(Paths.get("logica.txt"));
            bn.printCPTs();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
