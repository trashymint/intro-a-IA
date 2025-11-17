import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;

public class RedBayesiana {

    private final Map<String, VariableNode> nodes = new LinkedHashMap<>();

    public VariableNode getOrCreateNode(String name) {
        return nodes.computeIfAbsent(name, VariableNode::new);
    }

    public Collection<VariableNode> getNodes() {
        return nodes.values();
    }

    /**
     * Agrega una arista Padre -> Hijo
     */
    public void addEdge(String parentName, String childName) {
        VariableNode parent = getOrCreateNode(parentName);
        VariableNode child = getOrCreateNode(childName);
        child.addParent(parent);
        parent.addChild(child);
    }

    /**
     * Lee la estructura de la red desde un archivo.
     * Formato: cada línea tiene "PADRE HIJO"
     */
    public void loadStructure(Path path) throws IOException {
        List<String> lines = Files.readAllLines(path);
        for (String line : lines) {
            line = line.trim();
            if (line.isEmpty() || line.startsWith("#")) {
                continue;
            }
            String[] parts = line.split("\\s+");
            if (parts.length != 2) {
                throw new IllegalArgumentException("Línea inválida en estructura: " + line);
            }
            String parent = parts[0];
            String child = parts[1];
            addEdge(parent, child);
        }
    }

    /**
     * Imprime la estructura de la red:
     * - lista de nodos con padres e hijos
     */
    public void printStructure() {
        System.out.println("=== ESTRUCTURA DE LA RED BAYESIANA ===");
        for (VariableNode node : nodes.values()) {
            System.out.println(node);
        }
    }

    /**
     * Lee los CPTs desde un archivo con el formato descrito:
     *
     * VARIABLE Nombre
     * DOMAIN v1 v2 ...
     * PARENTS none  --o--  PARENTS P1 P2 ...
     * TABLE
     * valorVar  valorP1  valorP2 ... prob
     * ...
     * END
     */
    public void loadCPTs(Path path) throws IOException {
        List<String> lines = Files.readAllLines(path);

        String currentVar = null;
        List<String> domain = null;
        List<String> parents = null;
        boolean inTable = false;
        tablaProbabilidadCondicional cpt = null;

        for (String rawLine : lines) {
            String line = rawLine.trim();
            if (line.isEmpty() || line.startsWith("#")) {
                continue;
            }

            if (line.startsWith("VARIABLE")) {
                // Cerrar CPT anterior si existía
                if (cpt != null && currentVar != null) {
                    VariableNode node = getOrCreateNode(currentVar);
                    node.setCpt(cpt);
                }

                String[] parts = line.split("\\s+");
                if (parts.length != 2) {
                    throw new IllegalArgumentException("Línea VARIABLE inválida: " + line);
                }
                currentVar = parts[1];
                domain = new ArrayList<>();
                parents = new ArrayList<>();
                inTable = false;
                cpt = null;

            } else if (line.startsWith("DOMAIN")) {
                String[] parts = line.split("\\s+");
                if (parts.length < 2) {
                    throw new IllegalArgumentException("Línea DOMAIN inválida: " + line);
                }
                domain = new ArrayList<>();
                for (int i = 1; i < parts.length; i++) {
                    domain.add(parts[i]);
                }

            } else if (line.startsWith("PARENTS")) {
                String[] parts = line.split("\\s+");
                parents = new ArrayList<>();
                if (parts.length == 2 && parts[1].equalsIgnoreCase("none")) {
                    // sin padres
                } else {
                    for (int i = 1; i < parts.length; i++) {
                        parents.add(parts[i]);
                    }
                }
                // Crear CPT ahora que tenemos variable, dominio y padres
                if (currentVar == null || domain == null) {
                    throw new IllegalStateException(
                        "Se encontró PARENTS antes de VARIABLE o DOMAIN");
                }
                cpt = new tablaProbabilidadCondicional(currentVar, domain, parents);

            } else if (line.equalsIgnoreCase("TABLE")) {
                if (cpt == null) {
                    throw new IllegalStateException("TABLE encontrado antes de definir VARIABLE/DOMAIN/PARENTS");
                }
                inTable = true;

            } else if (line.equalsIgnoreCase("END")) {
                inTable = false;
                // Asignar CPT al nodo
                if (cpt != null && currentVar != null) {
                    VariableNode node = getOrCreateNode(currentVar);
                    node.setCpt(cpt);
                }
                currentVar = null;
                domain = null;
                parents = null;
                cpt = null;

            } else if (inTable) {
                // Línea de tabla: valorVar [valPadre1 valPadre2 ...] prob
                String[] parts = line.split("\\s+");
                if (parts.length < 2) {
                    throw new IllegalArgumentException("Línea de TABLE inválida: " + line);
                }
                String varValue = parts[0];
                double prob;
                int numParents = (parents == null) ? 0 : parents.size();

                if (parts.length != numParents + 2) {
                    throw new IllegalArgumentException(
                        "Línea de TABLE no coincide con número de padres (" +
                                numParents + "): " + line);
                }

                Map<String, String> assignment = new LinkedHashMap<>();
                assignment.put(currentVar, varValue);

                for (int i = 0; i < numParents; i++) {
                    String parentName = parents.get(i);
                    String parentValue = parts[1 + i];
                    assignment.put(parentName, parentValue);
                }

                prob = Double.parseDouble(parts[1 + numParents]);
                cpt.addEntry(assignment, prob);

            } else {
                throw new IllegalArgumentException("Línea inesperada: " + line);
            }
        }

        // Por si quedó una CPT sin cerrar al final del archivo
        if (cpt != null && currentVar != null) {
            VariableNode node = getOrCreateNode(currentVar);
            node.setCpt(cpt);
        }
    }

    /**
     * Imprime todas las tablas de probabilidad
     */
    public void printCPTs() {
        System.out.println("=== TABLAS DE PROBABILIDAD (CPTs) ===");
        for (VariableNode node : nodes.values()) {
            if (node.getCpt() != null) {
                System.out.println(node.getCpt());
            } else {
                System.out.println("No hay CPT definida para nodo: " + node.getName());
            }
        }
    }
}
