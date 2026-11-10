package com.interview.unitconverter.models;

import java.util.List;

public class Category {
    private final String id;
    private final String name;
    private final List<Unit> units;
    private final boolean allowNegative;

    public Category(String id, String name, List<Unit> units, boolean allowNegative) {
        this.id = id;
        this.name = name;
        this.units = units;
        this.allowNegative = allowNegative;
    }

    public String getId() { return id; }
    public String getName() { return name; }
    public List<Unit> getUnits() { return units; }
    public boolean isAllowNegative() { return allowNegative; }

    @Override
    public String toString() {
        return name;
    }
}
