package net.jar.quarkus.webapp;

import java.math.BigDecimal;

public class User {

    public final BigDecimal price;
    public final String name;

    public User(BigDecimal price, String name) {
        this.price = price;
        this.name = name;
    }

}