<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>

<%@ page import="com.codequest.DBConnection" %>

<%
    // Check whether the student is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int totalXP = 0;
    int playerLevel = 1;
    int completedMissions = 0;
    int totalMissions = 0;

    Connection con = null;

    try {
        con = DBConnection.getConnection();

        // Get student's XP and level from the database
        String userSQL =
            "SELECT username, total_xp, player_level FROM users WHERE id = ?";

        try (PreparedStatement ps = con.prepareStatement(userSQL)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    username = rs.getString("username");
                    totalXP = rs.getInt("total_xp");
                    playerLevel = rs.getInt("player_level");

                    // Keep the current username in the session
                    session.setAttribute("username", username);
                } else {
                    session.invalidate();
                    response.sendRedirect("login.jsp");
                    return;
                }
            }
        }

        // Count all available missions
        String totalSQL = "SELECT COUNT(*) FROM missions";

        try (PreparedStatement ps = con.prepareStatement(totalSQL);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalMissions = rs.getInt(1);
            }
        }

        // Count missions submitted by this student
        String completedSQL =
            "SELECT COUNT(*) FROM mission_submissions WHERE user_id = ?";

        try (PreparedStatement ps = con.prepareStatement(completedSQL)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    completedMissions = rs.getInt(1);
                }
            }
        }

    } catch (SQLException e) {
        application.log("Error loading CodeQuest dashboard", e);
        response.sendError(
            HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
            "Unable to load the dashboard. Check the Eclipse Console."
        );
        return;
    } finally {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                application.log("Error closing dashboard connection", e);
            }
        }
    }

    int nextLevelXP = 100;
    int remainingXP = nextLevelXP - (totalXP % nextLevelXP);
    if (remainingXP == nextLevelXP) {
        remainingXP = 0;
    }

    String safeUsername = username == null ? "Student" :
        username.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");

    int progress = totalMissions > 0
        ? (int) Math.round((completedMissions * 100.0) / totalMissions)
        : 0;

    if (progress > 100) {
        progress = 100;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CodeQuestPro | Student Dashboard</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #0f172a;
            color: #f8fafc;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            padding: 18px 7%;
            background: #111c32;
            border-bottom: 1px solid #334155;
        }

        .brand {
            font-size: 25px;
            font-weight: bold;
            color: #38bdf8;
        }

        .nav-links {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .nav-links a {
            text-decoration: none;
            color: #e2e8f0;
            padding: 10px 13px;
            border-radius: 7px;
            transition: 0.2s;
        }

        .nav-links a:hover {
            background: #334155;
            color: #38bdf8;
        }

        .nav-links .logout {
            background: #991b1b;
            color: white;
        }

        .nav-links .logout:hover {
            background: #b91c1c;
            color: white;
        }

        .container {
            max-width: 1150px;
            margin: auto;
            padding: 35px 22px;
        }

        .welcome {
            padding: 32px;
            border-radius: 16px;
            background: linear-gradient(120deg, #172554, #1e293b);
            border: 1px solid #334155;
            margin-bottom: 28px;
        }

        .welcome h1 {
            font-size: 32px;
            margin: 0 0 12px;
        }

        .welcome h1 span {
            color: #38bdf8;
        }

        .welcome p {
            color: #cbd5e1;
            line-height: 1.7;
            margin-bottom: 0;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: #1e293b;
            padding: 24px;
            border: 1px solid #334155;
            border-radius: 13px;
        }

        .stat-card .label {
            color: #94a3b8;
            font-size: 14px;
            margin-bottom: 12px;
        }

        .stat-card .number {
            font-size: 32px;
            font-weight: bold;
            color: #38bdf8;
        }

        .stat-card .description {
            margin-top: 10px;
            color: #cbd5e1;
            font-size: 13px;
        }

        .section-title {
            font-size: 23px;
            margin: 35px 0 18px;
        }

        .actions {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }

        .action-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 13px;
            padding: 25px;
        }

        .action-card h3 {
            margin-top: 0;
            color: #7dd3fc;
            font-size: 20px;
        }

        .action-card p {
            color: #cbd5e1;
            line-height: 1.7;
            min-height: 48px;
        }

        .btn {
            display: inline-block;
            text-decoration: none;
            color: white;
            background: #0284c7;
            padding: 12px 17px;
            border-radius: 7px;
            font-weight: bold;
            margin-top: 8px;
        }

        .btn:hover {
            background: #0369a1;
        }

        .progress-section {
            background: #1e293b;
            border: 1px solid #334155;
            padding: 25px;
            border-radius: 13px;
            margin-top: 25px;
        }

        .progress-info {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            flex-wrap: wrap;
            color: #cbd5e1;
            margin-bottom: 12px;
        }

        .progress-track {
            width: 100%;
            height: 12px;
            background: #334155;
            border-radius: 20px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            width: <%= progress %>%;
            background: #38bdf8;
            border-radius: 20px;
        }

        .footer {
            text-align: center;
            padding: 25px;
            color: #94a3b8;
            border-top: 1px solid #334155;
            margin-top: 40px;
            font-size: 14px;
        }

        @media (max-width: 700px) {
            .navbar {
                padding: 18px 5%;
            }

            .stats {
                grid-template-columns: 1fr;
            }

            .actions {
                grid-template-columns: 1fr;
            }

            .welcome h1 {
                font-size: 25px;
            }

            .container {
                padding: 25px 15px;
            }
        }
    </style>
</head>

<body>

    <header class="navbar">
        <div class="brand">CodeQuestPro</div>

        <nav class="nav-links">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="missions">Missions</a>
            <a href="leaderboard">Leaderboard</a>
            <a href="logout" class="logout">Logout</a>
        </nav>
    </header>

    <main class="container">

        <section class="welcome">
            <h1>Welcome back, <span><%= safeUsername %></span>!</h1>
            <p>
                Keep learning, solve coding missions, earn XP, and improve
                your position on the CodeQuestPro leaderboard.
            </p>
        </section>

        <section class="stats">

            <div class="stat-card">
                <div class="label">TOTAL EXPERIENCE</div>
                <div class="number"><%= totalXP %> XP</div>
                <div class="description">Earn XP by answering missions correctly.</div>
            </div>

            <div class="stat-card">
                <div class="label">CURRENT LEVEL</div>
                <div class="number"><%= playerLevel %></div>
                <div class="description">
                    <%= remainingXP %> XP until the next level milestone.
                </div>
            </div>

            <div class="stat-card">
                <div class="label">MISSIONS ATTEMPTED</div>
                <div class="number"><%= completedMissions %></div>
                <div class="description">
                    Out of <%= totalMissions %> available missions.
                </div>
            </div>

        </section>

        <h2 class="section-title">Continue Your Journey</h2>

        <section class="actions">

            <div class="action-card">
                <h3>Explore Missions</h3>
                <p>
                    Practice your coding knowledge by answering multiple-choice
                    questions and earning experience points.
                </p>
                <a href="missions" class="btn">View Missions</a>
            </div>

            <div class="action-card">
                <h3>Leaderboard</h3>
                <p>
                    Compare your total XP and level with other students
                    and see your progress.
                </p>
                <a href="leaderboard" class="btn">View Leaderboard</a>
            </div>

        </section>

        <section class="progress-section">
            <h2 style="margin-top: 0;">Mission Activity</h2>

            <div class="progress-info">
                <span>Missions attempted</span>
                <strong><%= completedMissions %> / <%= totalMissions %></strong>
            </div>

            <div class="progress-track">
                <div class="progress-fill"></div>
            </div>

            <p style="color:#94a3b8; margin-bottom:0; margin-top:12px;">
                <%= progress %>% of available missions attempted.
                Keep going to build your coding skills!
            </p>
        </section>

    </main>

    <footer class="footer">
        CodeQuestPro &copy; 2026 | Learn, Practice, Level Up.
    </footer>

</body>
</html>