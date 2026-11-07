
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    List<Map<String, Object>> questions =
        (List<Map<String, Object>>) request.getAttribute("questions");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CodeQuest - View Questions</title>

<style>
    * { box-sizing: border-box; }

    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background: #0f172a;
        color: #f8fafc;
    }

    header {
        padding: 20px 5%;
        background: #111827;
        border-bottom: 1px solid #334155;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 15px;
    }

    header h1 { margin: 0; color: #38bdf8; }

    a { color: #38bdf8; text-decoration: none; }

    .container {
        max-width: 1200px;
        margin: 35px auto;
        padding: 20px;
    }

    .table-container {
        overflow-x: auto;
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        min-width: 750px;
    }

    th, td {
        padding: 14px;
        text-align: left;
        border-bottom: 1px solid #334155;
        vertical-align: top;
    }

    th { background: #273449; color: #38bdf8; }

    tr:hover { background: #273449; }

    .badge {
        display: inline-block;
        padding: 5px 9px;
        background: #164e63;
        border-radius: 6px;
    }

    .button {
        display: inline-block;
        padding: 10px 14px;
        background: #0284c7;
        color: white;
        border-radius: 6px;
        margin: 12px 0;
    }

    .empty {
        padding: 30px;
        text-align: center;
        color: #cbd5e1;
    }
</style>
</head>

<body>

<header>
    <h1>CodeQuest</h1>
    <div>
        Admin: <%= session.getAttribute("adminUsername") %>
        &nbsp; | &nbsp;
        <a href="admin-dashboard.jsp">Dashboard</a>
        &nbsp; | &nbsp;
        <a href="admin-logout">Logout</a>
    </div>
</header>

<div class="container">

    <h2>All Questions</h2>
    <p>View the programming questions created for students.</p>

    <a class="button" href="add-question.jsp">+ Add New Question</a>

    <% if (questions == null || questions.isEmpty()) { %>

        <div class="table-container empty">
            No questions found. Add your first question.
        </div>

    <% } else { %>

        <p>Total questions: <strong><%= questions.size() %></strong></p>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Question</th>
                        <th>Category</th>
                        <th>Difficulty</th>
                        <th>Options</th>
                        <th>Correct Answer</th>
                        <th>XP</th>
                    </tr>
                </thead>

                <tbody>
                <% for (Map<String, Object> q : questions) { %>
                    <tr>
                        <td><%= q.get("id") %></td>

                        <td>
                            <strong><%= q.get("title") %></strong><br>
                            <%= q.get("description") %>
                        </td>

                        <td><%= q.get("category") %></td>

                        <td>
                            <span class="badge">
                                <%= q.get("difficulty") %>
                            </span>
                        </td>

                        <td>
                            A. <%= q.get("option_a") %><br>
                            B. <%= q.get("option_b") %><br>
                            C. <%= q.get("option_c") %><br>
                            D. <%= q.get("option_d") %>
                        </td>

                        <td><strong><%= q.get("correct_answer") %></strong></td>

                        <td><%= q.get("xp_reward") %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

    <% } %>

    <p>
        <a href="admin-dashboard.jsp">← Back to Admin Dashboard</a>
    </p>

</div>

</body>
</html>
