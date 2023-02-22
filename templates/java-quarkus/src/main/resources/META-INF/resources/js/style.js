// Apply classes to html elements with jQuery
$(document).ready(function(){

  /* Base Template */
  
  // Header Navbar
  $("header > nav").addClass("navbar navbar-expand-sm bg-light");
  $("#navbarbrand").addClass("navbar-brand");
  $("header > nav > ul").addClass("navbar-nav");
  $("header > nav > ul > li").addClass("nav-item");
  $("header > nav > ul > li > a").addClass("nav-link");
  // Dropdown
  $("header > nav > ul > li > div").addClass("dropdown");
  $("header > nav > ul > li > div > a").addClass("nav-link dropdown-toggle");
  $("header > nav > ul > li > div > a").attr({"data-bs-toggle":"dropdown","role":"button","aria-expanded":"false"});
  $("header > nav > ul > li > div > ul").addClass("dropdown-menu");
  $("header > nav > ul > li > div > ul > li > a").addClass("dropdown-item");
  $("header > nav > ul > li > div > ul > li > hr").addClass("dropdown-divider");
  
  $("body > #contentsection").addClass("container-fluid");
  
  /* */
  
  /* HTML Components */
  
  $("#deleteuser").addClass("btn btn-danger");
  
  // Forms
  $(":text").addClass("form-control");
  $(":password").addClass("form-control");
  $("#email").addClass("form-control");
  $(":submit").addClass("btn btn-success");
  $(":reset").addClass("btn btn-primary");
  $("form > label").addClass("form-label");
  
  $("table").addClass("table");
  
  /* */
  
  /* Pages */
  
  // Index
  $("body > div > #index").addClass("container");
  $("body > div > #index > div").addClass("card");
  
  // Login
  $("#login").addClass("row");
  $("#login > div").first().addClass("col-3");
  $("#login > div").last().addClass("col-3");
  $("#loginpart").addClass("col-6");
  $("#loginpart > div").addClass("container");
  $("#loginpart > div > div").addClass("card m-3");
  $("#loginpart > div > div > form > div").addClass("m-3");
  
  // User
  $("#usernav").addClass("row card m-3 p-3");
  $("#usernav > div").addClass("col m-3 p-3");
  $("#userlistlink").addClass("btn btn-primary");
  $("#usercreatelink").addClass("btn btn-success");
  $("#userlist").addClass("container");
  $("#userdetail").addClass("btn btn-sm btn-secondary");
  $("#useremail").addClass("btn btn-sm btn-secondary");
  $("#usercreate").addClass("row card m-3 p-3");
  $("#usercreate > div").addClass("m-3 p-3");
  
  /* */
  
  // $().addClass();
  
});