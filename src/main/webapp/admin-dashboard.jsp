
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    String adminUsername =
        (String) session.getAttribute("adminUsername");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CodeQuest | Admin Dashboard</title>
<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #0f172a;
    color: #f8fafc;
}
header {
    background: #1e293b;
    padding: 20px 6%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    flex-wrap: wrap;
}
h1, h2 { color: #38bdf8; }
a { color: #38bdf8; text-decoration: none; }
.logout {
    background: #ef4444;
    color: white;
    padding: 10px 14px;
    border-radius: 6px;
}
main { width: 88%; max-width: 1000px; margin: 40px auto; }
.cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
}
.card {
    background: #1e293b;
    padding: 24px;
    border: 1px solid #334155;
    border-radius: 12px;
}
.card p { color: #cbd5e1; line-height: 1.6; }
</style>
</head>
<body>
<header>
    <h2>CodeQuest Admin</h2>
    <a class="logout" href="admin-logout">Logout</a>
</header>

<main>
    <h1>Welcome, <%= adminUsername %>!</h1>
    <p>Manage programming questions and student learning missions.</p>

    <div class="cards">
        <div class="card">
            <h2>Add Mission</h2>
            <p>Create Java, SQL, and DSA programming questions.</p>
            <a href="add-question.jsp">Add Question</a>
            <a href="view-questions">View Questions</a>
            <a href="admin-logout">Logout</a>
            <a href="add-question.jsp">Add New Mission</a>
        </div>

        <div class="card">
            <h2>View Missions</h2>
            <p>Review questions saved in your database.</p>
            <a href="view-questions">View Questions →</a>
        </div>
    </div>
</main>
</body>
</html>
