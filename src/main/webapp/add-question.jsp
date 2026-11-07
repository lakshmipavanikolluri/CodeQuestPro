<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    // Allow only logged-in admins
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    String adminUsername =
        (String) session.getAttribute("adminUsername");

    String status = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Question | CodeQuest</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #0f172a;
            color: #f8fafc;
            min-height: 100vh;
        }

        header {
            background: #111827;
            padding: 18px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            border-bottom: 1px solid #334155;
        }

        .logo {
            color: #38bdf8;
            font-size: 25px;
            font-weight: bold;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 18px;
            flex-wrap: wrap;
        }

        .header-right span {
            color: #cbd5e1;
        }

        a {
            color: #38bdf8;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .logout-btn {
            background: #dc2626;
            color: white;
            padding: 9px 14px;
            border-radius: 6px;
        }

        .logout-btn:hover {
            background: #b91c1c;
            text-decoration: none;
        }

        .container {
            width: 90%;
            max-width: 850px;
            margin: 35px auto;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
        }

        .form-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 14px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        h1 {
            color: #38bdf8;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #94a3b8;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .message {
            padding: 13px 15px;
            border-radius: 7px;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .success {
            background: #052e16;
            color: #4ade80;
            border: 1px solid #166534;
        }

        .error {
            background: #450a0a;
            color: #fca5a5;
            border: 1px solid #991b1b;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #e2e8f0;
        }

        input, textarea, select {
            width: 100%;
            padding: 12px;
            background: #0f172a;
            border: 1px solid #475569;
            border-radius: 7px;
            color: #f8fafc;
            font-size: 15px;
        }

        input:focus, textarea:focus, select:focus {
            outline: 2px solid #38bdf8;
            border-color: #38bdf8;
        }

        textarea {
            min-height: 110px;
            resize: vertical;
        }

        select option {
            background: #0f172a;
        }

        .options-grid, .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .required {
            color: #f87171;
        }

        .btn-row {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 10px;
        }

        .btn {
            display: inline-block;
            border: none;
            border-radius: 7px;
            padding: 13px 20px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            text-align: center;
        }

        .submit-btn {
            background: #0284c7;
            color: white;
        }

        .submit-btn:hover {
            background: #0369a1;
        }

        .cancel-btn {
            background: #334155;
            color: white;
        }

        .cancel-btn:hover {
            background: #475569;
            text-decoration: none;
        }

        .hint {
            display: block;
            color: #94a3b8;
            font-size: 12px;
            margin-top: 6px;
        }

        footer {
            text-align: center;
            color: #64748b;
            padding: 25px 10px;
        }

        @media (max-width: 600px) {
            header {
                padding: 16px 5%;
                align-items: flex-start;
                flex-direction: column;
            }

            .container {
                width: 94%;
                margin: 22px auto;
            }

            .form-card {
                padding: 20px;
            }

            .options-grid, .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
        }
    </style>
</head>

<body>

<header>
    <div class="logo">CodeQuest</div>

    <div class="header-right">
        <span>
            Admin:
            <%= adminUsername == null ? "Administrator" : adminUsername %>
        </span>

        <a href="admin-dashboard.jsp">Dashboard</a>
        <a href="admin-logout" class="logout-btn">Logout</a>
    </div>
</header>

<main class="container">

    <a href="admin-dashboard.jsp" class="back-link">
        &#8592; Back to Admin Dashboard
    </a>

    <section class="form-card">

        <h1>Add a New Question</h1>

        <p class="subtitle">
            Create a programming mission for students.
            Add four options, select the correct answer, and set the XP reward.
        </p>

        <% if ("1".equals(status)) { %>
            <div class="message success" role="status">
                Question added successfully!
            </div>
        <% } %>

        <% if (error != null) { %>
            <div class="message error" role="alert">
                <% if ("missing".equals(error)) { %>
                    Please fill in all required fields.
                <% } else if ("length".equals(error)) { %>
                    One or more fields exceed the allowed length.
                <% } else if ("xp".equals(error)) { %>
                    XP reward must be between 1 and 1000.
                <% } else if ("answer".equals(error)) { %>
                    Select the correct answer: A, B, C, or D.
                <% } else if ("category".equals(error)) { %>
                    Please select a valid category.
                <% } else if ("difficulty".equals(error)) { %>
                    Please select a valid difficulty.
                <% } else if ("save".equals(error)) { %>
                    The question could not be saved. Please try again.
                <% } else { %>
                    Could not save the question. Check the server logs.
                <% } %>
            </div>
        <% } %>

        <!-- FORM URL: submits to AddQuestionServlet -->
        <form action="AddQuestionServlet" method="post">

            <div class="form-group">
                <label for="title">
                    Question Title <span class="required">*</span>
                </label>
                <input type="text" id="title" name="title"
                    maxlength="100" placeholder="Example: What is Java?"
                    required>
            </div>

            <div class="form-group">
                <label for="description">
                    Question Description <span class="required">*</span>
                </label>
                <textarea id="description" name="description"
                    placeholder="Write the complete question here..."
                    required></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="category">
                        Category <span class="required">*</span>
                    </label>
                    <select id="category" name="category" required>
                        <option value="">Select category</option>
                        <option value="Java">Java</option>
                        <option value="SQL">SQL</option>
                        <option value="DSA">DSA</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="difficulty">
                        Difficulty <span class="required">*</span>
                    </label>
                    <select id="difficulty" name="difficulty" required>
                        <option value="">Select difficulty</option>
                        <option value="Easy">Easy</option>
                        <option value="Medium">Medium</option>
                        <option value="Hard">Hard</option>
                    </select>
                </div>
            </div>

            <h3 style="margin: 10px 0 20px; color: #38bdf8;">
                Answer Options
            </h3>

            <div class="options-grid">
                <div class="form-group">
                    <label for="option_a">Option A <span class="required">*</span></label>
                    <input type="text" id="option_a" name="option_a"
                        maxlength="255" placeholder="Enter option A" required>
                </div>

                <div class="form-group">
                    <label for="option_b">Option B <span class="required">*</span></label>
                    <input type="text" id="option_b" name="option_b"
                        maxlength="255" placeholder="Enter option B" required>
                </div>

                <div class="form-group">
                    <label for="option_c">Option C <span class="required">*</span></label>
                    <input type="text" id="option_c" name="option_c"
                        maxlength="255" placeholder="Enter option C" required>
                </div>

                <div class="form-group">
                    <label for="option_d">Option D <span class="required">*</span></label>
                    <input type="text" id="option_d" name="option_d"
                        maxlength="255" placeholder="Enter option D" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="correct_answer">
                        Correct Answer <span class="required">*</span>
                    </label>
                    <select id="correct_answer" name="correct_answer" required>
                        <option value="">Choose correct option</option>
                        <option value="A">Option A</option>
                        <option value="B">Option B</option>
                        <option value="C">Option C</option>
                        <option value="D">Option D</option>
                    </select>
                    <small class="hint">
                        Select the correct option.
                    </small>
                </div>

                <div class="form-group">
                    <label for="xp_reward">
                        XP Reward <span class="required">*</span>
                    </label>
                    <input type="number" id="xp_reward" name="xp_reward"
                        min="1" max="1000" value="50" required>
                    <small class="hint">
                        Enter a reward between 1 and 1000 XP.
                    </small>
                </div>
            </div>

            <div class="btn-row">
                <button type="submit" class="btn submit-btn">
                    Add Question
                </button>

                <a href="admin-dashboard.jsp" class="btn cancel-btn">
                    Cancel
                </a>
            </div>

        </form>
    </section>
</main>

<footer>
    &copy; 2026 CodeQuest | Learn, Practice, Level Up
</footer>

</body>
</html>