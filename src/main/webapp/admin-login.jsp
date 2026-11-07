
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeQuest - Admin Login</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: Arial, sans-serif;
            background: #0f172a;
            color: #f8fafc;
            padding: 20px;
        }

        .login-box {
            width: 100%;
            max-width: 420px;
            padding: 32px;
            background: #1e293b;
            border: 1px solid #475569;
            border-radius: 14px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        h1 {
            text-align: center;
            color: #38bdf8;
            margin-top: 0;
        }

        .description {
            text-align: center;
            color: #cbd5e1;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-top: 18px;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input {
            display: block;
            width: 100%;
            padding: 13px;
            background: #f8fafc;
            color: #0f172a;
            border: 1px solid #94a3b8;
            border-radius: 7px;
            font-size: 15px;
        }

        .login-button {
            display: block;
            width: 100%;
            min-height: 48px;
            margin-top: 25px;
            padding: 13px;
            background: #0284c7;
            color: #ffffff;
            border: none;
            border-radius: 7px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .login-button:hover {
            background: #0369a1;
        }

        .error {
            padding: 10px;
            background: #7f1d1d;
            color: #fecaca;
            border-radius: 6px;
            text-align: center;
        }

        .success {
            padding: 10px;
            background: #14532d;
            color: #bbf7d0;
            border-radius: 6px;
            text-align: center;
        }

        .links {
            text-align: center;
            margin-top: 22px;
        }

        .links a {
            color: #38bdf8;
            text-decoration: none;
        }

        .links a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

    <div class="login-box">

        <h1>Admin Login</h1>

        <p class="description">
            Sign in to manage CodeQuest missions.
        </p>

        <% if ("invalid".equals(request.getParameter("error"))) { %>
            <p class="error">Invalid username or password.</p>
        <% } else if ("server".equals(request.getParameter("error"))) { %>
            <p class="error">
                Server error. Please check the Eclipse Console.
            </p>
        <% } %>

        <% if ("success".equals(request.getParameter("logout"))) { %>
            <p class="success">You have logged out successfully.</p>
        <% } %>

        <form action="admin-login" method="post">

            <label for="username">Admin Username</label>
            <input
                type="text"
                id="username"
                name="username"
                placeholder="Enter admin username"
                autocomplete="username"
                required>

            <label for="password">Password</label>
            <input
                type="password"
                id="password"
                name="password"
                placeholder="Enter admin password"
                autocomplete="current-password"
                required>

            <button type="submit" class="login-button">
                Login as Admin
            </button>

        </form>

        <div class="links">
            <a href="login.jsp">Back to Student Login</a>
        </div>

    </div>

</body>
</html>
