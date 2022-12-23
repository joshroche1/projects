package net.jar.webapp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ViewController {
  
  @Autowired
  private PersonRepository personRepository;

	@RequestMapping(path="/home")
	public String viewHome(Model model) {
    Person p = new Person();
    p.setFirstName("FirstNameTEST");
    p.setLastName("LastNameTEST");
    model.addAttribute("test","TEST123");
    model.addAttribute("testperson",p);
		return "home";
	}
  
  @GetMapping(path="/test")
  public String viewError(Model model) {
    model.addAttribute("test","TestPAGE123!@#");
    return "test";
  }
}
