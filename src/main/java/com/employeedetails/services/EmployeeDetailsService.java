package com.employeedetails.services;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.StringWriter;
import java.util.Scanner;
import java.util.regex.Pattern;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.employeedetails.constants.EmployeeDetailsConstants;
import com.employeedetails.jaxb.request.EmployeeDetails;
import com.employeedetails.jaxb.response.Deductions;
import com.employeedetails.jaxb.response.EmployeeResponse;
import com.employeedetails.jaxb.response.EmployeeSalary;

public class EmployeeDetailsService {

	static final Logger logger = Logger.getLogger(EmployeeDetailsService.class);
	
	public static EmployeeResponse processEmployeeDetails(JAXBContext jaxbContext, EmployeeDetails employeeDetails) {	

		String employeeId = employeeDetails.getEmployeeParticulars().getId();
		EmployeeResponse employeeResponse = new EmployeeResponse();
		EmployeeSalary employeeSalary;
		
		StringWriter requestWriter = new StringWriter();
		StringWriter responseWriter = new StringWriter();
		String employeeDetailsRequest = EmployeeDetailsConstants.EMPTY;
		String employeeDetailsResponse = EmployeeDetailsConstants.EMPTY;
		Marshaller marshaller = null;

		try {
			marshaller = jaxbContext.createMarshaller();
			marshaller.marshal(employeeDetails, requestWriter);
		} catch (JAXBException e) {
			
			logger.info(EmployeeDetailsConstants.JAXB_EXCEPTION_MESSAGE);
		}
		
		employeeDetailsRequest = requestWriter.toString();
		
		//Logging employeeDetails request XML string
		logger.info(EmployeeDetailsConstants.REQUEST_XML + employeeDetailsRequest);

		if (!StringUtils.isEmpty(employeeId)) {

			employeeSalary = calculateDeductions(employeeDetails, employeeId);
			employeeResponse.setName(EmployeeDetailsConstants.EMPLOYEE_TYPE);
			employeeResponse.setEmployeeSalary(employeeSalary);
		}
		
		try {
			
			marshaller.marshal(employeeResponse, responseWriter);
		} catch (JAXBException e) {

			logger.info(EmployeeDetailsConstants.JAXB_EXCEPTION_MESSAGE);
		}
		
		employeeDetailsResponse = responseWriter.toString();
		
		//Logging employeeResponse response XML string
		logger.info(EmployeeDetailsConstants.RESPONSE_XML + employeeDetailsResponse);
		
		return employeeResponse;
	}

	/**
	 * Method to calculate the deductions and totalPay
	 * @param employeeDetails
	 * @param employeeId
	 * @return employeeSalary
	 */
	public static EmployeeSalary calculateDeductions(EmployeeDetails employeeDetails, String employeeId) {

		String employeeType = employeeDetails.getName();
		EmployeeSalary employeeSalary = new EmployeeSalary();

		if (employeeType.equalsIgnoreCase(EmployeeDetailsConstants.EMPLOYEE_TYPE)) {

			String basicPay = employeeDetails.getEmployeeParticulars().getSalaryInformation().getBasicPay();
			String hraPay = employeeDetails.getEmployeeParticulars().getSalaryInformation().getHraPay();
			String daPay = employeeDetails.getEmployeeParticulars().getSalaryInformation().getDaPay();
			int totalEarning = 0;

			if (!(StringUtils.isEmpty(basicPay)) && !(StringUtils.isEmpty(hraPay)) 
					&& !(StringUtils.isEmpty(daPay))) {

				totalEarning = Integer.parseInt(basicPay) + Integer.parseInt(hraPay) + Integer.parseInt(daPay);
			}

			int facilitiesCharge = EmployeeDetailsConstants.FACILITIES_CHARGE;
			int taxAmount = 0;

			if (totalEarning > EmployeeDetailsConstants.TAXABLE_LIMIT_PERMONTH) {

				taxAmount = (totalEarning * EmployeeDetailsConstants.TAX_RATE) / 100;
			}

			int totalDeductions = facilitiesCharge + taxAmount;
			int totalPayout = totalEarning - totalDeductions;

			Deductions deductions = new Deductions();
			deductions.setFacilities(Integer.valueOf(facilitiesCharge).toString());
			deductions.setTax(Integer.valueOf(taxAmount).toString());
			deductions.setDeductionsTotal(Integer.valueOf(totalDeductions).toString());		

			employeeSalary.setId(employeeId);
			employeeSalary.setEarningsTotal(Integer.valueOf(totalEarning).toString());
			employeeSalary.setDeductions(deductions);
			employeeSalary.setTotalPayout(Integer.valueOf(totalPayout).toString());
		}
		
		return employeeSalary;
	}
	
	

	
	
}
