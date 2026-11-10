package com.interview.unitconverter.models;

public class Unit {
    private final String id;
    private final String name;
    private final String symbol;
    private final double toBaseFactor;

    public Unit(String id, String name, String symbol, double toBaseFactor) {
        this.id = id;
        this.name = name;
        this.symbol = symbol;
        this.toBaseFactor = toBaseFactor;
    }

    public String getId() { return id; }
    public String getName() { return name; }
    public String getSymbol() { return symbol; }
    public double getToBaseFactor() { return toBaseFactor; }

    @Override
    public String toString() {
        return name + " (" + symbol + ")";
    }
}
