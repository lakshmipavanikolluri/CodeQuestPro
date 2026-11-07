
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

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null
                || username.isBlank() || password.isEmpty()) {
            response.sendRedirect("admin-login.jsp?error=invalid");
            return;
        }

        String sql =
        		 "SELECT id, username FROM admins " +
        				    "WHERE username = ? AND password = ?";
           

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    HttpSession session = request.getSession();

                    session.setAttribute("adminId", rs.getInt("id"));
                    session.setAttribute("adminUsername",
                                         rs.getString("username"));

                    response.sendRedirect("admin-dashboard.jsp");
                    return;
                }
            }

            response.sendRedirect("admin-login.jsp?error=invalid");

        } catch (SQLException e) {
            getServletContext().log("Admin login database error", e);
            response.sendRedirect("admin-login.jsp?error=server");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("admin-login.jsp");
    }
}
