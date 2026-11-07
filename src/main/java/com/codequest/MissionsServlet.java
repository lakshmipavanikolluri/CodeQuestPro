
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

@WebServlet("/missions")
public class MissionsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check student login
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        response.setContentType("text/html;charset=UTF-8");

        // Retrieve missions from database.
        // Correct answer is deliberately NOT selected.
        String sql = "SELECT id, title, description, category, difficulty, "
                   + "option_a, option_b, option_c, option_d, xp_reward "
                   + "FROM missions ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery();
             PrintWriter out = response.getWriter()) {

            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<meta charset='UTF-8'>");
            out.println("<meta name='viewport' content='width=device-width, initial-scale=1'>");
            out.println("<title>CodeQuest - Missions</title>");

            out.println("<style>");

            out.println("*{box-sizing:border-box}");

            out.println("body{margin:0;padding:25px;font-family:Arial,sans-serif;"
                    + "background:#0f172a;color:#f8fafc}");

            out.println(".container{max-width:1000px;margin:auto}");

            out.println("h1{color:#38bdf8;text-align:center}");

            out.println(".nav{text-align:center;margin:20px 0}");

            out.println(".nav a{display:inline-block;margin:5px;padding:10px 14px;"
                    + "background:#334155;color:#fff;text-decoration:none;border-radius:6px}");

            out.println(".nav a:hover{background:#0284c7}");

            out.println(".card{background:#1e293b;border:1px solid #475569;"
                    + "border-radius:12px;padding:22px;margin:20px 0}");

            out.println(".meta{color:#cbd5e1;font-size:14px}");

            out.println(".option{display:block;margin:12px 0;padding:12px;"
                    + "background:#334155;border-radius:7px;cursor:pointer}");

            out.println(".option input{margin-right:10px}");

            out.println("button{background:#0284c7;color:white;border:0;"
                    + "padding:12px 18px;border-radius:7px;font-weight:bold;cursor:pointer}");

            out.println("button:hover{background:#0369a1}");

            out.println(".message{padding:14px;margin:18px 0;border-radius:8px;font-weight:bold}");

            out.println(".success{background:#14532d;color:#bbf7d0}");

            out.println(".error{background:#7f1d1d;color:#fecaca}");

            out.println(".warning{background:#78350f;color:#fde68a}");

            out.println(".empty{padding:20px;background:#1e293b;border-radius:8px;text-align:center}");

            out.println("</style>");
            out.println("</head>");
            out.println("<body>");

            out.println("<div class='container'>");

            out.println("<h1>CodeQuest Missions</h1>");

            // Navigation
            out.println("<div class='nav'>");
            out.println("<a href='dashboard.jsp'>Dashboard</a>");
            out.println("<a href='missions'>Missions</a>");
            out.println("<a href='leaderboard'>Leaderboard</a>");
            out.println("<a href='logout'>Logout</a>");
            out.println("</div>");

            // Display answer submission messages
            String result = request.getParameter("result");

            if ("correct".equals(result)) {

                String xp = request.getParameter("xp");

                if (xp != null && xp.matches("\\d+")) {
                    out.println("<div class='message success'>"
                            + "Correct answer! You earned " + xp + " XP."
                            + "</div>");
                } else {
                    out.println("<div class='message success'>"
                            + "Correct answer! XP awarded.</div>");
                }

            } else if ("wrong".equals(result)) {

                out.println("<div class='message error'>"
                        + "Incorrect answer. No XP awarded.</div>");

            } else if ("duplicate".equals(result)) {

                out.println("<div class='message warning'>"
                        + "You have already submitted an answer for this mission."
                        + " XP cannot be awarded twice.</div>");

            } else if ("invalid".equals(result)) {

                out.println("<div class='message error'>"
                        + "Invalid mission or answer. Please try again.</div>");

            } else if ("notfound".equals(result)) {

                out.println("<div class='message error'>"
                        + "Mission not found.</div>");

            } else if ("server".equals(result)) {

                out.println("<div class='message error'>"
                        + "A server error occurred. Please check the Eclipse Console."
                        + "</div>");
            }

            boolean hasMissions = false;

            // Display all available missions
            while (rs.next()) {

                hasMissions = true;

                int id = rs.getInt("id");

                String title = rs.getString("title");
                String description = rs.getString("description");
                String category = rs.getString("category");
                String difficulty = rs.getString("difficulty");

                String optionA = rs.getString("option_a");
                String optionB = rs.getString("option_b");
                String optionC = rs.getString("option_c");
                String optionD = rs.getString("option_d");

                int xpReward = rs.getInt("xp_reward");

                out.println("<div class='card'>");

                out.println("<h2>" + escapeHtml(title) + "</h2>");

                out.println("<p>" + escapeHtml(description) + "</p>");

                out.println("<p class='meta'>Category: "
                        + escapeHtml(category)
                        + " | Difficulty: "
                        + escapeHtml(difficulty)
                        + " | XP Reward: "
                        + xpReward + "</p>");

                // Answer submission form
                out.println("<form action='submit-answer' method='post'>");

                out.println("<input type='hidden' name='missionId' value='"
                        + id + "'>");

                out.println("<p><strong>Select your answer:</strong></p>");

                printOption(out, "A", optionA);
                printOption(out, "B", optionB);
                printOption(out, "C", optionC);
                printOption(out, "D", optionD);

                out.println("<button type='submit'>Submit Answer</button>");

                out.println("</form>");

                out.println("</div>");
            }

            // If there are no missions
            if (!hasMissions) {

                out.println("<div class='empty'>");

                out.println("<h2>No missions available yet</h2>");

                out.println("<p>Please check back after the administrator adds missions.</p>");

                out.println("</div>");
            }

            out.println("</div>");

            out.println("</body>");
            out.println("</html>");

        } catch (SQLException e) {

            getServletContext().log("Unable to load missions", e);

            if (!response.isCommitted()) {
                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to load missions. Check the server log.");
            }
        }
    }

    // Display an individual answer option
    private void printOption(PrintWriter out,
                             String letter,
                             String optionText) {

        out.println("<label class='option'>");

        out.println("<input type='radio' name='answer' value='"
                + letter + "' required>");

        out.println("<strong>" + letter + ".</strong> ");

        out.println(escapeHtml(optionText));

        out.println("</label>");
    }

    // Escape HTML to prevent HTML injection
    private String escapeHtml(String value) {

        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }
}
