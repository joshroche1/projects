package net.jar.quarkus.webapp;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import io.quarkus.qute.CheckedTemplate;
import io.quarkus.qute.TemplateExtension;
import io.quarkus.qute.TemplateInstance;

@Path("users")
public class UserResource {

    @CheckedTemplate
    static class Templates {
        
        static native TemplateInstance users(List<User> users);
    }

    @GET
    @Produces(MediaType.TEXT_HTML)
    public TemplateInstance get() {
        List<User> users = new ArrayList<>();
        users.add(new User(new BigDecimal(10), "Jim"));
        users.add(new User(new BigDecimal(16), "Bob"));
        users.add(new User(new BigDecimal(30), "Joe"));
        return Templates.users(users);
    }

    /**
     * This template extension method implements the "discountedPrice" computed property.
     */
    @TemplateExtension
    static BigDecimal discountedPrice(User user) {
        return user.price.multiply(new BigDecimal("0.9"));
    }

}
