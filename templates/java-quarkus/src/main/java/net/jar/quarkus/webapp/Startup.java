package net.jar.quarkus.webapp;

import jakarta.enterprise.event.Observes;
import jakarta.inject.Singleton;
import jakarta.transaction.Transactional;
import org.jboss.logging.Logger;
import io.quarkus.runtime.StartupEvent;

@Singleton
public class Startup {
  
  private static final Logger LOGGER = Logger.getLogger(Startup.class.getName());
  
  @Transactional
  public void loadDefaults(@Observes StartupEvent evt) {
    // Init objects
    UserEntity.add("admin", "admin", "user", "admin@admin.adm");
    LOGGER.info("Added [UserEntity] Admin");
  }
}