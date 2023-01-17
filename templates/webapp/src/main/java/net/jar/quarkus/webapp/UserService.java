package net.jar.quarkus.webapp;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.POST;
import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import io.quarkus.qute.CheckedTemplate;
import io.quarkus.qute.TemplateExtension;
import io.quarkus.qute.TemplateInstance;

@Path("users")
public class UserService {

  @CheckedTemplate
  static class Templates {
    static native TemplateInstance list(List<User> testusers);
  }

  @GET
  @Path("list")
  @Produces(MediaType.TEXT_HTML)
  public TemplateInstance get() {
    List<User> testusers = new ArrayList<>();
    testusers.add(new User("Jim", "jim@bob.joe", "JimBobJoe"));
    testusers.add(new User("Bob", "bob@joe.jim", "bobJOEjim"));
    testusers.add(new User("Joe", "joe@jim.bob", "jOEjIMbOB"));
    return Templates.list(testusers);
  }

  /**
   * This template extension method implements the "discountedPrice" computed property.
   *
  @TemplateExtension
  static BigDecimal discountedPrice(User user) {
    return user.price.multiply(new BigDecimal("0.9"));
  }*/

}
