<%@page import="db.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // Evitar que se acceda a esta página después de cerrar sesión utilizando el botón "Regresar" del navegador
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
    response.setDateHeader("Expires", -1);

    // Validar si la sesión está activa
    if (session.getAttribute("nombreusuario") == null) {
        response.sendRedirect("login.jsp"); // Redirige al login si no hay sesión activa
        return;
    }

    // Obtener el idprofesional de la sesión
    Integer idprofesional = (Integer) session.getAttribute("idprofesional");
%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.9.1/font/bootstrap-icons.min.css">

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Citas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    .card-calendar {
    border: none;
    margin: 20px 0;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    transition: transform 0.2s ease-in-out, box-shadow 0.3s ease;
}

.card-calendar:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}

.card-header {
    background-color: #000000;
    color: #ffffff;
    font-size: 1.2rem;
    text-align: center;
    padding: 15px;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    text-transform: uppercase; /* Convertir el motivo a mayúsculas */
}

.btn-detalle {
    background-color: #000000;
    color: #ffffff;
    font-weight: bold;
    border-radius: 5px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    transition: background-color 0.3s ease, transform 0.2s;
}

.btn-detalle:hover {
    background-color: #333333;
    transform: translateY(-2px);
}

.btn-eliminar {
    background-color: #dc3545;
    color: #ffffff;
    font-weight: bold;
    border-radius: 5px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    transition: background-color 0.3s ease, transform 0.2s;
}

.btn-eliminar:hover {
    background-color: #c82333;
    transform: translateY(-2px);
}

.card-body {
    padding: 20px;
}

.card-title {
    font-size: 1.1rem;
    font-weight: bold;
    color: #333;
}

.card-text {
    font-size: 0.95rem;
    color: #555;
}

    </style>
</head>
<body>

<div style="background-color: #000000;">
  <div class="text-center py-3" style="background: linear-gradient(to bottom, #fafafa, #f5f5f5);">
      <img src="https://i.ibb.co/M1xqhhQ/logo-citas.png" class="img-fluid img-rounded" alt="Logo" width="900" height="250">
  </div>

  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav me-auto">
          <li class="nav-item"><a class="nav-link" href="reghorarioprof.jsp">Gestionar Horarios</a></li>
          <li class="nav-item"><a class="nav-link active" href="listarcita.jsp">Citas</a></li>
   
          <li class="nav-item"><a class="nav-link" href="perfilprofesional.jsp">Mi perfil</a></li>
        </ul>
        <ul class="navbar-nav ms-3">
          <li class="nav-item d-flex align-items-center">
            <div class="dropdown">
              <button class="btn p-0" data-bs-toggle="dropdown" aria-expanded="false" style="border: none; background: none;">
                <img src="<%= session.getAttribute("fotoperfil") != null ? session.getAttribute("fotoperfil") : "https://via.placeholder.com/40" %>" class="rounded-circle" alt="Avatar" width="40" height="40">
              </button>
              <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="perfilprofesional.jsp">Mi perfil</a></li>
                <li><a class="dropdown-item" href="eliminarcuenta.jsp">Eliminar Cuenta</a></li>
                <li><a class="dropdown-item" href="CerrarSesion">Cerrar Sesión</a></li>
              </ul>
            </div>
            <span class="text-white ms-2"><%= session.getAttribute("nombreusuario") %></span> 
          </li>
        </ul>
      </div>
    </div>
  </nav>
</div>

<div class="container">
<script>
    function closeAlert() {
        var alert = document.getElementById("alert");
        alert.style.display = "none"; // Oculta el mensaje de alerta
    }
</script>

<% 
    String mensaje = (String) request.getAttribute("mensaje");
    if (mensaje != null) {
%>
    <div id="alert" class="alert" role="alert" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin: 20px 0; border: 1px solid #f5c6cb;">
        <button class="close-btn" onclick="closeAlert()" style="float: right; background: none; border: none; font-size: 1.2em;">✖</button> <!-- Botón de cerrar -->
        <%= mensaje %>
    </div>
<% 
    }
