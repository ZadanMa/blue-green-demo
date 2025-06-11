package com.example.demo.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class UnifiedController {

    private static final String ACCESS_TOKEN = "dev123";
    private static final String VERSION_COOKIE = "APP_VERSION_TOKEN";

    @Value("${app.version:blue}")
    private String currentVersion;

    @GetMapping("/")
    public String rootRedirect() {
        return "redirect:/info";
    }

    @GetMapping("/info")
    public String getInfo(
            @CookieValue(name = VERSION_COOKIE, defaultValue = "") String token
    ) {
        return shouldShowGreen(token) ? "green-template" : "blue-template";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/auth")
    public String authenticate(
            @RequestParam("token") String token,
            HttpServletResponse response
    ) {
        if (ACCESS_TOKEN.equals(token)) {
            Cookie cookie = new Cookie(VERSION_COOKIE, token);
            cookie.setPath("/");
            cookie.setMaxAge(3600);
            response.addCookie(cookie);
            return "redirect:/info";
        } else {
            return "redirect:/login?error=invalid_token";
        }
    }

    // Endpoints para pruebas en desarrollo
    @GetMapping("/switch-blue")
    public String switchBlue(HttpServletResponse response) {
        response.addCookie(new Cookie(VERSION_COOKIE, ""));
        return "redirect:/info";
    }

    @GetMapping("/switch-green")
    public String switchGreen(HttpServletResponse response) {
        Cookie cookie = new Cookie(VERSION_COOKIE, ACCESS_TOKEN);
        cookie.setPath("/");
        response.addCookie(cookie);
        return "redirect:/info";
    }

    private boolean shouldShowGreen(String token) {
        return ACCESS_TOKEN.equals(token) || "green".equals(currentVersion);
    }
}