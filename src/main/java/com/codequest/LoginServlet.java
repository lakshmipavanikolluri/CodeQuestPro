
package com.codequest;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Step 1: Validate input
        if (username == null || password == null
                || username.trim().isEmpty()
                || password.isEmpty()) {

            response.sendRedirect("login.jsp?error=empty");
            return;
        }

        String sql =
            "SELECT id, username, password FROM users WHERE username = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());

            try (ResultSet rs = ps.executeQuery()) {

                // Step 2: Check whether the student exists
                if (rs.next()) {

                    String storedPassword = rs.getString("password");

                    // Step 3: Verify the entered password
                    boolean passwordMatches =
                        PasswordUtil.verifyPassword(password, storedPassword);

                    if (passwordMatches) {

                        // Step 4: Create a student session
                        HttpSession session = request.getSession();
                        session.setAttribute("userId", rs.getInt("id"));
                        session.setAttribute(
                            "username", rs.getString("username"));

                        // Step 5: Open the student dashboard
                        response.sendRedirect("dashboard.jsp");
                        return;
                    }
                }
            }

            // Username not found or password incorrect
            response.sendRedirect("login.jsp?error=invalid");

        } catch (SQLException e) {

            getServletContext().log("Login database error", e);
            response.sendRedirect("login.jsp?error=server");

        } catch (Exception e) {

            getServletContext().log("Password verification error", e);
            response.sendRedirect("login.jsp?error=server");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("login.jsp");
    }
}
