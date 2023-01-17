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

import org.jboss.resteasy.reactive.RestCookie;
import org.jboss.resteasy.reactive.RestForm;
import org.jboss.resteasy.reactive.RestHeader;
import org.jboss.resteasy.reactive.RestMatrix;
import org.jboss.resteasy.reactive.RestPath;
import org.jboss.resteasy.reactive.RestQuery;

import org.hibernate.Query;
import org.jboss.logging.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@Path("users")
@ApplicationScoped
@Produces("application/json")
@Consumes("application/json")
public class UserResource {

  private static final Logger LOGGER = Logger.getLogger(UserResource.class.getName());

  @Inject
  EntityManager entityManager;

  @GET
  public List<User> get() {
    return entityManager.createNamedQuery("Users.findAll", User.class)
      .getResultList();
  }

  @GET
  @Path("{id}")
  public User getSingle(Integer id) {
    User entity = entityManager.find(User.class, id);
    if (entity == null) {
      throw new WebApplicationException("User with id of " + id + " does not exist.", 404);
      }
    return entity;
  }

  @POST
  @Transactional
  public Response create(User user) {
    if (user.getId() != null) {
      throw new WebApplicationException("Id was invalidly set on request.", 422);
    }

    entityManager.persist(user);
    return Response.ok(user).status(201).build();
  }

  @PUT
  @Path("{id}")
  @Transactional
  public User update(Integer id, User user) {
    if (user.getName() == null) {
      throw new WebApplicationException("User Name was not set on request.", 422);
    }

    User entity = entityManager.find(User.class, id);

    if (entity == null) {
      throw new WebApplicationException("User with id of " + id + " does not exist.", 404);
    }

    entity.setName(user.getName());

    return entity;
  }

  @DELETE
  @Path("{id}")
  @Transactional
  public Response delete(Integer id) {
    User entity = entityManager.getReference(User.class, id);
    if (entity == null) {
      throw new WebApplicationException("User with id of " + id + " does not exist.", 404);
    }
    entityManager.remove(entity);
    return Response.status(204).build();
  }
  
  @POST
  @Path("login")
  @Transactional
  public Object userlogin(User user) {
    if (user.getName() == null) {
      throw new WebApplicationException("User Name was not set on request.", 422);
    }
    System.out.println("USER OBJ: " + user.toString());
    System.out.println("USER NAME: " + user.getName());
    Object entity = entityManager.createNativeQuery("SELECT u FROM User u WHERE u.name = :name", User.class).setParameter("name", user.getName()).getSingleResult();

    if (entity == null) {
      throw new WebApplicationException("User with username of " + user.getName() + " does not exist.", 404);
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
