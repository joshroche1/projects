package net.jar.quarkus.webapp;

import java.util.List;

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
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;

import org.jboss.logging.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import io.quarkus.panache.common.Sort;

@Path("user")
@ApplicationScoped
public class UserResource {
  
  private static final Logger LOGGER = Logger.getLogger(UserResource.class.getName());
  
  @GET
  @Produces(MediaType.APPLICATION_JSON)
  public List<UserEntity> get() {
    return UserEntity.listAll(Sort.by("id"));
  }
  
  @GET
  @Path("{id}")
  @Produces(MediaType.APPLICATION_JSON)
  public UserEntity getUser(Long id) {
    UserEntity entity = UserEntity.findById(id);
    if (entity == null) {
      throw new WebApplicationException("User with id of " + id + " does not exist.", 404);
    }
    return entity;
  }
  
  @POST
  @Consumes(MediaType.APPLICATION_JSON)
  @Transactional
  public Response create(UserEntity entity) {
    if (entity.id != null) {
      throw new WebApplicationException("Id invalidly set on request.", 422);
    }
    entity.persist();
    return Response.ok(entity).status(201).build();
  }
  
  @PUT
  @Path("{id}")
  @Produces(MediaType.APPLICATION_JSON)
  @Consumes(MediaType.APPLICATION_JSON)
  @Transactional
  public UserEntity update(Long id, UserEntity updatedEntity) {
    UserEntity entity = UserEntity.findById(id);
    if (entity == null) {
      throw new WebApplicationException("User with id of " + id + " does not exist.", 404);
    }
    entity.username = updatedEntity.username;
    entity.password = updatedEntity.password;
    entity.role = updatedEntity.role;
    entity.email = updatedEntity.email;
    entity.persist();
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
