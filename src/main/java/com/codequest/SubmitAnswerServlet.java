
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

@WebServlet("/submit-answer")
public class SubmitAnswerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("missions");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String missionValue = request.getParameter("missionId");
        String answer = request.getParameter("answer");

        int missionId;

        try {
            missionId = Integer.parseInt(missionValue);
        } catch (Exception e) {
            response.sendRedirect("missions?result=invalid");
            return;
        }

        if (answer == null ||
                !answer.matches("(?i)[ABCD]")) {
            response.sendRedirect("missions?result=invalid");
            return;
        }

        answer = answer.toUpperCase();

        String missionSql =
                "SELECT correct_answer, xp_reward " +
                "FROM missions WHERE id = ?";

        String submissionSql =
                "INSERT INTO mission_submissions " +
                "(user_id, mission_id, answer, is_correct, completed_at) " +
                "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";

        String xpSql =
                "UPDATE users SET total_xp = total_xp + ? " +
                "WHERE id = ?";

        String levelSql =
                "UPDATE users SET player_level = " +
                "FLOOR(total_xp / 100) + 1 WHERE id = ?";

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                String correctAnswer;
                int xpReward;

                // Read the answer key and XP reward from the database.
                try (PreparedStatement ps =
                             con.prepareStatement(missionSql)) {

                    ps.setInt(1, missionId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            con.rollback();
                            response.sendRedirect(
                                    "missions?result=notfound");
                            return;
                        }

                        correctAnswer = rs.getString("correct_answer");
                        xpReward = rs.getInt("xp_reward");
                    }
                }

                if (correctAnswer == null ||
                        !correctAnswer.trim().matches("(?i)[ABCD]")) {
                    throw new SQLException(
                            "Mission has an invalid correct_answer value.");
                }

                boolean isCorrect =
                        answer.equalsIgnoreCase(correctAnswer.trim());

                // Insert first. The unique constraint prevents duplicates.
                try (PreparedStatement ps =
                             con.prepareStatement(submissionSql)) {

                    ps.setInt(1, userId);
                    ps.setInt(2, missionId);
                    ps.setString(3, answer);
                    ps.setBoolean(4, isCorrect);

                    ps.executeUpdate();
                }

                if (isCorrect) {

                    // Award XP only for a correct first submission.
                    try (PreparedStatement ps =
                                 con.prepareStatement(xpSql)) {

                        ps.setInt(1, xpReward);
                        ps.setInt(2, userId);

                        if (ps.executeUpdate() != 1) {
                            throw new SQLException(
                                    "Student account was not found.");
                        }
                    }

                    // Level rule: one level for every 100 XP.
                    try (PreparedStatement ps =
                                 con.prepareStatement(levelSql)) {

                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                }

                con.commit();

                if (isCorrect) {
                    response.sendRedirect(
                            "missions?result=correct&xp=" + xpReward);
                } else {
                    response.sendRedirect(
                            "missions?result=wrong");
                }

            } catch (SQLException e) {
                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    e.addSuppressed(rollbackError);
                }

                // MySQL duplicate key error.
                if ("23000".equals(e.getSQLState())
                        && e.getErrorCode() == 1062) {
                    response.sendRedirect(
                            "missions?result=duplicate");
                } else {
                    throw e;
                }
            }

        } catch (SQLException e) {
            getServletContext().log(
                    "Mission answer submission failed", e);
            response.sendRedirect("missions?result=server");
        }
    }
}
