package net.jar.quarkus.webapp;

import java.util.List;

import jakarta.annotation.security.PermitAll;
import jakarta.annotation.security.RolesAllowed;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.PUT;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.FormParam;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.UriInfo;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;

import org.jboss.logging.Logger;

import org.eclipse.microprofile.config.inject.ConfigProperty;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import io.quarkus.panache.common.Sort;
import io.quarkus.qute.CheckedTemplate;
import io.quarkus.qute.TemplateInstance;
import io.smallrye.common.annotation.Blocking;
import io.vertx.core.http.HttpServerResponse;

@Path("/")
@ApplicationScoped
public class PublicResource {
  
  private static final Logger LOGGER = Logger.getLogger(PublicResource.class.getName());
  
  @ConfigProperty(name = "quarkus.http.auth.form.cookie-name")
  String cookieName;
    
  @Inject
  UriInfo uriInfo;
  
  @CheckedTemplate
  static class Templates {
    static native TemplateInstance index();
    static native TemplateInstance login();
    static native TemplateInstance error();
    static native TemplateInstance home(List<UserEntity> userlist);
  }
  
  @GET
  @Path("/")
  @PermitAll
  @Produces(MediaType.TEXT_HTML)
  public TemplateInstance index() {
    return Templates.index();
  }
  
  @GET
  @Path("/login")
  @PermitAll
  @Produces(MediaType.TEXT_HTML)
  public TemplateInstance login() {
    return Templates.login();
  }
  
  @GET
  @Path("/logout")
  @PermitAll
  public TemplateInstance logout(HttpServerResponse response) {
    response.removeCookie(cookieName, true);
    return Templates.login();
  }
  
  @GET
  @Path("/error")
  @PermitAll
  @Produces(MediaType.TEXT_HTML)
  public TemplateInstance error() {
    return Templates.error();
  }
  
  @GET
  @Path("/home")
  @RolesAllowed("user")
  @Produces(MediaType.TEXT_HTML)
  @Blocking
  public TemplateInstance home() {
    List<UserEntity> userlist = UserEntity.listAll(Sort.by("id"));
    return Templates.home(userlist);
  }
  
  @POST
  @Path("/home")
  @RolesAllowed("user")
  @Produces(MediaType.TEXT_HTML)
  @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
  @Transactional
  public TemplateInstance home_add_user(@FormParam("username") String username, @FormParam("password") String password, @FormParam("email") String email, @FormParam("role") String role) {
    UserEntity usernamecheck = UserEntity.findByUsername(username);
    if (usernamecheck != null) {
      throw new WebApplicationException("User with username of " + username + " already exists.", 404);
    }
    UserEntity emailcheck = UserEntity.findByEmail(email);
    if (emailcheck != null) {
      throw new WebApplicationException("User with email of " + email + " already exists.", 404);
    }
    UserEntity.add(username,password,role,email);
    List<UserEntity> userlist = UserEntity.listAll(Sort.by("id"));
    return Templates.home(userlist);
  }
  
  @POST
  @Path("/home/{id}/delete")
  @RolesAllowed("user")
  @Produces(MediaType.TEXT_HTML)
  @Transactional
  public TemplateInstance home_delete_user(@PathParam("id") Long id) {
    UserEntity entity = UserEntity.findById(id);
    if (entity == null) {
      throw new WebApplicationException("User with id of " + id + " does not exist.", 404);
    }
    entity.delete();
    List<UserEntity> userlist = UserEntity.listAll(Sort.by("id"));
    return Templates.home(userlist);
  }
  
  @Provider
  public static class ErrorMapper implements ExceptionMapper<Exception> {

    @Inject
    ObjectMapper objectMapper;

    @Override
    public Response toResponse(Exception exception) {
      LOGGER.error("Failed to handle request", exception);

      int code = 500;
      if (exception instanceof WebApplicationException) {
        code = ((WebApplicationException) exception).getResponse().getStatus();
      }

      ObjectNode exceptionJson = objectMapper.createObjectNode();
      exceptionJson.put("exceptionType", exception.getClass().getName());
      exceptionJson.put("code", code);

      if (exception.getMessage() != null) {
        exceptionJson.put("error", exception.getMessage());
      }

      return Response.status(code)
        .entity(exceptionJson)
        .build();
    }
  }
  
}
