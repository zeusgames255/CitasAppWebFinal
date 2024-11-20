
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio de Sesi�n</title>
    <!-- Incluye Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            background-color: #000000;
            color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            padding: 20px;
        }
        .login-container .form-control {
            background-color: #333333;
            color: #ffffff;
            border: 1px solid #555555;
            border-radius: 5px;
        }
        .login-container .form-control::placeholder {
            color: #ffffff;
        }
        .login-container .btn-primary {
            background-color: #ffffff;
            color: #000000;
            border-color: #ffffff;
        }
        .login-container .btn-primary:hover {
            background-color: #f8f9fa;
            color: #000000;
            border-color: #f8f9fa;
        }
        .login-container .form-check-input:checked {
            background-color: #ffffff;
            border-color: #ffffff;
        }
        .login-container .form-check-label {
            color: #ffffff;
        }
        .login-container .btn-secondary {
            background-color: #666666;
            color: #ffffff;
        }
        .login-container .btn-secondary:hover {
            background-color: #555555;
            color: #ffffff;
        }
        .login-container img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
        }
        .login-header {
            background-color: #333333;
            color: #ffffff;
            padding: 10px;
            border-radius: 10px 10px 0 0;
        }
        .login-footer {
            background-color: #333333;
            color: #ffffff;
            padding: 10px;
            border-radius: 0 0 10px 10px;
            text-align: center;
        }
        .error-message {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header text-center">
            <h5 class="mb-0">Inicio de Sesi�n</h5>
        </div>
        <div class="text-center mb-3" style="background: white;">
            <img src="https://i.ibb.co/M1xqhhQ/logo-citas.png" alt="Logo">
        </div>

        <!-- Mostrar mensaje de error solo si existe -->
        <c:if test="${not empty errorMessage}">
            <p class="error-message">${errorMessage}</p>
        </c:if>

        <form action="LoginServlet" method="POST">
            <div class="mb-3">
                <label for="username" class="form-label">Usuario</label>
                <input type="text" class="form-control" id="nombreusuario" name="nombreusuario" placeholder="Ingrese su usuario" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Contrase�a</label>
                <input type="password" class="form-control" id="contrase�a" name="contrase�a" placeholder="Ingrese su contrase�a" required>
            </div>
            <div class="d-flex justify-content-between mb-3">
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="rememberMe">
                    <label class="form-check-label" for="rememberMe">Recordarme</label>
                </div>
                <a href="#" class="text-white">Olvid� su contrase�a?</a>
            </div>
            <button type="submit" class="btn btn-primary w-100">Iniciar Sesi�n</button>
        </form>
        <div class="login-footer">
            <a href="Registrar.jsp" class="text-white me-2"><i class="fas fa-user-plus"></i> Reg�strate</a>
            <a href="contacto.jsp" class="text-white"><i class="fas fa-envelope"></i> Contacto</a>
        </div>
    </div>
    <!-- Incluye Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.7/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>
