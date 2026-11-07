
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
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddQuestionServlet")
public class AddQuestionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Check Admin session
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        // Get form values
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");

        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");

        String correctAnswer = request.getParameter("correctAnswer");
        String xpValue = request.getParameter("xpReward");

        // Validate empty fields
        if (isEmpty(title) ||
            isEmpty(description) ||
            isEmpty(category) ||
            isEmpty(difficulty) ||
            isEmpty(optionA) ||
            isEmpty(optionB) ||
            isEmpty(optionC) ||
            isEmpty(optionD) ||
            isEmpty(correctAnswer) ||
            isEmpty(xpValue)) {

            response.sendRedirect(
                request.getContextPath()
                + "/add-question.jsp?error=empty");
            return;
        }

        // Validate XP
        int xpReward;

        try {
            xpReward = Integer.parseInt(xpValue);

            if (xpReward < 1) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/add-question.jsp?error=xp");
            return;
        }

        // Validate category, difficulty and correct answer
        if (!("Java".equals(category) ||
              "SQL".equals(category) ||
              "DSA".equals(category))) {

            response.sendRedirect(
                request.getContextPath()
                + "/add-question.jsp?error=invalid");
            return;
        }

        if (!("Easy".equals(difficulty) ||
              "Medium".equals(difficulty) ||
              "Hard".equals(difficulty))) {

            response.sendRedirect(
                request.getContextPath()
                + "/add-question.jsp?error=invalid");
            return;
        }

        if (!("A".equals(correctAnswer) ||
              "B".equals(correctAnswer) ||
              "C".equals(correctAnswer) ||
              "D".equals(correctAnswer))) {

            response.sendRedirect(
                request.getContextPath()
                + "/add-question.jsp?error=invalid");
            return;
        }

        // Insert mission into MySQL
        String sql = "INSERT INTO missions "
                   + "(title, description, category, difficulty, "
                   + "option_a, option_b, option_c, option_d, "
                   + "correct_answer, xp_reward) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title.trim());
            ps.setString(2, description.trim());
            ps.setString(3, category);
            ps.setString(4, difficulty);
            ps.setString(5, optionA.trim());
            ps.setString(6, optionB.trim());
            ps.setString(7, optionC.trim());
            ps.setString(8, optionD.trim());
            ps.setString(9, correctAnswer);
            ps.setInt(10, xpReward);

            int rows = ps.executeUpdate();

            if (rows > 0) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/missions?added=success");

            } else {

                response.sendRedirect(
                    request.getContextPath()
                    + "/add-question.jsp?error=insert");
            }

        } catch (SQLException e) {

            getServletContext().log(
                "Error while adding a new mission", e);

            response.sendRedirect(
                request.getContextPath()
                + "/add-question.jsp?error=database");
        }
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}
