
package com.codequest;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Opening /register directly should display the registration page.
        response.sendRedirect("register.jsp");
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate required fields.
        if (username == null || email == null || password == null
                || username.trim().isEmpty()
                || email.trim().isEmpty()
                || password.isBlank()) {

            response.sendRedirect("register.jsp?error=empty");
            return;
        }

        username = username.trim();
        email = email.trim();

        // Validate input lengths.
        if (username.length() > 50
                || email.length() > 100
                || password.length() < 8
                || password.length() > 128) {

            response.sendRedirect("register.jsp?error=invalid");
            return;
        }

        // Store a secure password hash, never the plain password.
        String sql = "INSERT INTO users "
                + "(username, email, password, total_xp, player_level) "
                + "VALUES (?, ?, ?, 0, 1)";

        try {
            String hashedPassword =
                    PasswordUtil.hashPassword(password);

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, hashedPassword);

                int rowsInserted = ps.executeUpdate();

                if (rowsInserted == 1) {
                    response.sendRedirect("login.jsp?registered=1");
                } else {
                    response.sendRedirect("register.jsp?error=server");
                }
            }

        } catch (SQLException e) {

            // Duplicate username/email or another integrity constraint.
            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect("register.jsp?error=duplicate");
            } else {
                getServletContext().log(
                        "Registration database error", e);

                response.sendRedirect("register.jsp?error=server");
            }

        } catch (Exception e) {

            getServletContext().log(
                    "Registration password hashing error", e);

            response.sendRedirect("register.jsp?error=server");
        }
    }
}
