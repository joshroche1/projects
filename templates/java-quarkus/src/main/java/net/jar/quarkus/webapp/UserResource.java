package net.jar.quarkus.webapp;

import java.util.List;
import javax.annotation.security.RolesAllowed;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.transaction.Transactional;
import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.FormParam;
import javax.ws.rs.PathParam;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import org.jboss.logging.Logger;
import io.quarkus.panache.common.Sort;
import io.quarkus.qute.CheckedTemplate;
import io.quarkus.qute.TemplateInstance;
import io.smallrye.common.annotation.Blocking;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;


@Path("user")
@ApplicationScoped
public class UserResource {

  private static final Logger LOGGER = Logger.getLogger(UserResource.class.getName());
  
  @CheckedTemplate
  static class Templates {
    static native TemplateInstance list(List<UserEntity> userlist);
  }
    
  @GET
  @Path("list")
  @RolesAllowed("user")
  @Produces(MediaType.TEXT_HTML)
  @Blocking
  public TemplateInstance list() {
    List<UserEntity> userlist = UserEntity.listAll(Sort.by("username"));
    return Templates.list(userlist);
  }
  
  @POST
  @Path("create/form")
  @RolesAllowed("user")
  @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
  @Produces(MediaType.TEXT_HTML)
  @Transactional
  public TemplateInstance create_form(@FormParam("email") String email, @FormParam("username") String username, @FormParam("password") String password) {
    UserEntity.add(username, password, "user", email);
    List<UserEntity> userlist = UserEntity.listAll(Sort.by("username"));
    return Templates.list(userlist);
  }
  
  @POST
  @Path("delete/form/{id}")
  @RolesAllowed("user")
  @Produces(MediaType.TEXT_HTML)
  @Transactional
  public TemplateInstance delete_form(@PathParam("id") Long id) {
    UserEntity entity = UserEntity.findById(id);
    if (entity == null) {
      throw new WebApplicationException("User with id: " + id + " not found", 404);
    }
    entity.delete();
    List<UserEntity> userlist = UserEntity.listAll(Sort.by("username"));
    return Templates.list(userlist);
  }
  
  /* REST */
  
  @GET
  @Path("all")
//  @RolesAllowed("user")
  @Produces(MediaType.APPLICATION_JSON)
  @Blocking
  public List<UserEntity> all() {
    List<UserEntity> entitylist = UserEntity.listAll(Sort.by("username"));
    return entitylist;
  }
  
  @GET
  @Path("{id}")
//  @RolesAllowed("user")
  @Produces(MediaType.APPLICATION_JSON)
  @Blocking
  public UserEntity get(long id) {
    UserEntity entity = UserEntity.findById(id);
    return entity;
  }
  
  @POST
  @Path("create")
//  @RolesAllowed("user")
  @Consumes(MediaType.APPLICATION_JSON)
  @Produces(MediaType.APPLICATION_JSON)
  @Transactional
  public UserEntity create(UserEntity entity) {
    entity.persist();
    return entity;
  }
  
  @PUT
  @Path("update/{id}")
//  @RolesAllowed("user")
  @Consumes(MediaType.APPLICATION_JSON)
  @Produces(MediaType.APPLICATION_JSON)
  @Transactional
  public UserEntity update(Long id, UserEntity user) {
    UserEntity entity = UserEntity.findById(id);
    if (entity == null) {
      throw new WebApplicationException("User with id: " + id + " not found", 404);
    }
    entity.username = user.username;
    entity.password = user.password;
    entity.role = user.role;
    entity.email = user.email;
    return entity;
  }

  @POST
  @Path("delete/{id}")
//  @RolesAllowed("user")
  @Consumes(MediaType.APPLICATION_JSON)
  @Produces(MediaType.APPLICATION_JSON)
  @Transactional
  public void delete(Long id) {
    UserEntity entity = UserEntity.findById(id);
    if (entity == null) {
      throw new WebApplicationException("User with id: " + id + " not found", 404);
    }
    entity.delete();
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