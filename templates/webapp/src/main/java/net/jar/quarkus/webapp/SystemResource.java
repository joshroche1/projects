package net.jar.quarkus.webapp;

import java.util.ArrayList;
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

import org.jboss.logging.Logger;
import io.quarkus.panache.common.Sort;
import io.quarkus.qute.CheckedTemplate;
import io.quarkus.qute.TemplateExtension;
import io.quarkus.qute.TemplateInstance;
import io.smallrye.common.annotation.Blocking;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@Path("systems")
@ApplicationScoped
public class SystemResource {

  private static final Logger LOGGER = Logger.getLogger(SystemResource.class.getName());

  @CheckedTemplate
  static class Templates {
    static native TemplateInstance list(List<System> testsystems);
  }

  @GET
  @Produces(MediaType.APPLICATION_JSON)
  public List<System> get() {
    return System.listAll(Sort.by("hostname"));
  }

  @GET
  @Produces(MediaType.APPLICATION_JSON)
  @Path("{id}")
  public System getSingle(Long id) {
    System entity = System.findById(id);
    if (entity == null) {
      throw new WebApplicationException("System with id of " + id + " does not exist.", 404);
    }
    return entity;
  }

  @POST
  @Produces(MediaType.APPLICATION_JSON)
  @Consumes(MediaType.APPLICATION_JSON)
  @Transactional
  public Response create(System system) {
    if (system.id != null) {
      throw new WebApplicationException("Id was invalidly set on request.", 422);
    }
    system.persist();
    return Response.ok(system).status(201).build();
  }

  @PUT
  @Produces(MediaType.APPLICATION_JSON)
  @Consumes(MediaType.APPLICATION_JSON)
  @Path("{id}")
  @Transactional
  public System update(Long id, System system) {
    if (system.hostname == null) {
      throw new WebApplicationException("System Hostname was not set on request.", 422);
    }

    System entity = System.findById(id);

    if (entity == null) {
      throw new WebApplicationException("System with id of " + id + " does not exist.", 404);
    }

    entity.hostname = system.hostname;
    
    return entity;
  }

  @DELETE
  @Consumes(MediaType.APPLICATION_JSON)
  @Path("{id}")
  @Transactional
  public Response delete(Long id) {
    System entity = System.findById(id);
    if (entity == null) {
      throw new WebApplicationException("System with id of " + id + " does not exist.", 404);
    }
    entity.delete();
    return Response.status(204).build();
  }
  
  @GET
  @Path("list")
  @Produces(MediaType.TEXT_HTML)
  @Blocking
  public TemplateInstance list() {
    List<System> testsystems = System.listAll(Sort.by("hostname"));
      //new ArrayList<>();
    //testsystems.add(new System("pgsql","10.0.0.2"));
    //testsystems.add(new System("jarpi4b8","192.168.2.221"));
    //testsystems.add(new System("jaresx","192.168.2.200"));
    return Templates.list(testsystems);
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
