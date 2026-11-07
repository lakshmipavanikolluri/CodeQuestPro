
package com.codequest;

import java.io.IOException;
import java.io.PrintWriter;
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

@WebServlet("/leaderboard")
public class LeaderboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        response.setContentType("text/html;charset=UTF-8");

        String sql =
                "SELECT username, total_xp, player_level " +
                "FROM users " +
                "ORDER BY total_xp DESC, username ASC";

        try (PrintWriter out = response.getWriter();
             Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            out.println("<!DOCTYPE html><html><head>");
            out.println("<meta charset='UTF-8'>");
            out.println("<meta name='viewport' content='width=device-width, initial-scale=1'>");
            out.println("<title>CodeQuest Leaderboard</title>");

            out.println("<style>");
            out.println("body{font-family:Arial;background:#0f172a;color:#f8fafc;padding:25px}");
            out.println(".container{max-width:850px;margin:auto;background:#1e293b;padding:25px;border-radius:12px}");
            out.println("h1{text-align:center;color:#38bdf8}");
            out.println("table{width:100%;border-collapse:collapse;margin-top:20px}");
            out.println("th,td{padding:13px;text-align:left;border-bottom:1px solid #475569}");
            out.println("th{background:#0284c7}");
            out.println("a{color:#38bdf8;margin-right:15px}");
            out.println("</style></head><body>");

            out.println("<div class='container'>");
            out.println("<h1>CodeQuest Leaderboard</h1>");
            out.println("<p>See how students rank by experience points.</p>");
            out.println("<p><a href='dashboard.jsp'>Dashboard</a>");
            out.println("<a href='missions'>Missions</a>");
            out.println("<a href='logout'>Logout</a></p>");

            out.println("<table>");
            out.println("<tr><th>Rank</th><th>Username</th>"
                    + "<th>Total XP</th><th>Level</th></tr>");

            int rank = 1;

            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rank++ + "</td>");
                out.println("<td>" + escapeHtml(rs.getString("username")) + "</td>");
                out.println("<td>" + rs.getInt("total_xp") + "</td>");
                out.println("<td>" + rs.getInt("player_level") + "</td>");
                out.println("</tr>");
            }

            out.println("</table></div></body></html>");

        } catch (SQLException e) {
            getServletContext().log("Leaderboard database error", e);

            if (!response.isCommitted()) {
                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to load the leaderboard.");
            }
        }
    }

    private String escapeHtml(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }
}
