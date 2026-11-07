
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeQuest - Student Registration</title>

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
            padding: 25px 15px;
            font-family: Arial, sans-serif;
            background: #0f172a;
            color: #f8fafc;
        }

        .register-box {
            width: 100%;
            max-width: 450px;
            padding: 32px;
            background: #1e293b;
            border: 1px solid #475569;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .logo {
            text-align: center;
            color: #38bdf8;
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        h2 {
            text-align: center;
            margin-top: 0;
            margin-bottom: 25px;
            font-size: 23px;
        }

        .subtitle {
            text-align: center;
            color: #cbd5e1;
            margin-bottom: 25px;
            font-size: 14px;
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
            border: 1px solid #94a3b8;
            border-radius: 7px;
            background: #eaf2ff;
            color: #0f172a;
            font-size: 15px;
        }

        input:focus {
            outline: 2px solid #38bdf8;
            border-color: #38bdf8;
        }

        button {
            width: 100%;
            margin-top: 26px;
            padding: 14px;
            border: none;
            border-radius: 7px;
            background: #0284c7;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
        }

        button:hover {
            background: #0369a1;
        }

        .message {
            padding: 12px;
            border-radius: 7px;
            text-align: center;
            margin: 15px 0;
            font-size: 14px;
            line-height: 1.5;
        }

        .error {
            background: #7f1d1d;
            color: #fecaca;
        }

        .links {
            text-align: center;
            margin-top: 22px;
            line-height: 2;
        }

        .links a {
            color: #38bdf8;
            text-decoration: none;
            margin: 0 8px;
        }

        .links a:hover {
            text-decoration: underline;
        }

        .hint {
            color: #cbd5e1;
            font-size: 12px;
            margin-top: 7px;
        }

        @media (max-width: 480px) {
            .register-box {
                padding: 24px 20px;
            }

            .logo {
                font-size: 28px;
            }
        }
    </style>
</head>

<body>

<div class="register-box">

    <div class="logo">CodeQuest</div>
    <h2>Create Your Account</h2>

    <p class="subtitle">
        Join the coding adventure and start earning XP!
    </p>

    <% if ("empty".equals(request.getParameter("error"))) { %>
        <p class="message error">
            Please fill in all required fields.
        </p>
    <% } else if ("invalid".equals(request.getParameter("error"))) { %>
        <p class="message error">
            Check your details. Username must be at most 50 characters,
            email at most 100 characters, and password 8–128 characters.
        </p>
    <% } else if ("duplicate".equals(request.getParameter("error"))) { %>
        <p class="message error">
            That username or email may already exist. Please try different details.
        </p>
    <% } else if ("server".equals(request.getParameter("error"))) { %>
        <p class="message error">
            Registration failed due to a server error.
            Check the Eclipse Console.
        </p>
    <% } %>

    <form action="register" method="post">

        <label for="username">Username</label>
        <input
            type="text"
            id="username"
            name="username"
            placeholder="Choose a username"
            maxlength="50"
            autocomplete="username"
            required>

        <label for="email">Email Address</label>
        <input
            type="email"
            id="email"
            name="email"
            placeholder="Enter your email address"
            maxlength="100"
            autocomplete="email"
            required>

        <label for="password">Password</label>
        <input
            type="password"
            id="password"
            name="password"
            placeholder="Create a password"
            minlength="8"
            maxlength="128"
            autocomplete="new-password"
            required>

        <p class="hint">
            Your password must contain at least 8 characters.
        </p>

        <button type="submit">Create Account</button>

    </form>

    <div class="links">
        <a href="login.jsp">Already have an account? Login</a>
        <br>
        <a href="index.jsp">Back to Home</a>
    </div>

</div>

</body>
</html>
