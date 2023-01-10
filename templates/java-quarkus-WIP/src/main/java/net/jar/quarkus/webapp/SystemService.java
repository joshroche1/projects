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
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import org.jboss.logging.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@Path("systems")
@ApplicationScoped
@Produces("application/json")
@Consumes("application/json")
public class SystemService {
  
  private static final Logger LOGGER = Logger.getLogger(SystemService.class.getName());
  
  @Inject
  EntityManager em;
  
  @GET
  public List<System> get() {
    List<System> systems = em.createQuery("SELECT id,hostname,ipaddress FROM System").getResultList();
    return systems;
  }
  
  @GET
  @Path("{id}")
  public System getSingle(Integer id) {
    System entity = em.find(System.class, id);
    if (entity == null) {
      throw new WebApplicationException("System with id of " + id + " does not exist", 404);
    }
    return entity;
  }
  
  @POST
  @Transactional
  public Response create(System system) {
    if (system.getId() != null) {
      throw new WebApplicationException("Id was invalidly set on request.", 422);
    }
    em.persist(system);
    return Response.ok(system).status(201).build();
  }
  
  @PUT
  @Path("{id}")
  @Transactional
  public System update(Integer id, System system) {
    System entity = em.find(System.class, id);
    if (entity == null) {
      throw new WebApplicationException("System with id of " + id + " does not exist.", 404);
    }
    entity.setHostname(system.getHostname());
    entity.setIpaddress(system.getIpaddress());
    em.persist(entity);
    return entity;
  }
  
  @DELETE
  @Path("{id}")
  @Transactional
  public Response delete(Integer id) {
    System entity = em.getReference(System.class, id);
    if (entity == null) {
      throw new WebApplicationException("System with id of " + id + " does not exist.", 404);
    }
    em.remove(entity);
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
