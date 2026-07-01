package uef.edu.vn.model;

import uef.edu.vn.enums.RoleName;

public class Role {
    private Long id;
    private RoleName roleName;
    private String description;

    public Role() {}

    public Role(Long id, RoleName roleName) {
        this.id = id;
        this.roleName = roleName;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public RoleName getRoleName() { return roleName; }
    public void setRoleName(RoleName roleName) { this.roleName = roleName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}