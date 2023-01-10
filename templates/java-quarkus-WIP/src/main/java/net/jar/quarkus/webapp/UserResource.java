package net.jar.quarkus.webapp;

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
        users.add(new User(1, "Apple"));
        users.add(new User(2, "Pear"));
        users.add(new User(3, "Orange"));
        return Templates.users(users);
    }

}