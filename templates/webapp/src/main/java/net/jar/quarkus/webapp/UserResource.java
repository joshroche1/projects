package net.jar.quarkus.webapp;

import java.util.List;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.transaction.Transactional;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import org.hibernate.Query;
import org.jboss.logging.Logger;
import io.quarkus.panache.common.Sort;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@Path("users")
@ApplicationScoped
@Produces("application/json")
@Consumes("application/json")
public class UserResource {

  private static final Logger LOGGER = Logger.getLogger(UserResource.class.getName());

  @GET
  public List<UserEntity> get() {
    return UserEntity.listAll(Sort.by("name"));
  }
  
  @GET
  @Path("{id}")
  public UserEntity getSingle(Long id) {
    UserEntity entity = UserEntity.findById(id);
    if (entity == null) {
      throw new WebApplicationException("User with id of " + id + " does not exist.", 404);
    }
    return entity;
  }
  
  @POST
  @Transactional
  public Response create(UserEntity user) {
    if (user.id != null) {
      throw new WebApplicationException("Id was invalidly set on request.", 422);
    }
    user.persist();
    return Response.ok(user).status(201).build();
  }
  
  @PUT
  @Path("{id}")
  @Transactional
  public UserEntity update(Long id, UserEntity user) {
    if (user.name == null) {
      throw new WebApplicationException("User Name was not set on request.", 422);
    }

    UserEntity entity = UserEntity.findById(id);

    if (entity == null) {
      throw new WebApplicationException("User with id of " + id + " does not exist.", 404);
    }

    entity.name = user.name;
    entity.email = user.email;
    entity.password = user.password;

    return entity;
  }
  
  @DELETE
  @Path("{id}")
  @Transactional
  public Response delete(Long id) {
    UserEntity entity = UserEntity.findById(id);
    if (entity == null) {
      throw new WebApplicationException("User with id of " + id + " does not exist.", 404);
    }
    entity.delete();
    return Response.status(204).build();
  }

  @POST
  @Path("login")
  @Transactional
  public UserEntity userlogin(UserEntity user) {
    if (user.name == null) {
      throw new WebApplicationException("User Name was not set on request.", 422);
    }
    UserEntity entity = UserEntity.findByName(user.name);

    if (entity == null) {
      throw new WebApplicationException("User with username of " + user.name + " does not exist.", 404);
    }

    return entity;
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
