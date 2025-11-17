import java.util.*;

public class tablaProbabilidadCondicional {

    /**
     * Representa una asignación específica de (variable + padres),
     * por ejemplo: {Alarma=true, Robo=true, Terremoto=false}
     */
    public static class AssignmentKey {
        private final Map<String, String> assignments;

        public AssignmentKey(Map<String, String> assignments) {
            // Clonamos para seguridad
            this.assignments = new LinkedHashMap<>(assignments);
        }

        public Map<String, String> getAssignments() {
            return assignments;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof AssignmentKey)) return false;
            AssignmentKey that = (AssignmentKey) o;
            return Objects.equals(assignments, that.assignments);
        }

        @Override
        public int hashCode() {
            return Objects.hash(assignments);
        }

        @Override
        public String toString() {
            StringBuilder sb = new StringBuilder();
            boolean first = true;
            for (Map.Entry<String, String> e : assignments.entrySet()) {
                if (!first) sb.append(", ");
                sb.append(e.getKey()).append("=").append(e.getValue());
                first = false;
            }
            return sb.toString();
        }
    }

    private final String variableName;
    private final List<String> domain;       // valores posibles de la variable
    private final List<String> parents;      // nombres de los padres
    private final Map<AssignmentKey, Double> table = new LinkedHashMap<>();

    public tablaProbabilidadCondicional(String variableName,
                                       List<String> domain,
                                       List<String> parents) {
        this.variableName = variableName;
        this.domain = new ArrayList<>(domain);
        this.parents = new ArrayList<>(parents);
    }

    public String getVariableName() {
        return variableName;
    }

    public List<String> getDomain() {
        return domain;
    }

    public List<String> getParents() {
        return parents;
    }

    public void addEntry(Map<String, String> assignment, double probability) {
        AssignmentKey key = new AssignmentKey(assignment);
        table.put(key, probability);
    }

    public Map<AssignmentKey, Double> getTable() {
        return table;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("CPT de ").append(variableName).append("\n");
        sb.append("  Dominio: ").append(domain).append("\n");
        sb.append("  Padres: ").append(parents.isEmpty() ? "ninguno" : parents).append("\n");
        sb.append("  Entradas:\n");
        for (Map.Entry<AssignmentKey, Double> e : table.entrySet()) {
            sb.append("    P(").append(variableName)
              .append("=").append(e.getKey().getAssignments().get(variableName))
              .append(" | ");
            boolean first = true;
            for (String p : parents) {
                if (!first) sb.append(", ");
                sb.append(p).append("=")
                  .append(e.getKey().getAssignments().get(p));
                first = false;
            }
            if (parents.isEmpty()) {
                sb.append("(sin padres)");
            }
            sb.append(") = ").append(e.getValue()).append("\n");
        }
        return sb.toString();
    }
}
