
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CodeQuest - Student Login</title>

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
            padding: 30px;
            background: #1e293b;
            border: 1px solid #475569;
            border-radius: 14px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        h1 {
            text-align: center;
            color: #38bdf8;
        }

        label {
            display: block;
            margin-top: 18px;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #94a3b8;
            border-radius: 7px;
            font-size: 15px;
        }

        button {
            width: 100%;
            margin-top: 24px;
            padding: 13px;
            border: none;
            border-radius: 7px;
            background: #0284c7;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            background: #0369a1;
        }

        .message {
            padding: 11px;
            border-radius: 6px;
            text-align: center;
            margin: 15px 0;
        }

        .success {
            background: #14532d;
            color: #bbf7d0;
        }

        .error {
            background: #7f1d1d;
            color: #fecaca;
        }

        .links {
            text-align: center;
            margin-top: 22px;
        }

        .links a {
            display: inline-block;
            margin: 8px;
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

        <h1>CodeQuest Student Login</h1>

        <% if ("1".equals(request.getParameter("registered"))) { %>
            <p class="message success">
                Registration successful! Please log in.
            </p>
        <% } %>

        <% if ("invalid".equals(request.getParameter("error"))) { %>
            <p class="message error">
                Invalid username or password.
            </p>
        <% } else if ("empty".equals(request.getParameter("error"))) { %>
            <p class="message error">
                Please enter your username and password.
            </p>
        <% } else if ("server".equals(request.getParameter("error"))) { %>
            <p class="message error">
                A server error occurred. Please check the Eclipse Console.
            </p>
        <% } %>

        <form action="login" method="post">

            <label for="username">Username</label>
            <input
                type="text"
                id="username"
                name="username"
                autocomplete="username"
                required>

            <label for="password">Password</label>
            <input
                type="password"
                id="password"
                name="password"
                autocomplete="current-password"
                required>

            <button type="submit">Login</button>

        </form>

        <div class="links">
            <a href="register.jsp">Create an account</a>
            <a href="index.jsp">Home</a>
        </div>

    </div>

</body>
</html>
