package com.employeedetails.services;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import javax.xml.bind.JAXBContext;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.employeedetails.constants.EmployeeDetailsConstants;
import com.employeedetails.jaxb.request.EmployeeDetails;
import com.employeedetails.jaxb.response.EmployeeResponse;
import com.sun.jersey.api.view.Viewable;

@Path(EmployeeDetailsConstants.EMPLOYEEDETAIL_CLASSPATH)
public class EmployeeDetail {
	
	private JAXBContext jaxbContext;

	public EmployeeDetail(JAXBContext jaxbContext) {

		this.jaxbContext = jaxbContext;
	}
	
	@POST
	@Path(EmployeeDetailsConstants.EMPLOYEEDETAILSREQUEST_PATH)
	@Consumes(EmployeeDetailsConstants.MEDIATYPE)
	@Produces(EmployeeDetailsConstants.MEDIATYPE)
	public EmployeeResponse employeeDetailsRequest(EmployeeDetails employeeDetails) {
		
		EmployeeResponse employeeResponse = EmployeeDetailsService.processEmployeeDetails(jaxbContext, employeeDetails);
		
		return employeeResponse;
	}
	
/*	@GET
	@Path("home1")
	public Response sendHostStatus() {
		
		String serviceStatus = "up";
		String serviceStatusJSP = "home";
		System.out.println("Executed");
		//model.addAttribute("status", serviceStatus);

		//Returns service status as 'UP' by default
		//return serviceStatusJSP;
		return Response.status(200).entity("statuss").build();
	}*/
	
	
	@GET
	@Path("/home1")
	public Viewable homePage(
	    @Context HttpServletRequest request,
	    @Context HttpServletResponse response) throws Exception
	{
		
		//String serviceStatus = "UP";
		int serviceStatus = 0;
	  request.setAttribute("serviceStatus", serviceStatus);
	  return new Viewable("/WEB-INF/jsp/home.jsp", null);
	}

}