%>
    <div class="row">
        <%
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Conectar a la base de datos
            con = DBConnection.getConnection();

            // Ejecutar consulta para obtener citas del idprofesional en la sesión
            if (idprofesional != null) {
                String query = "SELECT c.*, u.nombres, u.apellidos FROM cita c JOIN usuario u ON c.idusuario = u.idusuario WHERE c.idprofesional = ?"; // Consulta SQL
                pstmt = con.prepareStatement(query);
                pstmt.setInt(1, idprofesional);  
                rs = pstmt.executeQuery();

                // Verificar si hay resultados
                if (!rs.isBeforeFirst()) { 
                    out.println("<p>No hay citas disponibles.</p>");
                } else {
                    // Iterar sobre los resultados
                    while (rs.next()) {
                        int idusuario = rs.getInt("idusuario"); 
                        String fecha = rs.getString("fecha");
                        String hora = rs.getString("hora");
                        String motivo = rs.getString("motivo");
                        String detalles = rs.getString("detalles");
                        String nombresUsuario = rs.getString("nombres");
                        String apellidoUsuario = rs.getString("apellidos");
        %>
 <div class="col-md-4">
    <div class="card card-calendar">
        <div class="card-header text-center">
            <div style="text-transform: uppercase; font-weight: bold;">
                <%= motivo %> <!-- Motivo en mayúsculas en el título -->
            </div>
        </div>
        <div class="card-body">
            <p><strong>Fecha:</strong> <%= fecha %></p> <!-- Mostrar la fecha abajo junto con los demás datos -->
            <h5 class="card-title"><strong>Cliente:</strong> <%= nombresUsuario + " " + apellidoUsuario %></h5> <!-- Mostrar el nombre y apellido del usuario -->
            <p class="card-text"><strong>Hora:</strong> <%= hora %></p> 

            <button type="button" class="btn btn-detalle" data-bs-toggle="modal" data-bs-target="#detalleCita<%= idusuario %>">
                <i class="bi bi-info-circle"></i> Detalle
            </button>
        </div>
    </div>
</div>



            <div class="modal fade" id="detalleCita<%= idusuario %>" tabindex="-1" aria-labelledby="detalleCitaLabel<%= idusuario %>" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="detalleCitaLabel<%= idusuario %>">Detalles de la Cita</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p><strong>Motivo:</strong> <%= motivo %></p>
                            <p><strong>Detalles:</strong> <%= detalles %></p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>

        <%
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        %>
    </div>
</div>
</body>
</html>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
<footer class="bg-dark text-white text-center mt-5 py-4">
  <h5>Agendame</h5>
  <ul class="list-unstyled d-flex justify-content-center mb-3">
    <li class="mx-3"><a href="#about" class="text-white text-decoration-none">Acerca de</a></li>
    <li class="mx-3"><a href="#services" class="text-white text-decoration-none">Servicios</a></li>
    <li class="mx-3"><a href="#contact" class="text-white text-decoration-none">Contacto</a></li>
  </ul>
  <ul class="list-unstyled d-flex justify-content-center footer-icons mb-3">
    <li class="mx-3"><a href="https://www.facebook.com" target="_blank" class="text-white"><i class="bi bi-facebook"></i></a></li>
    <li class="mx-3"><a href="https://www.twitter.com" target="_blank" class="text-white"><i class="bi bi-twitter"></i></a></li>
    <li class="mx-3"><a href="https://www.instagram.com" target="_blank" class="text-white"><i class="bi bi-instagram"></i></a></li>
  </ul>
  <p class="mb-0">© 2024 Nombre de tu Sitio Web. Todos los derechos reservados.</p>
</footer>
<a href="#top" class="btn btn-primary position-fixed bottom-0 end-0 m-4" style="border-radius: 50%; background-color: #f8b400; border: none;">
    <i class="bi bi-arrow-up"></i>
</a>

</html>

