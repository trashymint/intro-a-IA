import java.util.ArrayList;
import java.util.List;

public class VariableNode {

    private final String name;
    private final List<VariableNode> parents = new ArrayList<>();
    private final List<VariableNode> children = new ArrayList<>();
    private tablaProbabilidadCondicional cpt;

    public VariableNode(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public List<VariableNode> getParents() {
        return parents;
    }

    public List<VariableNode> getChildren() {
        return children;
    }

    public void addParent(VariableNode parent) {
        if (!parents.contains(parent)) {
            parents.add(parent);
        }
    }

    public void addChild(VariableNode child) {
        if (!children.contains(child)) {
            children.add(child);
        }
    }

    public tablaProbabilidadCondicional getCpt() {
        return cpt;
    }

    public void setCpt(tablaProbabilidadCondicional cpt) {
        this.cpt = cpt;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Nodo ").append(name).append("\n");
        sb.append("  Padres: ");
        if (parents.isEmpty()) {
            sb.append("ninguno");
        } else {
            for (int i = 0; i < parents.size(); i++) {
                sb.append(parents.get(i).getName());
                if (i < parents.size() - 1) sb.append(", ");
            }
        }
        sb.append("\n");

        sb.append("  Hijos: ");
        if (children.isEmpty()) {
            sb.append("ninguno");
        } else {
            for (int i = 0; i < children.size(); i++) {
                sb.append(children.get(i).getName());
                if (i < children.size() - 1) sb.append(", ");
            }
        }
        sb.append("\n");

        return sb.toString();
    }
}
