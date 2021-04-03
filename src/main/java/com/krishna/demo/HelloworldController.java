package com.krishna.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloworldController {
	@GetMapping("/hello")
	public String sayHello() {
		return "Hi From Krishna - version-4.8";
	}

}
